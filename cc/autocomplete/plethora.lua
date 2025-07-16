---@class plethora.custom.TablePos3D
---@field [1] number x
---@field [2] number y
---@field [3] number z

---@class plethora.custom.TablePos2D
---@field [1] number x
---@field [2] number y

---@class plethora.custom.Vector3D
---@field x number
---@field y number
---@field z number

---@class plethora.custom.Vector2D
---@field x number
---@field y number

---@class plethora.custom.OverlayGlasses
---@field canvas fun():plethora.custom.Canvas2D
---@field canvas3d fun():plethora.custom.Canvas3DFactory

---@class plethora.Sensor
---@field getMetaByID fun(id:string):plethora.Entity|plethora.EntityLivingBase|nil
---@field getMetaByName fun(name:string):plethora.Entity|plethora.EntityLivingBase|nil
---@field sense fun():table<integer, plethora.Entity|plethora.EntityLivingBase>

---@class plethora.Scanner
---@field getBlockMeta fun(x:integer, y:integer, z:integer):table
---@field scan fun():table



---@class plethora.custom.Frame3D : plethora.Frame2D, plethora.object3d.DepthTestable, plethora.object3d.Positionable3D, plethora.object3d.Rotatable3D
---@class plethora.custom.ItemObject3D : plethora.ItemObject, plethora.object3d.Positionable3D, plethora.object3d.Rotatable3D, plethora.object3d.DepthTestable, plethora.BaseObject, plethora.Scalable
---@class plethora.custom.Canvas3DFactory : plethora.Origin3D
---@class plethora.custom.Canvas3D : plethora.Group3D
---@class plethora.custom.Canvas2D : plethora.Frame2D



---@class plethora.Entity : plethora.custom.Vector3D
---@field displayName string
---@field id string
---@field motionX number
---@field motionY number
---@field motionZ number
---@field name string
---@field pitch number
---@field withinBlock plethora.custom.Vector3D
---@field yaw number

---@class plethora.EntityLivingBase : plethora.Entity
---@field armor table
---@field health number
---@field heldItem net.minecraft.item.ItemStack
---@field isAirborne boolean
---@field isAlive boolean
---@field isBurning boolean
---@field isChild boolean
---@field isDead boolean
---@field isElytraFlying boolean
---@field isInWater boolean
---@field isOnLadder boolean
---@field isRiding boolean
---@field isSleeping boolean
---@field isSneaking boolean
---@field isSprinting boolean
---@field isWet boolean
---@field maxHealth number
---@field offhandItem net.minecraft.item.ItemStack
---@field potionEffects tablePotion

---@class plethora.BaseObject
---@field remove fun()

---@class plethora.Colourable
---@field getAlpha fun():integer
---@field getColor fun():integer
---@field getColour fun():integer
---@field setAlpha fun(alpha:integer)
---@field setColor fun(colour:integer):number
---@field setColor fun(r:integer, g:integer, b:integer):number
---@field setColor fun(r:integer, g:integer, b:integer, alpha:integer):number
---@field setColour fun(colour:integer):number
---@field setColour fun(r:integer, g:integer, b:integer):number
---@field setColour fun(r:integer, g:integer, b:integer, alpha:integer):number

---@class plethora.ItemObject
---@field getItem fun(): string, number
---@field setItem fun(item:string)
---@field setItem fun(item:string, damage:integer)

---@class plethora.ObjectGroup
---@field clear fun()

---@class plethora.Frame2D : plethora.Group2D
---@field getSize fun():number, number

