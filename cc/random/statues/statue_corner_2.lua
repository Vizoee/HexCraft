local p = peripheral.wrap("left")
p.reset()

local cubes = {}
for i = 1, 16 do
    table.insert(cubes, {
        x1 = i-1,
        x2 = 16,
        y1 = 0,
        y2 = i,
        z1 = 0,
        z2 = i
    })
    table.insert(cubes, {
        x1 = 0,
        x2 = i,
        y1 = 0,
        y2 = i,
        z1 = i-1,
        z2 = 16
    })
end
p.setCubes(cubes)