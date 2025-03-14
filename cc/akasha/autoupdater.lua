local patternsPath = "/patterns"
local patternsPath = "/pattern_hashes"

local function hashFile(filename)
    local file = fs.open(filename, "r")
    if not file then
        print("Error: File not found")
        return nil
    end
    
    local content = file.readAll()
    file.close()

    return crypto.sha256(content)
end

local function checkIfFileWasUpdated(filename)
    local filenameWithoutExtension = filename:gsub("%.hexpattern$", "")
    local file = fs.open(filenameWithoutExtension .. ".hash", "r")
    if not file then
        return true
    end

    local oldHash = file.readAll()
    file.close()

    local newHash = hashFile(filename)
    local result = oldHash ~= newHash
    if result then
        local file = fs.open(filenameWithoutExtension .. ".hash", "w")
        file.write(newHash)
        file.close()
    end
    return result
end

local function updateAkasha(filename)
    print("File: "..filename.." updated.")
end

while true do
    local files = fs.list(patternsPath)

    for _, filename in ipairs(files) do
        if checkIfFileWasUpdated(filename) then
            updateAkasha(filename)
        end
    end

    sleep(20)
end