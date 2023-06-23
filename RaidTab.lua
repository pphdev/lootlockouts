local _, core = ...;
core.RaidTab = {};

local Config = core.Config;
local RaidTab = core.RaidTab;

local function CreateButton(point, relativeFrame, relativePoint, yOffset, text, width, height)
  width = width or 140;
  height = height or 40;
  local btn = CreateFrame("Button", nil, relativeFrame, "GameMenuButtonTemplate");
  btn:SetPoint(point, relativeFrame, relativePoint, 0, yOffset);
  btn:SetSize(width,height);
  btn:SetText(text);
  btn:SetNormalFontObject("GameFontNormalLarge");
  btn:SetHighlightFontObject("GameFontHighlightLarge")
  return btn;
end;

function RaidTab:SetRaidTab(relativeParent)
  -- relativeParent.btn = CreateFrame("Button", nil, relativeParent, "GameMenuButtonTemplate");
  -- relativeParent.btn:SetPoint("TOPLEFT", relativeParent, "TOPLEFT", 0, 0);
  -- relativeParent.btn:SetSize(120,40);
  -- relativeParent.btn:SetText("hallo");
  -- relativeParent.btn:SetNormalFontObject("GameFontNormalLarge");
  -- relativeParent.btn:SetHighlightFontObject("GameFontHighlightLarge")
  relativeParent.btn = core.Config:CreateButton("TOPLEFT", relativeParent, "TOPLEFT", 0, "Hallo")

  -- return btn;
end