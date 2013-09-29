local Menu = Game:addState('Menu')

function Menu:enteredState()
  self.background_image = game.preloaded_image["Intro_Screen.png"]
  self.scale = g.getHeight() / self.background_image:getHeight()
end

function Menu:render()
  g.setColor(COLORS.white:rgb())
  g.draw(self.background_image, 0, 0, 0, self.scale)
end

function Menu:keypressed(key, unicode)
  if key == "return" then
    self:gotoState("Main")
  end
end

function Menu:mousepressed(x, y, button)
  print(x,y)
end

function Menu:exitedState()
  self.background_image = nil
end

return Menu
