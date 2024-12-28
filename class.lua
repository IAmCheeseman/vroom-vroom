local class_mt = {}

local function instance(class, ...)
  local inst = setmetatable({}, class)
  if inst.init then
    inst:init(...)
  end
  return inst
end

class_mt.__call = instance

local function newClass()
  local class = setmetatable({}, class_mt)
  class.__index = class
  return class
end

return newClass
