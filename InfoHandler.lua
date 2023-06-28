  -- Namespaces
  local _, core = ...;
  core.InfoHandler = {}; -- adds Config table to addon namespace
  core.lastMessage = nil;
  core.lastMessageArray = {};
  _G["LootLockouts"] = core

  
  core.DataFrame = CreateFrame("Frame");

  local Helpers = core.Helpers;
  local InfoHandler = core.InfoHandler;

  function InfoHandler:GetData()
    -- print("GetData aufgerufen");
    -- core.lastMessageArray = {};
    SendChatMessage(".loot_cd" ,"SAY", nil);
      core.DataFrame:RegisterEvent("CHAT_MSG_SYSTEM");
      core.DataFrame:SetScript("OnEvent", function(DataFrame, event, ...)
        local msg = ...;
        -- print("test")
        -- print(msg);
        C_Timer.After(0.2, function()
          core.lastMessage = msg;
          table.insert(core.lastMessageArray, msg);
          -- print("test")
        end)
        -- if callback then
        --   callback(core.lastMessage);
        -- end

        -- print(core.lastMessage);
      end)
      C_Timer.After(0.5, function()
        -- lastMess = core.lastMessage;
        -- firstDataCall = false;
        core.DataFrame:UnregisterEvent("CHAT_MSG_SYSTEM");
        -- print(lastMessageArray[1], lastMessageArray[2])
      end)
    -- print("Get Data fertig");
  end;
