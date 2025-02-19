local github = {}

github.cashe = {}

function github.convert_url(url)
    url = url
        :gsub("https://github.com/", "https://api.github.com/repos/")
        :gsub("https://raw.githubusercontent.com/", "https://api.github.com/repos/")
        :gsub("blob/main/", "contents/")
        :gsub("refs/heads/main/", "contents/")
    return url
end

function github.api_response(url)
    -- Check if the URL is valid
    local ok, err = http.checkURL(url)
    if not ok then
        printError(err or "Invalid URL.")
        return
    end

    local apiurl = github.convert_url(url)

    if github.cashe[apiurl] then
        print("Returned cashed")
        return github.cashe[apiurl]
    end

    local response = http.get(apiurl).readAll()
    local json = require("json")
    local content = json.get(response, "content"):gsub("\\n", "\n")
    local name = json.get(response, "name"):gsub(" ", "_")
    local base64 = require("base64")
    local data = base64.decode(content)
    local output = {
        name = name,
        content = data,
        response = response
    }
    github.cashe[apiurl] = output
    return output
end

function github.api(url, folder)
    folder = folder or "./"
    local response = github.api_response(url)
    local file = fs.open(folder..response.name, "w")
    file.write(response.content)
    file.close()
end

if debug.getinfo(3) then
    return github
else
    if #arg > 0 then
        github.api(arg[1], arg[2])
    else
        print("Usage: github <repository-file>")
    end
end

