function CreateCheckbox(parent, label, tooltip, initialValue, onClick, labelColor)
    local checkbox = CreateFrame("CheckButton", nil, parent, "ChatConfigCheckButtonTemplate")
    checkbox:SetSize(20, 20)
    checkbox:SetChecked(initialValue)

    checkbox.Text = checkbox:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    checkbox.Text:SetPoint("LEFT", checkbox, "RIGHT", 5, 0)
    checkbox.Text:SetText(label)

    if labelColor then
        checkbox.Text:SetTextColor(labelColor.r, labelColor.g, labelColor.b)
    end

    checkbox:SetScript("OnEnter", function()
        GameTooltip:SetOwner(checkbox, "ANCHOR_RIGHT")
        GameTooltip:SetText(tooltip, nil, nil, nil, nil, true)
        GameTooltip:Show()
    end)

    checkbox:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    checkbox:SetScript("OnClick", function(self)
        onClick(self:GetChecked())
    end)

    return checkbox
end

function CreateClearButton(parent, searchBox, placeholderSearchText)
    local clearButton = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    clearButton:SetSize(20, 20)
    clearButton:SetPoint("LEFT", searchBox, "RIGHT", 5, 0)
    clearButton:SetText("X")

    clearButton:SetNormalFontObject("GameFontNormal")
    clearButton:SetHighlightFontObject("GameFontHighlight")

    clearButton:SetScript("OnClick", function()
        searchBox:SetText(placeholderSearchText)
        searchBox:SetTextColor(0.5, 0.5, 0.5)
        searchBox:ClearFocus()
        UpdateListFrame(nil)
    end)

    return clearButton
end