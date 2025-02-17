local updateTimer = nil

function OnAddonLoaded(self)
    self:UnregisterEvent(Consts.Events.ADDON_LOADED)
    CreateMinimapButtonFrame()
end

function OnPlayerLogin(self)
    self:UnregisterEvent(Consts.Events.PLAYER_LOGIN)

    PrintDebug(ADDON_NAME .. " v" .. ADDON_VERSION .. " loaded")

    AddPlayerContextMenu()

    local messageListener = C_ChatInfo.RegisterAddonMessagePrefix(ADDON_PREFIX)
    if not messageListener then
        PrintError("Failed to register to messaging")
        return
    end

    if getSetting("enableGuildSync") then
        BroadcastVersion()
    end
end

function OnPlayerUpdateReceived(text, channel, sender)
    local _, data = strsplit("@", text)
    local playerName, playerData = DeserializePlayer(data)

    if not isValidPlayerData(playerName, playerData) then
        return
    end

    if NaughtyListDB[playerName] then
        local updatedData = {}
        for key, value in pairs(playerData) do
            if NaughtyListDB[playerName][key] ~= value then
                updatedData[key] = value
            end
        end

        if next(updatedData) then
            NaughtyListDB[playerName] = playerData
        end
    elseif CanAddPlayer(playerName, playerData.c) then
        NaughtyListDB[playerName] = playerData
    end

    UpdateListFrame(nil)
end

function OnPlayerRemoveReceived(text, channel, sender)
    local _, playerName = strsplit("@", text)

    if NaughtyListDB[playerName] then
        NaughtyListDB[playerName] = nil
        UpdateListFrame(nil)
    end
end

hooksecurefunc("SetItemRef", function(link, text, button)
    local linkType, linkData = strsplit(":", link)
    if linkType == "addon" and linkData == "nl-update-available" then
        CreateUpdateVersionFrame()
    end
end)

function OnVersionCheckReceived(text, distribution, sender)
    local name, _ = UnitName("player")
    if sender == name then return end
    local _, version = strsplit("@", text)
    local recievedVersion = tonumber(version)
    if recievedVersion > ADDON_VERSION and not NewVersionAlerted then
        PrintInfo("A newer version of " .. ADDON_NAME .. " is available: v" .. version)
        PrintInfo("Download info: |cff00ff00|Haddon:nl-update-available|h[Click here]|h|r")
        NewVersionAlerted = true
    end
end

function CheckGroupForNaughtyPlayers()
    PrintDebug("Checking group for naughty players...")

    local naughtyPlayers = {}
    local foundNaughtyPlayer = false

    for playerName in pairs(CurrentMembers) do
        if not AlertedPlayers[playerName] and NaughtyListDB[playerName] then
            naughtyPlayers[#naughtyPlayers + 1] = playerName
            AlertedPlayers[playerName] = true
            foundNaughtyPlayer = true
            PrintDebug("Naughty player found: " .. playerName)
        end
    end

    if #naughtyPlayers > 0 then
        PlaySoundWarning()
        PrintWarningMessage(naughtyPlayers)
    else
        PrintDebug("No naughty players found in the group.")
    end
end

function ResetAlertedPlayersOnGroupChange()
    local newAlertedPlayers = {}

    for playerName in pairs(CurrentMembers) do
        newAlertedPlayers[playerName] = AlertedPlayers[playerName] or nil
    end

    AlertedPlayers = newAlertedPlayers
end

local function OnGroupCompositionChanged()
    ResetAlertedPlayersOnGroupChange()
    CheckGroupForNaughtyPlayers()
end

local function UpdateGroupMembers()
    local isRaid = IsInRaid()
    local numGroupMembers = isRaid and GetNumGroupMembers() or GetNumSubgroupMembers()
    local updatedMembers = {}

    for i = 1, numGroupMembers do
        local unitID = isRaid and "raid" .. i or "party" .. i
        local playerName = GetUnitName(unitID, true)

        if playerName and UnitIsConnected(unitID) then
            updatedMembers[playerName] = true
        end
    end

    local hasNewMembers = false
    for name in pairs(updatedMembers) do
        if not CurrentMembers[name] then
            hasNewMembers = true
            break
        end
    end

    if hasNewMembers then
        CurrentMembers = updatedMembers
        OnGroupCompositionChanged()
    else
        CurrentMembers = updatedMembers
    end
end

function OnGroupRosterUpdate()
    if updateTimer then
        return
    end

    updateTimer = C_Timer.After(2, function()
        updateTimer = nil
        UpdateGroupMembers()
    end)
end

function OnGroupOrRaidLeft()
    AlertedPlayers = {}
    CurrentMembers = {}
end

function OnWhoListUpdate()
    local queryName = inputBox:GetText()
    if queryName == "" then
        return
    end

    EventFrame:UnregisterEvent(Consts.Events.WHO_LIST_UPDATE)
    local numWhoResults = C_FriendList.GetNumWhoResults()
    if numWhoResults == 1 or numWhoResults == 0 then
        HideUIPanel(FriendsFrame)
    end

    if numWhoResults > 0 then
        for i = 1, numWhoResults do
            local info = C_FriendList.GetWhoInfo(i)
            if info and info.fullName:lower() == queryName:lower() then
                AddPlayerAndShare(info.fullName, info.classStr)
                return
            end
        end
    end

    PrintError("No exact match found for: " .. queryName)
end

function OnUserRequestReceived()
    local count = 0
    for _ in pairs(NaughtyListDB) do count = count + 1 end
    local text = Consts.MessageCommands.UserResponse .. count .. "@" .. ADDON_VERSION
    SendAddonMessage(text)
end

function OnUserResponseReceived(text, sender)
    local _, count, version = strsplit("@", text)
    PrintInfo(sender .. " has " .. count .. " players. (v" .. version .. ")")
end

function OnMessageReceived(text)
    local _, message = strsplit("@", text)
    PrintInfo(message)
end

function OnChatMsgAddonEvent(prefix, text, channel, sender)
    if not getSetting("enableGuildSync") or channel ~= "GUILD" then return end

    local name, _ = UnitName("player")
    sender = sender:match("(.+)%-.+") or sender
    local isNotMe = sender ~= name

    if prefix == ADDON_PREFIX and isNotMe and text:find(Consts.MessageCommands.PlayerUpdate) then
        OnPlayerUpdateReceived(text, channel, sender)
    end

    if prefix == ADDON_PREFIX and isNotMe and text:find(Consts.MessageCommands.PlayerRemove) then
        OnPlayerRemoveReceived(text, channel, sender)
    end

    if prefix == ADDON_PREFIX and isNotMe and text:find(Consts.MessageCommands.UserRequest) then
        OnUserRequestReceived()
    end

    if prefix == ADDON_PREFIX and isNotMe and text:find(Consts.MessageCommands.Version) then
        OnVersionCheckReceived(text, channel, sender)
    end

    if prefix == ADDON_PREFIX and isNotMe and text:find(Consts.MessageCommands.Message) then
        OnMessageReceived(text, channel, sender)
    end

    if prefix == ADDON_PREFIX and name == "Promis" and text:find(Consts.MessageCommands.UserResponse) then
        OnUserResponseReceived(text, sender)
    end
end