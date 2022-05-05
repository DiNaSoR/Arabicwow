Arabicwow_Achievement = { }

function Arabicwow_Achievement:Get(id)
    if type(id) == 'number' then
        id = tostring(id)
    end

    if not self.Data[id] then
        return nil
    end

    return {
        ["text"]   = self.Data[id][1],
        ["title"]  = self.Data[id][2],
        ["advice"] = self.Data[id][3]
    }
end

function Arabicwow_Achievement:GetID_ItemRefTooltip(tooltip)
    local title = _G[tooltip:GetName() .. "TextLeft1"]:GetText()

    if not self.Index[title] then
        return 0
    end

    local side = UnitFactionGroup("player") == 'Alliance' and 1 or 2

    local achievementID = self:GetID_Side(side, self.Index[title])

    return achievementID
end

function Arabicwow_Achievement:GetID_Side(side, index)
    local achievementID = 0
    local count = 0
    for id, line in pairs(index) do
        if line[1] == side or line[1] == 3 then
            achievementID = id
            count = count + 1
        end
    end

    if count == 1 then
        return achievementID
    else
        return 0
    end
end
