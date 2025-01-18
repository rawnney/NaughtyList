Consts = Consts or {}

local function makeReadOnly(table)
    return setmetatable({}, {
        __index = table,
        __newindex = function(_, key, _)
            error("Attempt to modify read-only table: " .. tostring(key))
        end
    })
end

Consts.ClassColors = makeReadOnly({
    warrior = {0.78, 0.61, 0.43},
    mage = {0.41, 0.8, 0.94},
    rogue = {1.0, 0.96, 0.41},
    druid = {1.0, 0.49, 0.04},
    hunter = {0.67, 0.83, 0.45},
    shaman = {0.0, 0.44, 0.87},
    priest = {1.0, 1.0, 1.0},
    warlock = {0.58, 0.51, 0.79},
    paladin = {0.96, 0.55, 0.73},
})

Consts.ClassIcons = makeReadOnly({
    warrior = "|TInterface\\WorldStateFrame\\ICONS-CLASSES:0:0:0:0:256:256:0:64:0:64|t",
    mage = "|TInterface\\WorldStateFrame\\ICONS-CLASSES:0:0:0:0:256:256:64:128:0:64|t",
    rogue = "|TInterface\\WorldStateFrame\\ICONS-CLASSES:0:0:0:0:256:256:128:196:0:64|t",
    druid = "|TInterface\\WorldStateFrame\\ICONS-CLASSES:0:0:0:0:256:256:196:256:0:64|t",
    hunter = "|TInterface\\WorldStateFrame\\ICONS-CLASSES:0:0:0:0:256:256:0:64:64:128|t",
    shaman = "|TInterface\\WorldStateFrame\\ICONS-CLASSES:0:0:0:0:256:256:64:128:64:128|t",
    priest = "|TInterface\\WorldStateFrame\\ICONS-CLASSES:0:0:0:0:256:256:128:196:64:128|t",
    warlock = "|TInterface\\WorldStateFrame\\ICONS-CLASSES:0:0:0:0:256:256:196:256:64:128|t",
    paladin = "|TInterface\\WorldStateFrame\\ICONS-CLASSES:0:0:0:0:256:256:0:64:128:196|t",
})

Consts.PlayerProperties = makeReadOnly({
    "a", -- Author
    "c", -- Class
    "d", -- Date
    "l", -- Location
    "n", -- Note
})

Consts.Events = makeReadOnly({
    ADDON_LOADED = "ADDON_LOADED",
    GROUP_ROSTER_UPDATE = "GROUP_ROSTER_UPDATE",
    GROUP_LEFT = "GROUP_LEFT",
    WHO_LIST_UPDATE = "WHO_LIST_UPDATE",
    CHAT_MSG_ADDON = "CHAT_MSG_ADDON",
    PLAYER_LOGIN = "PLAYER_LOGIN"
})

Consts.MessageCommands = makeReadOnly({
    PlayerUpdate = "playerUpdate@",
    PlayerRemove = "playerRemove@",
    Message = "message@",
    Version = "version@",
    UserRequest = "userRequest@",
    UserResponse = "userResponse@",
})

function Consts:NormalizeClassName(className)
    return className:lower()
end

function Consts:GetClassIcon(className)
    local normalizedClass = self:NormalizeClassName(className)
    return self.ClassIcons[normalizedClass] or ""
end

function Consts:IsValidPlayerProperty(property)
    for _, prop in ipairs(self.PlayerProperties) do
        if prop == property then
            return true
        end
    end
    return false
end

function Consts:IsEventSupported(eventName)
    return self.Events[eventName] ~= nil
end