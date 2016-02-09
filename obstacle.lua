Obstacle = class('Obstacle', Base)
Obstacle.static.instances = {}

function Obstacle:initialize(x, y, width, height, velx, vely)
  Base.initialize(self)

  local images = {"homeless_man.png", "KFC_bucket.png", "Paparazzi.png", "trashbag.png"}
  local num = math.random(#images)
  self.image = game.preloaded_image[images[num]]
  self.image_name = images[num]

  self.velx, self.vely = velx, vely
  self.width, self.height = self.image:getWidth(), self.image:getHeight()

  self._physics_body = Collider:addRectangle(x, y, self.width, self.height / 4)
  self._physics_body.parent = self

  self.full_collider = Collider:addRectangle(x, y - self.height + self.height / 4, self.width, self.height)
  self.full_collider.parent = self
  Collider:setGhost(self.full_collider)

  Obstacle.instances[self.id] = self
end

function Obstacle:update(dt)
  self._physics_body:move(self.velx * dt, self.vely * dt)
  self.full_collider:move(self.velx * dt, self.vely * dt)

  local x1, y1, x2, y2 = self:bbox()
  if x2 < 0 then
    self:destroy()
  end
end

function Obstacle:render()
  -- g.setColor(COLORS.red:rgb())
  local x1, y1, x2, y2 = self:bbox()
  -- g.rectangle("line", x1, y2 - self.height, self.width, self.height)
  g.setColor(COLORS.white:rgb())
  g.draw(self.image, x1, y2 - self.height)
end

function Obstacle:bbox()
  return self._physics_body:bbox()
end

function Obstacle:destroy()
  local index = 0
  for i,object in ipairs(game.render_queue) do
    if object == self then
      index = i
      break
    end
  end
  table.remove(game.render_queue, index)
  Collider:remove(self._physics_body)
  Collider:remove(self.full_collider)
  Obstacle.instances[self.id] = nil
end

function Obstacle:__lt(other)
  local _, _, _, sy = self._physics_body:bbox()
  local _, _, _, oy = other._physics_body:bbox()
  if sy < oy then return true
  elseif sy == oy and self.id < other.id then return true
  else return false
  end
end

function Obstacle:__le(other)
  return self < other
end

return Obstacle
