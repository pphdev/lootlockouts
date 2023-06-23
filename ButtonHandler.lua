local _, core = ...;
core.ButtonHandler = {};

local ButtonHandler = core.ButtonHandler;
local Config = core.Config;

function ButtonHandler:RescanData()
  core.lastMessageArray = {};
  core.InfoHandler.GetData();
  C_Timer.After(0.5, function()
    core.Config.ShowData();
    print("test hallo")
  end)
end