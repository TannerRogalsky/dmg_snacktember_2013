Platform = class('Platform', Base)
Platform.static.instances = {}

function Platform:initialize(x, y, width)
  Base.initialize(self)

  width = width or 250
  self._physics_body = Collider:addRectangle(x, y, width, g.getHeight() - y)
  self._physics_body.parent = self

  Platform.instances[self.id] = self
end

function Platform.make_next_platform(previous_platform)
  local px1, py1, px2, py2 = previous_platform:bbox()
  local x = px2 + 100 -- offset
  local y = py1 + math.random(-75, 75)
  y = math.clamp(300, y, g.getHeight() - 100)

  return Platform:new(x, y, math.random(50, 400))
end

function Platform:update(dt)
end

function Platform:render()
end

function Platform:bbox()
  return self._physics_body:bbox()
end

function Platform:destroy()
  Collider:remove(self._physics_body)
  Platform.instances[self.id] = nil
end

return Platform
