function CreateSettingsFrame(parentFrame)
    local frame = CreateFrame("Frame", "NaughtySettingsFrame", parentFrame, "BasicFrameTemplateWithInset")
    frame:SetSize(300, parentFrame:GetHeight())
    frame:SetPoint("RIGHT", parentFrame, "LEFT", -10, 0)
    frame:Hide()

    tinsert(UISpecialFrames, frame:GetName())

    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.title:SetPoint("CENTER", frame.TitleBg, "TOP", 0, -8)
    frame.title:SetText("Settings")

    local showContextMenuCheckbox = CreateCheckbox(
        frame,
        "Context Menu",
        "Enable context menu visibility.",
        getSetting('enableContextMenu'),
        function(value)
            setSetting('enableContextMenu', value)
        end
    )

    showContextMenuCheckbox:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -40)

    local enableSoundAlertCheckbox = CreateCheckbox(
        frame,
        "Sound Alerts",
        "Enable sound alerts.",
        getSetting('enableSoundAlert'),
        function(value)
            setSetting('enableSoundAlert', value)
        end
    )

    enableSoundAlertCheckbox:SetPoint("TOPLEFT", showContextMenuCheckbox, "BOTTOMLEFT", 0, -10)

    local enablePrintAlertCheckbox = CreateCheckbox(
        frame,
        "Print Alerts",
        "Enable print alerts.",
        getSetting('enablePrintAlert'),
        function(value)
            setSetting('enablePrintAlert', value)
        end
    )

    enablePrintAlertCheckbox:SetPoint("TOPLEFT", enableSoundAlertCheckbox, "BOTTOMLEFT", 0, -10)

    enableGuildSyncCheckbox = CreateCheckbox(
        frame,
        "Guild Sync",
        "Enable guild sync.",
        getSetting('enableGuildSync'),
        function(value)
            setSetting('enableGuildSync', value)
        end
    )

    enableGuildSyncCheckbox:SetPoint("TOPLEFT", enablePrintAlertCheckbox, "BOTTOMLEFT", 0, -10)

    local debugLabelColor = {r = 1.0, g = 0.0, b = 0.0}

    enableDebugCheckbox = CreateCheckbox(
        frame,
        "Debug Mode",
        "Enable debug mode.",
        getSetting('enableDebug'),
        function(value)
            setSetting('enableDebug', value)
        end,
        debugLabelColor
    )

    enableDebugCheckbox:SetPoint("TOPLEFT", enableGuildSyncCheckbox, "BOTTOMLEFT", 0, -10)

    if getSetting('enableGuildSync') then
        local TestButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        TestButton:SetSize(120, 25)
        TestButton:SetPoint("BOTTOM", frame, "BOTTOM", 0, 40)
        TestButton:SetText("Share all players")
        TestButton:SetScript("OnClick", function()
            ShareAllNaughtyPlayers()
        end)
    end

    local PurgeButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    PurgeButton:SetSize(120, 25)
    PurgeButton:SetPoint("BOTTOM", frame, "BOTTOM", 0, 10)
    PurgeButton:SetText("Purge Database")

    StaticPopupDialogs["CONFIRM_PURGE"] = {
        text = "WARNING! Are you sure you want to remove all naughty players from the list? This action cannot be undone.",
        button1 = "Yes",
        button2 = "No",
        OnAccept = function()
            NaughtyListDB = {}
            UpdateListFrame(nil)
            DetailsFrame:Hide()
            PrintInfo("Database purged.")
        end,
        OnCancel = function()
            return
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
    }

    PurgeButton:SetScript("OnClick", function()
        StaticPopup_Show("CONFIRM_PURGE")
    end)

    frame.OnShow = function(self)
        frame:AdjustPosition()
        showContextMenuCheckbox:SetChecked(getSetting('enableContextMenu'))
        enableSoundAlertCheckbox:SetChecked(getSetting('enableSoundAlert'))
        enablePrintAlertCheckbox:SetChecked(getSetting('enablePrintAlert'))
        enableDebugCheckbox:SetChecked(getSetting('enableDebug'))
        if DetailsFrame and DetailsFrame:IsShown() then
            DetailsFrame:Hide()
            SelectedPlayerDetailsName = nil
        end
    end

    frame.Toggle = function()
        if frame:IsShown() then
            frame:Hide()
        else
            frame:Show()
            frame:OnShow()
        end
    end

    frame.AdjustPosition = function(self)
        local parentX = parentFrame:GetCenter()
        local screenWidth = UIParent:GetWidth()

        if parentX < screenWidth / 2 then
            self:ClearAllPoints()
            self:SetPoint("LEFT", parentFrame, "RIGHT", 10, 0)
        else
            self:ClearAllPoints()
            self:SetPoint("RIGHT", parentFrame, "LEFT", -10, 0)
        end
    end

    return frame
end
