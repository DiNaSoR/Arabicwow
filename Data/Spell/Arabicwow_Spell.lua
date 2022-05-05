Arabicwow_Spell = { }

function Arabicwow_Spell:Get(id)
    if type(id) == 'number' then
        id = tostring(id)
    end

    local text = nil
    local data = nil

    -- Newbie
	local checkbox = InterfaceOptionsHelpPanelBeginnerTooltips

	if checkbox ~= nil then
		checkbox.cvar = "showNewbieTips"
		if tonumber(GetCVar(checkbox.cvar)) == 1 then
			if self.Newbie[id] then
				data = self.Newbie[id]
			end
		end
	end
	
    if not data then
        data = self.Data[id]
    end

    if data then
        -- include macro
        text = string.gsub(data[1], "^include:(%w+):(%d+)$", function(type, i)
            if not self.Data[i] then
                return ""
            end
            return self.Data[i][1]
        end)

        -- average -> range
        if data[2] then
            local checkbox2 = InterfaceOptionsDisplayPanelShowSpellPointsAvg
            checkbox2.cvar = "SpellTooltip_DisplayAvgValues"
            if tonumber(GetCVar(checkbox2.cvar)) ~= 1 then
                local n = data[2]
                -- text = text:gsub("%$(N%d+,%d+)", n)
				 text = text:gsub("%$(N%d+)", n)

            end
        end
    end

    if not text or text == "" then
        return nil
    end

--    return {
--        ["text"] = string.gsub(text, "^%refer:(.+)$", self.Content),
--    }

    return {
        ["id"] = id,
        ["text"] = text,
        ["next"] = nil,
    }
end

function Arabicwow_Spell:GetNextRank(id)
    if type(id) == 'number' then
        id = tostring(id)
    end

    if self.Chain[id] then
        return self:Get(self.Chain[id])
    else
        return nil
    end
end

function Arabicwow_Spell:GetGlyphByName(name)
    if self.Glyph[name] then
        return self:Get(self.Glyph[name])
    else
        return nil
    end
end

function Arabicwow_Spell:GetTooltipText(id, tooltip)
    local spell = self:Get(id)

    if not spell then
        return nil
    end

    if not tooltip then
        tooltip = GameTooltip
    end

    function convertMacro(ar, en)
        local n = {}
        local j = 1
        en = string.gsub(en, "%|[cC][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]([^%|]+)%|[rR]", "%1")
        for i in string.gmatch(en, "[%d%,%.]+") do
            i = string.gsub(i, "%.$", "")
            i = string.gsub(i, ",", "")		
            i = string.gsub(i, "^%.", "")
            if i ~= '' then
                n['N' .. tostring(j)] = i
                j = j + 1
            end
        end

        return string.gsub(ar, "%$(N%d+)", n)
    end

    if string.match(spell.text, "$N%d+") then
--    if string.match(spell.text, "$N%d+") then
        local num = tooltip:NumLines()
        local target = _G[tooltip:GetName() .. "TextLeft" .. num]

        if target:GetText() == 'Right click to remove a point' then
            num = num - 1
            target = _G[tooltip:GetName() .. "TextLeft" .. num]
        end

        if target:GetText() == 'Left click to add a point' then
            num = num - 1
            target = _G[tooltip:GetName() .. "TextLeft" .. num]
        end

        num = num - 1

        local target2 = _G[tooltip:GetName() .. "TextLeft" .. num]
        if target2 then
            if target2:GetText() == 'Next rank:' then
                local spellnext = self:GetNextRank(id)

                if spellnext then
                    spell.next = convertMacro(spellnext.text, target:GetText())
                end

                num = num - 2
                target = _G[tooltip:GetName() .. "TextLeft" .. num]
            end
        end

        spell.text = convertMacro(spell.text, target:GetText())
    end

    return spell
end

function Arabicwow_Spell:GetBuff(id)
    if type(id) == 'number' then
        id = tostring(id)
    end

    local text = ""

    if self.Data[id] then
        text = self.Data[id][3]
    end

    if not text or text == "" then
        return nil
    end

    return {
        ["text"] = text,
    }
end

function Arabicwow_Spell:GetBuffTooltipText(id, tooltip)
    local spell = self:GetBuff(id)

    if not spell then
        return nil
    end

    if not tooltip then
        tooltip = GameTooltip
    end

    function convertMacro(ar, en)
        local n = {}
        local j = 1

        for i in string.gmatch(en, "[%d%.]+") do
            i = string.gsub(i, "%.$", "")
            i = string.gsub(i, "^%.", "")
            if i ~= '' then
                n['N' .. tostring(j)] = i
                j = j + 1
            end
        end

        return string.gsub(ar, "%$(N%d+)", n)
    end

    if string.match(spell.text, "$N%d+") then
        local num = tooltip:NumLines()
        local target = _G[tooltip:GetName() .. "TextLeft" .. num]

        if string.match(target:GetText(), "remaining$") then
            num = num - 1
            target = _G[tooltip:GetName() .. "TextLeft" .. num]
        end

        spell.text = convertMacro(spell.text, target:GetText())
    end

    return spell
end
