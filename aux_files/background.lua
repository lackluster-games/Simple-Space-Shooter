--File contains functions for creating the background of game

local Obj  = require("aux_files.object")

--list of all background objects
local BG_LIST = {}

--print object to background canvas
local function getIcon(rand)
    return love.graphics.newImage("/assets/img/planets/planet_icon_" .. rand(1,41) ..".png")
end

--draw border around game map
local function drawBorderToCanvas()
    love.graphics.setColor(1,1,1)
    love.graphics.setLineWidth(10)
    love.graphics.line(1,1,GAME_W,1)
    love.graphics.line(1,GAME_H,GAME_W,GAME_H)
    love.graphics.line(1,1,1,GAME_H)
    love.graphics.line(GAME_W,1,GAME_W,GAME_H)
end

--gets a new randomly genrated x y for background objext
local function getXY(rand)
    local params = {x = nil, y = nil}
    local checkoverlap = checkIfOverLap
    local iterate      = iterateList
    repeat
        params.x = rand(50,GAME_W - 50)
        params.y = rand(50,GAME_H - 50)
    until(iterate(BG_LIST,checkIfOverLap,params) == -1 )
    return params.x,params.y
end

--create the background for the game
function makeBackground()
    local bg_canvas = love.graphics.newCanvas(GAME_W,GAME_H)
    local rand      = math.random
    local n         = rand(30,150)
    local add       = table.insert
    local getxy     = getXY
    love.graphics.setCanvas(bg_canvas)
    for i=1,n,1 do
        local x,y    = getXY(rand)
        local angle  = -3.14159 + rand() * 6.28318530718
        local icon   = getIcon(rand)
        local bg_obj = OBJECT:new(x,y,angle,icon)
        add(BG_LIST,bg_obj)
        bg_obj:printObj()
    end
    drawBorderToCanvas()
    love.graphics.setCanvas()
    return bg_canvas 
end

