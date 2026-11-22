local async = require('openmw.async')
local ui = require('openmw.ui')
local util = require('openmw.util')
local settings = require('openmw.interfaces').Settings

settings.registerPage({key='MonetPond', l10n='MonetPond', name='page', description='description'})
settings.registerRenderer('monetPercent', function(value, set)
    local width = 200
    local change = async:callback(function(event)
        if event.button == 1 then
            set(math.max(0, math.min(100, math.floor(event.offset.x * 100 / width + 0.5))))
        end
    end)
    local white = ui.texture{path='white'}
    local function bar(x, y, w, h, color)
        return {type=ui.TYPE.Image, props={position=util.vector2(x,y), size=util.vector2(w,h),
            resource=white, color=color, inheritAlpha=true}}
    end
    return {type=ui.TYPE.Widget, props={size=util.vector2(width+60,24)}, content=ui.content{
        bar(0,10,width,3,util.color.rgb(.35,.32,.25)),
        bar(value*1.96,4,4,15,util.color.rgb(.90,.76,.50)),
        {type=ui.TYPE.Text, props={position=util.vector2(width+8,1), size=util.vector2(52,22), text=value..'%'}},
        {type=ui.TYPE.Widget, props={size=util.vector2(width,24)}, events={mousePress=change, mouseMove=change}},
    }}
end)
