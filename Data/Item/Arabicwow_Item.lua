Arabicwow_Item = { }

function Arabicwow_Item:Get(id)
    if type(id) == 'number' then
        id = tostring(id)
    end

    if not self.Data[id] then
        return nil
    end

    local text = self.Data[id][1]

    if self.Data[id][2] then
        if tonumber(GetCVar("SpellTooltip_DisplayAvgValues")) == 1 then
            local n = {}
            for k, v in pairs(self.Data[id][2]) do
                local i1, i2 = v:match('(%d+)-(%d+)')
                n[k] = math.floor(( i1 + i2 ) / 2)
            end

            text = text:gsub("%$(N%d+)", n)
        else
            text = text:gsub("%$(N%d+)", self.Data[id][2])
        end
    end

    return {
        ["text"] = text,
    }
end

