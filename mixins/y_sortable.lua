local YSortable = {}

function YSortable:__lt(other)
  if self.y < other.y then return true
  elseif self.y == other.y and self.id < other.id then return true
  else return false
  end
end

function YSortable:__le(other)
  return self < other
end

return YSortable
