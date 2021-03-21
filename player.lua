local baton = require "lib.baton"

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
  local size = 32
  local x = entry.x + entry.width / 2 - size / 2
  local y = entry.y + entry.height - size / 2

  local body = love.physics.newBody(world, x, y, "dynamic")
  local shape = love.physics.newRectangleShape(size, size)
  local fixture = love.physics.newFixture(body, shape)
  fixture:setFriction(0)

  local player = {
    width = size,
    height = size,
    body = body,
    shape = shape,
    fixture = fixture,
    jumping = false,
  }

  function player:update()
    input:update()

    local dx, dy = player.body:getLinearVelocity()

    if input:down("left") then
      dx = -64
    elseif input:down("right") then
      dx = 64
    else
      dx = 0
    end

    if not player.jumping and input:down("jump") then
      dy = -150
      player.jumping = true
    end

    player.body:setLinearVelocity(dx, dy)
  end

  function player:draw()
    love.graphics.rectangle("fill", player.body:getX(), player.body:getY(), player.width, player.height)
  end

  return player
end
