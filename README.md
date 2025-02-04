# Protodragon
An addon for developers to assist with rapid prototyping.

# Usage

Protodragon's API is (hopefully) quite simple to use.
```lua
local PD = Protodragon;

local title = "My Title";
local width, height = 100, 200;
local closeOnEsc = false;
local frame = PD.CreateFrame(title, width, height, closeOnEsc);

-- add a title
frame:AddTitle("Title Text");

-- add regular text
local str = frame:AddFontString("GameFontNormal");
str:SetText("bark");

-- add an edit box
local label = "My EditBox";
local width = 80;
local eb = frame:AddEditBox(label, width);

-- add a button
local text = "Bark";
local function Callback(self, button)
    print("Clicked!");
end
local button = frame:AddButton(text, Callback);

-- add a radio menu
local label = "My Radio Menu";
local default = "Select Option";
local values = {
    {"Option 1", 1},
    {"Option 2", 2},
    {"Option 3", 3}
};
frame:AddRadioMenu(label, default, values);

-- add a watched variable
local name = "In Combat";
local function Lookup()
    return tostring(InCombatLockdown());
end
local interval = 5; -- check every 5 seconds (default is every frame)
frame:AddWatchedVariable(Lookup, name, interval);

-- make the frame draggable
frame:AddDragBar();
```