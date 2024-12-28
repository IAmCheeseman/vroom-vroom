viewport = {
  camx = 0,
  camy = 0,
  pointerx = 0,
  pointery = 0,
  real_pointer_x = 0,
  real_pointer_y = 0,
  screenw = 352,
  screenh = 288,
}

local canvas = love.graphics.newCanvas(viewport.screenw + 1, viewport.screenh + 1)
local guic = love.graphics.newCanvas(viewport.screenw, viewport.screenh)

function getWorldMousePosition()
  local scale, x, y = viewport.getDrawTranslation()
  local mx, my = love.mouse.getPosition()
  local camx, camy = viewport.camx, viewport.camy

  mx = mx - x
  my = my - y

  mx = math.floor(camx + mx / scale)
  my = math.floor(camy + my / scale)

  return mx, my
end

function getMousePosition()
  local scale, x, y = viewport.getDrawTranslation()
  local mx, my = love.mouse.getPosition()

  mx = mx - x
  my = my - y

  mx = math.floor(mx / scale)
  my = math.floor(my / scale)

  return mx, my
end

function setPointerPosition(x, y)
  viewport.pointerx = x
  viewport.pointery = y
end

function setRealPointerPosition(x, y)
  viewport.real_pointer_x = x
  viewport.real_pointer_y = y
end

function getPointerPosition()
  return viewport.pointerx, viewport.pointery
end

function getScreenPointerPosition()
  local sx = viewport.pointerx - viewport.camx
  local sy = viewport.pointery - viewport.camy
  return sx, sy
end

function getRealPointerPosition()
  return viewport.real_pointer_x, viewport.real_pointer_y
end

function getRealScreenPointerPosition()
  local sx = viewport.real_pointer_x - viewport.camx
  local sy = viewport.real_pointer_y - viewport.camy
  return sx, sy
end

function viewport.getDrawTranslation()
  local ww, wh = love.graphics.getDimensions()

  local scale = math.min(ww / viewport.screenw, wh / viewport.screenh)
  local x = (ww - viewport.screenw * scale) / 2
  local y = (wh - viewport.screenh * scale) / 2
  return scale, x, y
end

function viewport.getCamBounds()
  local x, y = viewport.camx, viewport.camy
  local w, h = viewport.screenw, viewport.screenh
  return x, y, w, h
end

function viewport.isRectOnScreen(x, y, w, h)
  local camx, camy = -viewport.camx, -viewport.camy

  -- 1|   2|   1|   2|
  return
        x + w > -camx
    and y + h > -camy
    and -camx + viewport.screenw > x
    and -camy + viewport.screenh > y
end

function viewport.isPointOnScreen(x, y)
  return viewport.isRectOnScreen(x, y, 0, 0)
end

function viewport.apply()
  love.graphics.setCanvas(canvas)
  love.graphics.push()
  love.graphics.translate(-math.floor(viewport.camx), -math.floor(viewport.camy))
end

function viewport.stop()
  love.graphics.pop()
  love.graphics.setCanvas()
end

function viewport.applyGui()
  love.graphics.setCanvas(guic)
  love.graphics.clear(0, 0, 0, 0)
end

function viewport.stopGui()
  love.graphics.setCanvas()
end

function viewport.draw()
  local scale, x, y = viewport.getDrawTranslation()
  local _, fx = math.modf(viewport.camx)
  local _, fy = math.modf(viewport.camy)
  local q = love.graphics.newQuad(
    fx, fy, viewport.screenw, viewport.screenh,
    viewport.screenw + 1, viewport.screenh + 1)
  love.graphics.draw(canvas, q, x, y, 0, scale)
  love.graphics.draw(guic, x, y, 0, scale)
end

return viewport
