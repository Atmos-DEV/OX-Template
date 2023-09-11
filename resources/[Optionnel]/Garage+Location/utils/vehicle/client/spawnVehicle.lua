---spawnVehicle
---@param modelName string
---@param coords table vector3
---@param heading number
---@param clientSpawn boolean
---@return void
function QDC:spawnVehicle(modelName, coords, heading, clientSpawn, spawnInto)
    local model = GetHashKey(modelName)
    if not IsModelInCdimage(model) then
        return
    end
    RequestModel(model) while
    not HasModelLoaded(model) do
        Wait(1)
    end
    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, not clientSpawn, 0)
    SetVehicleDirtLevel(vehicle, 0.0)
    SetEntityCoordsNoOffset(vehicle, coords.x, coords.y, coords.z + 0.5, 0.0, 0.0, 0.0)
    SetVehicleOnGroundProperly(vehicle)
    SetEntityHeading(vehicle, heading)
    SetEntityAsMissionEntity(vehicle, 1, 1)
    if spawnInto then
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    end
    return vehicle
end