local robot = require("robot")
local term = require("term")

function toByteList(number)
  rest = number
  result = {}
  while rest ~= 0 do
    table.insert(result, rest % 2)
    rest = math.floor(rest / 2)
  end
  return result
end

function toInt(buffer)
  result = 0
  n = 1
  for a, i in pairs(buffer) do
    if i == 1 then
      result = result + n
    end
    n = n * 2
  end
  return result
end

-- for debugging to print out lists, stolen from stackoverflow
function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function send(msg)
  for i = 1, #msg do
    local c = str:msg(i,i)
    encoded = toByteList(string.byte(c))
    for a, i in pairs(encoded) do
      if i == 1 then
        robot.drop(1)
      end
      os.sleep(waittime)
    end
  end
end
----------------------------------------------------------------

receiving = true
waittime = 1
buffer = {}

-- simple kill command
for i=1,33 do
  if #buffer == 8 then
    -- convert received bits to int and then to char
    asInt = toInt(buffer)
    if asInt == 0 then
      --one empyt byte, no message / end of message
      -- in future: allow to write
      print("no msg!")
    else
      char = string.char(asInt)
      print(char)
    end
    buffer = {}
  end
  if robot.suck() then
  -- one item picked up (at least)
    table.insert(buffer, 1)
    os.sleep(waittime)
  else
  -- nothing picked up
    table.insert(buffer, 0)
    os.sleep(waittime)
  end
end
