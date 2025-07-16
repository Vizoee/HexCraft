-- local ObjectBase = {}
-- function ObjectBase:new(o)
--     local _o = o or {}
--     setmetatable(_o, self)
--     self.__index = self
--     return _o
-- end
-- function ObjectBase:newClass()
--     local newClass = self:new()
--     newClass.base = self
--     return newClass
-- end

-- ---@class Canvas3DFactory
-- local Canvas3DFactory = {}
-- function Canvas3DFactory:clear()
--     local peri = peripheral.wrap("back") ---@type plethora.custom.OverlayGlasses
--     if not peri or not peri.canvas3d then
--         error("Missing OverlayGlasses")
--     end
--     local canvas3d = peri.canvas3d()
--     canvas3d.clear()
-- end



-- ---@class Vector3D : plethora.custom.Vector3D
-- local Vector3D = ObjectBase:newClass()
-- ---@param o Vector3D|plethora.custom.Vector3D|plethora.custom.TablePos3D|nil
-- ---@return Vector3D
-- function Vector3D:new(o)
--     local _o = self.base.new(self)
--     _o.x = o and (o.x or o[1]) or 0
--     _o.y = o and (o.y or o[2]) or 0
--     _o.z = o and (o.z or o[3]) or 0
--     return _o
-- end
-- ---@return Vector3D
-- function Vector3D.__add(a, b)
--     return Vector3D:new({x=a.x+b.x, y=a.y+b.y, z=a.z+b.z})
-- end
-- ---@return number|Vector3D
-- function Vector3D.__mul(a, b)
--     if type(b) == "number" then
--         return Vector3D:new({x=a.x*b, y=a.y*b, z=a.z*b})
--     end
--     if type(a) == "number" then
--         return Vector3D:new({x=b.x*a, y=b.y*a, z=b.z*a})
--     end
--     error("Not implemented")
-- end
-- ---@return boolean
-- function Vector3D.__eq(a, b)
--     return a.x==b.x and a.y==b.y and a.z==b.z
-- end
-- ---@return string
-- function Vector3D:__tostring()
--     return string.format("%.2f %.2f %.2f", self.x, self.y, self.z)
-- end
-- ---@return number
-- function Vector3D:__len()
--     return math.sqrt(self.x^2 + self.y^2 + self.z^2)
-- end
-- ---@return number
-- function Vector3D:__index(k)
--     if k == 1 then return self.x
--     elseif k == 2 then return self.y
--     elseif k == 3 then return self.z
--     else error("Attempting to index incorrect")
--     end
-- end
-- function Vector3D:normalize()
--     local lenght = #self
--     self.x=self.x/lenght
--     self.y=self.y/lenght
--     self.z=self.z/lenght
-- end
-- ---@return Vector3D
-- function Vector3D:normalized()
--     local v = Vector3D:new(self)
--     v:normalize()
--     return v
-- end
-- function Vector3D:toTable()
--     return {self.x, self.y, self.z}
-- end
-- function Vector3D:unpack()
--     return table.unpack(self:toTable())
-- end
-- ---@param pitch number
-- ---@param yaw number
-- function Vector3D:rotate(pitch, yaw)
--     local a = yaw / 180 * math.pi
--     local b = pitch / 180 * math.pi
    

--     -- local x
--     -- local y
--     -- local z

--     -- y = self.y * math.cos(b) - self.z * math.cos(b)
--     -- z = -self.y * math.cos(b) - self.z * math.sin(b)
--     -- self.y = y
--     -- self.z = z

--     -- x = self.x * math.cos(a) - self.z * math.sin(a)
--     -- z = self.x * math.sin(a) + self.z * math.cos(a)
--     -- self.x = x
--     -- self.z = z
-- end
-- ---@param normal Vector3D
-- ---@return Vector3D
-- function Vector3D:rotate2(normal)
--     normal = normal:normalized()
--     local angle = math.acos(normal:dot(Vector3D.DefaultNormal))
--     if angle < 0.001 then
--         return Vector3D:new(self)
--     end
--     local axis = Vector3D.DefaultNormal:cross(normal)
--     return self:rotateAround(axis, angle)
-- end
-- ---@param a Vector3D
-- ---@return Vector3D
-- function Vector3D:cross(a)
--     return Vector3D:new({
--         self.y*a.z - self.z*a.y,
--         self.z*a.x - self.x*a.z,
--         self.x*a.y - self.y*a.x
--     })
-- end
-- ---@param a Vector3D
-- ---@return number
-- function Vector3D:dot(a)
--     return self.x * a.x + self.y * a.y + self.z * a.z
-- end
-- ---@param a Vector3D
-- ---@return Vector3D
-- function Vector3D:componentwise(a)
--     return Vector3D:new({x=a.x*b.x, y=a.y*b.y, z=a.z*b.z})
-- end
-- ---@param axis Vector3D
-- ---@param angle number
-- ---@return Vector3D
-- function Vector3D:rotateAround(axis, angle)
--     return self * math.cos(angle)
--             + axis:cross(self) * math.sin(angle)
--             + axis * axis:dot(self) * (1 - math.cos(angle))
-- end
-- Vector3D.DefaultNormal = Vector3D:new({0, 0, 1})

