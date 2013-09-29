Obstacle = class('Obstacle', Base)
Obstacle.static.instances = {}

function Obstacle:initialize(x, y, width, height, velx, vely)
  Base.initialize(self)

  self.velx, self.vely = velx, vely
  self.width, self.height = width, height

  self._physics_body = Collider:addRectangle(x, y, width, height / 4)
  self._physics_body.parent = self

  Obstacle.instances[self.id] = self
end

function Obstacle:update(dt)
  self._physics_body:move(self.velx * dt, self.vely * dt)

  local x1, y1, x2, y2 = self:bbox()
  if x2 < 0 then
    self:destroy()
  end
end

function Obstacle:render()
  g.setColor(COLORS.red:rgb())
  local x1, y1, x2, y2 = self:bbox()
  g.rectangle("line", x1, y2 - self.height, self.width, self.height)
end

function Obstacle:bbox()
  return self._physics_body:bbox()
end

function Obstacle:destroy()
  print(self)
  Collider:remove(self._physics_body)
  Obstacle.instances[self.id] = nil
end
