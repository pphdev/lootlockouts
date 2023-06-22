local addonName, core = ...; -- Namespace

------------------------

-- core.commands = {
--   ["config"] = core.Config.Toggle,
--   ["help"] = core:Print();
-- };

-- puts all arguments that are typed after "/ll" in str
local function HandleSlashCommands(str)
  if(tostring(str) == "config") then
     core.Config.Toggle();
     return;
  end;
end;

function core:Print(...)
  local prefix = "LootLockouts";
  DEFAULT_CHAT_FRAME:AddMessage(prefix);
end;

function core:init(event, name)
  if (name ~= "LootLockouts") then return end;

  SLASH_RELOAD1 = "/rl"; -- for quicker reloading
  SlashCmdList.RELOAD = ReloadUI;

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
  minimapFrame:SetHighlightTexture("Interface\\MINIMAP\\UI-Minimap-ZoomButton-Highlight")
  minimapFrame:SetNormalTexture("Interface\\MINIMAP\\UI-Minimap-ZoomInButton-Up")
  minimapFrame:SetPushedTexture("Interface\\MINIMAP\\UI-Minimap-ZoomInButton-Down")

 

  -- minimapFrame:SetPoint("CENTER", Minimap, "CENTER", 80 * cos(45), 80 * sin(45))
  --  minimapFrame:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0)
  minimapFrame:SetScript("OnClick", function(self, button)
    core.Config:Toggle();
  end)
   local texture = minimapFrame:CreateTexture(nil, "BACKGROUND")
   texture:SetTexture("Interface\\MINIMAP\\UI-Minimap-ZoomInButton-Up")
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
  

  core:Print();

end;

local events = CreateFrame("Frame");
events:RegisterEvent("ADDON_LOADED");
events:SetScript("OnEvent", core.init);
