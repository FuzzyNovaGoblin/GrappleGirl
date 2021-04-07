require("tiles")
require("camera")

Screen = {}
local tiles = {}
Screen.tiles = tiles
local width, height = love.graphics.getDimensions()

-- Initialize the screen
function Screen.init(x, y)
    tiles.width = x
    tiles.height = y
    for px = 1, x, 1 do
        tiles[px] = {}
        for py = 1, y, 1 do
            tiles[px][py] = Tile.byName["air"]
            -- Screen.setTile(x, y, Tile.byName["air"])
        end
    end
end

-- Check if a tile is within the bounds of the screen
function Screen.isInBounds(x, y)
    if x < 1 or y < 1 then
        return false
    end
    return not (x > tiles.width or y > tiles.height)
end

function Screen.setSpawn(spawnx, spawny)
    tiles.spawn = {x = spawnx, y = spawny}
end

function Screen.setExit(exitx, exity)
    tiles.exit = {x = exitx, y = exity}
end

-- Get the tile position from a pixel position
function Screen.getTilePosition(x, y)
    x = x - Camera.x
    y = (y - Camera.y)
    return math.floor(x / TileSize) + 1, tiles.height - math.floor(y / TileSize)
end

-- Get the screen pixel position from a tile position
function Screen.getScreenPosition(x, y)
    return (x * TileSize) + Camera.x, (tiles.height * TileSize - ((y + 1) * TileSize)) + Camera.y
end

-- Set a tile on the screen
function Screen.setTile(x, y, tile)
    if not Screen.isInBounds(x, y) then
        return
    end
    tiles[x][y] = tile
end

-- Get a table with all of the tiles by numeric ID
function Screen.getAllTiles()
    local toSave = {}
    toSave.spawn = tiles.spawn
    toSave.exit = tiles.exit
    toSave.width = tiles.width
    toSave.height = tiles.height
    for px = 1, tiles.width, 1 do
        toSave[px] = {}
        for py = 1, tiles.height, 1 do
            toSave[px][py] = Screen.getTile(px, py).id
        end
    end
    return toSave
end

-- Convert pixel coordinates to where they should be drawn on the screen
function Screen.adjustPositionForDrawing(x, y)
    return x + Camera.x, (tiles.height * TileSize) - y + Camera.y
end

-- Convert pixel coordinates from virtual positions to where they are physically on the screen
function Screen.adjustPositionForScreen(x, y)
    return x - Camera.x, (tiles.height * TileSize) - y + Camera.y
end

-- Get a tile on the screen
function Screen.getTile(x, y)
    local tile = tiles[x][y]
    if tile == nil then
        return Tile.byName["air"]
    end
    return tile
end

-- Draw the entire screen, call in love.draw
function Screen.drawScreen()
    for px = 1, tiles.width, 1 do
        for py = 1, tiles.height, 1 do
            Screen.drawTile(Screen.getTile(px, py), px - 1, py - 1)
        end
    end
    if tiles.spawn ~= nil then
        local posx, posy = Screen.adjustPositionForDrawing(tiles.spawn.x, tiles.spawn.y)
        love.graphics.setColor(0, 255, 0)
        love.graphics.circle("fill", posx, posy, TileSize / 2)
    end
    if tiles.exit ~= nil then
        local posx, posy = Screen.adjustPositionForDrawing(tiles.exit.x, tiles.exit.y)
        love.graphics.setColor(255, 0, 0)
        love.graphics.circle("fill", posx, posy, TileSize / 2)
    end
end

-- Draw a single tile to the screen. Inverts y so that 0 is the bottom of the window.
function Screen.drawTile(tile, x, y)
	love.graphics.setColor(tile.color[1] / 255, tile.color[2] / 255, tile.color[3] / 255, 1)
	-- Account for camera position
	x, y = Screen.getScreenPosition(x, y)
	love.graphics.rectangle("fill", x, y, TileSize, TileSize)
end