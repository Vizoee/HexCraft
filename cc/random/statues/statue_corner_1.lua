local p = peripheral.wrap("left")
p.reset()

local cubes = {}
for i = 1, 16 do
    table.insert(cubes, {
        x1 = i-1,
        x2 = 16,
        y1 = 0,
        y2 = i,
        z1 = i-1,
        z2 = 16
    })
end
p.setCubes(cubes)
-- p.setCubes({{x1=8,x2=9,y1=13,y2=14,z1=6,z2=7},{x1=8,x2=9,y1=13,y2=14,z1=9,z2=10}})
-- p.setCubes({{x1=8,x2=9,y1=13,y2=14,z1=6,z2=7},{x1=8,x2=9,y1=13,y2=14,z1=9,z2=10},{x1=8,x2=9,y1=11,y2=12,z1=5,z2=6},{x1=8,x2=9,y1=10,y2=11,z1=6,z2=7},{x1=8,x2=9,y1=11,y2=12,z1=7,z2=9},{x1=8,x2=9,y1=10,y2=11,z1=9,z2=10},{x1=8,x2=9,y1=11,y2=12,z1=10,z2=11}})