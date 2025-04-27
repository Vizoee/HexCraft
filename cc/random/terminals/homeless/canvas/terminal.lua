--- 
--- tLines - list of tLine
--- 
--- tLine:
---     text
---     color
---     background color
--- 

local canvas
local cTextFrame
local cbackgroundFrame
local cLines = {}
local tLines = {}
local tHeight
local nCursorX = 1
local nCursorY = 1

local function createEmptyLine()
    return {"test", 0xFFFFFFFF, 0x000000FF}
end

local function getLineHeight(size)
    return 10*size
end

local function getLinewidth(size)
    return 200*size
end

local function createEmptyCanvasLine(pos, size)
    local line = {
        cTextFrame.addText(pos, "", 0xFFFFFFFF, size),
    }
    table.insert(line, cbackgroundFrame.addRectangle(pos.x, pos.y, getLinewidth(size), math.ceil(line[1].getLineHeight() / 2), 0x000000FF))
    return line
end

local function initLines(height, size)
    size = size or 0.5
    
    local interface = peripheral.wrap("back")
    canvas = interface.canvas()
    canvas.clear()

    cbackgroundFrame = canvas.addGroup({x=300, y=10})
    cTextFrame = canvas.addGroup({x=300, y=10})
    
    tHeight = height
    for i = 1, height do
        table.insert(tLines, createEmptyLine())
        table.insert(cLines, createEmptyCanvasLine({x=0, y=i*getLineHeight(size)}, size))
    end
    -- tLines[2][1] = ":3"
end

local function redrawLine(n)
    local tLine = tLines[n]
    local cLine = cLines[n]
    cLine[1].setText(tLine[1])
end

local function redraw()
    for i = 1, tHeight do
        redrawLine(i)
    end
end

initLines(10)
redraw()