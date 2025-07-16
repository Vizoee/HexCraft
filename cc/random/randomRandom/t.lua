
---@class Base
---@field _private table Private fields for each object instance.
---@field _getters table Getter functions for fields.
---@field _setters table Setter functions for fields.
---@field base table Reference to the parent class for accessing non-overridden functions.
---@field new fun(self:table, o:table|nil):table Creates a new instance of the class.
---@field newClass fun(self:table):table Creates a new class that inherits from the current class.
---@field copy fun(self:table, o:table) Copies all key-value pairs from table `o` into the current object.
---@field createField fun(self:table, name:string, getter:function|nil, setter:function|nil) Defines a new field with optional getter and setter functions.
---@field privateGet fun(self:table, name:string):any Default getter for private fields.
---@field privateSet fun(self:table, name:string, value:any) Default setter for private fields.
---
--[[
Usage:
- Use `ObjectBase:new()` to create new instances.
- Use `ObjectBase:newClass()` to create subclasses.
- Use `ObjectBase:createField()` to define fields with custom accessors.
]]
local ObjectBase = {}
local ObjectBase_Private = "_private"
local ObjectBase_Getters = "_getters"
local ObjectBase_Setters = "_setters"
function ObjectBase:new(o)
    local _o = o or {}
    _o[ObjectBase_Private] = {}
    _o[ObjectBase_Getters] = {}
    _o[ObjectBase_Setters] = {}
    setmetatable(_o, self)
    self.__index = function(t, k)
        local f = rawget(t, ObjectBase_Getters)[k]
        if f then
            return f(t, k)
        end
        return rawget(t, k) or self[k]
    end
    self.__newindex = function(t, k, v)
        local f = rawget(t, ObjectBase_Setters)[k]
        if f then
            f(t, k, v)
        else
            rawset(t, k ,v)
        end
    end
    return _o
end
function ObjectBase:newClass()
    local newClass = self:new()
    newClass.base = self
    return newClass
end
function ObjectBase:copy(o)
    for key, value in pairs(o) do
        self[key] = value
    end
end
function ObjectBase:createField(name, getter, setter)
    local function create(n, f, t)
        local old = rawget(self, n)
        if old then
            rawget(self, ObjectBase_Private)[n] = old
            rawset(self, n, nil)
        end
        rawget(self, t)[n] = f
    end
    create(name, getter or self.privateGet, ObjectBase_Getters)
    create(name, setter or self.privateSet, ObjectBase_Setters)
end
function ObjectBase:privateGet(name)
    return rawget(self, ObjectBase_Private)[name]
end
function ObjectBase:privateSet(name, value)
    rawget(self, ObjectBase_Private)[name] = value
end



---@class Canvas3DFactory
local Canvas3DFactory = {}
function Canvas3DFactory:clear()
    local peri = peripheral.wrap("back") ---@type plethora.custom.OverlayGlasses
    if not peri or not peri.canvas3d then
        error("Missing OverlayGlasses")
    end
    local canvas3d = peri.canvas3d()
    canvas3d.clear()
end



---@class Vector3D : Base, plethora.custom.Vector3D
local Vector3D = ObjectBase:newClass()
---@param o Vector3D|plethora.custom.Vector3D|plethora.custom.TablePos3D|nil
---@return Vector3D
function Vector3D:new(o)
    local _o = self.base.new(self)
    _o.x = o and (o.x or o[1]) or 0
    _o.y = o and (o.y or o[2]) or 0
    _o.z = o and (o.z or o[3]) or 0
    return _o
end
---@return Vector3D
function Vector3D.__add(a, b)
    return Vector3D:new({x=a.x+b.x, y=a.y+b.y, z=a.z+b.z})
end
---@return number|Vector3D
function Vector3D.__mul(a, b)
    if type(b) == "number" then
        return Vector3D:new({x=a.x*b, y=a.y*b, z=a.z*b})
    end
    if type(a) == "number" then
        return Vector3D:new({x=b.x*a, y=b.y*a, z=b.z*a})
    end
    error("Not implemented")
end
---@return boolean
function Vector3D.__eq(a, b)
    return a.x==b.x and a.y==b.y and a.z==b.z
end
---@return string
function Vector3D:__tostring()
    return string.format("%.2f %.2f %.2f", self.x, self.y, self.z)
end
---@return number
function Vector3D:__len()
    return math.sqrt(self.x^2 + self.y^2 + self.z^2)
end
---@return number
function Vector3D:__index(k)
    if k == 1 then return self.x
    elseif k == 2 then return self.y
    elseif k == 3 then return self.z
    else
        return self[k]
    end
