local wand = peripheral.find("wand")

local turtle_pos = {x = -991.5, y = 42.5, z = -133.5}
local bookshelf_name = "akashic_bookshelf"

local min_range = {x = -9, y = 0, z = -9}
local max_range = {x = 10, y = 7, z = 10}

-- local pos = {x = -991.5, y = 42.5, z = -133.5, ["iota$serde"] = "hextweaks:vec3"}
-- wand.clearStack()
-- wand.pushStack(pos)
-- wand.runPattern("NORTH_EAST", "qqqqqe")
-- print(textutils.serialise(wand.getStack()))
-- wand.clearStack()

local function getBlockType(pos)
    pos["iota$serde"] = "hextweaks:vec3"
    wand.clearStack()
    wand.pushStack(pos)
    wand.runPattern("NORTH_EAST", "qqqqqe")
    local result = wand.getStack()
    wand.clearStack()
    return result[1]
end

local function checkIfBookshelf(pos)
    local results = getBlockType(pos)
    return results["path"] == bookshelf_name
end


local bookshelf_pos = {x=-985.5,y=43.5,z=-129.5}

local function writeSameLine(...)
    local x, y = term.getCursorPos()
    term.setCursorPos(1, y > 1 and y - 1 or y)
    print(...)
end

local function getBookshelfPositions()
    local result = {}
    local x_total = max_range.x - min_range.x
    local y_total = max_range.y - min_range.y
    local z_total = max_range.z - min_range.z
    local total = y_total * x_total * z_total
    local count = 0
    for y = min_range.y, max_range.y do
        for x = min_range.x, max_range.x do
            for z = min_range.z, max_range.z do
                count = count + 1
                local offset_pos = {
                    x=turtle_pos.x+x,
                    y=turtle_pos.y+y,
                    z=turtle_pos.z+z
                }
                if checkIfBookshelf(offset_pos) then
                    writeSameLine("Bookshelf! at", offset_pos.x, offset_pos.y, offset_pos.z)
                    print("")
                end
            end
            sleep(0)
            writeSameLine("                     ")
            writeSameLine("%", math.floor(count / total * 10000) / 100, " - ", y)
        end
    end
end
print("")
getBookshelfPositions()
-- print(max_range.y)