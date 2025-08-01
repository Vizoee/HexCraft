
local x = 23
local z = 23
local center = {11.5, 11.5}

local list = {}
for i = 1, x do
    for j = 1, z do
        local pos = {i-center[1],j-center[2]}
        table.insert(list, pos)
    end
end

local file = fs.open("positions.json","w")
file.write(textutils.serializeJSON(list))
file.close()