-- Helper assignments and erata
g = love.graphics
GRAVITY = 700
math.tau = math.pi * 2

function math.round(n, deci) deci = 10^(deci or 0) return math.floor(n*deci+.5)/deci end
function math.clamp(low, n, high) return math.min(math.max(low, n), high) end
function pointInCircle(circle, point) return (point.x-circle.x)^2 + (point.y - circle.y)^2 < circle.radius^2 end
function string:split(sep) return self:match((self:gsub("[^"..sep.."]*"..sep, "([^"..sep.."]*)"..sep))) end
globalID = 0
function generateID() globalID = globalID + 1 return globalID end
function is_func(f) return type(f) == "function" end
function is_num(n) return type(n) == "number" end
function is_string(s) return type(s) == "string" end

-- Put any game-wide requirements in here
require 'lib/middleclass'
Stateful = require 'lib/stateful'
skiplist = require "lib/skiplist"
HC = require 'lib/HardonCollider'
inspect = require 'lib/inspect'
require 'lib/AnAL'
cron = require 'lib/cron'
COLORS = require 'lib/colors'
tween = require 'lib/tween'
beholder = require 'lib/beholder'

YSortable = require 'mixins/y_sortable'

Base = require 'base'
Game = require 'game'
Runner = require 'runner'
Platform = require 'platform'
MovableSprite = require 'moving_sprite'
Obstacle = require 'obstacle'
RobFord = require 'rob_ford'

local function require_all(directory)
  local lfs = love.filesystem
  for index,filename in ipairs(lfs.getDirectoryItems(directory)) do
    local file = directory .. "/" .. filename
    if lfs.isFile(file) and file:match("%.lua$") then
      require(file:gsub("%.lua", ""))
    elseif lfs.isDirectory(file) then
      require_all(file)
    end
  end
end
require_all("states")
