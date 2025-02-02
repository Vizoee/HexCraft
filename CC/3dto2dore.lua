function project3DTo2D(x, y, z, verticalFov)
    -- Convert FOV from degrees to radians
    local fovRadHalf = math.rad(verticalFov) / 2
    -- Calculate aspect ratio
    local aspectRatio = 1920 / 1008
    local m1 = aspectRatio * math.tan(fovRadHalf)
    local m2 = math.tan(fovRadHalf)
    
    return x / m1 / z, y / m2 / z
end

function rotate(point, pitch, yaw)
    local rpitch = math.rad(pitch)
    local ryaw = math.rad(-yaw)
    local x = point[1]
    local y = point[2]
    local z = point[3]
    local xi = x * math.cos(rpitch) + z * math.sin(rpitch)
    local yi = y
    local zi = -x * math.sin(rpitch) + z * math.cos(rpitch)
    local xii = xi
    local yii = yi * math.cos(ryaw) - zi * math.sin(ryaw)
    local zii = yi * math.sin(ryaw) + zi * math.cos(ryaw)
    return {xii, yii, zii}
end 


-- Example usage
local screenWidth, screenHeight = 512, 288 -- Adjust for your terminal size
local fov = 100

local points = 
{
    {3, 10, 20},
    {5, -2, 10},
    {-3, -2, 10},
    {-3, -1, 10},
    {-2, -2, 10},
    {-2, -1, 10},
    {-2, -2, 11},
    {-2, -1, 11}
}

local searched = 
{
    "minecraft:yellow_concrete"
}


function drawPoint(point, fov)
    local screenX, screenY = project3DTo2D(point[1], point[2], point[3], fov)
    local xx, yy = (1 - screenX)/2*screenWidth, (1 - screenY)/2*screenHeight
    -- print(xx, yy)
    shell.run("setpoint", xx, yy)
end

while true do
    local p = peripheral.wrap("back").getMetaByName("Vizoee")
    local pitch = p.pitch
    local yaw = p.yaw
    local b = peripheral.wrap("back").scan()
    points = {}
    for i = 1, #b do
        for j = 1, #searched do
            if b[i].name == searched[j] then
                -- print(b[i])
                local po = {b[i].x - p.withinBlock.x, b[i].y - p.withinBlock.y, b[i].z - p.withinBlock.z}
                table.insert(points, {po[1], po[2], po[3]})
                table.insert(points, {po[1] + 1, po[2], po[3]})
                table.insert(points, {po[1] + 1, po[2], po[3] + 1})
                table.insert(points, {po[1], po[2], po[3] + 1})

                table.insert(points, {po[1], po[2] + 1, po[3]})
                table.insert(points, {po[1] + 1, po[2] + 1, po[3]})
                table.insert(points, {po[1] + 1, po[2] + 1, po[3] + 1})
                table.insert(points, {po[1], po[2] + 1, po[3] + 1})
            end
        end
    end



    peripheral.wrap("back").canvas().clear()
    for i = 1, #points do
        -- drawPoint(points[i], 100)
        drawPoint(rotate(points[i], yaw, pitch), 100)
    end
    --os.sleep(1)
    -- return
end
--[[
for i = fov, 120, 10 do
    local screenX, screenY = project3DTo2D(x, y, z, i)
    local xx, yy = (1 + screenX)/2*screenWidth, (1 - screenY)/2*screenHeight
    print(xx, yy)
    shell.run("setpoint", xx, yy)
end]]