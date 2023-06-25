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
local RaidTab = core.RaidTab;
local ButtonHandler = core.ButtonHandler;

local tabs = {}; -- contains both tabs
local isChecked = false;

-- Config functions
function Config:Toggle()
	local menu = UIConfig or Config:CreateMenu();
	menu:SetShown(not menu:IsShown());
  if menu:IsShown() == true and denyDataCall == false then
    -- print(core.lastMessage);
    core.InfoHandler.GetData();
    denyDataCall = true ;
  end
  -- print("Toggle Funktion fertig");
end

function Config:CreateButton(point, relativeFrame, relativePoint, yOffset, text, width, height)
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

function Config:CreateLabel(point, relativeFrame, relativePoint, yOffset, text, xOffset)
  xOffset = xOffset or 5
  local label = relativeFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
  label:ClearAllPoints();
  label:SetFontObject("GameFontHighlight");
  label:SetPoint(point, relativeFrame, relativePoint, xOffset, yOffset);
  label:SetText(text);
  return label;
end;


local function Tab_OnClick(self)
  PanelTemplates_SetTab(self:GetParent(), self:GetID());

  local scrollChild = UIConfig.ScrollFrame:GetScrollChild();
  if(scrollChild) then
    scrollChild:Hide()
  end

  UIConfig.ScrollFrame:SetScrollChild(self.content);
  self.content:Show();
end

local function SetTabs(frame, numTabs, ...)
  frame.numTabs = numTabs;

  local contents = {};
  local frameName = frame:GetName();

  for i = 1, numTabs do
    local tab = CreateFrame("Button", frameName .."Tab"..i, frame, "CharacterFrameTabButtonTemplate");
    tab:SetID(i);
    tab:SetText(select(i, ...))
    tab:SetScript("OnClick", Tab_OnClick);
    tab:SetSize(550,30);

    tab.content = CreateFrame("Frame", nil, UIConfig.ScrollFrame);
    tab.content:SetSize(550,300);
    tab.content:Hide();

    -- tab.content.bg = tab.content:CreateTexture(nil, "BACKGROUND");
    -- tab.content.bg:SetAllPoints(true);
    -- tab.content.bg:SetColorTexture(math.random(), math.random(), math.random(), 0.6)

    table.insert(tabs, tab);
    table.insert(contents, tab.content);

    if (i == 1) then
      tab:SetPoint("TOPLEFT", UIConfig, "BOTTOMLEFT", 5, 7);
    else
      tab:SetPoint("TOPLEFT", _G[frameName.."Tab"..(i-1)], "TOPRIGHT", -14, 0)
    end
  end
  Tab_OnClick(_G[frameName.."Tab1"]);

  return unpack(contents);
end

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
  UIConfig.title:SetText("LootLockouts by Wáyne/Tho");

  -- Creating Scroll Frame
  UIConfig.ScrollFrame = CreateFrame("ScrollFrame", nil, UIConfig, "UIPanelScrollFrameTemplate");
  UIConfig.ScrollFrame:SetPoint("TOPLEFT", LootLockoutsFrameDialogBG, "TOPLEFT", 4, -8);
  UIConfig.ScrollFrame:SetPoint("BOTTOMRIGHT", LootLockoutsFrameDialogBG, "BOTTOMRIGHT", -3, -8);

  -- Setting Child Clipping
  UIConfig.ScrollFrame:SetClipsChildren(true);

  -- Creating Child Frame
  -- local child = CreateFrame("Frame", nil, UIConfig.ScrollFrame);
  -- child:SetSize(550,300);
  -- UIConfig.ScrollFrame:SetScrollChild(child);

  -- Setting ScrollBar position
  UIConfig.ScrollFrame.ScrollBar:ClearAllPoints();
  UIConfig.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", UIConfig.ScrollFrame, "TOPRIGHT", -12, -18);
  UIConfig.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", UIConfig.ScrollFrame, "BOTTOMRIGHT", -7, 28);

  local content1, content2 = SetTabs(UIConfig, 2, "Dungeons", "Raids")
  
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
        local conBossTable = table.concat(bossIsDone, " ");
        for key1, value3 in pairs(bossTable) do
          -- red coloring string
          if string.find(conBossTable, value3) then
            local coloredStr = string.format("|cffff0000%s|r", value3)
            coloredOutputStr = string.join(" - ", coloredOutputStr, coloredStr);
            -- print(value3);
          else
            -- green coloring string
            local coloredStr = string.format("|cff00ff00%s|r", value3)
            coloredOutputStr = string.join(" - ", coloredOutputStr, coloredStr);
          end
        end
          -- print(Helpers:getTableLen(labelArray))
        coloredOutputStr = string.gsub(coloredOutputStr, " - $", "")
        coloredOutputStr = string.gsub(coloredOutputStr, "^%s*-+%s*", "")      
        if (Helpers:getTableLen(labelArray) == Helpers:getTableLen(instances)) then
          labelArray[counter]:SetText(coloredOutputStr);
          -- print(Helpers:getTableLen(bossIsDone))
          counter = counter + 1;
          -- print(core.Helpers.getTableLen(instances));
          -- print("test if")
        else
          content1.InstanceLabel = self:CreateLabel("CENTER", content1, "TOPLEFT", yPos, key, 30);
          content1.InstanceBoss = self:CreateLabel("CENTER", content1, "TOP", yPos, coloredOutputStr, 0);
          table.insert(labelArray, content1.InstanceBoss);
          -- print("test else")
        end;
        yPos = yPos - 30;
      end
      
      content1.checkBtn:Hide();
      content1.rescanBtn:Show();
    --  print("Check Ende");
  end

  -- Check Button
  content1.checkBtn = self:CreateButton("CENTER", content1, "CENTER", 0, "Check");
  content1.checkBtn:SetScript("OnClick", function()
    ShowData();
    RaidTab:SetRaidTab(content2);
    -- print("Click Check")
  end)

  -- Reload Button
  content1.rescanBtn = self:CreateButton("TOPRIGHT", content1, "TOPRIGHT", 0, "Rescan", 120);
  content1.rescanBtn:SetScript("OnClick", function()
    core.lastMessageArray = {};
    core.InfoHandler.GetData();
    C_Timer.After(0.5, function()
      ShowData();
    end)
  end)
  content1.rescanBtn:Hide();

  -- Player label
  local _, englishClass, _ = UnitClass("player");
  local rPerc, gPerc, bPerc, _ = GetClassColor(englishClass)
  content1.charLabel = self:CreateLabel("CENTER", content1, "TOP", -10, UnitName("player"),0);
  content1.charLabel:SetTextColor(rPerc,gPerc,bPerc);

  -- RaidTab:SetRaidTab(content2);

  -- tabs[2]:Disable();
  -- tabs[1]:SetTextColor(0.5,0.5,0.5)
  UIConfig:Hide();
  return UIConfig;
end;



