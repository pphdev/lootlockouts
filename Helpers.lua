local _, core = ...;
core.Helpers = {};
local Helpers = core.Helpers;

function core.Helpers:getTableLen(table)
  local counter = 0;
  for _, value in pairs(table) do
    counter = counter + 1;
  end
  return counter;
end