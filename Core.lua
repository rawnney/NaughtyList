ADDON_NAME = "NaughtyList"
ADDON_VERSION = "1.0.1"
ADDON_PREFIX = "NaughtyList"
ADDON_DOWNLOAD_LINK = "https://github.com/rawnney/NaughtyList/archive/refs/heads/master.zip"

NaughtyListDB = {}
NaughtyListConfigDB = {
    enableContextMenu = true,
    enableSoundAlert = true,
    enablePrintAlert = true,
    enableGuildSync = true,
    enableDebug = false
}

PlayerTexts = {}
AlertedPlayers = {}
CurrentMembers = {}
SelectedPlayerDetailsName = nil
NewVersionAlerted = false

EventFrame = CreateEventFrame()
MainFrame = CreateMainFrame()
DetailsFrame = CreateDetailsFrame(MainFrame)
SettingsFrame = CreateSettingsFrame(MainFrame)

SLASH_NAUGHTYLIST1 = "/nl"
SLASH_NAUGHTYLIST2 = "/naughtylist"
SlashCmdList["NAUGHTYLIST"] = function(msg)
    if MainFrame:IsShown() then
        MainFrame:Hide()
    else
        MainFrame:Show()
    end
end
