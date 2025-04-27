local interface = peripheral.wrap("back")
local canvas = interface.canvas()
canvas.clear()
-- And add a rectangle
local rect = canvas.addRectangle(0, 0, 100, 100, 0xFF0000FF)