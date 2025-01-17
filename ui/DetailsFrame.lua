local function OnInputChanged(self, inputType)
    local playerName = SelectedPlayerDetailsName
    local text = self:GetText()

    if not isValidInput(text) then
        PrintError(string.format("Invalid input for %s: %s", inputType, text))
        return
    end

    local playerData = NaughtyListDB[playerName] or {}
    text = string.sub(text, 1, 20)

    if inputType == "location" then
        if playerData.l ~= text then
            playerData.l = tostring(text)
            UpdatePlayer(playerName, playerData)
        end
    end
    
    if inputType == "note" then
        if playerData.n ~= text then
            playerData.n = tostring(text)
            UpdatePlayer(playerName, playerData)
        end
    end
end

local function ClearFocus(self)
    self:ClearFocus()
end 

function CreateDetailsFrame(parentFrame)
    local frame = CreateFrame("Frame", "NaughtyDetailsFrame", parentFrame, "BasicFrameTemplateWithInset")
    frame:SetSize(300, parentFrame:GetHeight())
    frame:SetPoint("RIGHT", parentFrame, "LEFT", -10, 0)
    frame:Hide()

    tinsert(UISpecialFrames, frame:GetName())

    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.title:SetPoint("CENTER", frame.TitleBg, "TOP", 0, -8)
    frame.title:SetText("Player Details")

    local playerNameLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    playerNameLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -60)
    playerNameLabel:SetText("Name:")

    local playerNameValue = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    playerNameValue:SetPoint("LEFT", playerNameLabel, "RIGHT", 10, 0)

    local playerClassLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    playerClassLabel:SetPoint("TOPLEFT", playerNameLabel, "BOTTOMLEFT", 0, -10)
    playerClassLabel:SetText("Class:")

    local playerClassValue = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    playerClassValue:SetPoint("LEFT", playerClassLabel, "RIGHT", 10, 0)

    local playerLocationLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    playerLocationLabel:SetPoint("TOPLEFT", playerClassLabel, "BOTTOMLEFT", 0, -10)
    playerLocationLabel:SetText("Location:")

    local playerLocationValue = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    playerLocationValue:SetSize(150, 30)
    playerLocationValue:SetPoint("LEFT", playerLocationLabel, "RIGHT", 10, 0)
    playerLocationValue:SetAutoFocus(false)
    playerLocationValue:SetMaxLetters(20)
    playerLocationValue:SetScript("OnEscapePressed", ClearFocus)
    playerLocationValue:SetScript("OnEnterPressed", ClearFocus)
    playerLocationValue:SetScript("OnEditFocusLost", function(self)
        self:ClearFocus()
        OnInputChanged(self, 'location')
    end)

    local playerAuthorLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    playerAuthorLabel:SetPoint("TOPLEFT", playerLocationLabel, "BOTTOMLEFT", 0, -10)
    playerAuthorLabel:SetText("Author:")

    local playerAuthorValue = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    playerAuthorValue:SetPoint("LEFT", playerAuthorLabel, "RIGHT", 10, 0)

    local playerDateLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    playerDateLabel:SetPoint("TOPLEFT", playerAuthorLabel, "BOTTOMLEFT", 0, -10)
    playerDateLabel:SetText("Date:")

    local playerDateValue = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    playerDateValue:SetPoint("LEFT", playerDateLabel, "RIGHT", 10, 0)
    
    local playerNoteLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    playerNoteLabel:SetPoint("TOPLEFT", playerDateLabel, "BOTTOMLEFT", 0, -10)
    playerNoteLabel:SetText("Note:")
    
    local playerNoteValue = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    playerNoteValue:SetSize(150, 30)
    playerNoteValue:SetPoint("LEFT", playerNoteLabel, "RIGHT", 10, 0)
    playerNoteValue:SetAutoFocus(false)
    playerNoteValue:SetMaxLetters(20)
    playerNoteValue:SetScript("OnEscapePressed", ClearFocus)
    playerNoteValue:SetScript("OnEnterPressed", ClearFocus)
    playerNoteValue:SetScript("OnEditFocusLost", function(self)
        self:ClearFocus()
        OnInputChanged(self, 'note')
    end)

    frame:SetScript("OnMouseDown", function(self, button)
        if not playerNoteValue:IsMouseOver() and playerNoteValue:HasFocus() then
            playerNoteValue:ClearFocus()
        end
        if not playerLocationValue:IsMouseOver() and playerLocationValue:HasFocus() then
            playerLocationValue:ClearFocus()
        end
    end)

    local removeButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    removeButton:SetSize(120, 25)
    removeButton:SetPoint("BOTTOM", frame, "BOTTOM", 0, 10)
    removeButton:SetText("Remove Player")
    removeButton:SetScript("OnClick", function()
        RemovePlayer(playerNameValue:GetText())
        frame:Hide()
    end)
   
    frame.SetPlayerDetails = function(self)
        local playerData = NaughtyListDB[SelectedPlayerDetailsName]
        if not playerData then
            PrintError("No data found for player:", SelectedPlayerDetailsName)
            return
        end

        playerNameValue:SetText(SelectedPlayerDetailsName)
        playerClassValue:SetText(playerData.c or "")
        playerLocationValue:SetText(playerData.l or "")
        playerAuthorValue:SetText(playerData.a or "")
        playerDateValue:SetText(playerData.d or "")
        playerNoteValue:SetText(playerData.n or "")
    end

    frame.OnShow = function(self)
        frame:AdjustPosition()
        frame:SetPlayerDetails()
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