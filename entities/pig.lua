local anim8 = require "lib.anim8"

return function(world, player, obj)
  local pig
  local width = 16
  local height = 16
  local spritewidth = 34
  local spriteheight = 28
  local x = obj.x - width / 2
  local y = obj.y - height / 2

  local body = love.physics.newBody(world, x, y, "dynamic")
  local shape = love.physics.newRectangleShape(width, height)
  local fixture = love.physics.newFixture(body, shape)
  fixture:setFriction(0)
  fixture:setCategory(3)
  fixture:setMask(3)

  local image = love.graphics.newImage("assets/sprites/pig.png")
  local g = anim8.newGrid(spritewidth, spriteheight, image:getWidth(), image:getHeight())
  local anims = {
    normal = {
      idle = anim8.newAnimation(g("1-11", 1), 0.1),
      run = anim8.newAnimation(g("1-6", 2), 0.1),
      jump = anim8.newAnimation(g(1, 3), 0.1),
      fall = anim8.newAnimation(g(1, 4), 0.1),
      ground = anim8.newAnimation(g(1, 5), 0.1),
      attack = anim8.newAnimation(g("1-5", 6), 0.1,
        function()
          pig.attacking = false
        end),
      hit = anim8.newAnimation(g("1-2", 7), 0.1),
      dead = anim8.newAnimation(g("1-4", 8), 0.1),
    },
  }
  local type_ = obj.type
  local anim = anims.normal.idle

  pig = {
    width = width,
    height = height,
    spritewidth = spritewidth,
    spriteheight = spriteheight,
    body = body,
    shape = shape,
    fixture = fixture,
    image = image,
    anims = anims,
    type = type_,
    anim = anim,
    dir = -1,
    attacking = false,
  }

  function pig:update(dt)
    local dx, dy = self.body:getLinearVelocity()
  	local pdx, pdy = player.body:getLinearVelocity()
  	local xdist = player.body:getX() - self.body:getX()
  	local ydist = player.body:getY() - self.body:getY()

  	if self.type == "normal" and not self.attacking then
      if math.abs(xdist) < 24 and math.abs(ydist) < 10 then
        self.anim = self.anims.normal.attack
        self.anim:gotoFrame(1)
        self.attacking = true
        dx = 0
        dy = 0
  	  elseif math.abs(pdy) < 0.1 and math.abs(xdist) < 128 and math.abs(ydist) < 10 then
        if self.anim ~= self.anims.normal.run then self.anim:gotoFrame(1) end
  	  	self.anim = self.anims.normal.run
        if xdist < 0 then
          self.dir = -1
        else
          self.dir = 1
        end
        dx = self.dir * 50
  	  else
        if self.anim ~= self.anims.normal.idle then self.anim:gotoFrame(1) end
        self.anim = self.anims.normal.idle
        dx = 0
      end
  	end

    self.body:setLinearVelocity(dx, dy)
  	self.anim:update(dt)
  end

  function pig:draw()
  	local x = self.body:getX() - self.width / 2 + 5
    local y = self.body:getY() - self.height / 2 + 5

    if self.dir == 1 then
      x = x + self.spritewidth + 5
    end

  	self.anim:draw(self.image, x, y, 0, -self.dir, 1)
  end

  return pig
end
