Runner = class('Runner', Base):include(Stateful)
Runner.static.instances = {}

function Runner:initialize(x, y)
  Base.initialize(self)

  self.vel_x, self.vel_y = 2, 0
  self._physics_body = Collider:addRectangle(x, y, 50, 100)
  self._physics_body.parent = self

  Runner.instances[self.id] = self
end

function Runner:update(dt)
  self.vel_y = self.vel_y - 0.1
  self:move(self.vel_x * 100 * dt, -self.vel_y * 100 * dt)
end

function Runner:jump()
  self.vel_y = 3
end

function Runner:render()
end

function Runner:destroy()
  Runner.instances[self.id] = nil
  Collider:remove(self._physics_body)
end

function Runner:move(dx, dy)
  self._physics_body:move(dx, dy)
end

function Runner:center()
  return self._physics_body:center()
end

function Runner:bbox()
  return self._physics_body:bbox()
end

function Runner:on_collide(dt, other, mtv_x, mtv_y)
  if other.deadzone == true then
    self:destroy()
    self.vel_x = 0
    Collider:clear()
    print("gameover")
  end

  self:move(mtv_x, mtv_y)

  local collision = {
    is_down = mtv_y < 0,
    is_up = mtv_y > 0,
    is_left = mtv_x > 0,
    is_right = mtv_x < 0
  }

  if collision.is_down and self.vel_y < 0 then
    self.vel_y = 0
  end
end
