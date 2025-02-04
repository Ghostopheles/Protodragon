local PH_BUTTON_TEXT = "$TEXT$";
local PH_LABEL = "$LABEL$";

------------

local function SetupWatchTimer(self, interval)
    if self.WatchTimers[interval] then
        return;
    end

    self.WatchCallbacks[interval] = {};
    local timer = C_Timer.NewTicker(interval, function()
        for _, callback in ipairs(self.WatchCallbacks[interval]) do
            local success, result = pcall(callback);
            if not success then
                --TODO: do something here?
            end
        end
    end);
    self.WatchTimers[interval] = timer;
end

------------

---@class Protodragon_FrameBaseMixin : Frame
local FrameBaseMixin = {};

function FrameBaseMixin:Init()
    ButtonFrameTemplate_HidePortrait(self);

    self.NumElements = 0;
    self.TagToElement = {};

    self.Workspace = CreateFrame("Frame", nil, self, "VerticalLayoutFrame");
    self.Workspace:SetPoint("TOPLEFT", 4, -50);
    self.Workspace:SetPoint("BOTTOMRIGHT", -4, 4);
    self.Workspace.spacing = 20;

    self.WatchCallbacks = {};
    self.WatchTimers = {};
end

function FrameBaseMixin:IncrementNumElements()
    self.NumElements = self.NumElements + 1;
end

function FrameBaseMixin:GetElement(tag)
    return self.TagToElement[tag];
end

function FrameBaseMixin:AddTagAccessors(obj)
    if obj.SetTag or obj.GetTag or obj.Tag or obj.ClearTag then
        return;
    end

    obj.SetTag = function(_obj, tag)
        _obj.Tag = tag;
        self.TagToElement[tag] = _obj;
    end

    obj.GetTag = function(_obj)
        return _obj.Tag;
    end

    obj.ClearTag = function(_obj)
        local tag = _obj:GetTag();
        self.TagToElement[tag] = nil;
        _obj.Tag = nil;
    end
end

function FrameBaseMixin:AddToLayout(object)
    self:IncrementNumElements();
    object.layoutIndex = self.NumElements;
    object.align = "center";

    self:AddTagAccessors(object);
    self.Workspace:MarkDirty();
end

function FrameBaseMixin:AddLabelToElement(obj, text)
    obj.Label = obj:CreateFontString(nil, "ARTWORK", "DatamineCleanFont");
    obj.Label:SetPoint("BOTTOMLEFT", obj, "TOPLEFT", 0, 4);
    obj.Label:SetJustifyH("LEFT");
    obj.Label:SetText(text or PH_LABEL);
    return obj.Label;
end

---@return FontString
function FrameBaseMixin:AddFontString(font)
    local str = self.Workspace:CreateFontString(nil, "ARTWORK", font or "DatamineCleanFont");
    self:AddToLayout(str);
    return str;
end

---@param text string
---@return FontString
function FrameBaseMixin:AddTitle(text)
    local str = self:AddFontString("DatamineCleanFontBig");
    str:SetTextToFit(text);
    str:SetHeight(str:GetStringHeight());

    self:AddToLayout(str);
    return str;
end

---@param label string
function FrameBaseMixin:AddEditBox(label, width)
    local eb = CreateFrame("EditBox", nil, self.Workspace, "InputBoxTemplate");
    eb:SetAutoFocus(false);
    eb:SetSize(width or 80, 18);

    self:AddLabelToElement(eb, label);
    self:AddToLayout(eb);
    return eb;
end

---@param label string
---@param maxLetters number
function FrameBaseMixin:AddMultiLineEditBox(label, maxLetters)
    local eb = CreateFrame("ScrollFrame", nil, self.Workspace, "GhostProtoEditBoxTemplate");

    self:AddLabelToElement(eb, label);
    self:AddToLayout(eb);
    return eb;
end

---@param text string
---@param callback function
---@param isGold? boolean if true, uses the gold border template
function FrameBaseMixin:AddButton(text, callback, isGold)
    local template = isGold and "SharedGoldRedButtonTemplate" or "SharedButtonSmallTemplate";
    local button = CreateFrame("Button", nil, self.Workspace, template);
    button:SetText(text or PH_BUTTON_TEXT);
    button:SetScript("OnClick", callback);

    self:AddToLayout(button);
    return button;
end

---@param label string
---@param defaultText string
---@param values table<table<string, any>>
function FrameBaseMixin:AddRadioMenu(label, defaultText, values)
    local dropdown = CreateFrame("DropdownButton", nil, self.Workspace, "WowStyle1DropdownTemplate");
    dropdown:SetDefaultText(defaultText);

    self:AddLabelToElement(dropdown, label);
    self:AddToLayout(dropdown);

    local g_selected;
    local function IsSelected(value)
        return value == g_selected;
    end

    local function SetSelected(value)
        g_selected = value;
    end

    MenuUtil.CreateRadioMenu(dropdown, IsSelected, SetSelected, unpack(values));
    return dropdown;
end

---@param lookupFunc function
---@param name string
---@param interval number?
function FrameBaseMixin:AddWatchedVariable(lookupFunc, name, interval)
    local str = self:AddFontString("DatamineCleanFont");
    self:AddToLayout(str);

    if not self.WatchVariables then
        self.WatchVariables = {};
    end
    self.WatchVariables[name] = str;

    interval = interval or 0;
    SetupWatchTimer(self, interval);
    local callback = function()
        local value = lookupFunc();
        local text = format("%s: %s", name, value);
        str:SetTextToFit(text);
        str:SetHeight(str:GetStringHeight());
        self.Workspace:MarkDirty();
    end
    tinsert(self.WatchCallbacks[interval], callback);
end

function FrameBaseMixin:AddDragBar()
    if self.DragBar then
        return;
    end

    local dragBar = CreateFrame("Frame", nil, self, "PanelDragBarTemplate");
    dragBar:SetPoint("TOPLEFT");
    dragBar:SetPoint("TOPRIGHT");
    dragBar:SetHeight(32);

    self:SetMovable(true);
    self.DragBar = dragBar;
    return dragBar;
end

------------

---@class Protodragon_Frame : Protodragon_FrameBaseMixin

---@class Protodragon_FrameBase
local FrameBase = {};

---@param parent FrameScriptObject?
---@return Protodragon_Frame
function FrameBase.New(parent)
    parent = parent or UIParent;
    local f = CreateFrame("Frame", nil, parent, "PortraitFrameFlatTemplate");
    Mixin(f, FrameBaseMixin);
    f:Init();

    ---@diagnostic disable-next-line: return-type-mismatch
    return f;
end

------------

Protodragon.FrameBase = FrameBase;
