require("tiles")
require("screen")
require("camera")

-- Initialize everything
local selectedTile = Tile.byName["wall"]
love.window.setTitle("Level Editor")
local mousePressed = false
local width, height = love.graphics.getDimensions()
local tileWidth, tileHeight = Screen.getScreenPosition(width, height)
Screen.init(tileWidth, tileHeight)

function love.mousepressed(x, y, button, istouch, presses)
	-- Todo: Handle mouse presses to draw tiles
end

function love.mousemoved(x, y, dx, dy, isTouch)
	-- Todo: Handle mouse drags to draw tiles
end

function love.update()
	-- Hand off update to Camera
	Camera.update()
end

function love.draw()
	-- Hand off drawing to Screen
	Screen.drawScreen()
end
