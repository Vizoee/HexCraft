local wand = peripheral.find("wand")
local hexicon = require("/programfiles/hexlator/hexicon")

local function createAkashicCassette(pos, pattern, arguments)
    local load = {
        {-- Introspection
            ["startDir"] = "WEST",
            ["angles"] = "qqq",
            ["iota$serde"] = "hextweaks:pattern"
        },
        arguments,
        {
            ["x"] = pos.x or pos[1],
            ["y"] = pos.y or pos[2],
            ["z"] = pos.z or pos[3],
            ["iota$serde"] = "hextweaks:vec3"
        },
        pattern,
        {-- Retrospection
            ["startDir"] = "EAST",
            ["angles"] = "eee",
            ["iota$serde"] = "hextweaks:pattern"
        },
        {-- Flock's Disintegration
            ["startDir"] = "NORTH_WEST",
            ["angles"] = "qwaeawq",
            ["iota$serde"] = "hextweaks:pattern"
        },
        {-- Akasha's Distillation
            ["startDir"] = "WEST",
            ["angles"] = "qqqwqqqqqaq",
            ["iota$serde"] = "hextweaks:pattern"
        },
        {-- Hermes' Gambit
            ["startDir"] = "SOUTH_EAST",
            ["angles"] = "deaqq",
            ["iota$serde"] = "hextweaks:pattern"
        },
        ["iota$serde"] = "hextweaks:list"
    }
    return load
end

local function runAkashicCassette(pos, commandString, arguments)
    local commandPattern = hexicon.toHexicon(commandString)
    commandPattern["iota$serde"] = "hextweaks:pattern"
    arguments["iota$serde"] = "hextweaks:list"

    wand.pushStack(createAkashicCassette(pos, commandPattern, arguments))
    wand.pushStack(1)
    wand.pushStack("NI Cassette")
    -- Enqueue
    wand.runPattern("EAST", "qeqwqwqwqwqeqaweqqqqqwweeweweewqdwwewewwewweweww")
    wand.clearStack()
end


return {runAkashicCassette = runAkashicCassette}