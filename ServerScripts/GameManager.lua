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
local TSUNAMI_INTERVAL = 300 -- 5 minutes
local WARNING_TIME = 30 -- 30 seconds warning

-- Function to start tsunami
local function StartTsunami()
    -- Warn players
    TsunamiEvent:FireAllClients("Warning", WARNING_TIME)
    wait(WARNING_TIME)
    
    -- Start tsunami
    TsunamiEvent:FireAllClients("Start")
    
    -- Check players
    for _, player in pairs(Players:GetPlayers()) do
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local pos = char.HumanoidRootPart.Position
            if pos.Y < 50 then -- Assume safe above 50
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
end

-- Loop disasters
while true do
    wait(math.random(200, 600)) -- Random interval
    local disaster = math.random(1,3)
    if disaster == 1 then
        StartTsunami()
    elseif disaster == 2 then
        StartEarthquake()
    elseif disaster == 3 then
        StartVolcano()
    end
end

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
    -- Lava or something
    wait(30)
    TsunamiEvent:FireAllClients("End")
end