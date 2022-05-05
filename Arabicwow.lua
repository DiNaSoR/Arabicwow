Arabicwow = LibStub("AceAddon-3.0"):NewAddon("Arabicwow", "AceConsole-3.0")

Arabicwow.FONT = "Interface\\AddOns\\Arabicwow\\font\\Arabicwow.ttf";
Arabicwow.DEBUG = false -- false when release

Arabicwow.property = {}

function Arabicwow:OnInitialize()
    self.version = GetAddOnMetadata("Arabicwow", "Version")
    print(string.format("Welcome to Arabicwow Ver: %s.\nSetting is /Ar", self.version))

    self.db = LibStub('AceDB-3.0'):New("ArabicwowDB")
	self.db:RegisterDefaults({
        profile = {
            quest       = { questlog = false, worldmap = false, gossip = false, questlog_movable = false },
            item        = { tooltip = true },
            spell       = { tooltip = false, buff = false },
            achievement = { tooltip = false, advice = false },
            developer   = true, -- false when release
            development = { debugger = true }, -- false when release
        }
    })

    -- Quest --

    -- ToolTip --
    ArabicwowGameToolTip:OnInitialize()
    --ArabicwowItemRefTooltip:OnInitialize()

    --ArabicwowBuffToolTip:OnInitialize()
    --ArabicwowGlyphToolTip:OnInitialize()
end

function Arabicwow:OnEnable()
    self:DebugLog("Arabicwow: OnEnable.");

    -- Option --
    self:SetupOptions()

    -- Quest --

    -- ToolTip --
    ArabicwowGameToolTip:OnEnable()
    --ArabicwowItemRefTooltip:OnEnable()

    --ArabicwowBuffToolTip:OnEnable()
    --ArabicwowGlyphToolTip:OnEnable()
end

function Arabicwow:OnDisable()
    self:DebugLog("Arabicwow: OnDisable.");

    -- Quest --

    -- ToolTip --
    ArabicwowGameToolTip:OnDisable()
    --ArabicwowItemRefTooltip:OnDisable()

    --ArabicwowBuffToolTip:OnDisable()
    --ArabicwowGlyphToolTip:OnDisable()
end

function Arabicwow:LoadAddOn(addon)
    return true
end

function Arabicwow:uc(str)
    return string.gsub(str, "(%w)", function(s)
        return string.upper(s)
    end, 1)
end

function Arabicwow:lc(str)
    return string.gsub(str, "(%w)", function(s)
        return string.lower(s)
    end, 1)
end

function Arabicwow:SetupOptions()
    function GetOptions()
        return {
            type = "group",
            name = "Arabicwow",
            args = {
                general = {
                    type = "group",
                    name = "Arabicwow",
                    args = {
                        desc = {
                            type = "description",
                            name = "Arabicwow is addon that displays the Arabic translation of Quest information and Spell/Item ToolTips.",
                            order = 1,
                        },
                    },
                },
            },
        }
    end

    LibStub("AceConfig-3.0"):RegisterOptionsTable("Arabicwow", GetOptions())

    local dialog =  LibStub("AceConfigDialog-3.0")
    dialog:AddToBlizOptions("Arabicwow", nil, nil, "general")
    dialog:AddToBlizOptions("Arabicwow", "Quest", "Arabicwow", "quest")
    dialog:AddToBlizOptions("Arabicwow", "ToolTip", "Arabicwow", "tooltip")
    dialog:AddToBlizOptions("Arabicwow", "Developer", "Arabicwow", "developer")

    self:RegisterChatCommand("Ar", "ChatCommand")
end

function Arabicwow:ChatCommand(input)
    if input == 'debug' then
        -- Debug Window --
        if self.db.profile.development.debugger then
            ArabicwowDebugFrame:Show()
        end
    else
        self:OpenConfigDialog()
    end
end

function Arabicwow:OpenConfigDialog()
    LibStub("AceConfigDialog-3.0"):Open("Arabicwow")
end

function Arabicwow:DebugLog(args)
    if not self.DEBUG then
        return
    end

    if type(args) == 'string' then
        self:Print(args)
        return
    end

    if type(args) == 'number' then
        self:Print(tostring(args))
        return
    end

    if type(args) == 'table' then
        self:Print("----------")
        for n, v in pairs(args) do
            self:Print(n .. ' : ' .. v)
        end
        self:Print("----------")
        return
    end
end
