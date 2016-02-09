local Loading = Game:addState('Loading')

function Loading:enteredState()
  self.preloaded_image = {}

  -- puts loaded images into the preloaded_image hash with they key being the file name
  for index, image in ipairs(love.filesystem.getDirectoryItems('images')) do
    if image:match('(.*).png$') ~= nil or image:match('(.*).gif$') ~= nil or image:match('(.*).jpg$') ~= nil then
      self.preloaded_image[image] = g.newImage('images/' .. image)
    end
  end

  self:gotoState("Menu")
end

function Loading:update(dt)
end

function Loading:exitedState()
end

return Loading
