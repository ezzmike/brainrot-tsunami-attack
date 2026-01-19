-- ServerScriptService: UpgradeManager.lua
-- Handles upgrading Brainrots and base

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UpgradeEvent = Instance.new("RemoteEvent")
UpgradeEvent.Name = "UpgradeEvent"
UpgradeEvent.Parent = ReplicatedStorage

local PlaceEvent = Instance.new("RemoteEvent")
PlaceEvent.Name = "PlaceEvent"
PlaceEvent.Parent = ReplicatedStorage

PlaceEvent.OnServerEvent:Connect(function(player, position)
    local playerData = require(script.Parent.PlayerManager).playerData[player.UserId]
    if #playerData.Brainrots < playerData.BaseLevel * 5 then -- slots
        table.insert(playerData.Brainrots, {Level = 1, Position = position})
        -- Spawn in world
        local brainrotModel = ReplicatedStorage:FindFirstChild("Brainrot")
        if brainrotModel then
            local clone = brainrotModel:Clone()
            clone.PrimaryPart.CFrame = CFrame.new(position)
            clone.Parent = Workspace
        end
    end
end)