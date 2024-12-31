Drivetrain = class()

local js = love.joystick.getJoysticks()[1]

function Drivetrain:init(params)
  self.wheelbase = params.wheelbase
  self.tire_friction = 0.8

  self.x = 0
  self.y = 0

  self.layout = params.layout

  self.front = Axle(self.x + self.wheelbase / 2, self.y)
  self.rear = Axle(self.x - self.wheelbase / 2, self.y)
end

function Drivetrain:move(dt)
  local accel_power = 1000

  local steering = 0
  if love.keyboard.isDown("a") then
    steering = steering - 1
  end
  if love.keyboard.isDown("d") then
    steering = steering + 1
  end

  if steering == 0 and js then
    steering = js:getGamepadAxis("leftx")
  end

  local velx, vely = self:getVelocity()
  local speed = vec.len(velx, vely)

  local steering_coeff = math.max(1 - (speed / 400) ^ 2, 0.2)
  steering = steering * math.rad(20) * steering_coeff

  self.front:setSteering(steering)

  local power = accel_power
  if love.keyboard.isDown("w") then
    self.rear:applyForce(power)
    self.front:applyForce(power)
  else
    power = accel_power * ((js and js:getGamepadAxis("triggerright")) or 0)
    self.rear:applyForce(power)
    self.front:applyForce(power)
  end
  if love.keyboard.isDown("s") or (js and (js:getGamepadAxis("triggerleft") ~= 0)) then
    self.rear:applyBrakes()
    self.front:applyBrakes()
  end

  if js then
    local vibration_speed = vec.len(self:getVelocity()) / 350
    vibration_speed = vibration_speed + (power / accel_power) * 0.1
    vibration_speed = vibration_speed + 0.05
    vibration_speed = mathx.clamp(vibration_speed, 0, 1)
    js:setVibration(vibration_speed, vibration_speed)
  end

  self.rear:update(dt)
  self.front:update(dt)

  local distance = vec.distance(
    self.rear.x, self.rear.y,
    self.front.x, self.front.y)

  if distance > self.wheelbase or distance < self.wheelbase then
    local centerx = (self.rear.x + self.front.x) / 2
    local centery = (self.rear.y + self.front.y) / 2

    local dirx, diry = vec.direction(
      self.rear.x, self.rear.y,
      self.front.x, self.front.y)

    local radius = self.wheelbase / 2

    self.rear.x = centerx - dirx * radius
    self.rear.y = centery - diry * radius
    self.front.x = centerx + dirx * radius
    self.front.y = centery + diry * radius
  end

  local angle = vec.angleBetween(
    self.rear.x, self.rear.y,
    self.front.x, self.front.y)
  self.rear.r = angle
  self.front.r = angle
end

function Drivetrain:moveTo(x, y, r)
  local radius = self.wheelbase / 2
  self.front.x = x + math.cos(r) * radius
  self.front.y = y + math.sin(r) * radius

  self.rear.x = x - math.cos(r) * radius
  self.rear.y = y - math.sin(r) * radius

  self.x = x
  self.y = y
  self.r = r
end

function Drivetrain:getCenter()
  return (self.rear.x + self.front.x) / 2, (self.rear.y + self.front.y) / 2
end

function Drivetrain:getRotation()
  return vec.angleBetween(
    self.rear.x, self.rear.y,
    self.front.x, self.front.y)
end

function Drivetrain:getVelocity()
  local avgx = (self.rear.velx + self.front.velx) / 2
  local avgy = (self.rear.vely + self.front.vely) / 2
  return avgx, avgy
end
