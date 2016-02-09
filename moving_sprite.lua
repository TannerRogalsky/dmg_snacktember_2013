MovableSprite = class('MovableSprite', Base)
MovableSprite:include(YSortable)
MovableSprite.static.instances = skiplist.new(30)

function MovableSprite:initialize(x, y, image, scale, velx, vely, z, repeats)
  Base.initialize(self)

  self.x, self.y, self.z = x, y, z
  self.velx, self.vely = velx, vely
  self.image = image
  self.scale = scale
  self.width = image:getWidth() * scale
  self.height = image:getHeight() * scale
  self.repeats = repeats or false

  if self.repeats and self.x + self.width < g.getWidth() then
    self.next = MovableSprite:new(self.x + self.width, self.y, self.image, self.scale, self.velx, self.vely, self.z, self.repeats)
  end

  MovableSprite.instances:insert(self)
end

function MovableSprite:update(dt)
  self.x = self.x + self.velx * dt
  self.y = self.y + self.vely * dt

  if self.next == nil and self.repeats and self.x + self.width < g.getWidth() then
    self.next = MovableSprite:new(self.x + self.width, self.y, self.image, self.scale, self.velx, self.vely, self.z, self.repeats)
  end

  if self.x + self.width < 0 then
    self:destroy()
  end
end

function MovableSprite:render()
  g.draw(self.image, self.x, self.y, 0, self.scale, self.scale)
end

function MovableSprite:destroy()
  MovableSprite.instances:delete(self)
end

return MovableSprite
