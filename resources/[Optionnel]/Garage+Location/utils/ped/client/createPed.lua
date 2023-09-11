---createPed
---@param coords table vector 3
---@param heading number
---@param pedName string
---@param isNetwork boolean
---@param hotePed boolean
---@public
function QDC:createPed(coords, heading, pedName, isNetwork, hotePed)
    if coords and heading and pedName and isNetwork and hotePed then
        local model = GetHashKey(pedName)
        while not HasModelLoaded(model) do RequestModel(model) Wait(10) end
        local ped = CreatePed(pedName, pedName, coords, heading, isNetwork, hotePed)
        return ped
    end
end