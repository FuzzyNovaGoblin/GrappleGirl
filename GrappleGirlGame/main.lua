require("Character")
require("love")
require("Music")
require("camera")
require("Levels")
require("config")

function love.load()
    music = playAudio("audio/music/Dioma.mp3", "stream", true)
    music:setVolume(MUSIC_VOLUME)

    if (not ENABLE_MUSIC) then
        stopAudio(music)
    end

    baseWorld = love.physics.newWorld(0, 1000, false)
    gGirl = Character:new(nil, baseWorld, {love.graphics.getWidth() / 2, 100}, {400, 400})

    viewport = Camera:new(love.graphics.getWidth(), love.graphics.getHeight(), 0.25, 0.40, nil, 0.20)

    baseWorld:setCallbacks(baseWorld.beginContact, baseWorld.endContact, mypresolve, mypostSolve)

    Level:loadLevel("levels/level2.lua")
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
        if doesContainCatagory(f1, FLOOR_CATEGORY) then
            charFic = f2
        else
            charFic = f1
        end
        charFic:getUserData().canJump = true
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
