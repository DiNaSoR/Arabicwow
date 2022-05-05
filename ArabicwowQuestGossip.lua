ArabicwowQuestGossip = ArabicwowQuest:New("ArabicwowQuestGossip")

ArabicwowQuestGossip.QUEST_DATA_INFO_TEMPLATE = "QuestData: |cffffffff%s|r"

function ArabicwowQuestGossip:OnInitialize()
    local obj = _G[self.base .. "TitleText"]
    obj:SetText("Arabicwow ("  .. Arabicwow.version .. ")")
    obj = _G[self.base .. "DataFrameText"]
    obj:SetFormattedText(self.QUEST_DATA_INFO_TEMPLATE, "unknown")

    self:Initialize()
    self.ScrollFrame = _G[self.Frame:GetName() .. "ScrollFrame"]

    self.QuestID =  _G[self.Frame:GetName() .. "QuestIdText"]
    self.QuestID:SetPoint("TOPLEFT", 0, -3)

    QuestFrameGreetingPanel:HookScript("OnShow", function()
        ArabicwowQuestGossip.Frame:Hide()
    end)
    QuestFrameDetailPanel:HookScript("OnShow", function()
        ArabicwowQuestGossip:QuestInfo(QUEST_DETAIL)
    end)
    QuestFrameProgressPanel:HookScript("OnShow", function()
        ArabicwowQuestGossip.Frame:Hide()
    end)
    QuestFrameRewardPanel:HookScript("OnShow", function()
        ArabicwowQuestGossip:QuestInfo(QUEST_COMPLETE)
    end)
end

function ArabicwowQuestGossip:OnEnable()
    Arabicwow:DebugLog("ArabicwowQuestGossip: OnEnable.");

    local obj = _G[self.base .. "DataFrameText"]
    obj:SetFormattedText(self.QUEST_DATA_INFO_TEMPLATE, Arabicwow.version)
end

function ArabicwowQuestGossip:OnDisable()
    Arabicwow:DebugLog("ArabicwowQuestGossip: OnDisable.");
end

function ArabicwowQuestGossip:QuestInfo(event)
    if not Arabicwow.db.profile.quest.gossip then
        self.Frame:Hide()
        return
    end

    Arabicwow:DebugLog("ArabicwowQuestGossip:QuestInfo")

    self:Clear()

    local index = self:GetID(event)

    if index.error or index.questID == 0 then
        self.Frame:Hide()
        return
    end

    if event == QUEST_DETAIL then
        self:ShowDetail(index.questID)
    elseif event == QUEST_COMPLETE then
        self:ShowComplete(index.questID)
    end

    if self.Arabicwow_Quest_Version == "unknown" and IsAddOnLoaded("Arabicwow_Quest") then
        self.Arabicwow_Quest_Version = Arabicwow.property.quest.version
        local obj = _G[self.base .. "DataFrameText"]
        obj:SetFormattedText(self.QUEST_DATA_INFO_TEMPLATE, self.Arabicwow_Quest_Version)
    end

    if QuestNPCModel:IsShown() then
        local point, relativeTo, relativePoint, xOffset, yOffset = QuestNPCModel:GetPoint(1) 
        QuestNPCModel:SetPoint(point, self.Frame, relativePoint, 0, yOffset)
    end
end

function ArabicwowQuestGossip:ShowDetail(questID)
    self:Show(questID, {
        { type = 1, empty = false, target = "title",       text = "" },
        { type = 2, empty = true,  target = "description", text = "" },
        { type = 1, empty = false, target = "",            text = Arabicwow.L["Objectives"] },
        { type = 2, empty = true,  target = "objective",   text = "" },
        { type = 1, empty = false, target = "",            text = Arabicwow.L["Translation"] },
        { type = 2, empty = true,  target = "translation", text = "" },
    })
end

function ArabicwowQuestGossip:ShowComplete(questID)
    self:Show(questID, {
        { type = 1, empty = false, target = "title",       text = "" },
        { type = 2, empty = false, target = "completion",  text = "" },
        { type = 1, empty = false, target = "",            text = Arabicwow.L["Translation"] },
        { type = 2, empty = true,  target = "translation", text = "" },
    })
end
