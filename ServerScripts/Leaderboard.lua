-- ServerScriptService: Leaderboard.lua
-- Manages leaderboard

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local leaderboardStore = DataStoreService:GetOrderedDataStore("Leaderboard")

local function UpdateLeaderboard(player, money)
    local success = pcall(function()
        leaderboardStore:SetAsync(player.UserId, money)
    end)
end

-- Update on save
local PlayerManager = require(script.Parent.PlayerManager)
Players.PlayerRemoving:Connect(function(player)
    local data = PlayerManager.playerData[player.UserId]
    if data then
        UpdateLeaderboard(player, data.Money)
    end
end)