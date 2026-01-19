-- ServerScriptService: UpgradeManager.lua
-- Handles upgrading Brainrots and base

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UpgradeEvent = Instance.new("RemoteEvent")
UpgradeEvent.Name = "UpgradeEvent"
UpgradeEvent.Parent = ReplicatedStorage

UpgradeEvent.OnServerEvent:Connect(function(player, upgradeType, index)
    local playerData = require(script.Parent.PlayerManager).playerData[player.UserId]
    
    if upgradeType == "Brainrot" then
        if playerData.Brainrots[index] then
            local cost = playerData.Brainrots[index].Level * 50
            if playerData.Money >= cost then
                playerData.Money = playerData.Money - cost
                playerData.Brainrots[index].Level = playerData.Brainrots[index].Level + 1
            end
        end
    elseif upgradeType == "Base" then
        local cost = playerData.BaseLevel * 250
        if playerData.Money >= cost then
            playerData.Money = playerData.Money - cost
            playerData.BaseLevel = playerData.BaseLevel + 1
        end
    end
    
    -- Update client
    local UpdateDataEvent = ReplicatedStorage:FindFirstChild("UpdateDataEvent")
    UpdateDataEvent:FireClient(player, playerData)
end)

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

UpgradeEvent.OnServerEvent:Connect(function(player, upgradeType, index)
    local playerData = require(script.Parent.PlayerManager).playerData[player.UserId]
    
    if upgradeType == "Brainrot" then
        if playerData.Brainrots[index] then
            local cost = playerData.Brainrots[index].Level * 50
            if playerData.Money >= cost then
                playerData.Money = playerData.Money - cost
                playerData.Brainrots[index].Level = playerData.Brainrots[index].Level + 1
            end
        end
    elseif upgradeType == "Base" then
        local cost = playerData.BaseLevel * 250
        if playerData.Money >= cost then
            playerData.Money = playerData.Money - cost
            playerData.BaseLevel = playerData.BaseLevel + 1
        end
    end
    
    -- Update client
    local UpdateDataEvent = ReplicatedStorage:FindFirstChild("UpdateDataEvent")
    UpdateDataEvent:FireClient(player, playerData)
end)