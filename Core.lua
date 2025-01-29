ADDON_NAME = "NaughtyList"
ADDON_VERSION = 3
ADDON_PREFIX = "NaughtyList"
ADDON_DOWNLOAD_LINK = "https://github.com/rawnney/NaughtyList/archive/refs/heads/master.zip"

InitiateDB()

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

SLASH_NAUGHTYLISTADMIN1 = "/nla"
SLASH_NAUGHTYLISTADMIN2 = "/naughtylistadmin"
SlashCmdList["NAUGHTYLISTADMIN"] = function(msg)
    if msg == "user-data" then
        RequestAddonUsers()
        return
    end

    if msg == "test-alert" then
        local naughtyPlayers = {"TestPlayer1", "TestPlayer2"}
        PlaySoundWarning()
        PrintWarningMessage(naughtyPlayers)
        return
    end
end
