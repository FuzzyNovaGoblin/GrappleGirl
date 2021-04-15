CHARACTER_CATEGORY = 2
GRAPPLEPOD_CATEGORY = 3

GRAPPLE_COIL_SPEED = 500
SHORTEN_COIL_KEY = "w"
LENGTHEN_COIL_KEY = "s"

Character = {}

function Character:new(o, world, pos, speed)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.speed = {x = speed.x or speed[1] or 150, y = speed.y or speed[2] or 150}
    self.mv = {u = false, d = false, r = false, l = false}
    self.shape = love.physics.newRectangleShape(20, 20)

    self.body = love.physics.newBody(world, pos.x or pos[1], pos.y or pos[2], "dynamic")
    self.body:setFixedRotation(true)

    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
    self.fixture:setFriction(1)
    self.fixture:setCategory(CHARACTER_CATEGORY)
    self.fixture:setUserData(o)

    self.canJump = true

    self.grapplepod = {
        joint = nil,
        fixture = nil,
        shape = love.physics.newCircleShape(2),
        body = nil,
        state = nil
    }

    return o
end

function Character:draw()
  -- Added getting mouse x and y to be used to do angletomouse
   local mousex, mousey = love.mouse.getPosition()
   local playerx, playery = gGirl.body:getPosition()
   mousex, mousey = Camera:reverseOffset(mousex, mousey)
   local angletomouse = math.atan2(mousey - playery, mousex - playerx)

    local x, y = self.body:getPosition()

    x, y = Camera:applyOffset(x, y)

    love.graphics.circle("fill", x, y, 10)

    -- Draws sprite for weapon on spawn
    Combat:update(x, y, angletomouse)
    -- Debug print to see angletomouse
    love.graphics.print(angletomouse, 250, 0)

    -- Going to be used to fire bullets
    if (love.keyboard.isDown("f")) then
       -- Combat:attack(x + 10, y)
    end

    if self.grapplepod.body ~= nil then
        local ax, ay = self.grapplepod.body:getPosition()
        ax, ay = Camera:applyOffset(ax, ay)
        love.graphics.circle("fill", ax, ay, 1)
        love.graphics.line(x, y, ax, ay)
    end
end

function Character:update(dt)

    local f = 1000
    if (love.keyboard.isDown("a")) then
        self.body:applyForce(-f, 0)
    end
    if (love.keyboard.isDown("d")) then
        self.body:applyForce(f, 0)
    end

    if (self.canJump and love.keyboard.isDown("space")) then
        self.canJump = false
        self.body:applyLinearImpulse(0, -400)
    end

    if self.grapplepod.joint ~= nil then
        if (self.canJump and love.keyboard.isDown(LENGTHEN_COIL_KEY)) then
            self.grapplepod.joint:setMaxLength(self.grapplepod.joint:getMaxLength() + dt * GRAPPLE_COIL_SPEED)
        end
        if (self.canJump and love.keyboard.isDown(SHORTEN_COIL_KEY)) then
            self.grapplepod.joint:setMaxLength(self.grapplepod.joint:getMaxLength() - dt * GRAPPLE_COIL_SPEED)
        end
        if self.grapplepod.joint:getMaxLength() < 0 then
            self.grapplepod.joint:setMaxLength(0)
        end
    end
end

function normalize(x, y)
    local v = math.sqrt(x * x + y * y)

    return (x / v), (y / v)
end

function Character:ropeMousePressedCallbackshootRope(vp)
    local mx, my = love.mouse:getPosition()
    mx, my = vp:reverseOffset(mx, my)
    local x, y = self.body:getPosition()
    self.grapplepod.body = love.physics.newBody(baseWorld, x, y, "dynamic")
    self.grapplepod.fixture = love.physics.newFixture(self.grapplepod.body, self.grapplepod.shape, 1)
    self.grapplepod.fixture:setCategory(GRAPPLEPOD_CATEGORY)
    self.grapplepod.fixture:setMask(CHARACTER_CATEGORY)

    local vx, vy = normalize(mx - x, my - y)
    self.grapplepod.body:setLinearVelocity(vx * 1500, vy * 1500)
end

function Character:ropeMouseReleasedCallbackshootRope()
    self.grapplepod.fixture:destroy()
    self.grapplepod.body:destroy()
    self.grapplepod.body = nil
    self.grapplepod.fixture = nil
    self.grapplepod.joint = nil
end
