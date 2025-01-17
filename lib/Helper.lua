function capitalizeFirstLetter(str)
    if not str or str == "" then
        return str or ""
    end
    return str:sub(1, 1):upper() .. str:sub(2):lower()
end

function formatDate(dateString)
    local year, month, day, hour, minute, second = dateString:match("(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)")
    return ("%s/%s/%s %s:%s:%s"):format(month, day, year, hour, minute, second)
end

function setDate()
    return date("%Y-%m-%d %H:%M:%S")
end

function getSetting(key)
    return NaughtyListConfigDB[key]
end

function setSetting(key, value)
    NaughtyListConfigDB[key] = value
    PrintDebug(key .. " " .. tostring(value))
end

function PrintDebug(message)
    if not getSetting("enableDebug") then return end
    print(message)
end

local yellowPrefixPart = "|cff00ff00[NaughtyList] |r"
local redPrefixPart = "|cffff0000[NaughtyList] |r"

function PrintInfo(message)
    print(yellowPrefixPart .. message)
end

function PrintError(message)
    print(redPrefixPart .. message)
end

function isValidPlayerData(playerName, playerData)
    if not playerName or not playerData then return false end
    for _, property in ipairs(Consts.PlayerProperties) do
        if not playerData[property] then
            PrintDebug("Missing property " .. property .. " for player " .. playerName)
            return false
        end
    end
    return true
end

function isValidInput(text)
    return string.match(text, "^[a-zA-Z0-9%s]*$") ~= nil
end

function SerializePlayer(playerName, playerData)
    local serialized = playerName .. "="
    if not isValidPlayerData(playerName, playerData) then
        PrintDebug("Invalid player data " .. playerName)
        return nil
    end
    for key, value in pairs(playerData) do
        serialized = serialized .. key .. "=" .. tostring(value) .. ";"
    end
    return serialized
end

function ApplyPrefix(serialized, prefix)
    return prefix .. serialized
end

function RemovePrefix(serialized, prefix)
    return string.sub(serialized, string.len(prefix) + 1)
end

function DeserializePlayer(serialized)
    local playerData = {strsplit("=", serialized, 2)}
    local playerName = playerData[1]
    local playerDataString = playerData[2]
    local playerDataPairs = {strsplit(";", playerDataString or "")}
    local data = {}
    for _, playerDataPair in ipairs(playerDataPairs) do
        if playerDataPair ~= "" then
            local dataPair = {strsplit("=", playerDataPair, 2)}
            data[dataPair[1]] = dataPair[2]
        end
    end
    return playerName, data
end

function ShareNaughtyPlayer(playerName, playerData)

    local serializedData = SerializePlayer(playerName, playerData)

    if not serializedData then
        PrintError("Failed to share data (invalid data)")
        return false
    end

    local sender = UnitName("player")
    local text = Consts.MessageCommands.player .. serializedData
    local success = C_ChatInfo.SendAddonMessage(ADDON_PREFIX, text, "GUILD", sender)
    if success then
        return true
    else
        return false
    end
end

local throttleInterval = 0.5
local playerQueue = {}
local totalPlayersToSync = 0

function SendMessage(message)
    local sender = UnitName("player")
    local text = Consts.MessageCommands.message .. message .. " by " .. sender
    C_ChatInfo.SendAddonMessage(ADDON_PREFIX, text, "GUILD", sender)
end

local function ProcessQueue()
    if #playerQueue == 0 then
        PrintInfo("Finished sharing " .. totalPlayersToSync .. " players.")
        SendMessage("Guild sync done (" .. totalPlayersToSync .. " players)")
        totalPlayersToSync = 0
        return
    end

    local entry = table.remove(playerQueue, 1)
    local playerName, playerData = entry.name, entry.data
    local success = ShareNaughtyPlayer(playerName, playerData)

    if not success then
        PrintDebug("Failed to share data for player:", playerName)
    end

    C_Timer.After(throttleInterval, ProcessQueue)
end

function ShareAllNaughtyPlayers()
    PrintInfo("Sharing all data...")

    playerQueue = {}
    for playerName, playerData in pairs(NaughtyListDB) do
        table.insert(playerQueue, { name = playerName, data = playerData })
    end

    totalPlayersToSync = #playerQueue

    if #playerQueue > 0 then
        ProcessQueue()
    else
        PrintInfo("No players to share.")
    end
end

function IsGuildMember(name)
    if not IsInGuild() then
        return false
    end

    for i = 1, GetNumGuildMembers() do
        local guildMemberName = GetGuildRosterInfo(i)
        -- Strip realm name from guild member if present
        guildMemberName = guildMemberName:match("([^%-]+)")
        if guildMemberName == name then
            return true
        end
    end

    return false
end

function BroadcastVersion()
    local sender = UnitName("player")
    local text = Consts.MessageCommands.message .. Consts.MessageCommands.version .. ADDON_VERSION
    local success = C_ChatInfo.SendAddonMessage(ADDON_PREFIX, text, "GUILD", sender)
    if success then
        PrintDebug("Version " .. ADDON_VERSION .. " broadcasted.")
        return true
    else
        PrintDebug("Failed to broadcast version.")
        return false
    end
end

function PlaySoundWarning()
    if not getSetting("enableSoundAlert") then return end
    local soundFile = "Interface\\AddOns\\NaughtyList\\sounds\\naughty_player_detected.mp3"
    PlaySoundFile(soundFile, "Master", 0.8)
end

function PrintWarningMessage(naughtyPlayers)
    if not getSetting("enablePrintAlert") then return end
    PrintError("\n\nAlert! You are grouped with naughty players (" .. #naughtyPlayers .. "): " .. table.concat(naughtyPlayers, ", ") .. "\n")
end