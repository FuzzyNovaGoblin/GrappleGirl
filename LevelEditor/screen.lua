require("tiles")
require("camera")

Screen = {}
local tiles = {}
local width, height = love.graphics.getDimensions()

-- Initialize the screen
function Screen.init(x, y)
    Screen.width = x
    Screen.height = y
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
    return not (x > Screen.width or y > Screen.height)
end

-- Get the tile position from a pixel position
function Screen.getTilePosition(x, y)
    x = x - Camera.x
    y = (y - Camera.y)
    return math.floor(x / TileSize) + 1, Screen.height - math.floor(y / TileSize)
end

-- Get the screen pixel position from a tile position
function Screen.getScreenPosition(x, y)
    return (x * TileSize) + Camera.x, (Screen.height * TileSize - ((y + 1) * TileSize)) + Camera.y
end

-- Set a tile on the screen
function Screen.setTile(x, y, tile)
    if not Screen.isInBounds(x, y) then
        return
    end
    tiles[x][y] = tile
end

-- Get a tile on the screen
function Screen.getTile(x, y)
    local tile = tiles[x][y]
    if tile == nil then
        return Tile.byName("air")
    end
    return tile
end

-- Draw the entire screen, call in love.draw
function Screen.drawScreen()
    for px = 1, Screen.width, 1 do
        for py = 1, Screen.height, 1 do
            Screen.drawTile(Screen.getTile(px, py), px - 1, py - 1)
        end
    end
end

-- Draw a single tile to the screen. Inverts y so that 0 is the bottom of the window.
function Screen.drawTile(tile, x, y)
	love.graphics.setColor(tile.color[1] / 255, tile.color[2] / 255, tile.color[3] / 255, 1)
	-- Account for camera position
	x, y = Screen.getScreenPosition(x, y)
	love.graphics.rectangle("fill", x, y, TileSize, TileSize)
end