-- ServerScriptService: PlayerManager.lua
-- Handles player data, saving, loading

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local playerDataStore = DataStoreService:GetDataStore("PlayerData")

local playerData = {} -- In-memory data

local function LoadPlayerData(player)
    local success, data = pcall(function()
        return playerDataStore:GetAsync(player.UserId)
    end)
    
    if success and data then
        playerData[player.UserId] = data
    else
        playerData[player.UserId] = {
            Money = 0,
            Brainrots = {},
            BaseLevel = 1,
            LastLogin = os.time()
        }
    end
    
    -- Calculate offline earnings
    local currentTime = os.time()
    local timeDiff = currentTime - (playerData[player.UserId].LastLogin or currentTime)
    local earnings = CalculateOfflineEarnings(playerData[player.UserId], timeDiff)
    playerData[player.UserId].Money = playerData[player.UserId].Money + earnings
    playerData[player.UserId].LastLogin = currentTime
    
    -- Send to client
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local UpdateDataEvent = ReplicatedStorage:FindFirstChild("UpdateDataEvent") or Instance.new("RemoteEvent")
    UpdateDataEvent.Name = "UpdateDataEvent"
    UpdateDataEvent.Parent = ReplicatedStorage
    UpdateDataEvent:FireClient(player, playerData[player.UserId])
end

local function SavePlayerData(player)
    local success = pcall(function()
        playerDataStore:SetAsync(player.UserId, playerData[player.UserId])
    end)
    if not success then
        warn("Failed to save data for " .. player.Name)
    end
end

local function CalculateOfflineEarnings(data, timeDiff)
    local totalEarnings = 0
    for _, brainrot in pairs(data.Brainrots) do
        totalEarnings = totalEarnings + (brainrot.Level * 10) * timeDiff / 60 -- per minute
    end
    return math.min(totalEarnings, 100000) -- cap
end

Players.PlayerAdded:Connect(LoadPlayerData)
Players.PlayerRemoving:Connect(SavePlayerData)

-- Money generation loop
while true do
    wait(1)
    for userId, data in pairs(playerData) do
        local earnings = 0
        for _, brainrot in pairs(data.Brainrots) do
            earnings = earnings + brainrot.Level * 1 -- 1 money per second per level
        end
        data.Money = data.Money + earnings
        
        -- Update client periodically
        local player = Players:GetPlayerByUserId(userId)
        if player then
            local UpdateDataEvent = ReplicatedStorage:FindFirstChild("UpdateDataEvent")
            UpdateDataEvent:FireClient(player, data)
        end
    end
end