local p = peripheral.wrap("left")
p.reset()

local cubes = {}
for j = 0, 16 do
    for i = 1, 16-j do    
        table.insert(cubes, {
            x1 = i-1,
            x2 = 16,
            y1 = 15-j,
            y2 = 16-j,
            z1 = 16-i-j,
            z2 = 16
        })
    end
end
p.setCubes(cubes)