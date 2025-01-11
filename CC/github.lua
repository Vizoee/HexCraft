local github = {}

function github.api(url)
    local apiurl = url
        :gsub("https://github.com/", "https://api.github.com/repos/")
        :gsub("https://raw.githubusercontent.com/", "https://api.github.com/repos/")
        :gsub("blob/main/", "contents/")
        :gsub("refs/heads/main/", "contents/")
    local response = http.get(apiurl)
    local responsetext = response.readAll()
    local json = require("json")
    local content = json.get(responsetext, "content"):gsub("\\n", "\n")
    local name = json.get(responsetext, "name"):gsub(" ", "_")
    local base64 = require("base64")
    local data = base64.decode(content)
    local file = fs.open(name, "w")
    file.write(data)
    file.close()
end

if debug.getinfo(3) then
    return github
else
    if #arg > 1 then
        github.api(arg[1])
    else
        print("Usage: github <repository-file>")
    end
end

