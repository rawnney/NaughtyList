function CreateEventFrame()
    local frame = CreateFrame("Frame", "NaughtyEventFrame", UIParent)

    frame:RegisterEvent(Consts.Events.ADDON_LOADED)
    frame:RegisterEvent(Consts.Events.CHAT_MSG_ADDON)
    frame:RegisterEvent(Consts.Events.GROUP_LEFT)
    frame:RegisterEvent(Consts.Events.GROUP_ROSTER_UPDATE)
    frame:RegisterEvent(Consts.Events.PLAYER_LOGIN)

    frame:SetScript("OnEvent", function(self, event, prefix, text, channel, sender)
        if not Consts:IsEventSupported(event) then return
        elseif event == Consts.Events.ADDON_LOADED then OnAddonLoaded(self)
        elseif event == Consts.Events.CHAT_MSG_ADDON then OnChatMsgAddonEvent(prefix, text, channel, sender)
        elseif event == Consts.Events.GROUP_LEFT then OnGroupOrRaidLeft()
        elseif event == Consts.Events.GROUP_ROSTER_UPDATE then OnGroupRosterUpdate()
        elseif event == Consts.Events.PLAYER_LOGIN then OnPlayerLogin(self)
        elseif event == Consts.Events.WHO_LIST_UPDATE then OnWhoListUpdate()
        end
    end)

    return frame
end