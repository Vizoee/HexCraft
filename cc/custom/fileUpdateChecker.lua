
local updateChecker = {
    patternsPath = "/homeless/patterns/",
    patternHashesPath = "/homeless/pattern_hashes/"
}

---@type fun(filename: string): string|nil
--- Returns previous hash for the file.
function updateChecker.getHashFile(filename)
    local file = fs.open(updateChecker.patternsPath..filename, "r")
    if not file then
        print("Error: File not found")
        return nil
    end
    
    local content = file.readAll()
    file.close()

    return crypto.sha256(content)
end

function updateChecker.checkIfFileWasUpdated(filename)
    local newHash = updateChecker.getHashFile(filename)

    local filenameWithoutExtension = filename:gsub("%.hexpattern$", "")
    local file = fs.open(updateChecker.patternHashesPath..filenameWithoutExtension .. ".hash", "r")
    if not file then
        local file2 = fs.open(updateChecker.patternHashesPath..filenameWithoutExtension .. ".hash", "w")
        file2.write(newHash)
        file2.close()
        return true
    end

    local oldHash = file.readAll()
    file.close()

    local result = oldHash ~= newHash
    if result then
        local file2 = fs.open(updateChecker.patternHashesPath..filenameWithoutExtension .. ".hash", "w")
        file2.write(newHash)
        file2.close()
    end
    return result
end

function updateChecker.onUpdate(filename)
    print("File: "..filename.." updated.")
end

function updateChecker.run(checkFrequency)
    checkFrequency = checkFrequency or 1
    while true do
        local files = fs.list(updateChecker.patternsPath)
        for _, filename in ipairs(files) do
            local result = updateChecker.checkIfFileWasUpdated(filename)
            if result then
                updateChecker.onUpdate(filename)
            end
        end

        sleep(checkFrequency)
    end
end

return updateChecker