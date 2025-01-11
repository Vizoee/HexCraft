-- Camera properties
local camX, camY, camZ = 0, 0, 0  -- Camera position
local scale = 100  -- Scaling factor for FOV

-- Function to project a 3D point to 2D
local function project3DTo2D(x, y, z)
    -- Adjust coordinates relative to camera
    local relativeX = x - camX
    local relativeY = y - camY
    local relativeZ = z - camZ

    -- Simple perspective projection
    if relativeZ == 0 then relativeZ = 0.001 end  -- Avoid division by zero
    local screenX = (relativeX / relativeZ) * scale
    local screenY = (relativeY / relativeZ) * scale

    return screenX, screenY
end

-- Example points
local points = {
    {2, 2, 5},
    {-1, -1, 10},
    {3, 0, 8}
}

-- Print projected points
for _, point in ipairs(points) do
    local x2D, y2D = project3DTo2D(point[1], point[2], point[3])
    print(string.format("3D: (%.2f, %.2f, %.2f) -> 2D: (%.2f, %.2f)", point[1], point[2], point[3], x2D, y2D))
end
