
local autoUpdater = {
    patternsPath = "/homeless/patterns/",
    patternHashesPath = "/homeless/pattern_hashes/"
}

---@type fun(filename: string): string|nil
--- Returns previous .
function autoUpdater.hashFile(filename)
    local file = fs.open(autoUpdater.patternsPath..filename, "r")
    if not file then
        print("Error: File not found")
        return nil
    end
    
    local content = file.readAll()
    file.close()

    return crypto.sha256(content)
end

function autoUpdater.checkIfFileWasUpdated(filename)
    local newHash = autoUpdater.hashFile(filename)

    local filenameWithoutExtension = filename:gsub("%.hexpattern$", "")
    local file = fs.open(autoUpdater.patternHashesPath..filenameWithoutExtension .. ".hash", "r")
    if not file then
        local file2 = fs.open(autoUpdater.patternHashesPath..filenameWithoutExtension .. ".hash", "w")
        file2.write(newHash)
        file2.close()
        return true
    end

    local oldHash = file.readAll()
    file.close()

    local result = oldHash ~= newHash
    if result then
        local file2 = fs.open(autoUpdater.patternHashesPath..filenameWithoutExtension .. ".hash", "w")
        file2.write(newHash)
        file2.close()
    end
    return result
end

function autoUpdater.onUpdate(filename)
    print("File: "..filename.." updated.")
end

function autoUpdater.run(checkFrequency)
    while true do
        local files = fs.list(autoUpdater.patternsPath)
        for _, filename in ipairs(files) do
            local result = autoUpdater.checkIfFileWasUpdated(filename)
            if result then
                autoUpdater.onUpdate(filename)
            end
        end

        sleep(checkFrequency)
    end
end

return autoUpdater