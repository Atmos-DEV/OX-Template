---createBlip
---@param coords table vector3
---@param color number
---@param scale number
---@param name string
---@public
local currentBlips = {}
function QDC:createBlip(coords, sprite, color, scale, name)
    if coords and sprite and color and scale and name then
        if not currentBlips[coords] then
            local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
            SetBlipSprite (blip, sprite)
            SetBlipDisplay(blip, 4)
            SetBlipColour (blip, color)
            SetBlipScale  (blip, scale)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(name)
            EndTextCommandSetBlipName(blip)
            currentBlips[coords] = true
            return blip
        end
    end
end