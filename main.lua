-- Game Of Life: Lua / LOVE2D version
--
-- from: https://en.wikipedia.org/wiki/Conway's_Game_of_Life
--
-- Any live cell with fewer than two live neighbours dies, as if by underpopulation.
-- Any live cell with two or three live neighbours lives on to the next generation.
-- Any live cell with more than three live neighbours dies, as if by overpopulation.
-- Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

local love = _G.love or {}
local gridSize, width, height = 10, 50, 50
local initNumber = 500
local world
local modulo = 0

local function inBoundaries(x,y)
    return (x > 0 and x <= width) and (y > 0 and y <= height)
end

local function coordsToIndex(x,y)
    assert(x > 0 and x <= width, "Bad X coord")
    assert(y > 0 and y <= height, "Bad Y coord")
    -- 1-indexed
    return x + (y - 1) * height
end

local function indexToCoords(idx)
    assert(idx > 0 and idx <= width * height, "Index not in range of world")
    local zidx = idx - 1
    return 1 + (zidx % width), math.floor(zidx / width) + 1
end

local function neighbourCellsCoords(x,y)
    local possibleCoords =  {   {x=x-1, y=y},
                                {x=x-1, y=y-1},
                                {x=x,   y=y-1},
                                {x=x+1, y=y-1},
                                {x=x+1, y=y},
                                {x=x+1, y=y+1},
                                {x=x,   y=y+1},
                                {x=x-1, y=y+1} }
    local result = {}

    for _,coord in pairs(possibleCoords) do
        if inBoundaries(coord.x, coord.y) then
            table.insert(result, coord)
        end
    end

    return result
end

local function nbLiveCellsAround(x,y)
    local number = 0
    for _,v in pairs(neighbourCellsCoords(x,y)) do
        local idx = coordsToIndex(v.x, v.y)
        if world[idx] then
            number = number + 1
        end
    end
    return number
end

local function emptyWorld()
    local result = {}
    for x = 1, width do
        for y = 1, height do
            result[coordsToIndex(x, y)] = false
        end
    end
    return result
end

local function initWorld(number)
    math.randomseed(os.time())
    -- empty world (false/dead)
    local result = emptyWorld()

    -- random alive/true cells
    for _ = 1, number do
        local x,y = math.random(width), math.random(height)
        result[coordsToIndex(x, y)] = true
    end
    return result
end

---------------------------------------------------------------------------

function love.load()
    love.window.setMode(gridSize * width, gridSize * height)
    love.window.setTitle("Conway's Game of Life")
    world = initWorld(initNumber)
end

function love.update(_)
    -- don't be too fast
    modulo = modulo + 1
    if modulo % 20 ~= 0 then return end

    -- make a copy of the world
    local newWorld = emptyWorld()

    -- parse world and apply rules to every cell
    for idx,liveCell in pairs(world) do
        local x,y = indexToCoords(idx)
        local nbAlive = nbLiveCellsAround(x,y)
        -- rules:
        -- for live cells
        if liveCell then
            -- simplification
            newWorld[idx] = nbAlive == 2 or nbAlive == 3
        else
            -- dead cell and reproduction
            if nbAlive == 3 then
                newWorld[idx] = true
            end
        end
    end

    -- Update the world
    world = newWorld
end

function love.draw()
    for idx, alive in pairs(world) do
        local x, y = indexToCoords(idx)
        love.graphics.setColor(1,1,1)
        if alive then
            love.graphics.rectangle("fill", gridSize * (x - 1), gridSize * (y -1), gridSize, gridSize)
        end
    end
end