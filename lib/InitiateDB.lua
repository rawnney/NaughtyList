DefaultNaughtyListConfigDB = {
    enableContextMenu = true,
    enableSoundAlert = true,
    enablePrintAlert = true,
    enableGuildSync = true,
    enableDebug = false,
    minimapPosition = {-80, 0},
}

function InitiateDB()
    NaughtyListDB = NaughtyListDB or {}
    NaughtyListConfigDB = NaughtyListConfigDB or DefaultNaughtyListConfigDB
    -- Add any missing keys to the config
    for key, value in pairs(DefaultNaughtyListConfigDB) do
        if NaughtyListConfigDB[key] == nil then
            NaughtyListConfigDB[key] = value
        end
    end
end