-- ---@param position plethora.custom.TablePos3D|Vector3D
-- ---@return Vector3D
-- local function parseVector3D(position)
--     if position.x then
--         ---@cast position Vector3D
--         return position
--     else
--         return Vector3D:new({x=position[1], y=position[2], z=position[3]})
--     end
-- end



-- ---@class Canvas3D : plethora.custom.Canvas3D
-- local Canvas3D = {}
-- ---@param canvas3d nil|plethora.custom.TablePos3D|plethora.custom.Canvas3D
-- ---@return Canvas3D
-- function Canvas3D:new(canvas3d)
--     if not canvas3d or not canvas3d.addBox then
--         ---@cast canvas3d nil|plethora.custom.TablePos3D
--         local peri = peripheral.wrap("back") ---@type plethora.custom.OverlayGlasses
--         if not peri or not peri.canvas3d then
--             error("Missing OverlayGlasses")
--         end

--         if canvas3d then
--             canvas3d = peri.canvas3d().create(canvas3d)
--         else
--             canvas3d = peri.canvas3d().create()
--         end
--     end
--     ---@cast canvas3d Canvas3D

--     setmetatable(canvas3d, self)
--     self.__index = self
--     return canvas3d
-- end
-- ---@param position plethora.custom.TablePos2D|plethora.custom.Vector2D
-- ---@return plethora.custom.Vector2D
-- function Canvas3D:parseVector2D(position)
--     if position.x then
--         ---@cast position plethora.custom.Vector2D
--         return position
--     else
--         return {x=position[1], y=position[2]}
--     end
-- end
-- ---@param position plethora.custom.TablePos3D|Vector3D
-- ---@param size nil|number
-- ---@param color nil|integer
-- ---@return plethora.object3d.Box
-- function Canvas3D:createPoint(position, size, color)
--     position = parseVector3D(position)
--     size = size or 0.1
--     color = color or 0xFFFFFFFF

--     return self.addBox(
--         position.x-size/2,
--         position.y-size/2,
--         position.z-size/2,
--         size,
--         size,
--         size,
--         color
--     )
-- end
-- -- ---@param position plethora.custom.TablePos3D|Vector3D
-- -- ---@param normal nil|plethora.custom.TablePos3D|Vector3D
-- -- ---@param offset nil|plethora.custom.TablePos3D|Vector3D
-- -- ---@return plethora.custom.Frame3D
-- -- function Canvas3D:createFrame3D(position, normal, offset)
-- --     position = parseVector3D(position)
-- --     normal = normal and parseVector3D(normal) or nil
-- --     offset = offset and parseVector3D(offset) or nil

-- --     local frame = self.addFrame(position:toTable())
-- --     if normal then
-- --         normal:normalize()
-- --         frame.setRotation(
-- --             math.atan2(normal.y, normal.z) / math.pi * 180,
-- --             math.asin(normal.x) / math.pi * 180,
-- --             0
-- --         )-- Z -> Y -> X
-- --     end
-- --     return frame
-- -- end
-- ---@param position plethora.custom.TablePos3D|Vector3D
-- ---@param normal nil|plethora.custom.TablePos3D|Vector3D
-- ---@param offset nil|plethora.custom.TablePos2D|plethora.custom.Vector2D
-- ---@return plethora.custom.Frame3D
-- function Canvas3D:createFrame3D(position, normal, offset)
--     position = parseVector3D(position)
--     normal = normal and parseVector3D(normal) or nil
--     offset = offset and self:parseVector2D(offset) or nil

--     local frame = self.addFrame(position:toTable())
--     if normal then
--         normal:normalize()
--         frame.setRotation(
--             math.atan2(normal.y, normal.z) / math.pi * 180,
--             math.asin(normal.x) / math.pi * 180,
--             0
--         )-- Z -> Y -> X
--     end
--     return frame
-- end


-- ---@class Plane3D : plethora.custom.Frame3D
-- ---@
-- local Plane3D = {}

-- ---@param params CreatePlane3DParam
-- ---@return Plane3D
-- function Canvas3D:createPlane(params)
--     -- position = parseVector3D(position)
--     -- size = self:parseVector2D(size)
--     -- normal = normal and parseVector3D(normal) or nil
--     -- color = color or 0x000000FF

--     -- local frame = self:createFrame3D(position, normal)
--     -- local rectangle = frame.addRectangle(-32, -32, size.x, size.y, color)

--     -- return rectangle, frame
--     local position = parseVector3D(params.position)
--     local _o = self:createFrame3D(position) ---@type any

--     setmetatable(_o, Plane3D)
--     Plane3D.__index = Plane3D

--     _o.position = position
--     _o.size = self:parseVector2D(params.size)
--     -- _o.normal = params.normal and parseVector3D(params.normal) or nil
--     _o.color = params.color or 0x000000FF
--     _o.offset = params.offset and self:parseVector2D(params.offset)
--     _o.rectangle = _o.addRectangle(0, 0, _o.size.x, _o.size.y, _o.color)

