local url = string.match(arg[1], "([^%s]+)")
pcall("hexget", url);
local focal = peripheral.find("focal_link")