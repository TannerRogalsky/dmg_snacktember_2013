RobFord = class('RobFord', Base)

function RobFord:initialize(x, y)
  Base.initialize(self)

  self.width, self.height = 115, 175

  self._physics_body = Collider:addRectangle(x, y, self.width, self.height / 4)
  self._physics_body.parent = self

  self.image = game.preloaded_image["Rob Ford.png"]

  self.keyboard_update = {
    up = self.up,
    down = self.down,
    left = self.left,
    right = self.right
  }

  self.velx, self.vely = 0, 0
end

function RobFord:update(dt)
  self.velx, self.vely = 0, 0
  for key,action in pairs(self.keyboard_update) do
    if love.keyboard.isDown(key) then action(self, dt) end
  end

  -- don't let rob for into the sky
  local x1, y1, x2, y2 = self._physics_body:bbox()
  if y2 < 400 then
    self.vely = 2
  elseif y2 > g.getHeight() then
    self.vely = -2
  end

  self._physics_body:move(self.velx * 50 * dt, self.vely * 50 * dt)
end

function RobFord:render()
  g.setColor(COLORS.white:rgb())
  local x1, y1, x2, y2 = self:bbox()
  g.draw(self.image, x1, y2 - self.height)
end

function RobFord:bbox()
  return self._physics_body:bbox()
end

function RobFord:destroy()
  Collider:remove(self._physics_body)
end

function RobFord:up()
  self.vely = -2
end

function RobFord:down()
  self.vely = 2
end

function RobFord:left()
  self.velx = -2
end

function RobFord:right()
  self.velx = 2
end

function RobFord:on_collide(dt, other, mtv_x, mtv_y)
  if instanceOf(Obstacle, other) then
    print("hit " .. tostring(other))
    other:destroy()
  end
end
