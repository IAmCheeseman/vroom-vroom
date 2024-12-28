StackedSprite = class()

function StackedSprite:init(path, layer_count)
  self.image = love.graphics.newImage(path)
  self.layer_count = layer_count
  self.layer_height = 1
  self.width = self.image:getWidth() / self.layer_count
  self.height = self.image:getHeight()
  self.offsetx = math.floor(self.width / 2)
  self.offsety = math.floor(self.height / 2)
  self.skewx = 0
  self.skewy = 0
end

function StackedSprite:draw(x, y, r)
  local image_width, image_height = self.image:getDimensions()
  for i=0,self.layer_count - 1 do
    local qx = i * self.width
    local quad = love.graphics.newQuad(
      qx, 0,
      self.width, self.height,
      image_width, image_height)

    local dx = x
    local dy = y - i * self.layer_height

    dx = dx + self.skewx * i
    dy = dy + self.skewy * i

    love.graphics.draw(
        self.image, quad,
        dx, dy, r,
        1, 1,
        self.offsetx, self.offsety)
  end
end
