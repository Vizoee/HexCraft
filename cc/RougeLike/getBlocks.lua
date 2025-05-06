-- scan all blocks from (1, 1, 1) to (16, 16, 16)

local scanRange = {min={x=0, y=0, z=0},max={x=16, y=7, z=16}}

local scanner = peripheral.find("manipulator")

local allBlocks = scanner.scan()
local filteredBlocks = {}

for _, block in ipairs(allBlocks) do
    if block.x >= scanRange.min.x and 
            block.y >= scanRange.min.x and 
            block.z >= scanRange.min.x and
            block.x < scanRange.max.x and 
            block.y < scanRange.max.y and 
            block.z < scanRange.max.z then
        table.insert(filteredBlocks, block)
    end
end

local processedBlocks = {}

for _, block in ipairs(filteredBlocks) do
    if block.name ~= "plethora:manipulator_mark_1" then
        if not processedBlocks[block.name] then
            processedBlocks[block.name] = {
                {},
                {block=block.name ~= "minecraft:air" and block.name or "botania:fake_air"}
            }
        end
        table.insert(processedBlocks[block.name][1], {x=block.x,y=block.y,z=block.z}) 
    end
end

local processedBlocksList = {}

for _, value in pairs(processedBlocks) do
    table.insert(processedBlocksList, value)
end

local forger = peripheral.find("reality_forger")


forger.clearAnchors()
forger.batchForgeRealityPieces(processedBlocksList)
