Axle = class()

local surface_friction = 4.6

function Axle:init(x, y)
  self.x = x
  self.y = y
  self.accelx = 0
  self.accely = 0
  self.velx = 0
  self.vely = 0
  self.brake_power = 500
  self.tiyre_friction = 0.8
  self.r = 0
  self.steering = 0
end

function Axle:applyForce(force)
  self.accelx = self.accelx + math.cos(self.r) * force
  self.accely = self.accely + math.sin(self.r) * force
end

function Axle:applyBrakes(depressed)
  depressed = depressed or 1
  depressed = mathx.clamp(depressed^2, 0, 1)
  self.accelx = self.accelx - math.cos(self.r) * self.brake_power * depressed
  self.accely = self.accely - math.sin(self.r) * self.brake_power * depressed
end

function Axle:setSteering(steering)
  self.steering = steering
end

function Axle:update(dt)
  local frictx = self.velx * -(surface_friction * self.tiyre_friction)
  local fricty = self.vely * -(surface_friction * self.tiyre_friction)

  frictx, fricty = vec.rotate(frictx, fricty, -self.steering)

  self.accelx = self.accelx + frictx
  self.accely = self.accely + fricty

  self.velx = self.velx + self.accelx * dt
  self.vely = self.vely + self.accely * dt

  self.x = self.x + self.velx * dt
  self.y = self.y + self.vely * dt

  self.accelx = 0
  self.accely = 0
end
