local _, core = ...;
core.RaidTab = {};

local Config = core.Config;
local RaidTab = core.RaidTab;
local Helpers = core.Helpers;

local raids = core.InstanceData.raids;
local raidkeys = core.InstanceData.raidkeys;
local lastMessageArray = core.lastMessageArray;
local labelArray = {};

function RaidTab:ShowData(frame)
 
    local yPos = -30;
    local counter = 1;
    local keycounter = 1;
      -- iteration over all raids
      for key, value in pairs(raids) do
        local bossTable = {};
        local bossIsDone = {};
        -- iteration over a raid
        for _, value1 in pairs(raids[raidkeys[keycounter]]) do
          table.insert(bossTable, value1);
          -- iteration over lastMessageArray
          for _, value2 in pairs(lastMessageArray) do
            if raidkeys[keycounter] == "EN (N)" then
              if string.find(value2, value1) and (not string.find(value2, "Mythic")) and (not string.find(value2, "Chest"))
              and (not string.find(value2, "Shade of Xavius")) and (not string.find(value2, "Heroic")) then
                table.insert(bossIsDone, value1);
                -- print("Found: " .. value1);
              end
            elseif raidkeys[keycounter] == "EN (HC)" then
              if string.find(value2, value1) and (string.find(value2, "Heroic")) and (not string.find(value2, "Chest"))
              and (not string.find(value2, "Shade of Xavius")) then
                table.insert(bossIsDone, value1);
                -- print("Found: " .. value1);
              end
            elseif raidkeys[keycounter] == "EN (M)" then
              if string.find(value2, value1) and (string.find(value2, "Mythic")) and (not string.find(value2, "Chest"))
              and (not string.find(value2, "Shade of Xavius")) then
                table.insert(bossIsDone, value1);
                -- print("Found: " .. value1);
              end
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
        coloredOutputStr = string.gsub(coloredOutputStr, " - $", "")
        coloredOutputStr = string.gsub(coloredOutputStr, "^%s*-+%s*", "")
          -- print(Helpers:getTableLen(labelArray))       
        if (Helpers:getTableLen(labelArray) == Helpers:getTableLen(raids)) then
          labelArray[counter]:SetText(coloredOutputStr);
          -- print(Helpers:getTableLen(bossIsDone))
          counter = counter + 1;
          -- print(core.Helpers.getTableLen(instances));
          -- print("test if")
        else
          frame.InstanceLabel = core.Config:CreateLabel("CENTER", frame, "TOPLEFT", yPos, raidkeys[keycounter], 30);
          frame.InstanceBoss = core.Config:CreateLabel("CENTER", frame, "TOP", yPos, coloredOutputStr, 0);
          table.insert(labelArray, frame.InstanceBoss);
          -- print("test else")
        end;
        yPos = yPos - 30;
        keycounter = keycounter + 1;
      end
      
      -- frame.checkBtn:Hide();
      -- frame.rescanBtn:Show();
    --  print("Check Ende");
  end

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
  -- print("SetRaidTab Anfang")
  -- relativeParent.btn = CreateFrame("Button", nil, relativeParent, "GameMenuButtonTemplate");
  -- relativeParent.btn:SetPoint("TOPLEFT", relativeParent, "TOPLEFT", 0, 0);
  -- relativeParent.btn:SetSize(120,40);
  -- relativeParent.btn:SetText("hallo");
  -- relativeParent.btn:SetNormalFontObject("GameFontNormalLarge");
  -- relativeParent.btn:SetHighlightFontObject("GameFontHighlightLarge")
  -- relativeParent.btn = core.Config:CreateButton("TOPLEFT", relativeParent, "TOPLEFT", 0, "Hallo")
  RaidTab:ShowData(relativeParent);
  -- print("SetRaidTab Ende")
end