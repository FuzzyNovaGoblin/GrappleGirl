require("Character")
require("love")
require("music")
require("camera")
FLOOR_CATEGORY = 4

function love.load()
    music = love.audio.play("audio/music/Dioma.mp3", "stream", true)
    music:setVolume(0.75)

    baseWorld = love.physics.newWorld(0, 1000, false)
    gGirl = Character:new(nil, baseWorld, {love.graphics.getWidth() / 2, 100}, {400, 400})
    viewport = Camera:new(love.graphics.getWidth(), love.graphics.getHeight(), 0.25, 0.40, nil, 0.20)

    -- floor --
    floor = {}
    floor.shape = love.physics.newRectangleShape(love.graphics.getWidth(), 100)
    floor.body = love.physics.newBody(baseWorld, love.graphics.getWidth() / 2, love.graphics.getHeight(), "static")
    floor.fixture = love.physics.newFixture(floor.body, floor.shape, 1)
    floor.fixture:setFriction(1)
    floor.fixture:setCategory(FLOOR_CATEGORY, 10, 9)
    -- floor end --

    -- grappleAnchorBlock --
    grappleAnchorBlock = {}
    grappleAnchorBlock.shape = love.physics.newRectangleShape(50, 50)
    grappleAnchorBlock.body =
        love.physics.newBody(baseWorld, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, "kinematic")
    grappleAnchorBlock.fixture = love.physics.newFixture(grappleAnchorBlock.body, grappleAnchorBlock.shape, 1)
    grappleAnchorBlock.fixture:setFriction(1)
    grappleAnchorBlock.fixture:setCategory(FLOOR_CATEGORY)
    -- grappleAnchorBlock end --

    baseWorld:setCallbacks(baseWorld.beginContact, baseWorld.endContact, mypresolve, mypostSolve)
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
    local contacts = baseWorld:getContacts()

    for i = 1, #baseWorld:getContacts() do
        f1, f2 = contacts[i]:getFixtures()
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
            local d, x2, y2, x, y = love.physics.getDistance(podf, othf)
            gGirl.grapplepod.fixture:destroy()
            gGirl.grapplepod.body:destroy()

            gGirl.grapplepod.body = love.physics.newBody(baseWorld, x, y, "static")
            gGirl.grapplepod.fixture = love.physics.newFixture(gGirl.grapplepod.body, gGirl.grapplepod.shape, 1)
            gGirl.grapplepod.fixture:setCategory(GRAPPLEPOD_CATEGORY)
            gGirl.grapplepod.fixture:setMask(CHARACTER_CATEGORY)

            local dist, x1, y1, x2, y2 = love.physics.getDistance(gGirl.fixture, gGirl.grapplepod.fixture)

            gGirl.grapplepod.joint = love.physics.newRopeJoint(gGirl.body, gGirl.grapplepod.body, x1, y1, x2, y2, dist)
        end
    end

    baseWorld:update(dt)
    gGirl:update(dt)
    Camera:update(gGirl)
end

function love.keypressed(key)
    if key == 'p' then
        -- plays from stopped position
        love.audio.play(music)
    elseif key == 's' then
        -- only pauses audio doesn't reset
        love.audio.stop(music)
    end
end

function love.draw()
    gGirl:draw()

    local gaPos = {}
    gaPos.x, gaPos.y = grappleAnchorBlock.body:getPosition()
    gaPos.x, gaPos.y = Camera:applyOffset(gaPos.x, gaPos.y)
    love.graphics.rectangle("fill", gaPos.x - 25, gaPos.y - 25, 50, 50)
end

function mypostSolve(f1, f2, contact)
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
