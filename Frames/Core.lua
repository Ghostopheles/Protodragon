---@class Protodragon_Internal
local INTERNAL = select(2, ...);

---@class Protodragon
local Protodragon = Protodragon;

local GLOBAL_PREFIX = "PROTO_";
local DEFAULT_SIZE_X, DEFAULT_SIZE_Y = 250, 250;
local DEFAULT_PARENT = UIParent;

local function String_IsValid(str)
    return str and str ~= "";
end

---@class Protodragon_FrameConfig
---@field Name? string
---@field Title? string
---@field Width? number
---@field Height? number
---@field Parent? FrameScriptObject
---@field CloseOnEsc? boolean
local DefaultFrameConfig = {
    Name = nil,
    Title = nil,
    Width = DEFAULT_SIZE_X,
    Height = DEFAULT_SIZE_Y,
    Parent = DEFAULT_PARENT,
    CloseOnEsc = false,
};

---Creates a new prototype frame
---@param data? Protodragon_FrameConfig
---@return Protodragon_Frame
function Protodragon.CreateFrame(data)
    if not data then
        data = DefaultFrameConfig;
    end

    if data.CloseOnEsc and (not String_IsValid(data.Name)) then
        error("CloseOnEsc requires a valid frame name.");
    end

    local f = INTERNAL.NewFrameBase(data.Parent or DEFAULT_PARENT);
    f:SetPoint("CENTER");
    f:SetSize(data.Width or DEFAULT_SIZE_X, data.Height or DEFAULT_SIZE_Y);

    if String_IsValid(data.Name) then
        local g_name = GLOBAL_PREFIX .. data.Name;
        _G[g_name] = f;

        if data.CloseOnEsc then
            tinsert(UISpecialFrames, g_name);
        end
    end

    if String_IsValid(data.Title) then
        f:SetTitle(data.Title);
    end

    return f;
end

---Creates a new action button
---@param spellID number?
---@param sizeX number?
---@param sizeY number?
---@return Protodragon_ActionButton
function Protodragon.CreateActionButton(spellID, sizeX, sizeY)
    local f = INTERNAL.NewActionButtonBase(nil, spellID);
    f:SetPoint("CENTER");
    f:SetSize(sizeX or (DEFAULT_SIZE_X / 2), sizeY or (DEFAULT_SIZE_Y / 2));

    return f;
end

function Protodragon.Example()
    -- frame configuration - see full struct above
    local frameConfig = {
        Name = "Test Frame",
        CloseOnEsc = true,
    };

    local f = Protodragon.CreateFrame(frameConfig);
    local eb = f:AddEditBox("Editbox 1");
    eb:SetTag("TEST_BOX_1");

    local eb2 = f:AddEditBox("Editbox 2");
    eb2:SetNumeric(true);

    local function OnClick(...)
        local eb1 = f:GetElement("TEST_BOX_1");
        print(eb1:GetText());
    end

    f:AddButton("Click me!", OnClick);

    local modes = {
        {"Mode 1", 1},
        {"Mode 2", 2},
        {"Mode 3", 3},
        {"Mode 4", 4}
    };
    local label = "Mode";
    local defaultText = "Select Mode";
    f:AddRadioMenu(label, defaultText, modes);

    PROTO_EXAMPLEVAR = "owo";
    local interval = 1; -- check every 1 second
    f:AddWatchedVariable(function() return PROTO_EXAMPLEVAR; end, "PROTO_EXAMPLEVAR", interval);
end