---@class plethora.Group2D : plethora.ObjectGroup
---@field addDot fun(position:plethora.custom.TablePos2D):table
---@field addDot fun(position:plethora.custom.TablePos2D, color:number):table
---@field addDot fun(position:plethora.custom.TablePos2D, color:number, size:number):table
---@field addGroup fun(position:plethora.custom.TablePos2D):table
---@field addItem fun(position:plethora.custom.TablePos2D, item:string):table
---@field addItem fun(position:plethora.custom.TablePos2D, item:string, damage:integer):table
---@field addItem fun(position:plethora.custom.TablePos2D, item:string, damage:integer, scale:number):table
---@field addLine fun(start:plethora.custom.TablePos2D, end:plethora.custom.TablePos2D):table
---@field addLine fun(start:plethora.custom.TablePos2D, end:plethora.custom.TablePos2D, colour:integer):table
---@field addLine fun(start:plethora.custom.TablePos2D, end:plethora.custom.TablePos2D, colour:integer, thickness:number):table
---@field addLines fun(points...:table<integer, plethora.custom.TablePos2D>):table
---@field addLines fun(points...:table<integer, plethora.custom.TablePos2D>, color:number):table
---@field addLines fun(points...:table<integer, plethora.custom.TablePos2D>, color:number, thickness:number):table
---@field addPolygon fun(points...:table<integer, plethora.custom.TablePos2D>):table
---@field addPolygon fun(points...:table<integer, plethora.custom.TablePos2D>, color:number):table
---@field addRectangle fun(x:number, y:number, width:number, height:number):table
---@field addRectangle fun(x:number, y:number, width:number, height:number, colour:integer):table
---@field addText fun(position:plethora.custom.TablePos2D, contents:string):table
---@field addText fun(position:plethora.custom.TablePos2D, contents:string, colour:integer):table
---@field addText fun(position:plethora.custom.TablePos2D, contents:string, colour:integer, size:number):table
---@field addTriangle fun(p1:plethora.custom.TablePos2D, p2:plethora.custom.TablePos2D, p3:plethora.custom.TablePos2D):table
---@field addTriangle fun(p1:plethora.custom.TablePos2D, p2:plethora.custom.TablePos2D, p3:plethora.custom.TablePos2D, colour:integer):table

---@class plethora.Group3D : plethora.ObjectGroup, plethora.object3d.ObjectRoot3D, plethora.BaseObject
---@field addBox fun(x:number, y:number, z:number):plethora.object3d.Box
---@field addBox fun(x:number, y:number, z:number, width:number, height:number, depth:number):plethora.object3d.Box
---@field addBox fun(x:number, y:number, z:number, width:number, height:number, depth:number, color:number):plethora.object3d.Box
---@field addFrame fun(position:plethora.custom.TablePos3D):plethora.custom.Frame3D
---@field addItem fun(position:plethora.custom.TablePos3D, item:string, damage:integer):plethora.custom.ItemObject3D
---@field addItem fun(position:plethora.custom.TablePos3D, item:string, damage:integer, scale:number):plethora.custom.ItemObject3D
-- ---@field addLine fun(start:table, end:table):table
-- ---@field addLine fun(start:table, end:table, thickness:number):table
-- ---@field addLine fun(start:table, end:table, thickness:number, colour:integer):table

---@class plethora.Origin3D : plethora.ObjectGroup
---@field create fun(offset:plethora.custom.TablePos3D|nil):plethora.custom.Canvas3D

---@class plethora.Scalable
---@field getScale fun():number
---@field setScale fun(scale:number)

---@class plethora.TextObject
---@field getLineHeight fun():integer
---@field getText fun():string
---@field hasShadow fun():boolean
---@field setLineHeight fun(lineHeight:integer)
---@field setShadow fun(shadow:boolean)
---@field setText fun(contents:string)

---@class plethora.object2d.MultiPoint2D
---@field getPoint fun(idx:integer):number, number
---@field setPoint fun(idx:integer, x:number, y:number)

---@class plethora.object2d.MultiPointResizable2D
---@field getPointCount fun():integer
---@field insertPoint fun(x:number, y:number)
---@field insertPoint fun(idx:integer, x:number, y:number)
---@field removePoint fun(idx:integer)

---@class plethora.object2d.Positionable2D
---@field getPosition fun():number, number
---@field setPosition fun(x:number, y:number)

---@class plethora.object2d.Rectangle
---@field getSize fun():number, number
---@field setSize fun(width:number, height:number)

---@class plethora.object3d.Box : plethora.Colourable, plethora.object3d.Positionable3D, plethora.object3d.DepthTestable, plethora.BaseObject
---@field getSize fun():number, number, number
---@field setSize fun(width:number, height:number, depth:number)

---@class plethora.object3d.DepthTestable
---@field isDepthTested fun():boolean
---@field setDepthTested fun(depthTest:boolean)

---@class plethora.object3d.MultiPoint3D
---@field getPoint fun(idx:integer):number, number, number
---@field setPoint fun(idx:integer, x:number, y:number, z:number)

---@class plethora.object3d.ObjectRoot3D
---@field recenter fun(offset:plethora.custom.TablePos3D|nil)

---@class plethora.object3d.Positionable3D
---@field getPosition fun():number, number, number
---@field setPosition fun(x:number, y:number, z:number)

---@class plethora.object3d.Rotatable3D
---@field setRotation fun()
---@field setRotation fun(x:number, y:number, z:number)
---@field getRotation fun():nil|number, number, number