ArabicwowToolTip = {}
ArabicwowToolTip.Tooltip = nil
ArabicwowToolTip.Store = nil

ArabicwowToolTip.TOOLTIP_NONE        = 0
ArabicwowToolTip.TOOLTIP_ITEM        = 1
ArabicwowToolTip.TOOLTIP_SPELL       = 2
ArabicwowToolTip.TOOLTIP_QUEST       = 3
ArabicwowToolTip.TOOLTIP_ACHIEVEMENT = 4

function ArabicwowToolTip:New(base)
    local obj = {}
    obj.base = base
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function ArabicwowToolTip:OnInitialize()
    Arabicwow:DebugLog(self.base .. ":OnInitialize");
    self:Initialize()
end

function ArabicwowToolTip:OnEnable()
    Arabicwow:DebugLog(self.base .. ":OnEnable");
    self:Enable()
end

function ArabicwowToolTip:OnDisable()
    Arabicwow:DebugLog(self.base .. ":OnDisable");
end

function ArabicwowToolTip:Initialize()
    self.selected  = { setup = false, type = self.TOOLTIP_NONE }
    self.developer = { setup = false }
    self.Store = nil

    self.Tooltip:HookScript("OnHide", function(tooltip)
--        self.selected.type  = self.TOOLTIP_NONE
        self:Restore()
    end)

    self.Tooltip:HookScript("OnTooltipCleared", function(tooltip)
        self.selected.setup  = false
        self.developer.setup = false
    end)

    self.Tooltip:HookScript("OnSizeChanged", function(tooltip, width, height)
        self:Resize(width, height)
    end)
end

function ArabicwowToolTip:Enable()
    Arabicwow:DebugLog(self.base .. ":Enable");

	self.Tooltip:HookScript("OnTooltipSetItem", function(tooltip)
		local name, link = tooltip:GetItem()

		if not link then
			return
		end

		local _, _, itemID = link:find("Hitem:(%d+):")
		self:DebugPrint('ITEM', itemID, name, self.Tooltip)

		if Arabicwow.db.profile.item.tooltip then
			item = Arabicwow_Item:Get(itemID)
			if item then
				self.selected.type  = self.TOOLTIP_ITEM
				self:AddText(item.text)
			end
		end

		self:DeveloperText("ItemID", itemID)
	end)

	self.Tooltip:HookScript("OnTooltipSetSpell", function(tooltip)
		local spellName, spellRank, spellID =  tooltip:GetSpell()
		self:DebugPrint('SPELL', spellID, spellName, self.Tooltip)

		if Arabicwow.db.profile.spell.tooltip then
			if not self:CheckEnhancedTooltips() then
				self:AddText(Arabicwow.L.NotEnhancedTooltips)
				return
			end

			spell = Arabicwow_Spell:GetTooltipText(spellID, self.Tooltip)
			if spell then
				self.selected.type  = self.TOOLTIP_SPELL
				if spell.next == nil then
					self:AddText(spell.text)
				else
					self:AddText(spell.text .. "\n|cffffffff" .. Arabicwow.L["NextRank"] .. "|r\n" .. spell.next)
				end
			end
		end

		self:DeveloperText("SpellID", spellID)
	end)
end

function ArabicwowToolTip:AddText(text)
    if text == '' then
        return
    end

    if not self:AddCheck(self.selected) then
        return
    end

    self:Restore()
    self.Tooltip:AddLine(text, 1, 0.4, 0)

    local num = self.Tooltip:NumLines()
    local target = _G[self.Tooltip:GetName() .. "TextLeft" .. num]
    local filename, fontHeight, flags =  target:GetFont()

    self.Store = {
        ["FontString"] = target,
        ["Font"]       = filename,
        ["Size"]       = fontHeight,
    }

    target:SetFont(Arabicwow.FONT, 14)
	target:SetJustifyH("RIGHT")
--    target:SetTextColor(1, 0.4, 0, 1)
end

function ArabicwowToolTip:DeveloperText(text, id)

	if id == nil then
		return
	end

    if Arabicwow.db.profile.developer then
        if not self:AddCheck(self.developer) then
            return
        end

        self.Tooltip:AddLine(text .. ": " .. id, 0.6, 0.6, 0.6)
--        self.Tooltip:AddLine(string.format("|cff999999%s: %d|r", text, id))
    end
end

function ArabicwowToolTip:Restore()
    if self.Store then
        self.Store.FontString:SetFont(
            self.Store.Font,
            self.Store.Size
        )
        self.Store = nil
    end
end

function ArabicwowToolTip:AddCheck(t)
    if t.setup then
        return false
    else
        t.setup = true
        return true
    end
end

function ArabicwowToolTip:AddSeparator()
    self.Tooltip:AddLine(" ")
end

function ArabicwowToolTip:Resize(width, height)
end

function ArabicwowToolTip:CheckEnhancedTooltips()
    local checkbox = InterfaceOptionsHelpPanelEnhancedTooltips
    checkbox.cvar = "UberTooltips"
    if tonumber(GetCVar(checkbox.cvar)) == 1 then
        return true
    else
        return false
    end
end

function ArabicwowToolTip:DebugPrint(base, id, name, tooltip)
    if ArabicwowDebugFrame:IsShown() then
        local num = tooltip:NumLines()
        local target = _G[tooltip:GetName() .. "TextLeft" .. num]

        local editbox = ArabicwowDebugFrameScrollFrameText
        base = base .. ":" .. tostring(id)

        editbox:SetText(editbox:GetText() .. "\nBEGIN:" .. base .. "\n" .. name .. "\n" .. target:GetText() .. "\nEND:" .. base .. "\n")
    end
end
