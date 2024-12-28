Vehicle = class()

function Vehicle:init()
  self.sprite = StackedSprite("awd_sport.png", 10)
  local width, height = viewport.screenw, viewport.screenh
  self.throttle = 0

  self.drivetrain = Drivetrain({
    wheelbase = 21,
    layout = "fwd"
  })
  self.drivetrain:moveTo(width / 2, height / 2, 0)
end

function Vehicle:update(dt)
  self.drivetrain:move(dt)

  local x, y = self.drivetrain:getCenter()
  viewport.camx = x - viewport.screenw / 2
  viewport.camy = y - viewport.screenh / 2
end

function Vehicle:draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", 0, 0, 100, 100)

  local x, y = self.drivetrain:getCenter()
  local r = self.drivetrain:getRotation() + math.pi / 2
  local velx, vely = self.drivetrain:getVelocity()
  self.sprite.skewx = -(velx / 150) * 0.25
  self.sprite.skewy = -(vely / 150) * 0.25
  self.sprite:draw(x, y, r)

  love.graphics.setColor(1, 0, 0)
  love.graphics.circle(
    "fill",
    self.drivetrain.rear.x,
    self.drivetrain.rear.y, 2)
  love.graphics.setColor(0, 1, 0)
  love.graphics.circle(
    "fill",
    self.drivetrain.front.x,
    self.drivetrain.front.y, 2)
end

function Vehicle:gui()
  love.graphics.setColor(1, 1, 1)

  local velx, vely = self.drivetrain:getVelocity()
  local speed = math.floor(vec.len(velx, vely) / 20 * 2.75)
  love.graphics.print(("%d KM/H"):format(speed), 10, 10)
  love.graphics.print(("%d MPH"):format(speed * 0.6213712), 10, 30)
end
