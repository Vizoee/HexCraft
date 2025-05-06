

local function getRunningPath()
    local runningProgram = shell.getRunningProgram()
    local programName = fs.getName(runningProgram)
    return runningProgram:sub(1, #runningProgram - #programName)
end

local function open(name, flag)
    return fs.open(getRunningPath().."/"..name, flag)
end

local function findAllAkasha()
    local center = {-991, 46, -133}
    local height = 30

    local centerHex = {
        x = center[1],
        z = center[3],
        ["iota$serde"] = "hextweaks:vec3"
    }

    local positions_file = open("/positions.json", "r")
    local positions = textutils.unserialiseJSON(positions_file.readAll())
    positions_file.close()

    local hexPositions = {}
    hexPositions["iota$serde"] = "hextweaks:list"
    for _, value in ipairs(positions) do
        table.insert(hexPositions, {
            x=value[1],
            y=0.5,
            z=value[2],
            ["iota$serde"] = "hextweaks:vec3"
        })
    end

    local hex_file = open("sliceHex.ser", "r")
    local slice_hex = textutils.unserialise(hex_file.readAll())
    hex_file.close()

    local wand = peripheral.find("wand")

    local function getAkashaPos(pos_list, y)
        centerHex.y = y
        wand.clearStack()
        wand.pushStack("hexcasting:akashic_bookshelf")
        wand.pushStack(centerHex)
        wand.pushStack(slice_hex)
        wand.pushStack(hexPositions)
        wand.runPattern("NORTH_EAST", "dadad")
        local results = wand.popStack()
        wand.clearStack()
        results["iota$serde"] = nil

        for _, value in ipairs(results) do
            table.insert(pos_list, {value.x, value.y, value.z})
        end
    end

    local lib_pos_list = {}

    for i = 0, height, 1 do
        local y = center[2]-i
        print("Checking Y="..y)
        getAkashaPos(lib_pos_list, y)
    end
    print("Got "..#lib_pos_list.." bookshelfs")

    local results_text = textutils.serialiseJSON(lib_pos_list)
    local results_file = open("lib_pos.json", "w")
    results_file.write(results_text)
    results_file.close()
end

-- return {findAllAkasha=findAllAkasha}
findAllAkasha()