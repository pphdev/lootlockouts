local addonName, core = ...; -- Namespace

------------------------

-- core.commands = {
--   ["config"] = core.Config.Toggle,
--   ["help"] = core:Print();
-- };

local mmtooltipTitle = string.format("|cff00ff00%s|r","LootLockouts")
-- puts all arguments that are typed after "/ll" in str
local function HandleSlashCommands(str)
  if(tostring(str) == "config") then
     core.Config.Toggle();
     return;
  else
    core.Config.Toggle();
  end;
end;

function core:Print(...)
  local prefix = "LootLockouts";
  DEFAULT_CHAT_FRAME:AddMessage(prefix);
end;

function core:init(event, name)
  if (name ~= "LootLockouts") then return end;

  -- SLASH_RELOAD1 = "/rl"; -- for quicker reloading
  -- SlashCmdList.RELOAD = ReloadUI;

  -- SLASH_FRAMESTK1 = "/fs"; -- for showing framestack tool
  -- SlashCmdList.RELOAD = function()
  --   LoadAddOn("Blizzard_DebugTools");
  --   FrameStackTooltip_Toggle();
  -- end

  SLASH_LootLockouts1 = "/ll";
  SlashCmdList.LootLockouts = HandleSlashCommands;

  -- minimap button
  local buttonSize = 32
  local radius = 80
  local angle = 45

  local minimapFrame = CreateFrame("Button", "LootLockout_MinimapButton", Minimap)
  minimapFrame:SetSize(32, 32)
  minimapFrame:SetHighlightTexture("Interface\\AddOns\\LootLockouts\\assets\\Mmbtn.blp")
  minimapFrame:SetNormalTexture("Interface\\AddOns\\LootLockouts\\assets\\Mmbtn.blp")
  minimapFrame:SetPushedTexture("Interface\\AddOns\\LootLockouts\\assets\\Mmbtn.blp")
  -- minimapFrame:SetHighlightTexture("Interface\\MINIMAP\\UI-Minimap-ZoomButton-Highlight")
  -- minimapFrame:SetNormalTexture("Interface\\MINIMAP\\UI-Minimap-ZoomInButton-Up")
  -- minimapFrame:SetPushedTexture("Interface\\MINIMAP\\UI-Minimap-ZoomInButton-Down")

 
  minimapFrame:ClearAllPoints();
  -- minimapFrame:SetPoint("CENTER", Minimap, "CENTER", 80 * cos(45), 80 * sin(45))
   minimapFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 0, 0)
  minimapFrame:SetScript("OnClick", function(self, button)
    core.Config:Toggle();
  end)
  local texture = minimapFrame:CreateTexture(nil, "OVERLAY")
  texture:SetTexture("Interface\\AddOns\\LootLockouts\\assets\\Mmbtn.blp")
  -- texture:SetTexCoord(0, 1, 0, 1)
  texture:SetAllPoints(minimapFrame)
  minimapFrame.texture = texture;

  minimapFrame:EnableMouse(true)
  minimapFrame:SetMovable(true)
  minimapFrame:RegisterForDrag("LeftButton")
  minimapFrame:SetScript("OnDragStart", function(self)
    self:StartMoving()
  end)
  minimapFrame:SetScript("OnDragStop", function(self)
      self:StopMovingOrSizing()
  end)

  minimapFrame:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:SetText((mmtooltipTitle.."\nClick to toggle AddOn window"))
    GameTooltip:Show()
  end)

  minimapFrame:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
  end)

  -- core:Print();

end;

local events = CreateFrame("Frame");
events:RegisterEvent("ADDON_LOADED");
events:SetScript("OnEvent", core.init);
