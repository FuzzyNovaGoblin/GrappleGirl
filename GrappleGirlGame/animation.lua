local class = require("class")
local Animation = class:derive("Animation")
local Vector2 = require("Vector2")

-- credit to recursor on youtube

function Animation:new(xoffset, yoffset, w, h, column_size, num_frames, fps)
    self.fps = fps
    self.timer = 1 / self.fps
    self.frame = 1
    self.num_frames = num_frames
    self.column_size = column_size
    self.start_offset = Vector2(xoffset, yoffset)
    self.offset = Vector2()
    self.size = Vector2(w, h)
end

function Animation:reset()
    self.timer = 1 / self.fps
    self.frame = 1
end

function Animation:set(quad)
    quad:setViewport(self.offset.x, self.offset.y, self.size.x, self.size.y)
end

function Animation:update(dt, quad)
    if(self.num_frames < 1) then return end

    self.timer = self.timer - dt
    if (self.timer <= 0) then
        self.timer = 1 / self.fps
        self.frame = self.frame + 1
        if self.frame > self.num_frames then
            self.frame = 1
        end
        self.offset.x = self.start_offset.x + (self.size.x * ((self.frame -1) % (self.column_size)))
        self.offset.y = self.start_offset.y + (self.size.y * (self.size.y * math.floor((self.frame - 1) / self.column_size)))
        self:set(quad)
    end
end

return Animation