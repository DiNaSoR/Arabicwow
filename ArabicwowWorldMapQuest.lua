ArabicwowWorldMapQuest = ArabicwowQuest:New("ArabicwowWorldMapQuestScroll")

function ArabicwowWorldMapQuest:OnInitialize()
    self:Initialize()

    self.selected = 0
    self.WorldMapQuestScrollFrameHeight = WorldMapQuestScrollFrame:GetHeight()

    ArabicwowWorldMapQuestShowArabicText:SetText("Show Arabic")
    ArabicwowWorldMapQuestShowArabic:SetPoint("BOTTOMRIGHT", WorldMapTrackQuest, "BOTTOMRIGHT", WorldMapTrackQuestText:GetWidth() + 45, 0)
    self:SetChecked(Arabicwow.db.profile.quest.worldmap)

	hooksecurefunc("WorldMapFrame_SelectQuestFrame", function(questFrame)
        self.selected = questFrame.questId
        ArabicwowWorldMapQuest:QuestInfo(questFrame.questId)
    end)
end

function ArabicwowWorldMapQuest:OnEnable()
    Arabicwow:DebugLog("ArabicwowWorldMapQuest: OnEnable.");
end

function ArabicwowWorldMapQuest:OnDisable()
    Arabicwow:DebugLog("ArabicwowWorldMapQuest: OnDisable.");
end

function ArabicwowWorldMapQuest:ResizeWorldMapQuestScrollFrame()
    if ArabicwowWorldMapQuestShowArabic:GetChecked() then
        local h = self.WorldMapQuestScrollFrameHeight - WorldMapQuestDetailScrollFrame:GetHeight() - 8
        WorldMapQuestScrollFrame:SetHeight(h)
    else
        WorldMapQuestScrollFrame:SetHeight(self.WorldMapQuestScrollFrameHeight)
    end
end

function ArabicwowWorldMapQuest:QuestInfo(questID)
    if not ArabicwowWorldMapQuestShowArabic:GetChecked() then
        return
    end

    self:ShowDefault(questID)
end

function ArabicwowWorldMapQuest:OnClickShowArabic()
    self:SetChecked(ArabicwowWorldMapQuestShowArabic:GetChecked())
    if ArabicwowWorldMapQuestShowArabic:GetChecked() then
        self:QuestInfo(self.selected)
    end
end

function ArabicwowWorldMapQuest:SetChecked(check)
    ArabicwowWorldMapQuestShowArabic:SetChecked(check)
    if not ArabicwowWorldMapQuestShowArabic:GetChecked() then
        self.Frame:Hide()
    end
    self:ResizeWorldMapQuestScrollFrame()
end
