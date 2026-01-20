-- ServerScriptService: GameManager.lua
-- Manages overall game state, tsunamis, etc.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Events
local TsunamiEvent = Instance.new("RemoteEvent")
TsunamiEvent.Name = "TsunamiEvent"
TsunamiEvent.Parent = ReplicatedStorage

local CollectBrainrotEvent = Instance.new("RemoteEvent")
CollectBrainrotEvent.Name = "CollectBrainrotEvent"
CollectBrainrotEvent.Parent = ReplicatedStorage

-- Tsunami settings
local TSUNAMI_INTERVAL = 120 -- 2 minutes
local WARNING_TIME = 30 -- 30 seconds warning

local Lighting = game:GetService("Lighting")

local function StartEarthquake()
    TsunamiEvent:FireAllClients("EarthquakeWarning", 10)
    wait(10)
    TsunamiEvent:FireAllClients("Earthquake")
    -- Shake screen, damage
    for _, player in pairs(Players:GetPlayers()) do
        local char = player.Character
        if char then
            char.Humanoid:TakeDamage(20)
        end
    end
    wait(5)
    TsunamiEvent:FireAllClients("End")
end

local function StartVolcano()
    TsunamiEvent:FireAllClients("VolcanoWarning", 15)
    wait(15)
    TsunamiEvent:FireAllClients("Volcano")
    
    -- Add fog
    local atmosphere = Instance.new("Atmosphere")
    atmosphere.Color = Color3.new(0.5, 0.3, 0.1)
    atmosphere.Decay = Color3.new(0.4, 0.2, 0)
    atmosphere.Glare = 0.2
    atmosphere.Haze = 0.5
    atmosphere.Parent = Lighting
    
    -- Visual effect: lava particles
    local volcanoPart = Instance.new("Part")
    volcanoPart.Size = Vector3.new(10, 10, 10)
    volcanoPart.Anchored = true
    volcanoPart.Position = Vector3.new(0, 0, 0) -- Assume volcano at center
    volcanoPart.BrickColor = BrickColor.new("Really red")
    volcanoPart.Parent = Workspace
    
    local particleEmitter = Instance.new("ParticleEmitter")
    particleEmitter.Texture = "rbxassetid://123456789" -- Placeholder, use lava texture
    particleEmitter.Size = NumberSequence.new(5)
    particleEmitter.Lifetime = NumberRange.new(2, 5)
    particleEmitter.Rate = 100
    particleEmitter.Speed = NumberRange.new(10, 20)
    particleEmitter.Parent = volcanoPart
    
    wait(30)
    
    particleEmitter:Destroy()
    volcanoPart:Destroy()
    atmosphere:Destroy()
    
    TsunamiEvent:FireAllClients("End")
end

-- Function to start tsunami
local function StartTsunami()
    -- Warn players
    TsunamiEvent:FireAllClients("Warning", WARNING_TIME)
    -- Dim lights
    Lighting.Brightness = 0.5
    wait(WARNING_TIME)
    
    -- Start tsunami
    TsunamiEvent:FireAllClients("Start")
    
    -- Visual effect: rising water
    local water = Instance.new("Part")
    water.Size = Vector3.new(1000, 1, 1000)
    water.Anchored = true
    water.CanCollide = false
    water.BrickColor = BrickColor.new("Bright blue")
    water.Transparency = 0.5
    water.Material = Enum.Material.Water
    water.Position = Vector3.new(0, -10, 0)
    water.Parent = Workspace
    
    for i = 1, 60 do
        water.Position = water.Position + Vector3.new(0, 1, 0)
        wait(1)
    end
    
    water:Destroy()
    
    -- Check players
    for _, player in pairs(Players:GetPlayers()) do
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local pos = char.HumanoidRootPart.Position
            if pos.Y < 40 then -- Assume safe above 40
                -- Kill or penalize
                char.Humanoid.Health = 0
                -- Lose some money
                local playerData = require(script.Parent.PlayerManager).playerData[player.UserId]
                playerData.Money = math.max(0, playerData.Money - 1000)
            end
        end
    end
    
    -- Simulate tsunami duration
    wait(60) -- 1 minute
    
    -- End tsunami
    TsunamiEvent:FireAllClients("End")
    Lighting.Brightness = 1 -- Restore lights
end

-- Loop disasters
while true do
    wait(math.random(60, 180)) -- Random interval 1-3 minutes
    local disaster = math.random(1,3)
    if disaster == 1 then
        StartTsunami()
    elseif disaster == 2 then
        StartEarthquake()
    elseif disaster == 3 then
        StartVolcano()
    end
end