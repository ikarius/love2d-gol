-- Game Of Life: Lua / LOVE2D version
--
-- from; https://en.wikipedia.org/wiki/Conway's_Game_of_Life
--
-- Any live cell with fewer than two live neighbours dies, as if by underpopulation.
-- Any live cell with two or three live neighbours lives on to the next generation.
-- Any live cell with more than three live neighbours dies, as if by overpopulation.
-- Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

--local os = require "os"

local love = _G.love or {}
local gridSize, width, height = 10, 50, 50
local initNumber = 100
local world

function coordsToIndex(x,y)
    assert(x > 0 and x <= width, "Bad X coord")
    assert(y > 0 and y <= height, "Bad Y coord")
    -- 1-indexed
    return x + (y - 1) * height
end

function indexToCoords(idx)
    assert(idx > 0 and idx <= width * height, "Index not in range of world")
    local zidx = idx - 1
    return 1 + (zidx % width), math.floor(zidx / width) + 1
end

function neighbourCellsCoords(x,y)
    return { {x=x-1, y=y},
             {x=x-1, y=y-1},
             {x=x, y=y-1},
             {x=x+1, y=y-1},
             {x=x+1, y=y},
             {x=x+1, y=y+1},
             {x=x, y=y+1},
             {x=x-1, y=y-1} }
end

local function initWorld(number)
    local result = {}
    math.randomseed( os.time())
    -- empty world (false/dead)
    for x = 1, width do
        for y = 1, height do
            result[coordsToIndex(x, y)] = false
        end
    end
    -- random alive/true cells
    for n = 1, number do
        local x,y = math.random(width), math.random(height)
        result[coordsToIndex(x, y)] = true
    end
    return result
end


function love.load()
    love.window.setMode(gridSize * width, gridSize * height)
    love.window.setTitle("Conway's Game of Life")
    world = initWorld(initNumber)
end

function love.update(dt)
end

function love.draw()
    for cell in pairs(world) do
        local x, y = 0, 0
    end
end