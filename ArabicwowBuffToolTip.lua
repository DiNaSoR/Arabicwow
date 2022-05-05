ArabicwowBuffToolTip = ArabicwowToolTip:New("ArabicwowBuffToolTip")
ArabicwowBuffToolTip.Tooltip = ArabicwowAssistTooltip

ArabicwowBuffToolTip.BuffList = {};
ArabicwowBuffToolTip.BuffStore = nil

function ArabicwowBuffToolTip:OnEnable()
	hooksecurefunc("AuraButton_Update", function(buttonName, index, filter)
		local buffName = buttonName .. index

		if self.BuffList[buffName] then
			return
		end

		local buff = _G[buffName]

		if buff then
			buff:HookScript("OnEnter", function(button)
				self:OnShow(button)
			end)

			buff:HookScript("OnLeave", function(button)
				self:OnHide(button)
			end)

			self.BuffList[buffName] = true
		end
	end)
end

function ArabicwowBuffToolTip:OnShow(button)
    if not Arabicwow.db.profile.spell.buff then return end

    local w = GameTooltip:GetWidth()
    self.Tooltip:SetOwner(GameTooltip, "ANCHOR_BOTTOMLEFT", w, 0)
    w = w - 20
    self.Tooltip:ClearLines()
    self.Tooltip:SetMinimumWidth(w)

    local num = 1
    local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spellID = UnitAura(PlayerFrame.unit, button:GetID(), button.filter)

    local spell = Arabicwow_Spell:GetBuffTooltipText(spellID, GameTooltip)
    if spell then
        local target = _G["ArabicwowAssistTooltipTextLeft" .. num]
        target:SetWidth(w)
        self:AddText(spell.text)
        num = num + 1
    end

    local target = _G["ArabicwowAssistTooltipTextLeft" .. num]
    target:SetWidth(w)

    if num == 1 then
        local filename, fontHeight, flags =  target:GetFont()

        self.BuffStore = {
            ["FontString"] = target,
            ["Font"]       = filename,
            ["Size"]       = fontHeight,
        }

        target:SetFont(filename, 12)
    end

    self:DeveloperText("SpellID", spellID)
    self.Tooltip:SetWidth(w)
    self.Tooltip:Show()
end

function ArabicwowBuffToolTip:OnHide(button)
    if self.Tooltip:IsShown() then
        self.Tooltip:Hide()
--        self.Tooltip:ClearLines()

        if self.BuffStore then
            self.BuffStore.FontString:SetFont(
                self.BuffStore.Font,
                self.BuffStore.Size
            )
            self.BuffStore = nil
        end

        for i=1, 8 do
            _G["ArabicwowAssistTooltipTextLeft" .. i]:SetWidth(0)
        end

        self.Tooltip:SetWidth(0)
        self.Tooltip:SetOwner(UIParent, "ANCHOR_NONE")
    end
end
