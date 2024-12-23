local minimapButton = CreateFrame("Button", "NaughtyListMinimapButton", Minimap)
minimapButton:SetSize(32, 32)
minimapButton:SetFrameStrata("MEDIUM")
minimapButton:SetFrameLevel(8)
minimapButton.icon = minimapButton:CreateTexture(nil, "BACKGROUND")
minimapButton.icon:SetTexture("Interface\\Icons\\INV_Scroll_01")
minimapButton.icon:SetSize(20, 20)
minimapButton.icon:SetPoint("CENTER")

minimapButton.border = minimapButton:CreateTexture(nil, "OVERLAY")
minimapButton.border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
minimapButton.border:SetSize(54, 54)
minimapButton.border:SetPoint("TOPLEFT")

minimapButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
    GameTooltip:SetText("Naughty List", 1, 1, 1)
    GameTooltip:AddLine("Left-Click: Toggle the Naughty List", 0.8, 0.8, 0.8)
--[[     GameTooltip:AddLine("Right-Click: Open the Settings Menu.", 0.8, 0.8, 0.8) ]]
    GameTooltip:Show()
end)

minimapButton:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

minimapButton:SetScript("OnMouseDown", function(self, button)
    if button == "RightButton" then
        if SettingsFrame then
            --[[ SettingsFrame:Toggle() ]]
        else
           --[[  print("Settings frame is not initialized.") ]]
        end
    elseif button == "LeftButton" then
        if MainFrame and MainFrame:IsShown() then
            MainFrame:Hide()
        elseif MainFrame then
            MainFrame:Show()
        else
            PrintError("Naughty List frame is not initialized.")
        end
    end
end)