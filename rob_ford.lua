RobFord = class('RobFord', Base)

local points = {}

function RobFord:initialize(x, y)
  Base.initialize(self)

  self.image = game.preloaded_image["rob_ford_anim.png"]
  self.anim = newAnimation(self.image, 134, 184, 0.2, 4)

  self.width, self.height = 134, 184

  self._physics_body = Collider:addRectangle(x, y, self.width / 3 * 2, self.height / 4)
  self._physics_body.parent = self

  self.keyboard_update = {
    up = self.up,
    down = self.down,
    left = self.left,
    right = self.right
  }

  self.velx, self.vely = 0, 0
end

function RobFord:update(dt)
  self.anim:update(dt)
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
  -- if self.vely ~= 0 then
  --   game.render_queue:delete(self)
  --   game.render_queue:insert(self)
  -- end
end

function RobFord:render()
  g.setColor(COLORS.white:rgb())
  local x1, y1, x2, y2 = self:bbox()
  -- g.draw(self.image, x1, y2 - self.height)
  self.anim:draw(x1, y2 - self.height)

  g.setColor(COLORS.red:rgb())
  for _,point in ipairs(points) do
    g.circle("fill", point[1], point[2], 5)
  end
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

function RobFord:punch()
  local x, y = self._physics_body:center()
  y =  y - self.height / 2
  x = x + self.width
  local connected = Collider:shapesAt(x, y)[1]
  if connected then connected = connected.parent end

  if connected ~= nil and connected.image_name == "Paparazzi.png" then
    local old_render = self.render
    local punch_img = game.preloaded_image["Rob_Ford_punching copy.png"]
    function self:render()
      g.setColor(COLORS.white:rgb())
      local x1, y1, x2, y2 = self:bbox()
      g.draw(punch_img, x1, y2 - self.height)
    end
    cron.after(0.5, function() self.render = old_render end)
    connected:destroy()
  end
  -- print(connected)
  -- table.insert(points, {x, y})
end

function RobFord:on_collide(dt, other, mtv_x, mtv_y)
  if instanceOf(Obstacle, other) then
    if other.image_name == "KFC_bucket.png" then
      other:destroy()
    else
      other:destroy()
      game:gotoState("Over")
    end
  end
end

RobFord.__lt = Obstacle.__lt
RobFord.__le = Obstacle.__le

return RobFord
