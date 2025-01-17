local function CreateHashTable(array, offset)
    local hash = {}
    for i, value in ipairs(array) do
        hash[(offset and (offset + i)) or value] = value
    end
    return hash
end

local menuTags = CreateHashTable({
    "MENU_UNIT_PLAYER",
    "MENU_UNIT_ENEMY_PLAYER",
    "MENU_UNIT_PARTY",
    "MENU_UNIT_RAID_PLAYER",
    "MENU_UNIT_FRIEND",
    "MENU_UNIT_COMMUNITIES_GUILD_MEMBER",
    "MENU_UNIT_COMMUNITIES_MEMBER",
    "MENU_LFG_FRAME_SEARCH_ENTRY",
    "MENU_LFG_FRAME_MEMBER_APPLY",
})

local classNamesByOffset = CreateHashTable({
    "WARRIOR",
    "PALADIN",
    "HUNTER",
    "ROGUE",
    "PRIEST",
    "SHAMAN",
    "MAGE",
    "WARLOCK",
    "DRUID",
}, 4000000000)

local function IsValidName(contextData)
    local name = contextData.name
    return name and name:sub(1, 1) ~= "|"
end

local function UpdateRootDescription(rootDescription, name, class)
    rootDescription:CreateDivider()
    rootDescription:CreateTitle("Naughty List")

    if NaughtyListDB[name] then
        rootDescription:CreateButton("Remove", function()
            RemovePlayer(name)
        end)
    else
        rootDescription:CreateButton("Add", function()
            AddPlayerAndShare(name, class)
        end)
    end
end

local function ModifyMenuCallback(ownerRegion, rootDescription, contextData)
    if not IsValidName(contextData) or not getSetting("enableContextMenu") then return end

    local name = contextData.name
    local class, guid

    if contextData.lineID then
        guid = C_ChatInfo.GetChatLineSenderGUID(contextData.lineID)
        class = classNamesByOffset[tonumber(contextData.lineID)]
    elseif contextData.unit then
        guid = UnitGUID(contextData.unit)
    elseif contextData.whoIndex then
        local whoInfo = C_FriendList.GetWhoInfo(contextData.whoIndex)
        name = whoInfo.fullName
        class = whoInfo.classStr
    else
        return
    end

    if not class and guid then
        _, class = GetPlayerInfoByGUID(guid)
    end

    UpdateRootDescription(rootDescription, name, class)
end

function AddPlayerContextMenu()
    for menuType in pairs(menuTags) do
        Menu.ModifyMenu(menuType, ModifyMenuCallback)
    end
end
