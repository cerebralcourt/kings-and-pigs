local anim8 = require "lib.anim8"

return function()
  local livebar

  local barimage = love.graphics.newImage("assets/sprites/livebar.png")
  local livesimage = love.graphics.newImage("assets/sprites/lives.png")
  local g = anim8.newGrid(18, 14, livesimage:getWidth(), livesimage:getHeight())
  local heart = anim8.newAnimation(g("1-8", 1), 0.1)
  local hearthit = {
    anim = anim8.newAnimation(g("1-2", 2), 0.1, function() livebar.hearthit.pos = 0 end),
    pos = 0,
  }
  local diamond = anim8.newAnimation(g("1-8", 3), 0.1)

  livebar = {
    barimage = barimage,
    livesimage = livesimage,
    heart = heart,
    hearthit = hearthit,
    diamond = diamond,
    lives = 3,
  }

  function livebar:update(dt)
  	self.heart:update(dt)
    self.diamond:update(dt)

    if self.hearthit.pos > 0 then
      self.hearthit.anim:update(dt)
    end
  end

  function livebar:draw()
    local scale = 2

  	love.graphics.draw(self.barimage, 0, 0, 0, scale, scale)

    if self.lives >= 1 then
      self.heart:draw(self.livesimage, 22, 19, 0, scale, scale)
    end
    if self.lives >= 2 then
      self.heart:draw(self.livesimage, 43, 19, 0, scale, scale)
    end
    if self.lives >= 3 then
      self.heart:draw(self.livesimage, 65, 19, 0, scale, scale)
    end

    if self.hearthit.pos == 1 then
      self.hearthit.anim:draw(self.livesimage, 22, 18, 0, scale, scale)
    elseif self.hearthit.pos == 2 then
      self.hearthit.anim:draw(self.livesimage, 43, 18, 0, scale, scale)
    elseif self.hearthit.pos == 3 then
      self.hearthit.anim:draw(self.livesimage, 65, 18, 0, scale, scale)
    end
  end

  function livebar:hit()
    self.hearthit.pos = self.lives
  	self.lives = self.lives - 1
  end

  return livebar
end
