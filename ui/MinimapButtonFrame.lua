function CreateMinimapButtonFrame()
    -- Create the minimap button
    local frame = CreateFrame("Button", "NaughtyListMinimapButton", Minimap)
    frame:SetSize(32, 32)
    frame:SetFrameStrata("MEDIUM")
    frame:SetFrameLevel(8)
    frame:SetClampedToScreen(true) -- dont allow to be dragged outside of game window

    -- Add the normal texture (icon)
    local icon = frame:CreateTexture(nil, "BACKGROUND")
    icon:SetTexture("Interface\\Icons\\INV_Scroll_01")
    icon:SetSize(18, 18)
    icon:SetPoint("CENTER")

    -- Add the highlight texture
    local highlight = frame:CreateTexture(nil, "HIGHLIGHT")
    highlight:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
    highlight:SetBlendMode("ADD")
    highlight:SetSize(32, 32)
    highlight:SetPoint("CENTER")

    -- Add the border texture
    local border = frame:CreateTexture(nil, "OVERLAY")
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    border:SetSize(54, 54)
    border:SetPoint("TOPLEFT")

    local x, y = unpack(NaughtyListConfigDB.minimapPosition)
    frame:SetPoint("CENTER", Minimap, "CENTER", x, y)

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
        return x, y
    end

    -- Enable dragging around the minimap
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self)
        self:LockHighlight()
        self:SetScript("OnUpdate", function()
            updateMinimapButtonPosition(self)
        end)
    end)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        self:UnlockHighlight()
        self:SetScript("OnUpdate", nil)  -- Stop updating the position after the drag ends
        x, y = updateMinimapButtonPosition(self)
        NaughtyListConfigDB.minimapPosition = {x, y}
    end)

    -- Show the tooltip on mouseover
    frame:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
        GameTooltip:SetText("Naughty List", 1, 1, 1)
        GameTooltip:AddLine("Left-Click: Toggle the Naughty List", 0.8, 0.8, 0.8)
        GameTooltip:Show()
    end)

    -- Hide the tooltip on mouseout
    frame:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    frame:SetScript("OnClick", function(self, button)
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
end
