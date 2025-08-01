local filesLocation = "/programs/akasha/data/"

-- Structure
--     spells - dict of spell names as keys and positions as values
--     unused_positions - list of unused positions
SpellLibrary = nil
local wand = peripheral.find("wand")
local hexicon = require("/programfiles/hexlator/hexicon")

local library = {}

local function open(name, flag)
    return fs.open(filesLocation .. name, flag)
end

local function updateSpellLibrary()
    local file = open("spellLibrary.json", "w")
    file.write(textutils.serialiseJSON(SpellLibrary))
    file.close()
end

local function reverseTable(tbl)
    local reversed = {}
    for i = #tbl, 1, -1 do
        table.insert(reversed, tbl[i])
    end
    return reversed
end

local function getSpellLibrary()
    local file = open("spellLibrary.json", "r")
    local content
    if file then
        content = file.readAll()
        file.close()
    end

    if content and content ~= "" then
        SpellLibrary = textutils.unserialiseJSON(content)
    else
        SpellLibrary = {}
        SpellLibrary.spells = {}
        
        file = open("lib_pos.json", "r")
        if file then
            content = file.readAll()
            file.close()
        end

        if content then
            local a_pos = textutils.unserialiseJSON(content)
            SpellLibrary.unused_positions = reverseTable(a_pos)
        else
            SpellLibrary.unused_positions = {}
        end

        updateSpellLibrary()
    end
    return SpellLibrary
end

local function pickNewSpellLocation()
    local pos = SpellLibrary.unused_positions[#SpellLibrary.unused_positions]
    if not pos then
        error("No more spaces for spells")
    end
    
    SpellLibrary.unused_positions[#SpellLibrary.unused_positions] = nil
    updateSpellLibrary()
    return pos
end

local function getSpellLocation(spell_name)
    if not SpellLibrary then
        getSpellLibrary()
    end

    if SpellLibrary.spells[spell_name] then
        return SpellLibrary.spells[spell_name]
    end

    local pos = pickNewSpellLocation()
    SpellLibrary.spells[spell_name] = pos
    return pos
end

local function getSpellCompiled(spell_name)
    spell_name = spell_name:gsub("_lib", "lib")
    local file = fs.open("/library/akasha/"..spell_name, "r")
    local spell = file.readAll()
    file.close()
    local hexlator = require("/programfiles/hexlator/hexlator")
    turtleComplie = false
    local stripped = false
    local verbose = false
    local compiled = hexlator.compile(spell, stripped, verbose, false)
    return compiled
end

local function writeSpell(pos, spell, spell_name)
    if not wand then
        error("No wand")
    end
    local name = spell_name:gsub("spells/", ""):gsub("%.hexpattern", "")
    local commandPattern = hexicon.toHexicon(name)
    local tpos = {x=pos[1], y=pos[2], z=pos[3]}

    local tab = {{
        ["startDir"] = "WEST",
        ["angles"] = "qqq",
    }, tpos, commandPattern, spell,{
        ["startDir"] = "EAST",
        ["angles"] = "eee",
    }, {
        ["startDir"] = "NORTH_WEST",
        ["angles"] = "qwaeawq",
    }, {
        ["startDir"] = "SOUTH_WEST",
        ["angles"] = "edeeedad",
    }}

    local focal_port = peripheral.find("focal_port")
    focal_port.writeIota(tab)

    local kinetic = peripheral.find("plethora:kinetic")
    kinetic.use(1)


    -- commandPattern["iota$serde"] = "hextweaks:pattern"
    -- tpos["iota$serde"] = "hextweaks:vec3"
    -- spell["iota$serde"] = "hextweaks:list"
    -- wand.pushStack(tpos)
    -- wand.pushStack(commandPattern)
    -- wand.pushStack(spell)
    -- wand.runPattern("SOUTH_WEST", "edeeedad")
    -- wand.clearStack()
end

function library.removeSpell(spell_name)
    if not SpellLibrary then
        getSpellLibrary()
    end

    if not SpellLibrary.spells[spell_name] then
        print("Spell does not exists")
        return
    end

    local pos = SpellLibrary.spells[spell_name]
    table.insert(SpellLibrary.unused_positions, pos)
    updateSpellLibrary()
end

function library.updateSpell(spell_name)
    print(spell_name)
    local pos = getSpellLocation(spell_name)
    local spell = getSpellCompiled(spell_name)
    writeSpell(pos, spell, spell_name)
end

function library.updateAllSpells()
    if not SpellLibrary then
        getSpellLibrary()
    end

    for key, _ in pairs(SpellLibrary.spells) do
        library.updateSpell(key)
    end
end

-- library.updateAllSpells()
return library