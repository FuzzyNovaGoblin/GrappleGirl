require("tiles")
require("screen")
require("camera")

-- Initialize everything
local selectedTile = Tile.byName["wall"]
love.window.setTitle("Level Editor")
local mousePressed = false
local width, height = love.graphics.getDimensions()
local tileWidth, tileHeight = width / TileSize, height / TileSize
Screen.init(tileWidth, tileHeight)

function love.mousepressed(x, y, button, istouch, presses)
	if button ~= 1 then
		return
	end
	x, y = Screen.getTilePosition(x, y)
	Screen.setTile(x, y, selectedTile)
end

function love.keypressed(key, scancode, isrepeat)
	local num = tonumber(key)
	if num == nil then
		return
	end
	selectedTile = Tile[num] or selectedTile
end

function love.mousemoved(x, y, dx, dy, isTouch)
	if not love.mouse.isDown(1) then
		return
	end
	local newX, newY = x + dx, y + dy
	-- Get new tile coordinates
	local tx, ty = Screen.getTilePosition(newX, newY)
	-- Get old tile coordinates
	local otx, oty = Screen.getTilePosition(x, y)
	if tx == otx and ty == oty then
		return
	end
	Screen.setTile(tx, ty, selectedTile)
end

function love.update()
	-- Hand off update to Camera
	Camera.update()
end

function love.draw()
	-- Hand off drawing to Screen
	Screen.drawScreen()
end
