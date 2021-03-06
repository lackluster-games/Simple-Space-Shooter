--File fontains functions for creating and manipulaating weapon objects

local Proj = require("aux_files.projectile")

WEAPON = {proj_speed = nil,proj_icon = nil,time_since_shot = nil,time_between_shots = nil,t_off = nil,target_angle = nil, sound = nil}
WEAPON.__index = WEAPON

CIRCLE_SHOT = {}
CIRCLE_SHOT.__index = CIRCLE_SHOT
setmetatable(CIRCLE_SHOT,WEAPON)

SINGLE_SHOT = {}
SINGLE_SHOT.__index = SINGLE_SHOT
setmetatable(SINGLE_SHOT,WEAPON)

MULTI_SHOT = {}
MULTI_SHOT.__index = MULTI_SHOT
setmetatable(MULTI_SHOT,WEAPON)

local PROJ_COLORS = {"blue","red","green","yellow"}

function WEAPON:resetSound()
    self.sound:stop()
    self.sound:play()
end

function SINGLE_SHOT:shootFunc(ship,list) 
    if love.timer.getTime() - self.time_since_shot > self.time_between_shots then
        table.insert(list,PROJECTILE:new(ship.x,ship.y,self.target_angle,self.t_off,self.proj_icon,self.proj_speed))
        self.time_since_shot = love.timer.getTime()
    self:resetSound()
    end
end

function CIRCLE_SHOT:shootFunc(ship,list)
    if love.timer.getTime() - self.time_since_shot > self.time_between_shots then
        local add   = table.insert
        local angle = self.target_angle
        for i=1,12,1 do
            angle = angle - 0.5235988
            add(list,PROJECTILE:new(ship.x,ship.y,angle,self.t_off,self.proj_icon,self.proj_speed))
        end
        self:resetSound()
        self.time_since_shot = love.timer.getTime()
    end
end

function MULTI_SHOT:shootFunc(ship,list) 
    if love.timer.getTime() - self.time_since_shot > self.time_between_shots then
        local add = table.insert
        add(list,PROJECTILE:new(ship.x,ship.y,self.target_angle,self.t_off,self.proj_icon,self.proj_speed))
        add(list,PROJECTILE:new(ship.x,ship.y,self.target_angle - 0.08726646,self.t_off,self.proj_icon,self.proj_speed))
        add(list,PROJECTILE:new(ship.x,ship.y,self.target_angle + 0.08726646,self.t_off,self.proj_icon,self.proj_speed))
        self:resetSound()
        self.time_since_shot = love.timer.getTime()
    end

end

function CIRCLE_SHOT:new(rand,ship_speed)
    local o = setmetatable(WEAPON:new(rand,ship_speed),CIRCLE_SHOT)
    return o
end

function SINGLE_SHOT:new(rand,ship_speed)
    local o = setmetatable(WEAPON:new(rand,ship_speed),SINGLE_SHOT)
    return o
end

function MULTI_SHOT:new(rand,ship_speed)
    local o = setmetatable(WEAPON:new(rand,ship_speed),MULTI_SHOT)
    return o
end

local function getProjIcon(rand)
    local color = PROJ_COLORS[rand(1,#PROJ_COLORS)]
    local  icon = "/assets/img/weapons/laser_" .. color .. ".png"
    return love.graphics.newImage(icon)
end

local function getProjSpeed(rand,ship_speed)
    if ship_speed > 0  then
        return ship_speed * (1.25 + rand() * 0.75)
    else
        return (0.75 + rand() * 1.25) * PLAYER.speed
    end
end

local function getProjSound(rand) 
    return love.audio.newSource("/assets/sounds/weapons/laser_sound_" .. rand(1,5) .. ".ogg","static")
end

function WEAPON:new(rand,ship_speed)
    local o              = setmetatable({},WEAPON)
    o.proj_icon          = getProjIcon(rand)
    o.t_off              = rand(1,3) < 2
    o.time_since_shot    = love.timer.getTime()
    o.time_between_shots = 0.90 + rand() * 1.5
    o.proj_speed         = getProjSpeed(rand,ship_speed)
    o.sound              = getProjSound(rand)
    return o
end