end
function Vector3D:normalize()
    local lenght = #self
    self.x=self.x/lenght
    self.y=self.y/lenght
    self.z=self.z/lenght
end
---@return Vector3D
function Vector3D:normalized()
    local v = Vector3D:new(self)
    v:normalize()
    return v
end
function Vector3D:toTable()
    return {self.x, self.y, self.z}
end
function Vector3D:unpack()
    return table.unpack(self:toTable())
end
---@param pitch number
---@param yaw number
function Vector3D:rotate2(pitch, yaw)
end
---@param normal Vector3D
function Vector3D:rotate(normal)
    self:copy(self:rotated(normal))
end
---@param normal Vector3D
---@return Vector3D
function Vector3D:rotated(normal)
    normal = normal:normalized()
    local angle = math.acos(normal:dot(Vector3D.DefaultNormal))
    if angle < 0.001 then
        return Vector3D:new(self)
    end
    local axis = Vector3D.DefaultNormal:cross(normal)
    return self:rotateAround(axis, angle)
end
---@param a Vector3D
---@return Vector3D
function Vector3D:cross(a)
    return Vector3D:new({
        self.y*a.z - self.z*a.y,
        self.z*a.x - self.x*a.z,
        self.x*a.y - self.y*a.x
    })
end
---@param a Vector3D
---@return number
function Vector3D:dot(a)
    return self.x * a.x + self.y * a.y + self.z * a.z
end
---@param a Vector3D
---@return Vector3D
function Vector3D:componentwise(a)
    return Vector3D:new({x=self.x*a.x, y=self.y*a.y, z=self.z*a.z})
end
---@param axis Vector3D
---@param angle number
---@return Vector3D
function Vector3D:rotateAround(axis, angle)
    return self * math.cos(angle)
            + axis:cross(self) * math.sin(angle)
            + axis * axis:dot(self) * (1 - math.cos(angle))
end
Vector3D.DefaultNormal = Vector3D:new({0, 0, 1})

---@param position plethora.custom.TablePos3D|Vector3D
---@return Vector3D
function Vector3D.parse(position)
    if position.x then
        ---@cast position Vector3D
        return position
    else
        return Vector3D:new({x=position[1], y=position[2], z=position[3]})
    end
end

---@class Vector2D : Base, plethora.custom.Vector2D
local Vector2D = ObjectBase:newClass()
---@param o Vector2D|plethora.custom.Vector2D|plethora.custom.TablePos2D|nil
---@return Vector2D
function Vector2D:new(o)
    local _o = self.base.new(self)
    _o.x = o and (o.x or o[1]) or 0
    _o.y = o and (o.y or o[2]) or 0
    return _o
end
---@param position plethora.custom.TablePos2D|Vector2D
---@return Vector2D
function Vector2D.parse(position)
    if position.x then
        ---@cast position Vector2D
        return position
    else
        return Vector2D:new({x=position[1], y=position[2]})
    end
end


---@class Canvas3D : Base, plethora.custom.Canvas3D
local Canvas3D = ObjectBase:newClass()
---@param canvas3d nil|plethora.custom.TablePos3D|plethora.custom.Canvas3D
---@return Canvas3D
function Canvas3D:new(canvas3d)
    if not canvas3d or not canvas3d.addBox then
        ---@cast canvas3d nil|plethora.custom.TablePos3D
        local peri = peripheral.wrap("back") ---@type plethora.custom.OverlayGlasses
        if not peri or not peri.canvas3d then
            error("Missing OverlayGlasses")
        end

        canvas3d = canvas3d and peri.canvas3d().create(canvas3d)
                or peri.canvas3d().create()
    end

    return self.base.new(self, canvas3d)
end
---@param position plethora.custom.TablePos3D|Vector3D
---@param size nil|number
---@param color nil|integer
---@return plethora.object3d.Box
function Canvas3D:createPoint(position, size, color)
    position = Vector3D.parse(position)
    size = size or 0.1
    color = color or 0xFFFFFFFF

    return self.addBox(
        position.x-size/2,
        position.y-size/2,
        position.z-size/2,
        size,
        size,
        size,
        color
    )
