local center = {-991, 46, -133}

center = {
    x = center[1],
    y = center[2],
    z = center[3],
    ["iota$serde"] = "hextweaks:vec3"
}

local positions_file = fs.open("positions.json", "r")
local positions = textutils.unserialiseJSON(positions_file.readAll())
positions_file.close()

local hexPositions = {}
hexPositions["iota$serde"] = "hextweaks:list"
for _, value in ipairs(positions) do
    table.insert(hexPositions, {
        x=value[1],
        y=value[2],
        z=value[3],
        ["iota$serde"] = "hextweaks:vec3"
    })
end

local wand = peripheral.find("wand")

wand.clearStack()
wand.pushStack("hexcasting:akashic_bookshelf")
wand.pushStack(center)
wand.pushStack()
wand.pushStack(hexPositions)
wand.runPattern("NORTH_EAST", "dadad")