local Over = Game:addState('Over')

function Over:enteredState()
  self.background_image = game.preloaded_image["Game_Over.png"]
  self.background_image:setWrap("repeat", "repeat")
  self.scale = g.getHeight() / self.background_image:getHeight()
end

function Over:render()
  g.setColor(COLORS.white:rgb())
  g.draw(self.background_image, 0, 0, 0, self.scale)
end

function Over:keypressed(key, unicode)
  if key == "return" then
    self:gotoState("Menu")
  end
end

function Over:mousepressed(x, y, button)
  print(x,y)
end

function Over:exitedState()
  self.background_image = nil
end

return Over
