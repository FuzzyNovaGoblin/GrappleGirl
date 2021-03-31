CHARACTER_CATEGORY = 2
GRAPPLEPOD_CATEGORY = 3

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
    local x, y = self.body:getPosition()

    love.graphics.circle("fill", x, y, 10)

    if self.grapplepod.body ~= nil then
        local ax, ay = self.grapplepod.body:getPosition()
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
end

function normalize(x, y)
    local v = math.sqrt(x * x + y * y)

    return (x / v), (y / v)
end

function Character:ropeMousePressedCallbackshootRope()
    local mx, my = love.mouse:getPosition()
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
end