end
---@param position plethora.custom.TablePos3D|Vector3D
---@param normal nil|plethora.custom.TablePos3D|Vector3D
---@param offset nil|plethora.custom.TablePos2D|Vector2D
---@return plethora.custom.Frame3D
function Canvas3D:createFrame3D(position, normal, offset)
    position = Vector3D.parse(position)
    -- normal = normal and Vector3D.parse(normal) or nil
    offset = offset and Vector2D.parse(offset) or nil

    local frame = self.addFrame(position:toTable())
    -- if normal then
    --     normal:normalize()
    --     frame.setRotation(
    --         math.atan2(normal.y, normal.z) / math.pi * 180,
    --         math.asin(normal.x) / math.pi * 180,
    --         0
    --     )-- Z -> Y -> X
    -- end
    return frame
end


---@class Plane3D : Base, plethora.custom.Frame3D
local Plane3D = ObjectBase:newClass()

---@param params CreatePlane3DParam
---@return Plane3D
function Canvas3D:createPlane(params)
    local position = Vector3D.parse(params.position)
    local _o = self.base.new(Plane3D, self:createFrame3D(position)) ---@type any

    _o.position = position
    _o.size = params.size and Vector2D.parse(params.size)
    _o.color = params.color or 0x000000FF
    _o.offset = params.offset and Vector2D.parse(params.offset)
    _o.rectangle = _o.addRectangle(0, 0, _o.size.x, _o.size.y, _o.color)

    _o:createField("normal",
        nil,
        function (t, k, v)
            local normal = Vector3D.parse(v):normalized()
            t:privateSet(k, normal)
            t.setRotation(
                math.atan2(normal.y, normal.z) / math.pi * 180,
                math.asin(normal.x) / math.pi * 180,
                0
            )
            if t.offset then
                local _offset = Vector3D:new({-t.offset.x / 64, t.offset.y / 64, 0})
                _offset:rotate(normal)
                print(_offset)
                t.setPosition((t.position + _offset):unpack())
            end
        end)

    if params.normal then
        _o.normal = params.normal
    end


    return _o
end



---@class CreatePlane3DParam
---@field position Vector3D|plethora.custom.TablePos3D
---@field normal nil|Vector3D|plethora.custom.TablePos3D
---@field size Vector2D|plethora.custom.TablePos2D
---@field color nil|integer
---@field offset nil|Vector2D|plethora.custom.TablePos2D


function Plane3D:setNormal(normal)
    self.normal = Vector3D.parse(normal)
    -- self.normal:normalize()
    -- self.setRotation(
    --     math.atan2(self.normal.y, self.normal.z) / math.pi * 180,
    --     math.asin(self.normal.x) / math.pi * 180,
    --     0
    -- )-- Z -> Y -> X
    -- if self.offset then
    --     local _offset = Vector3D:new({-self.offset.x / 64, self.offset.y / 64, 0})
    --     _offset:rotate(self.normal)
    --     self.setPosition((self.position + _offset):unpack())
    -- end
end


---@class PlayerHandler : Base
---@field sensor plethora.Sensor
---@field name string
local PlayerHandler = ObjectBase:newClass()
---@param name string
---@return PlayerHandler
function PlayerHandler:new(name)
    local _o = self.base.new(self)
    _o.sensor = peripheral.wrap("back") ---@type plethora.Sensor
    _o.name = name
    return _o
end

---@return nil|number, nil|number
function PlayerHandler:getRotation()
    local meta = self.sensor.getMetaByName(self.name)
    if meta then
        return meta.pitch, meta.yaw
    end
end



Canvas3DFactory:clear()
local canvas = Canvas3D:new()

local plane = canvas:createPlane({
    position={0, 0, 0},
    size={64, 64},
    normal={1, 0, 0},
    offset={32, 32}
})

plane:setNormal({1, 1, 0})

local player = PlayerHandler:new("Vizoee")
-- while true do
--     canvas.clear()
--     canvas.recenter()
--     local pitch, yaw = player:getRotation()
--     if not pitch or not yaw then
--         error("Error")
--     end

--     local p = Vector3D:new({0, 0, 2})
--     p:rotat : Basee2(pitch - 90, yaw)
--     local point = canvas:createPoint(p)
--     point.setDepthTested(false)
--     point.setColor(0xFF0000FF)
--     sleep(0.05)
-- end


-- print(textutils.serialize( frame.getDocs()))

-- local p = {x=1, y=2, z=3}
-- local p2 = Vector3D:new(p)
-- local p3 = Vector3D:new({x=3, y=2, z=3})
-- print(table.unpack(p2:toTable()))
-- print(p2 + p3)
-- print(#p2)

local function class(Base)
    local C = {}
    C.__index = C

    function C:new(o)
        o = o or {}
        setmetatable(o, { __index = C })
        o.__class = C
        return o
    end
    return C
end