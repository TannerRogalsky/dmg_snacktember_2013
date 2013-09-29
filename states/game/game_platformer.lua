local Platformer = Game:addState('Platformer')

function Platformer:enteredState()
  Collider = HC(100, self.on_start_collide, self.on_stop_collide)
  self.runner = Runner:new(100, 100)
  function self.runner:render()
    local x, y = self._physics_body:center()
    g.setColor(COLORS.red:rgb())
    g.circle("fill", x, y, 20)
  end

  self.deadzone = Collider:addRectangle(0, g.getHeight() + 100, g.getWidth(), 100)
  self.deadzone.parent = {deadzone = true}

  self.platforms = {}
  local x = 0
  for i=1,6 do
    local width = 250
    table.insert(self.platforms, Platform:new(x, math.random(300, 400), width))
    -- table.insert(self.platforms, new_platform)
    x = x + width + 100
  end
  function self:spawn_platform()
    local new_platform = Platform.make_next_platform(self.platforms[#self.platforms])
    table.insert(self.platforms, new_platform)

    self.platforms[1]:destroy()
    table.remove(self.platforms, 1)
  end

  cron.every(2, function()
    self.runner.vel_x = self.runner.vel_x * 1.1
    self.runner.vel_x = math.clamp(1, self.runner.vel_x, 3)
  end)
end

function Platformer:update(dt)
  Collider:update(dt)
  for _,runner in pairs(Runner.instances) do
    runner:update(dt)
  end

  local rx, ry = self.runner:center()
  self.camera:setPosition(rx - g.getWidth() / 2, 0)
  local dx, dy = self.deadzone:center()
  self.deadzone:moveTo(self.camera.x, dy)

  local platform = self.platforms[1]
  local x1, y1, x2, y2 = platform:bbox()
  if x2 < self.camera.x then
    self:spawn_platform()
  end
end

function Platformer:render()
  self.camera:set()

  for _,runner in pairs(Runner.instances) do
    runner:render()
  end

  local count = 0
  g.setColor(COLORS.blue:rgb())
  for k,v in pairs(Collider._active_shapes) do
    v:draw("line")
    count = count + 1
  end

  self.camera:unset()
end

function Platformer:mousepressed(x, y, button)
end

function Platformer:mousereleased(x, y, button)
end

function Platformer:keypressed(key, unicode)
  for _,runner in pairs(Runner.instances) do
    runner:jump()
  end
end

function Platformer:keyreleased(key, unicode)
end

function Platformer:joystickpressed(joystick, button)
end

function Platformer:joystickreleased(joystick, button)
end

function Platformer:focus(has_focus)
end

-- shape_one and shape_two are the colliding shapes. mtv_x and mtv_y define the minimum translation vector,
-- i.e. the direction and magnitude shape_one has to be moved so that the collision will be resolved.
-- Note that if one of the shapes is a point shape, the translation vector will be invalid.
function Platformer.on_start_collide(dt, shape_one, shape_two, mtv_x, mtv_y)
  local object_one, object_two = shape_one.parent, shape_two.parent

  if object_one and is_func(object_one.on_collide) then
    object_one:on_collide(dt, object_two, mtv_x, mtv_y)
  end

  if object_two and is_func(object_two.on_collide) then
    object_two:on_collide(dt, object_one, -mtv_x, -mtv_y)
  end
end

function Platformer.on_stop_collide(dt, shape_one, shape_two)
end

function Platformer:exitedState()
  Collider:clear()
  Collider = nil
end

return Platformer
