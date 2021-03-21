local baton = require "lib.baton"
local anim8 = require "lib.anim8"

local input = baton.new {
  controls = {
    left = {"key:left", "key:a", "axis:leftx-", "button:dpleft"},
    right = {"key:right", "key:d", "axis:leftx+", "button:dpright"},
    jump = {"key:up", "key:w", "key:space", "axis:lefty-", "button:dpup", "button:a"},
    attack = {"key:down", "key:s", "axis:lefty+", "button:dpdown", "button:x", "mouse:1"},
  },
  joystick = love.joystick.getJoysticks()[1],
}

return function(world, entry)
  local width = 26
  local height = 26
  local spritewidth = 78
  local spriteheight = 58
  local x = entry.x + entry.width / 2 - width / 2
  local y = entry.y + entry.height - height / 2

  local body = love.physics.newBody(world, x, y, "dynamic")
  local shape = love.physics.newRectangleShape(width, height)
  local fixture = love.physics.newFixture(body, shape)
  fixture:setFriction(0)

  local image = love.graphics.newImage("assets/sprites/king-human.png")
  local g = anim8.newGrid(spritewidth, spriteheight, image:getWidth(), image:getHeight())
  local anims = {
    idle = anim8.newAnimation(g("1-11", 1), 0.1),
    run = anim8.newAnimation(g("1-8", 2), 0.1),
    jump = anim8.newAnimation(g(1, 3), 0.1),
    fall = anim8.newAnimation(g(1, 4), 0.1),
  }
  local anim = anims.idle

  local player = {
    width = width,
    height = height,
    spritewidth = spritewidth,
    spriteheight = spriteheight,
    body = body,
    shape = shape,
    fixture = fixture,
    jumping = false,
    image = image,
    anims = anims,
    anim = anim,
    dir = 1,
  }

  function player:update(dt)
    input:update()

    local dx, dy = player.body:getLinearVelocity()

    if input:down("left") then
      dx = -64
    elseif input:down("right") then
      dx = 64
    else
      dx = 0
      if not player.jumping and (input:released("left") or input:released("right")) then
        player.anim = player.anims.idle
      end
    end

    if input:pressed("left") then
      player.dir = -1
      if not player.jumping then
        player.anim = player.anims.run
      end
    elseif input:pressed("right") then
      player.dir = 1
      if not player.jumping then
        player.anim = player.anims.run
      end
    end

    if player.jumping then
      if dy < 0 then
        player.anim = player.anims.jump
      elseif dy > 0 then
        player.anim = player.anims.fall
      end
    elseif input:down("jump") then
      dy = -150
      player.jumping = true
    end

    player.body:setLinearVelocity(dx, dy)

    player.anim:update(dt)
  end

  function player:draw()
    local x = player.body:getX() - player.width / 2 - 3.5
    local y = player.body:getY() - player.height / 2 - 1

    if player.dir == -1 then
      x = x + player.spritewidth - player.width / 2
    end

    player.anim:draw(player.image, x, y, 0, player.dir, 1)
  end

  return player
end
