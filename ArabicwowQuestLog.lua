ArabicwowQuestLog = ArabicwowQuest:New("ArabicwowQuestLog")

ArabicwowQuestLog.QUEST_DATA_INFO_TEMPLATE = "Gnome Technology"

isCarbonInitialized = false

function ArabicwowQuestLog:OnInitialize()
    ArabicwowQuestLogTitleText:SetText("Arabicwow")
    ArabicwowQuestLogDataFrameText:SetFormattedText(self.QUEST_DATA_INFO_TEMPLATE, "unknown")

    self:Initialize()
    self.ScrollFrame = _G[self.Frame:GetName() .. "ScrollFrame"]

    self.QuestID =  _G[self.Frame:GetName() .. "QuestIdText"]
    self.QuestID:SetPoint("TOPLEFT", 0, -3)

    ArabicwowQuestLogShowArabicText:SetText("Arabic")
    self:SetChecked(Arabicwow.db.profile.quest.questlog)

--    local button = _G[self.Frame:GetName() .. "CloseButton"]
--    button:HookScript("OnClick", function()
--        ArabicwowQuestLog:SetChecked(false)
--    end)
end

function ArabicwowQuestLog:OnEnable()
    Arabicwow:DebugLog("ArabicwowQuestLog: OnEnable.");
    ArabicwowQuestLogDataFrameText:SetFormattedText(self.QUEST_DATA_INFO_TEMPLATE, "")

    self:SetMovable(Arabicwow.db.profile.quest.questlog_movable)

    if IsAddOnLoaded("Carbonite") then
		self:OnEnableCarbonite()
        return
    end

    if self:IsOldQuestGuru() then
        self:OnEnableQuestGuru()
    else
        ArabicwowQuestLogShowArabic:SetPoint("BOTTOMRIGHT", QuestLogFrameShowMapButtonText, "BOTTOMRIGHT", -85 - ArabicwowQuestLogShowArabicText:GetWidth(), -6)

        hooksecurefunc("QuestLogTitleButton_OnClick", function()
            ArabicwowQuestLog:QuestInfo()
        end)
    end

    self.Frame:GetParent():SetScript("OnShow", function()
        ArabicwowQuestLog:QuestInfo()
    end)
end

function ArabicwowQuestLog:OnDisable()
    Arabicwow:DebugLog("ArabicwowQuestLog: OnDisable.");
end

function ArabicwowQuestLog:OnEnableCarbonite()
	-- Move into CarboniteCheck due to Carbonite design change
	-- self.Frame:SetParent(NxQuestD)
	
	-- if NXQuestLogDetailScrollChildFrame ~= nil then 
	--	self.Frame:SetPoint("TOPLEFT", NXQuestLogDetailScrollChildFrame, NXQuestLogDetailScrollChildFrame:GetWidth() + 75, 42)
	-- end
	
    -- self:ResizeFrame(512)

    hooksecurefunc("QuestInfo_Display", function(quest_template, ...)
        if quest_template == QUEST_TEMPLATE_LOG then
            ArabicwowQuestLog:QuestInfo()
        end
    end)
end

function ArabicwowQuestLog:CarboniteCheck()

	if isCarbonInitialized == true then
		return
	end
	
	if NXQuestLogDetailScrollChildFrame ~= nil then 
		self.Frame:SetParent(NxQuestD)
		self.Frame:SetPoint("TOPLEFT", NXQuestLogDetailScrollChildFrame, NXQuestLogDetailScrollChildFrame:GetWidth() + 75, 42)
		self:ResizeFrame(512)
		isCarbonInitialized = true
	end
end

function ArabicwowQuestLog:QuestInfo()

	-- DEBUG CODE
	self:CarboniteCheck()
	-- DEBUG CODE

	
    if not ArabicwowQuestLogShowArabic:GetChecked() then
        self.Frame:Hide()
        return
    end

    local index = GetQuestLogSelection()
    local questLogTitleText, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID =  GetQuestLogTitle(index)

    if isHeader then
        return
    end

    self:ShowDefault(questID)

    if QuestNPCModel:IsShown() then
        local point, relativeTo, relativePoint, xOffset, yOffset = QuestNPCModel:GetPoint(1) 
        QuestNPCModel:SetPoint(point, self.Frame, relativePoint, 0, yOffset)
    end
end

function ArabicwowQuestLog:OnClickShowArabic()
    self:SetChecked(ArabicwowQuestLogShowArabic:GetChecked())
    if ArabicwowQuestLogShowArabic:GetChecked() then
        self:QuestInfo()
    else
        self.Frame:Hide()
    end
end

function ArabicwowQuestLog:IsOldQuestGuru()
    if IsAddOnLoaded("QuestGuru") then
        local version = GetAddOnMetadata("QuestGuru", "Version")

        if string.match(version, "^[01]") then
            return true
        end
    end

    return false
end

function ArabicwowQuestLog:OnEnableQuestGuru()
    self.Frame:SetParent(QuestGuru_QuestLogDetailScrollFrame)
    self.Frame:SetPoint("TOPLEFT", QuestGuru_QuestLogDetailScrollFrame, 330, 53);

    ArabicwowQuestLogShowArabic:SetParent(QuestGuru_QuestFrameOptionsButton)
    ArabicwowQuestLogShowArabic:SetPoint("BOTTOMRIGHT", QuestGuru_QuestFrameOptionsButton, "BOTTOMRIGHT", -120 - ArabicwowQuestLogShowArabicText:GetWidth(), -2)

    self:ResizeFrame(QuestGuru_QuestLogFrame:GetHeight())

    for i=1, QUESTGURU_QUESTS_DISPLAYED do
        button = _G["QuestGuru_QuestLogTitle" .. i]
        button:HookScript("OnClick", function()
            ArabicwowQuestLog:QuestInfo()
        end)
    end
end





function ArabicwowQuestLog:ResizeFrame(height)
    if height > 512 then
        height = 512
    end

    self.Frame:SetHeight(height)
    self.ScrollFrame:SetHeight(height - 104)

    height = height - 256
    local bl = _G[self.Frame:GetName() .. "BottomLeft"]
    bl:SetHeight(height)
    bl:SetTexCoord(0, 1, ((256 - height) / 256), 1)

    local br = _G[self.Frame:GetName() .. "BottomRight"]
    br:SetHeight(height)
    br:SetTexCoord(0, 1, ((256 - height) / 256), 1)
end

function ArabicwowQuestLog:SetChecked(check)
    ArabicwowQuestLogShowArabic:SetChecked(check)
end

function ArabicwowQuestLog:SetMovable(movable)
    self.Frame:SetMovable(movable)
    if movable then
        self.Frame:RegisterForDrag("LeftButton")
    end
end

function ArabicwowQuestLog:OnDragStart()
    if self.Frame:IsMovable() then
        self.Frame:StartMoving()
    end
end

function ArabicwowQuestLog:OnDragStop()
    if self.Frame:IsMovable() then
        self.Frame:StopMovingOrSizing()
        ValidateFramePosition(self.Frame)
    end
end
