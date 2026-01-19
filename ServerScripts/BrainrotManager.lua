-- ServerScriptService: BrainrotManager.lua
-- Manages Brainrot spawning and collection

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local CollectBrainrotEvent = ReplicatedStorage:FindFirstChild("CollectBrainrotEvent")

local brainrotModel = Instance.new("Model") -- Placeholder, assume Brainrot model exists
brainrotModel.Name = "Brainrot"
local part = Instance.new("Part")
part.Size = Vector3.new(2,2,2)
part.Anchored = true
part.CanCollide = false
part.Parent = brainrotModel
brainrotModel.Parent = ReplicatedStorage

local spawnedBrainrots = {}

local function SpawnBrainrot(position)
    local clone = brainrotModel:Clone()
    clone.PrimaryPart.CFrame = CFrame.new(position)
    clone.Parent = Workspace
    table.insert(spawnedBrainrots, clone)
end

-- Spawn some initial Brainrots
for i = 1, 10 do
    SpawnBrainrot(Vector3.new(math.random(-100,100), 5, math.random(-100,100)))
end

CollectBrainrotEvent.OnServerEvent:Connect(function(player, brainrot)
    if brainrot and brainrot:IsDescendantOf(Workspace) then
        brainrot:Destroy()
        -- Add to player's data
        local playerData = require(script.Parent.PlayerManager).playerData[player.UserId]
        table.insert(playerData.Brainrots, {Level = 1})
        -- Update client
        local UpdateDataEvent = ReplicatedStorage:FindFirstChild("UpdateDataEvent")
        UpdateDataEvent:FireClient(player, playerData)
    end
end)