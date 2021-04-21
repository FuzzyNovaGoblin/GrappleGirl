require("config")
local Anim = require("animation")
local Sprite = require("sprite")
local sprite = require "sprite"
local Vector2 = require("Vector2")

Character = {}
local walk = Anim(16, 32, 16, 16, 6, 6, 12)

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

    self.shouldAddGrapple = nil

    love.graphics.setDefaultFilter('nearest', 'nearest')
    local full_sprite = love.graphics.newImage("sprites/hero.png")
    self.spr = Sprite(full_sprite, 20, 20, 100, 100, 1, 1)
    self.spr:add_animation("walk", walk)
    self.spr:animate("walk")
    
    return o
end

function Character:draw()
    local x, y = self.body:getPosition()

    x, y = Camera:applyOffset(x, y)
    self.spr.pos = Vector2(x, y)
    self.spr:draw()

    --love.graphics.circle("fill", x, y, 10)

    if self.grapplepod.body ~= nil then
        local ax, ay = self.grapplepod.body:getPosition()
        ax, ay = Camera:applyOffset(ax, ay)
        love.graphics.circle("fill", ax, ay, 1)
        love.graphics.line(x, y, ax, ay)
    end
end

function Character:update(dt)
    local f = 1000

    self.spr:update(dt)

    if (love.keyboard.isDown(CHARACTER_LEFT_KEY)) then
        self.body:applyForce(-f, 0)
    end
    if (love.keyboard.isDown(CHARACTER_RIGHT_KEY)) then
        self.body:applyForce(f, 0)
    end

    if (self.canJump and love.keyboard.isDown(CHARACTER_JUMP_KEY)) then
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

    if self.shouldAddGrapple ~= nil then
        local d = self.shouldAddGrapple.d
        local x2 = self.shouldAddGrapple.x2
        local y2 = self.shouldAddGrapple.y2
        local x = self.shouldAddGrapple.x
        local y = self.shouldAddGrapple.y

        self.grapplepod.fixture:destroy()
        self.grapplepod.body:destroy()

        self.grapplepod.body = love.physics.newBody(baseWorld, x, y, "static")
        self.grapplepod.fixture = love.physics.newFixture(self.grapplepod.body, self.grapplepod.shape, 1)
        self.grapplepod.fixture:setCategory(GRAPPLEPOD_CATEGORY)
        self.grapplepod.fixture:setMask(CHARACTER_CATEGORY)

        local dist, x1, y1, x2, y2 = love.physics.getDistance(self.fixture, self.grapplepod.fixture)

        self.grapplepod.joint = love.physics.newRopeJoint(self.body, self.grapplepod.body, x1, y1, x2, y2, dist)
        self.shouldAddGrapple = nil
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
