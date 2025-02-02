local x = 7
local y = 7
local z = 7

local file = fs.open("test.hexpattern", "w")

for i = 0, x do
    for j = 0, y do
        for k = 0, z do
            file.write("@vec("..i..", "..j..", "..k..")")
        end
    end
end
file.close()