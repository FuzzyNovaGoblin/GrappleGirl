require("tiles")
require("screen")
require("camera")
require("savefile")

-- Initialize everything
local selectedTile = Tile.byName["wall"]
love.window.setTitle("Level Editor")
love.window.setMode(1200, 800)
local mousePressed = false
local tileWidth, tileHeight

function love.load(arg)
	if #arg < 2 then
		local width, height = love.graphics.getDimensions()
		tileWidth, tileHeight = width / TileSize, height / TileSize
	else
		tileWidth, tileHeight = tonumber(arg[1]), tonumber(arg[2])
	end
	Screen.init(tileWidth, tileHeight)
end

function love.mousepressed(x, y, button, istouch, presses)
	-- Todo: Handle mouse presses to draw tiles
	if button ~= 1 then
		return
	end
	x, y = Screen.getTilePosition(x, y)
	print(x.." "..y)
	Screen.setTile(x, y, selectedTile)
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

function love.keypressed(key)
	if key == "[" then
		local x, y = love.mouse.getPosition()
		x, y = Screen.adjustPositionForScreen(x, y)
		Screen.setSpawn(x, y)
	elseif key == "]" then
		local x, y = love.mouse.getPosition()
		x, y = Screen.adjustPositionForScreen(x, y)
		Screen.setExit(x, y)
	end
	if key == "s" and love.keyboard.isDown("lctrl") then
		SaveFile.save(Screen.getAllTiles(), "../level.lua")
	end
end

function love.update()
	-- Hand off update to Camera
	Camera.update()
end

function love.draw()
	-- Hand off drawing to Screen
	Screen.drawScreen()
end
