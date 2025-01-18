-- Create the minimap button
local naughtyListMinimapButton = CreateFrame("Button", "NaughtyListMinimapButton", Minimap)
naughtyListMinimapButton:SetSize(32, 32)
naughtyListMinimapButton:SetFrameStrata("MEDIUM")
naughtyListMinimapButton:SetFrameLevel(8)
naughtyListMinimapButton:SetClampedToScreen(true) -- dont allow to be dragged outside of game window

-- Add the normal texture (icon)
local icon = naughtyListMinimapButton:CreateTexture(nil, "BACKGROUND")
icon:SetTexture("Interface\\Icons\\INV_Scroll_01")
icon:SetSize(18, 18)
icon:SetPoint("CENTER")

-- Add the highlight texture
local highlight = naughtyListMinimapButton:CreateTexture(nil, "HIGHLIGHT")
highlight:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
highlight:SetBlendMode("ADD")
highlight:SetSize(32, 32)
highlight:SetPoint("CENTER")

-- Add the border texture
local border = naughtyListMinimapButton:CreateTexture(nil, "OVERLAY")
border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
border:SetSize(54, 54)
border:SetPoint("TOPLEFT")

-- Set the initial position of the button
naughtyListMinimapButton:SetPoint("CENTER", Minimap, "CENTER", 0, 0)

-- Function to update the button's position around the minimap
local function updateMinimapButtonPosition(button)
    local xpos, ypos = GetCursorPosition()
    local xmin, ymin = Minimap:GetLeft(), Minimap:GetBottom()
    xpos = (xpos / UIParent:GetScale() - xmin) - 70
    ypos = (ypos / UIParent:GetScale() - ymin) - 70
    local angle = math.atan2(ypos, xpos)
    local x = math.cos(angle) * 80  -- 80 is the radius from the center of the Minimap
    local y = math.sin(angle) * 80
    button:ClearAllPoints()  -- Clear existing points before setting a new one
    button:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

-- Enable dragging around the minimap
naughtyListMinimapButton:SetMovable(true)
naughtyListMinimapButton:RegisterForDrag("LeftButton")
naughtyListMinimapButton:SetScript("OnDragStart", function(self)
    self:LockHighlight()
    self:SetScript("OnUpdate", function()
        updateMinimapButtonPosition(self)
    end)
end)
naughtyListMinimapButton:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    self:UnlockHighlight()
    self:SetScript("OnUpdate", nil)  -- Stop updating the position after the drag ends
    updateMinimapButtonPosition(self)
end)

-- Show the tooltip on mouseover
naughtyListMinimapButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
    GameTooltip:SetText("Naughty List", 1, 1, 1)
    GameTooltip:AddLine("Left-Click: Toggle the Naughty List", 0.8, 0.8, 0.8)
    GameTooltip:Show()
end)

-- Hide the tooltip on mouseout
naughtyListMinimapButton:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

naughtyListMinimapButton:SetScript("OnClick", function(self, button)
    if button == "RightButton" then
        if SettingsFrame then
            --[[ SettingsFrame:Toggle() ]]
        else
           --[[ print("Settings frame is not initialized.") ]]
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