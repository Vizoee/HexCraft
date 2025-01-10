local function api(url)
    local response = http.get(url)
    local json = require("json")
    local content = json.get(response, "content"):gsub("\\n", "\n")
    local name = json.get(response, "name"):gsub(" ", "_")
    local base64 = require("base64")
    local data = base64.decode(content)
    local file = fs.open(name, "w")
    file.write(data)
    file.close()
end

if ... == nil then
    api(arg[1])
else
    return {
        api = api
    }
end

