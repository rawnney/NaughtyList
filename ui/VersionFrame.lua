function CreateUpdateVersionFrame()
    local promptFrame = CreateFrame("Frame", "NaughtyPromptFrame", UIParent, "BasicFrameTemplateWithInset")
    promptFrame:SetSize(500, 300)
    promptFrame:SetPoint("CENTER", UIParent, "CENTER")
    promptFrame:SetFrameStrata("DIALOG")

    local title = promptFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("TOP", promptFrame, "TOP", 0, -8)
    title:SetText("Addon update available")

    local step1 = promptFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    step1:SetPoint("TOPLEFT", 20, -40)
    step1:SetText("1. Download the link below:")

    local linkInputBox = CreateFrame("EditBox", nil, promptFrame, "InputBoxTemplate")
    linkInputBox:SetSize(450, 30)
    linkInputBox:SetPoint("TOPLEFT", step1, "BOTTOMLEFT", 0, 0)
    linkInputBox:SetAutoFocus(false)
    linkInputBox:SetText(ADDON_DOWNLOAD_LINK)
    linkInputBox:SetScript("OnTextChanged", function(self)
        self:SetText(ADDON_DOWNLOAD_LINK)
    end)

    local step2 = promptFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    step2:SetPoint("TOPLEFT", linkInputBox, "BOTTOMLEFT", 0, -10)
    step2:SetText("2. Open the .zip and add/replace the NaughtList at your AddOns folder:")

    local addonsPathInputBox = CreateFrame("EditBox", nil, promptFrame, "InputBoxTemplate")
    local addonsFolderText = "C:\\Program Files (x86)\\World of Warcraft\\_classic_era_\\Interface\\AddOns"
    addonsPathInputBox:SetMultiLine(true)
    addonsPathInputBox:SetSize(450, 30)
    addonsPathInputBox:SetPoint("TOPLEFT", step2, "BOTTOMLEFT", 0, -10)
    addonsPathInputBox:SetAutoFocus(false)
    addonsPathInputBox:SetText(addonsFolderText)
    addonsPathInputBox:SetScript("OnTextChanged", function(self)
        self:SetText(addonsFolderText)
    end)

    local step3 = promptFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    step3:SetPoint("TOPLEFT", addonsPathInputBox, "BOTTOMLEFT", 0, -10)
    step3:SetText("3. Remove the ´-master´ part from the folder name")

    local step4 = promptFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    step4:SetPoint("TOPLEFT", step3, "BOTTOMLEFT", 0, -10)
    step4:SetText("4. /reload & stay naughty!")

    local middleButton = CreateFrame("Button", nil, promptFrame, "UIPanelButtonTemplate")
    middleButton:SetSize(100, 25)
    middleButton:SetPoint("BOTTOM", promptFrame, "BOTTOM", 0, 10)
    middleButton:SetText("Got it!")
    middleButton:SetScript("OnClick", function()
        promptFrame:Hide()
    end)
end
