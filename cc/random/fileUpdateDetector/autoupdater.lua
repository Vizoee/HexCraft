local patternsPath = "/homeless/patterns/"
local patternHashesPath = "/homeless/pattern_hashes/"

local function hashFile(filename)
    local file = fs.open(patternsPath..filename, "r")
    if not file then
        print("Error: File not found")
        return nil
    end
    
    local content = file.readAll()
    file.close()

    return crypto.sha256(content)
end

local function checkIfFileWasUpdated(filename)
    local newHash = hashFile(filename)

    local filenameWithoutExtension = filename:gsub("%.hexpattern$", "")
    local file = fs.open(patternHashesPath..filenameWithoutExtension .. ".hash", "r")
    if not file then
        local file2 = fs.open(patternHashesPath..filenameWithoutExtension .. ".hash", "w")
        file2.write(newHash)
        file2.close()
        return true
    end

    local oldHash = file.readAll()
    file.close()

    local result = oldHash ~= newHash
    if result then
        local file2 = fs.open(patternHashesPath..filenameWithoutExtension .. ".hash", "w")
        file2.write(newHash)
        file2.close()
    end
    return result
end

local function updateAkasha(filename)
    print("File: "..filename.." updated.")
end

while true do
    local files = fs.list(patternsPath)
    for _, filename in ipairs(files) do
        local result = checkIfFileWasUpdated(filename)
        if result then
            updateAkasha(filename)
        end
    end

    sleep(1)
end