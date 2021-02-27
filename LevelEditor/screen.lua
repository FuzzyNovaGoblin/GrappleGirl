require("tiles")

Screen = {}
local tiles = {}

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

-- Get the tile position from a pixel position
function Screen.getScreenPosition(x, y)
    return x / TileSize, y / TileSize
end

-- Set a tile on the screen
function Screen.setTile(x, y, tile)
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
            Tile.drawTile(Screen.getTile(px, py), px - 1, py - 1)
        end
    end
end