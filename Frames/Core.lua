local DEFAULT_SIZE_X, DEFAULT_SIZE_Y = 250, 250;

local function String_IsValid(str)
    return str and str ~= "";
end

---Creates a new prototype frame
---@param name? string
---@param sizeX? number
---@param sizeY? number
---@param closeOnEsc? boolean
---@return Protodragon_Frame
function Protodragon.CreateFrame(name, sizeX, sizeY, closeOnEsc)
    if closeOnEsc and not String_IsValid(name) then
        error("closeOnEsc requires a valid frame name");
    end

    local f = Protodragon.FrameBase.New();
    f:SetPoint("CENTER");
    f:SetSize(sizeX or DEFAULT_SIZE_X, sizeY or DEFAULT_SIZE_Y);

    if String_IsValid(name) then
        f:SetTitle(name);

        local g_name = "GHT_" .. name;
        _G[g_name] = f;

        if closeOnEsc then
            tinsert(UISpecialFrames, g_name);
        end
    end

    return f;
end

---@param spellID number?
---@param sizeX number?
---@param sizeY number?
---@return Protodragon_ActionButton
function Protodragon.CreateActionButton(spellID, sizeX, sizeY)
    local f = Protodragon.ActionButtonBase.New(nil, spellID);
    f:SetPoint("CENTER");
    f:SetSize(sizeX or (DEFAULT_SIZE_X / 2), sizeY or (DEFAULT_SIZE_Y / 2));

    return f;
end

function Protodragon.Example()
    local f = Protodragon.CreateFrame("Test", nil, nil, true);
    local eb = f:AddEditBox("test box 1");
    eb:SetTag("TEST_BOX_1");

    local eb2 = f:AddEditBox("test box 2");
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

    GHOST_TESTVAR = "owo";
    f:AddWatchedVariable(function() return GHOST_TESTVAR; end, "Watched Variable");
end