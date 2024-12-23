
function CreateMainFrame()
    local frame = CreateFrame("Frame", "NaughtyMainFrame", UIParent, "BasicFrameTemplateWithInset")
    tinsert(UISpecialFrames, frame:GetName())

    frame:SetSize(300, 400)
    frame:SetPoint("CENTER")
    frame:Hide()
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)

    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.title:SetPoint("CENTER", frame.TitleBg, "TOP", 0, -8)
    frame.title:SetText(ADDON_NAME)

    local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetSize(260, 310)
    scrollFrame:SetPoint("TOP", frame, "TOP", -10, -50)

    playerList = CreateFrame("Frame", nil, scrollFrame)
    playerList:SetSize(260, 400)
    scrollFrame:SetScrollChild(playerList)

    local placeholderSearchText = "Search Player..."
    SearchBox = CreateFrame("EditBox", "SearchBox", frame, "InputBoxTemplate")
    SearchBox:SetSize(120, 20)
    SearchBox:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -30)
    SearchBox:SetAutoFocus(false)
    SearchBox:SetText(placeholderSearchText)
    SearchBox:SetTextColor(0.5, 0.5, 0.5)
    SearchBox:SetScript("OnTextChanged", function(self)
        UpdateListFrame(self:GetText())
    end)

    SearchBox:SetScript("OnEditFocusGained", function(self)
        if self:GetText() == placeholderSearchText then
            self:SetText("")
            self:SetTextColor(1, 1, 1)
        end
    end)

    SearchBox:SetScript("OnEditFocusLost", function(self)
        if self:GetText() == "" then
            self:SetText(placeholderSearchText)
            self:SetTextColor(0.5, 0.5, 0.5)
        end
    end)

    SearchBox:SetScript("OnEnterPressed", function(self)
        self:ClearFocus()
    end)

    SearchBox:SetScript("OnEscapePressed", function(self)
        self:ClearFocus()
    end)

    frame:SetScript("OnMouseDown", function(self, button)
        if not SearchBox:IsMouseOver() and SearchBox:HasFocus() then
            SearchBox:ClearFocus()
        end
    end)

    local ClearButton = CreateClearButton(frame, SearchBox, placeholderSearchText)

    local SettingsButton = CreateFrame("Button", "SettingsButton", frame, "UIPanelButtonTemplate")
    SettingsButton:SetSize(80, 20)
    SettingsButton:SetPoint("LEFT", ClearButton, "RIGHT", 20, 0)
    SettingsButton:SetText("Settings")
    SettingsButton:SetScript("OnClick", function()
        SettingsFrame:Toggle()
    end)

    local AddTargetButton = CreateFrame("Button", "AddTargetButton", frame, "UIPanelButtonTemplate")
    AddTargetButton:SetSize(120, 25)
    AddTargetButton:SetPoint("BOTTOM", frame, "BOTTOM", -60, 10)
    AddTargetButton:SetText("Add Target")

    AddTargetButton:SetScript("OnClick", function()
        local name = UnitName("target")
        local _, class = UnitClass("target")
        local isPlayer = UnitIsPlayer("target")
        if not isPlayer then return end
        AddPlayerAndShare(name, class)
    end)

    local AddButton = CreateFrame("Button", "NaughtyAddButton", frame, "UIPanelButtonTemplate")
    AddButton:SetSize(120, 25)
    AddButton:SetPoint("BOTTOM", frame, "BOTTOM", 60, 10)
    AddButton:SetText("Add Name")

    AddButton:SetScript("OnClick", function()
        HideUIPanel(FriendsFrame)
        local promptFrame = CreateFrame("Frame", "NaughtyPromptFrame", UIParent, "BasicFrameTemplateWithInset")
        promptFrame:SetSize(300, 120)
        promptFrame:SetPoint("CENTER", UIParent, "CENTER")
        promptFrame:SetFrameStrata("DIALOG")

        local title = promptFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        title:SetPoint("TOP", promptFrame, "TOP", 0, -8)
        title:SetText("Add Player")

        local inputPlaceholder = "Enter player name"
        inputBox = CreateFrame("EditBox", nil, promptFrame, "InputBoxTemplate")
        inputBox:SetSize(200, 30)
        inputBox:SetPoint("CENTER", promptFrame, "CENTER")
        inputBox:SetAutoFocus(true)
        inputBox:SetMaxLetters(30)
        inputBox:SetText(inputPlaceholder)
        inputBox:SetTextColor(0.5, 0.5, 0.5)

        inputBox:SetScript("OnEditFocusGained", function(self)
            if self:GetText() == inputPlaceholder then
                self:SetText("")
                self:SetTextColor(1, 1, 1)
            end
        end)
        
        inputBox:SetScript("OnEditFocusLost", function(self)
            if self:GetText() == "" then
                self:SetText(inputPlaceholder)
                self:SetTextColor(0.5, 0.5, 0.5)
            end
        end)

        inputBox:SetScript("OnEscapePressed", function()
            promptFrame:Hide()
        end)

        function SendWhoQuery()
            local playerName = inputBox:GetText()
            if playerName == inputPlaceholder then
                promptFrame:Hide()
                return
            end

            if playerName and playerName ~= "" then
                C_FriendList.SetWhoToUi(playerName)
                C_FriendList.SendWho(playerName)
            else
                PrintError("Invalid player name")
            end
            promptFrame:Hide()
        end

        inputBox:SetScript("OnEnterPressed", SendWhoQuery)

        frame:RegisterEvent("WHO_LIST_UPDATE")

        local confirmButton = CreateFrame("Button", nil, promptFrame, "UIPanelButtonTemplate")
        confirmButton:SetSize(100, 25)
        confirmButton:SetPoint("BOTTOM", promptFrame, "BOTTOM", -60, 10)
        confirmButton:SetText("Confirm")
        confirmButton:SetScript("OnClick", SendWhoQuery)

        local cancelButton = CreateFrame("Button", nil, promptFrame, "UIPanelButtonTemplate")
        cancelButton:SetSize(100, 25)
        cancelButton:SetPoint("BOTTOM", promptFrame, "BOTTOM", 60, 10)
        cancelButton:SetText("Cancel")
        cancelButton:SetScript("OnClick", function()
            promptFrame:Hide()
        end)
    end)

    return frame
end
