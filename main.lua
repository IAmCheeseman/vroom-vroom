love.graphics.setDefaultFilter("nearest", "nearest")

class = require("class")
require("viewport")
require("mathx")
require("vec")
require("stacked_sprite")
require("axle")
require("drivetrain")
require("vehicle")

local vehicle = Vehicle()

function love.update(dt)
  vehicle:update(dt)
end

function love.draw()
  viewport.apply()
    love.graphics.clear(0.2, 0.2, 0.2)
    love.graphics.setColor(1, 1, 1)
    vehicle:draw()
  viewport.stop()

  viewport.applyGui()
    love.graphics.clear(0, 0, 0, 0)
    love.graphics.setColor(1, 1, 1)
    vehicle:gui()
  viewport.stopGui()

  love.graphics.setColor(1, 1, 1)
  viewport.draw()
end
