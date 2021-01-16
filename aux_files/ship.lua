--File conatins functions for creating and manipulating ship objects

local Obj   = require("aux_files.object")

SHIP = {target_x = nil, target_y = nil,moveable = nil,speed = nil,health = nil, max_health = nil, shoot_func = nil,score = nil,thruster = nil,missle = nil}
SHIP.__index = SHIP
setmetatable(SHIP,OBJECT)

THRUSTER = {}
THRUSTER.__index = THRUSTER
setmetatable(THRUSTER,OBJECT)

local TYPE_NAMES = {"Fighter","UFO","Rocket","Satellite","Space_station","Solitary_Ship"}


--if the fighter can chase the player hen do so if player is visible, otherwise just move straight
function SHIP:canChasePlayer()
    if self.isPlayerVisible() == true then
        self.lookAtPlayer()
        self.moveStraightLine()
    else
        self.moveStraightLine()
    end
end

function SHIP:printThruster()
    if self.thruster ~= nil then
        self.thruster.x     = self.x
        self.thruster.y     = self.y
        self.thruster.angle = self.angle
        self.thruster:printObj()
    end
end


--look at a random spot near player position
function SHIP:lookAtPlayer()
    if self.isPlayerVisible() == true then
        self.target_x = math.random(PLAYER.x - 5, PLAYER.x + 5)
        self.target_y = math.random(PLAYER.y - 5, PLAYER.x + 5)
        self.getnewAngle()
    end
end

--change a ships health
function SHIP:changeHealth(h)
    self.health = self.health + h
    if self.health > self.max_health then
        self.health = self.max_health
    end
end

--cahnge angle of ship based on targeting location
function SHIP:getNewAngle()
    self.angle = math.atan2(self.target_y - self.y,self.target_x - self.x)
end

--get new random angle between 90 and 270 degrees
function SHIP:getRandomAngle()
    self.angle = self.angle - 1.57079 * math.random() * 3.14159
end

function updateShip(list,i,dt)
    if list[i].moveable == true then
        list[i]:moveObject(dt)
    end
   --[[ local j = iterateList(list,checkForCollision,list[i])
    if j ~= -1 then
        table.remove(list,i)
        table.remove(list,j)
        return false
    end
    if list[i].shoot_func ~= nil then
        list[i].shoot_func(list[i])
    end
    --]]
    return false
end

local function getShipType()
    if math.random(1,3) < 3 then
        return TYPE_NAMES[1]
    else
        return TYPE_NAMES[math.random(2,#TYPE_NAMES)]
    end
end

local function getIcon(ship_type)
    local icon
    if ship_type == TYPE_NAMES[1] then
        icon = "/assets/img/ships/fighter_" .. math.random(1,2) .. ".png"
    elseif ship_type == TYPE_NAMES[2] then
        icon = "/assets/img/ships/ship_icon_ufo.png"
    elseif ship_type == TYPE_NAMES[3] then
        icon = "/assets/img/ships/rocket.png"
    elseif ship_type == TYPE_NAMES[4] then
        icon = "/assets/img/ships/satellite_" .. math.random(1,5) .. ".png"
    elseif ship_type == TYPE_NAMES[5] then
        icon = "/assets/img/ships/space_station_" .. math.random(1,3) .. ".png"
    elseif ship_type == TYPE_NAMES[6] then
        icon = "/assets/img/ships/rocket.png"
    elseif ship_type == "Player" then
        icon = "/assets/img/ships/player.png"
    end
      return love.graphics.newImage(icon)
end

local function getSound()
    local n = math.random(1,3)
    return love.audio.newSource("","static")
end

local function getSpeed(moveable)
    return math.random(100,250)

end

local function getChase(ship_type)
    if ship_type == TYPE_NAMES[1] then
        return math.random(1,3) < 3 and true or false
    end
    return false
end

local function getMoveable(ship_type)
    if ship_type == TYPE_NAMES[5] or ship_type == TYPE_NAMES[7] then
        return false
    end
    return true
end


local function getThrusterIcon()
    return love.graphics.newImage("/assets/img/effects/thrust_" .. math.random(1,5) .. ".png")
end


function THRUSTER:new(x,y,angle)
    local icon = getThrusterIcon()
    local o    = setmetatable(OBJECT:new(x,y,angle,icon),THRUSTER)
    return o
end

local function makeThruster(x,y,angle,ship_type)
    if ship_type == TYPE_NAMES[1] or ship_type == TYPE_NAMES[3] then
        return THRUSTER:new(x,y,angle)
    end
    return THRUSTER:new(x,y,angle)
end


local function getMissleOrLaser()
    local n = math.random(1,3)
    if n < 3 then
        return false
    end
    return true
end

local function getLaserColor(missle)
    if missle == false then
        return math.random(1,3)
    end
    return nil
end

local function getHealth(ship_type)
    return 3
end

function SHIP:new()
    local ship_type  = getShipType()
    local icon       = getIcon(ship_type)
   -- local chase    = getChase(ship_type)
    local x,y        = makeXY(SHIP_LIST)
    local o          = setmetatable(OBJECT:new(x,y,angle,icon),SHIP)
    o.moveable       = getMoveable(ship_type)
    --o.sound          = getSound(o.moveable) 
    o.speed          = getSpeed(o.moveable)
   -- o.shoot_func     = getShootFunc(o.moveable,chase)
    o.angle          = getAngle(ship_type)
    o.thruster       = makeThruster(x,y,o.angle,ship_type)
    o.health         = getHealth(ship_type)
    o.max_health     = o.health
    o.move_func      = moveStraightLine
  --  o.missle         = getMissleOrLaser()
    return o
end

function SHIP:makePlayer()
    local ship_type  = "Player"
    local icon       = getIcon(ship_type)
    local moveable   = true 
    local x,y        = makeXY(nil)
    local o          = setmetatable(OBJECT:new(x,y,angle,icon),SHIP)
    --o.sound          = getSound(moveable) 
    o.speed          = getSpeed(moveable)
   -- o.shoot_func     = getShootFunc(moveable,chase)
    o.angle          = getAngle(ship_type)
    o.thruster       = makeThruster(x,y,o.angle,ship_type)
  --  o.missle         = getMissleOrLaser()
    return o
end

function makeEnemyShips()
    local n = math.random(20,60)
    for i=1,n,1 do
        table.insert(SHIP_LIST,SHIP:new())
    end
end

