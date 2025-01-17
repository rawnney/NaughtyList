function CanAddPlayer(name, class)
    if not name or not class then
        PrintError("No player data provided.")
        return false
    end

    if name == UnitName("player") then
        PrintError("You cannot add yourself.")
        return false
    end

    if NaughtyListDB[name] then
        PrintInfo(name .. " is already on the naughty list.")
        return false
    end

    if IsGuildMember(name) then
        PrintError(name .. " can't be naughty, he is a zug...")
        return false
    end

    return true
end

function AddPlayer(name, class, shouldLog)
    local canAdd = CanAddPlayer(name, class)

    if not canAdd then return false end

    local playerData = {
        a = UnitName("player"),             -- Added by
        d = setDate(),                      -- Date added
        l = GetRealZoneText(),              -- Zone
        c = capitalizeFirstLetter(class),   -- Class
        n = 'n/a',                          -- Initial note
    }

    NaughtyListDB[name] = playerData
    PrintInfo(name .. " added")
    UpdateListFrame(nil)

    return true
end

function AddPlayerAndShare(name, class)
    local success = AddPlayer(name, class, true)

    if success and getSetting("enableGuildSync") then
        local shareSuccess = ShareNaughtyPlayer(name, NaughtyListDB[name])
        if not shareSuccess then
            PrintError("Failed to share data for " .. name)
        else 
            SendMessage(name .. " added")
            PrintDebug("Guild sync done")
        end
    end
end

function UpdatePlayer(playerName, playerData)
    local message = playerName .. " updated"

    if not playerName or not playerData then
        PrintError("No data provided.")
        return
    end

    if not NaughtyListDB[playerName] then
        PrintError(playerName .. " is not on the list.")
        return
    end

    if not isValidPlayerData(playerName, playerData) then
        return
    end

    NaughtyListDB[playerName] = playerData
    PrintInfo(message)

    if getSetting("enableGuildSync") then
        local shareSuccess = ShareNaughtyPlayer(playerName, playerData)
        if not shareSuccess then
            PrintError("Failed to share updated data for " .. playerName)
        else
            SendMessage(message)
            PrintDebug("Guild sync done")
        end
    end
end

function RemovePlayer(playerName)
    if not playerName then
        PrintError("No name provided.")
        return
    end

    if not NaughtyListDB[playerName] then
        PrintError(playerName .. " is not on the list.")
        return
    end

    NaughtyListDB[playerName] = nil
    PrintInfo(playerName .. " removed ")

    UpdateListFrame(nil)
end