--     if params.normal then
--         _o:setNormal(params.normal)
--     end
--     -- if _o.normal then
--     --     _o.normal:normalize()
--     --     _o.setRotation(
--     --         math.atan2(_o.normal.y, _o.normal.z) / math.pi * 180,
--     --         math.asin(_o.normal.x) / math.pi * 180,
--     --         0
--     --     )-- Z -> Y -> X
--     --     if _o.offset then
--     --         local _offset = Vector3D:new({_o.offset.x, _o.offset.y, 0})
--     --         _offset:rotate(
--     --             math.atan2(_o.normal.y, _o.normal.z) / math.pi * 180,
--     --             math.asin(_o.normal.x) / math.pi * 180
--     --         )
--     --         _o.setPosition((_o.position + _offset):unpack())
--     --     end
--     -- end

    

--     return _o
-- end



-- ---@class CreatePlane3DParam
-- ---@field position Vector3D|plethora.custom.TablePos3D
-- ---@field normal nil|Vector3D|plethora.custom.TablePos3D
-- ---@field size plethora.custom.TablePos2D|plethora.custom.Vector2D
-- ---@field color nil|integer
-- ---@field offset nil|plethora.custom.TablePos2D|plethora.custom.Vector2D


-- function Plane3D:setNormal(normal)
--     self.normal = parseVector3D(normal)
--     self.normal:normalize()
--     self.setRotation(
--         math.atan2(self.normal.y, self.normal.z) / math.pi * 180,
--         math.asin(self.normal.x) / math.pi * 180,
--         0
--     )-- Z -> Y -> X
--     if self.offset then
--         local _offset = Vector3D:new({-self.offset.x / 64, self.offset.y / 64, 0})
--         _offset = _offset:rotate2(self.normal)
--         self.setPosition((self.position + _offset):unpack())
--     end
-- end


-- ---@class PlayerHandler
-- ---@field sensor plethora.Sensor
-- ---@field name string
-- local PlayerHandler = {}
-- ---@param name string
-- ---@return PlayerHandler
-- function PlayerHandler:new(name)
--     local _o = {}
--     _o.sensor = peripheral.wrap("back") ---@type plethora.Sensor
--     _o.name = name
--     setmetatable(_o, self)
--     self.__index = self
--     return _o
-- end

-- ---@return nil|number, nil|number
-- function PlayerHandler:getRotation()
--     local meta = self.sensor.getMetaByName(self.name)
--     if meta then
--         return meta.pitch, meta.yaw
--     end
-- end



-- Canvas3DFactory:clear()
-- local canvas = Canvas3D:new()

-- local player = PlayerHandler:new("Vizoee")
-- -- while true do
-- --     canvas.clear()
-- --     canvas.recenter()
-- --     local pitch, yaw = player:getRotation()
-- --     if not pitch or not yaw then
-- --         error("Error")
-- --     end

-- --     local p = Vector3D:new({0, 0, 2})
-- --     p:rotate(pitch - 90, yaw)
-- --     local point = canvas:createPoint(p)
-- --     point.setDepthTested(false)
-- --     point.setColor(0xFF0000FF)
-- --     sleep(0.05)
-- -- end

-- local _ = canvas:createPlane({
--     position={0, 0, 0},
--     size={64, 64},
--     normal={1, 0, 0},
--     offset={32, 32}
-- })
-- -- print(textutils.serialize( frame.getDocs()))

-- -- local p = {x=1, y=2, z=3}
-- -- local p2 = Vector3D:new(p)
-- -- local p3 = Vector3D:new({x=3, y=2, z=3})
-- -- print(table.unpack(p2:toTable()))
-- -- print(p2 + p3)
-- -- print(#p2)

local function class(Base, n)
    local C = {}
    -- local private = {}

    local function index(t, k)
        if t._private[k] then
            return t._private[k]
        end
        return C[k]
    end

    local function newindex(t, k, v)
        print("setter "..n)
        t._private[k] = v
    end

    C.__index = C
    if Base then
        C.__base = {}
        setmetatable(C.__base, {
            __index = function (t, k)
                print("getter "..n)
                if k == "_private" then
                    return rawget(t, k)
                end
                local r = rawget(Base, k)
                if type(r) == "function" then
                    return r
                end
                return t._private[k]
            end,
            __newindex = newindex
        })
    end

    local function base(s, func, ...)
        if C.__base then
            return C.__base[func](s, ...)
        end
        return nil
    end

    function C:new()
        print("Creating " .. n)
        local o
        if Base then
            o = self:super("new")
        else
            o = {}
            o._private = {}
        end
        setmetatable(o, { __index = index, __newindex = newindex })
        print("Created " .. n)
        o[n] = 1
        return o
    end

    function C:test()
        if Base then
            self:super("test")
        end
        print(0)
        self[n] = 2
    end

    function C:super(...)
        print(n)
        return base(self, ...)
    end

    return C
end

local A = class(nil, "a")
local B = class(A, "b")
local C = class(B, "c")
-- local a = A:new()
-- local b = B:new()
local c = C:new()
print()
c:test()
local o = c
print(o["a"])
print(o["b"])
print(o["c"])