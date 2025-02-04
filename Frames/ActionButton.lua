---@class Protodragon_ActionButtonMixin : Button
local ActionButtonMixin = {};

function ActionButtonMixin:Init(spellID)
    self:SetScript("OnEnter", self.OnEnter);
    self:SetScript("OnLeave", self.OnLeave);
    self:RegisterForClicks("AnyUp", "AnyDown");

    self.Icon = self:CreateTexture("ARTWORK");
    self.Icon:SetAllPoints();

    if spellID then
        self:SetSpell(spellID);
    end

    self:SetAttribute("type", "action");
    self:SetAttribute("unit", "player");
end

function ActionButtonMixin:OnEnter()
    if not self.SpellLoaded then
        return;
    end

    GameTooltip:SetOwner(self, "ANCHOR_CURSOR");
    GameTooltip:SetSpellByID(self.SpellID);
    GameTooltip:Show();
end

function ActionButtonMixin:OnLeave()
    if not self.SpellLoaded then
        return;
    end

    GameTooltip:Hide();
end

function ActionButtonMixin:OnSpellLoaded()
    self.SpellLoaded = true;

    local fdid = self.Spell:GetSpellTexture();
    self.Icon:SetTexture(fdid);

    local name = self.Spell:GetSpellName();
    self:SetAttribute("spell", name);
end

function ActionButtonMixin:SetSpell(spellID)
    self.SpellID = spellID;
    self.Spell = Spell:CreateFromSpellID(spellID);
    self.Spell:ContinueOnSpellLoad(function() self:OnSpellLoaded() end);
end

function ActionButtonMixin:SetUnitTarget(unit)
    self:SetAttribute("unit", unit);
end

------------

---@class Protodragon_ActionButton : Protodragon_ActionButtonMixin

---@class Protodragon_ActionButtonBase
local ActionButtonBase = {};

---@param parent FrameScriptObject?
---@return Protodragon_ActionButton
function ActionButtonBase.New(parent, spellID)
    parent = parent or UIParent;
    local b = CreateFrame("Button", nil, parent, "SecureActionButtonTemplate");
    Mixin(b, ActionButtonMixin);
    b:Init(spellID);

    ---@diagnostic disable-next-line: return-type-mismatch
    return b;
end

------------

Protodragon.ActionButtonBase = ActionButtonBase;