mathx = {}

function mathx.lerp(a, b, t)
  return (b - a) * t + a
end

function mathx.dtLerp(a, b, t, dt)
  return mathx.lerp(b, a, 0.5^(t * dt))
end

function mathx.clamp(a, min, max)
  return math.min(max, math.max(min, a))
end
