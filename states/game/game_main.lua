local Main = Game:addState('Main')

function Main:enteredState()
  Collider = HC(100, self.on_start_collide, self.on_stop_collide)

  local image = self.preloaded_image["Cheesy_background.png"]
  local scale = g.getHeight() / image:getHeight()
  local msprite = MovableSprite:new(0, 0, image, scale, -100, 0, 0, true)

  local buildings = {"Grey_bldg.png", "Brown_bldg.png", "Beige_bldg.png", "Pink_bldg.png", "Green_bldg.png"}
  local bspeeds = {-50, -60, -75, -90, -100}
  for i,building_image_name in ipairs(buildings) do
    cron.every(1, function()
      if math.random() > 0.85 then
        local sprite = MovableSprite:new(g.getWidth(), 0, self.preloaded_image[building_image_name], 1, bspeeds[i], 0, #buildings - i + 5)
        sprite.y = 400 - sprite.height
      end
    end)
  end

  self.render_queue = {}

  cron.every(2.2, function()
    local w, h = 100, 100
    local new_obstacle = Obstacle:new(g.getWidth(), math.random(400, g.getHeight()), w, h, -100, 0)
    table.insert(self.render_queue, new_obstacle)
  end)

  self.rob_ford = RobFord:new(100, g.getHeight() - 300)
  table.insert(self.render_queue, self.rob_ford)
end

function Main:update(dt)
  Collider:update(dt)

  for _,msprite in MovableSprite.instances:ipairs() do
    msprite:update(dt)
  end

  for _,obstacle in pairs(Obstacle.instances) do
    obstacle:update(dt)
  end

  table.sort(self.render_queue, function(a, b)
    local ax1, ay1, ax2, ay2 = a:bbox()
    local bx1, by1, bx2, by2 = b:bbox()
    return ay2 < by2
  end)

  self.rob_ford:update(dt)
end

function Main:render()
  self.camera:set()

  g.setColor(COLORS.white:rgb())
  for _,msprite in MovableSprite.instances:ipairs() do
    msprite:render()
  end

  for _, obj in ipairs(self.render_queue) do
    obj:render()
  end

  -- local count = 0
  -- g.setColor(COLORS.blue:rgb())
  -- for k,v in pairs(Collider._active_shapes) do
  --   v:draw("line")
  --   count = count + 1
  -- end
  -- -- print(count)

  -- count = 0
  -- g.setColor(COLORS.pink:rgb())
  -- for k,v in pairs(Collider._ghost_shapes) do
  --   v:draw("line")
  --   count = count + 1
  -- end
  -- print(count)

  self.camera:unset()
end

function Main:mousepressed(x, y, button)
  -- print(x,y)
end

function Main:mousereleased(x, y, button)
end

function Main:keypressed(key, unicode)
  if key == " " then
    self.rob_ford:punch()
  end
end

function Main:keyreleased(key, unicode)
end

function Main:joystickpressed(joystick, button)
end

function Main:joystickreleased(joystick, button)
end

function Main:focus(has_focus)
end

-- shape_one and shape_two are the colliding shapes. mtv_x and mtv_y define the minimum translation vector,
-- i.e. the direction and magnitude shape_one has to be moved so that the collision will be resolved.
-- Note that if one of the shapes is a point shape, the translation vector will be invalid.
function Main.on_start_collide(dt, shape_one, shape_two, mtv_x, mtv_y)
  local object_one, object_two = shape_one.parent, shape_two.parent

  if object_one and is_func(object_one.on_collide) then
    object_one:on_collide(dt, object_two, mtv_x, mtv_y)
  end

  if object_two and is_func(object_two.on_collide) then
    object_two:on_collide(dt, object_one, -mtv_x, -mtv_y)
  end
end

function Main.on_stop_collide(dt, shape_one, shape_two)
end

function Main:exitedState()
  Collider:clear()
  Collider = nil
  cron.reset()
end

return Main
