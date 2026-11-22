local core = require('openmw.core')
local util = require('openmw.util')
local world = require('openmw.world')
local storage = require('openmw.storage')
local settings = require('openmw.interfaces').Settings
local group = 'SettingsMonetPond'
settings.registerGroup({key=group, page='MonetPond', l10n='MonetPond', name='rain',
    permanentStorage=true, settings={{key='silt', renderer='monetPercent', name='silt', default=100}}})
local options = storage.globalSection(group)
local marker, lastPosition, lastSun
local elapsed, sediment = 0, 0

local function weatherValues(weather)
    if not weather then return 0, 0 end
    local id = weather.scriptId
    return (id == 4 or id == 5) and 1 or 0,
        (id == 0 or id == 1) and math.min(1, math.max(0, weather.glareView or 0)) or 0
end

local function update(dt)
    elapsed = elapsed + dt
    if elapsed < 0.5 then return end
    dt, elapsed = elapsed, 0
    local player = world.players[1]
    if not player or not player.cell then return end
    local cell = player.cell
    local rain, sun = weatherValues(core.weather.getCurrent(cell))
    local nextWeather = core.weather.getNext(cell)
    if nextWeather then
        local nextRain, nextSun = weatherValues(nextWeather)
        local t = core.weather.getTransition(cell) or 0
        rain, sun = rain+(nextRain-rain)*t, sun+(nextSun-sun)*t
    end
    sediment = math.max(rain, sediment-dt/180)
    if not cell.isExterior or not cell.hasWater then return end
    local hour = (core.getGameTime()/3600) % 24
    sun = sun * (0.5 - 0.5*math.cos(hour*math.pi/12))
    local fraction = sediment * (options:get('silt') or 100)/100
    local function snap(value) return math.floor(value/256+0.5)*256 end
    local z = cell.waterLevel-3072+math.floor(256*fraction+0.5)/4
    local position = util.vector3(snap(player.position.x),snap(player.position.y),z)
    sun = math.floor(512*sun+0.5)/512
    if not marker or not marker:isValid() then
        marker = world.createObject('monet_pond_state')
        lastPosition = nil
    end
    if position ~= lastPosition or sun ~= lastSun or marker.cell ~= cell then
        marker:teleport(cell, position, {rotation=util.transform.rotateZ(math.acos(sun))})
        lastPosition, lastSun = position, sun
    end
end

return {engineHandlers={onUpdate=update,
    onSave=function() return {marker=marker, sediment=sediment} end,
    onLoad=function(data)
        marker, sediment = data and data.marker, data and data.sediment or 0
        lastPosition, lastSun = nil, nil
    end}}
