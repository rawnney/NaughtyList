function UpdateListFrame(searchTerm)
    local function OnPlayerClick(self, button)
        local playerName = self:GetText():match("|cff%x%x%x%x%x%x(.-)|r")
        if not playerName then return end
        if SelectedPlayerDetailsName == playerName then
            DetailsFrame:Hide()
            SelectedPlayerDetailsName = nil
        else
            SelectedPlayerDetailsName = playerName
            DetailsFrame:OnShow()
            DetailsFrame:Show()
            if SettingsFrame and SettingsFrame:IsShown() then
                SettingsFrame:Hide()
            end
        end
    end

    local yOffset = -10

    if not playerList then
        playerList = CreateFrame("Frame", "NaughtyPlayerListFrame", UIParent)
        playerList:SetSize(300, 400)
        playerList:SetPoint("CENTER", UIParent, "CENTER")
    end

    if not searchTerm then
        SearchBox:SetText("Search Player...")
        SearchBox:SetTextColor(0.5, 0.5, 0.5)
        SearchBox:SetAutoFocus(false)
        SearchBox:ClearFocus()
    end
    searchTerm = (searchTerm and searchTerm ~= "" and searchTerm ~= "Search Player...") and searchTerm:lower() or nil

    PlayerTexts = PlayerTexts or {}

    local playerListData = {}
    for playerName, ratingData in pairs(NaughtyListDB) do
        if ratingData.d then
            table.insert(playerListData, {name = playerName, dateAdded = ratingData.d})
        else
            PrintDebug("Warning: Missing dateAdded for player:", playerName)
        end
    end

    table.sort(playerListData, function(a, b)
        return a.dateAdded > b.dateAdded
    end)

    for _, playerData in ipairs(playerListData) do
        local playerName = playerData.name
        local data = NaughtyListDB[playerName]

        local playerText = PlayerTexts[playerName]
        if not playerText then
            playerText = playerList:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            PlayerTexts[playerName] = playerText
        end

        if not searchTerm or string.match(playerName:lower(), searchTerm) then
            local class = data.c:lower() or "Unknown"
            local color = Consts.ClassColors[class] or {1.0, 1.0, 1.0}
            local icon = Consts.ClassIcons[class] or ""

            playerText:SetText(string.format("%s |cff%02x%02x%02x%s|r", icon, color[1] * 255, color[2] * 255, color[3] * 255, playerName))
            playerText:SetPoint("TOPLEFT", playerList, "TOPLEFT", 10, yOffset)
            playerText:SetScript("OnMouseDown", OnPlayerClick)
            playerText:Show()
            yOffset = yOffset - 20
        else
            playerText:Hide()
        end
    end

    for playerName, playerText in pairs(PlayerTexts) do
        if not NaughtyListDB[playerName] then
            playerText:Hide()
            PlayerTexts[playerName] = nil
        end
    end

    playerList:SetHeight(math.abs(yOffset) + 10)
end