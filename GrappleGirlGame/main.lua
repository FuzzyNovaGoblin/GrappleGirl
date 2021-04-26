require("Character")
require("love")
require("Music")
require("camera")
require("weapons")
require("Levels")
require("config")
local Anim = require("animation")
local Sprite = require("sprite")

local full_sprite

local angle = 0

-- animation param
local fps = 10
local frame = 1
local animation_timer = 1 / fps
local x_offset
local num_frames = 6
---------------------

function love.load()
    music = playAudio("audio/music/Dioma.mp3", "stream", true)
    music:setVolume(MUSIC_VOLUME)

    if (not ENABLE_MUSIC) then
        stopAudio(music)
    end
    -- Sets title for window
    love.window.setTitle('Grapple Girl')

    baseWorld = love.physics.newWorld(0, 1000, false)

    gGirl = Character:new(nil, baseWorld, {love.graphics.getWidth() / 2, 100}, {400, 400})

    viewport = Camera:new(love.graphics.getWidth(), love.graphics.getHeight(), 0.25, 0.40, nil, 0.20)

    baseWorld:setCallbacks(baseWorld.beginContact, baseWorld.endContact, mypresolve, mypostSolve)

    Level:loadLevel("levels/level1.lua")

    -- Draws weapon on spawn and creates images
    loadweapon = weapon:draw()
    WEAPONS.grapplegun.img = love.graphics.newImage("sprites/magnum.png")
    WEAPONS.bullet.img = love.graphics.newImage("sprites/bullet.png")

    -- Limits bullet firerate
    canFire = true
    fire_tick = 0
    fire_wait = 0.1
    -- Bullets table
    bullets = {
      bulletSpeed = 250
    }
end

function doesContainCatagory(fixt, cat)
    local cats = {fixt:getCategory()}
    for i = 1, #cats do
        if cats[i] == cat then
            return true
        elseif cats[i] > cat then
            return false
        end
    end
    return false
end

function love.update(dt)
    baseWorld:update(dt)
    gGirl:update(dt)
    Camera:update(gGirl)

    -- Table for bullets
    for i,v in ipairs(bullets) do
      v.x = v.x + (v.dx * dt)
      v.y = v.y + (v.dy * dt)
    end

    -- Cleans up bullets that are off screen
    for i = #bullets, 1, -1 do
      local o = bullets[i]
      if(o.x > love.graphics.getWidth() + 10)
      or(o.y > love.graphics.getWidth() + 10) then
        table.remove(bullets, i)
      end
    end

    -- Limits firerate of bullets
    if not canFire then
      fire_tick = fire_tick + dt
      if fire_tick > fire_wait then
        canFire = true
        fire_tick = 0
      end
    end

    if gGirl.body then
        -- print(gGirl.body:getPosition())
    end
end

function love.keypressed(key)
    if key == PLAY_MUSIC_KEY then
        -- plays from stopped position
        playAudio(music)
    elseif key == PAUSE_MUSIC_KEY then
        -- only pauses audio doesn't reset
        stopAudio(music)
    end
end

function love.draw()
    gGirl:draw()
    for i = 1, #(Level.blocks) do
        Block:draw(Level.blocks[i])
    end

    -- Spawns bullets
    weapon:spawnBullets(angletomouse)

    -- FPS counter
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print(love.timer.getFPS(), love.graphics.getWidth() - 25, 0)
    love.graphics.setColor(1, 1, 1)

    -- print()
    -- print()
    -- print(#Level.blocks)
end

function mypostSolve(f1, f2, contact)
    if
        not love.keyboard.isDown("space") and
            ((doesContainCatagory(f1, FLOOR_CATEGORY) and doesContainCatagory(f2, CHARACTER_CATEGORY)) or
                (doesContainCatagory(f2, FLOOR_CATEGORY) and doesContainCatagory(f1, CHARACTER_CATEGORY)))
     then
        if  gGirl.canJump ~= true then
        if doesContainCatagory(f1, FLOOR_CATEGORY) then
            charFic = f2
            rand = math.random(1, 5)
            if rand < 4 then
              playAudio("audio/grapplegirl_voicelines/ow"..rand..".mp3", "stream", false)
            end
        else
            charFic = f1
            rand = math.random(1, 4)
            if rand < 3 then
              playAudio("audio/grapplegirl_voicelines/bigdrop"..rand..".mp3", "stream", false)
            end
        end
        charFic:getUserData().canJump = true
    end
    end

    local podf = nil
    local of = nil

    if doesContainCatagory(f1, GRAPPLEPOD_CATEGORY) then
        podf = f1
        othf = f2
    elseif doesContainCatagory(f2, GRAPPLEPOD_CATEGORY) then
        podf = f2
        othf = f1
    end
    if podf ~= nil then
        gGirl.shouldAddGrapple = {}

        gGirl.shouldAddGrapple.d,
            gGirl.shouldAddGrapple.x2,
            gGirl.shouldAddGrapple.y2,
            gGirl.shouldAddGrapple.x,
            gGirl.shouldAddGrapple.y = love.physics.getDistance(podf, othf)
    end
end
function mypreSolve(f1, f2, contact)
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        gGirl:ropeMousePressedCallbackshootRope(viewport)
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if button == 1 then
        gGirl:ropeMouseReleasedCallbackshootRope()
    end
end
