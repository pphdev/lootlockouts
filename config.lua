-- Namespaces
local _, core = ...;
core.Config = {}; -- adds Config table to addon namespace

local Config = core.Config;
local UIConfig;
local denyDataCall = false;
local lastMess = nil;
local lastMessageArray = core.lastMessageArray;
local instances = core.InstanceData.instances;
local labelArray = {};
local Helpers = core.Helpers;


-- Config functions
function Config:Toggle()
	local menu = UIConfig or Config:CreateMenu();
	menu:SetShown(not menu:IsShown());
  if menu:IsShown() == true and denyDataCall == false then
    -- print(core.lastMessage);
    core.InfoHandler.GetData();
    denyDataCall = true ;
  end
  print("Toggle Funktion fertig");
end

function Config:CreateButton(point, relativeFrame, relativePoint, yOffset, text, width, height)
  width = width or 140;
  height = height or 40;
  local btn = CreateFrame("Button", nil, UIConfig.ScrollFrame, "GameMenuButtonTemplate");
  btn:SetPoint(point, relativeFrame, relativePoint, 0, yOffset);
  btn:SetSize(width,height);
  btn:SetText(text);
  btn:SetNormalFontObject("GameFontNormalLarge");
  btn:SetHighlightFontObject("GameFontHighlightLarge")
  return btn;
end;

function Config:CreateLabel(point, relativeFrame, relativePoint, yOffset, text, xOffset)
  xOffset = xOffset or 5
  local label = UIConfig.ScrollFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
  label:ClearAllPoints();
  label:SetFontObject("GameFontHighlight");
  label:SetPoint(point, relativeFrame, relativePoint, xOffset, yOffset);
  label:SetText(text);
  return label;
end;

function Config:CreateMenu()
  -- UIConfig is the parent frame for all other child frames and layers
  -- regions which are added will make it graphical
  UIConfig = CreateFrame("Frame", "LootLockoutsFrame", UIParent, "UIPanelDialogTemplate");
  UIConfig:SetSize(600,360); -- width, height
  UIConfig:SetPoint("CENTER"); -- point, relativeFrame, relativePoint, xOffset, yOffset
  
  -- Start Drag
  UIConfig:EnableMouse(true)
  UIConfig:SetMovable(true)
  UIConfig:RegisterForDrag("LeftButton")
  UIConfig:SetScript("OnDragStart", function(self)
      self:StartMoving()
  end)
  UIConfig:SetScript("OnDragStop", function(self)
      self:StopMovingOrSizing()
  end)
  -- Ende Drag

  -- Child frames and regions:
  UIConfig.title = UIConfig:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
  UIConfig.title:ClearAllPoints();
  UIConfig.title:SetFontObject("GameFontHighlight");
  UIConfig.title:SetPoint("LEFT", UIConfig.Title, "LEFT", 5, -6);
  UIConfig.title:SetText("LootLockouts");

  -- Creating Scroll Frame
  UIConfig.ScrollFrame = CreateFrame("ScrollFrame", nil, UIConfig, "UIPanelScrollFrameTemplate");
  UIConfig.ScrollFrame:SetPoint("TOPLEFT", LootLockoutsFrameDialogBG, "TOPLEFT", 4, -8);
  UIConfig.ScrollFrame:SetPoint("BOTTOMRIGHT", LootLockoutsFrameDialogBG, "BOTTOMRIGHT", -3, -8);

  -- Setting Child Clipping
  UIConfig.ScrollFrame:SetClipsChildren(true);

  -- Creating Child Frame
  local child = CreateFrame("Frame", nil, UIConfig.ScrollFrame);
  child:SetSize(550,300);
  UIConfig.ScrollFrame:SetScrollChild(child);

  -- Setting ScrollBar position
  UIConfig.ScrollFrame.ScrollBar:ClearAllPoints();
  UIConfig.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", UIConfig.ScrollFrame, "TOPRIGHT", -12, -18);
  UIConfig.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", UIConfig.ScrollFrame, "BOTTOMRIGHT", -7, 18);


  -- Debugging Coloring child
  -- child.bg = child:CreateTexture(nil, "BACKGROUND");
  -- child.bg:SetAllPoints(true);
  -- child.bg:SetColorTexture(0.2, 0.6, 0, 0.8)

  local function ShowData()
    local yPos = -30;
    local counter = 1;
      -- iteration over all instances
      for key, value in pairs(instances) do
        local bossTable = {};
        local bossIsDone = {};
        -- iteration over a dungeon
        for _, value1 in pairs(instances[key]) do
          table.insert(bossTable, value1);
          -- iteration over lastMessageArray
          for _, value2 in pairs(lastMessageArray) do
            if string.find(value2, value1) and string.find(value2, "Mythic") and (not string.find(value2, "Chest")) then
              table.insert(bossIsDone, value1);
              -- print("Found: " .. value1);
            end
          end
        end
  
        local coloredOutputStr = "";
        for key1, value3 in pairs(bossTable) do
          -- red coloring string
          if bossIsDone[key1] == value3 then
            local coloredStr = string.format("|cffff0000%s|r", value3)
            coloredOutputStr = string.join(" ", coloredOutputStr, coloredStr);
            -- print(value3);
          else
            -- green coloring string
            local coloredStr = string.format("|cff00ff00%s|r", value3)
            coloredOutputStr = string.join(" ", coloredOutputStr, coloredStr);
            -- print(bossIsDone[key1]);
          end
        end
          -- print(Helpers:getTableLen(labelArray))       
        if (Helpers:getTableLen(labelArray) == Helpers:getTableLen(instances)) then
          labelArray[counter]:SetText(coloredOutputStr);
          -- print(Helpers:getTableLen(bossIsDone))
          counter = counter + 1;
          -- print(core.Helpers.getTableLen(instances));
          -- print("test if")
        else
          child.InstanceLabel = self:CreateLabel("CENTER", child, "TOPLEFT", yPos, key, 30);
          child.InstanceBoss = self:CreateLabel("CENTER", child, "TOP", yPos, coloredOutputStr, 0);
          table.insert(labelArray, child.InstanceBoss);
          -- print("test else")
        end;
        yPos = yPos - 30;
        -- C_Timer.After(0.4, function()
        --   print(coloredOutputStr);
        -- end)
        -- print(#bossTable)
      end
      
      UIConfig.checkBtn:Hide();
      UIConfig.rescanBtn:Show();
      print("Check Ende");
  end

  -- Check Button
  UIConfig.checkBtn = self:CreateButton("CENTER", child, "CENTER", 0, "Check");
  UIConfig.checkBtn:SetScript("OnClick", function()
    ShowData();
  end)

  -- Reload Button
  UIConfig.rescanBtn = self:CreateButton("TOPRIGHT", child, "TOPRIGHT", 0, "Rescan", 120);
  UIConfig.rescanBtn:SetScript("OnClick", function()
    core.lastMessageArray = {};
    core.InfoHandler.GetData();
    C_Timer.After(0.5, function()
      ShowData();
    end)
  end)
  UIConfig.rescanBtn:Hide();

  -- Player label
  local _, englishClass, _ = UnitClass("player");
  local rPerc, gPerc, bPerc, _ = GetClassColor(englishClass)
  UIConfig.charLabel = self:CreateLabel("CENTER", child, "TOP", -10, UnitName("player"),0);
  UIConfig.charLabel:SetTextColor(rPerc,gPerc,bPerc);

  -- Creating Instance Labels
  UIConfig:Hide();
  return UIConfig;
end;



