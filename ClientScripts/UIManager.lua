-- StarterPlayerScripts: UIManager.lua
-- Client-side UI management

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainGui"
screenGui.Parent = playerGui

-- Money display
local moneyLabel = Instance.new("TextLabel")
moneyLabel.Size = UDim2.new(0, 200, 0, 50)
moneyLabel.Position = UDim2.new(0, 10, 0, 10)
moneyLabel.Text = "Money: 0"
moneyLabel.BackgroundColor3 = Color3.new(0,0,0)
moneyLabel.TextColor3 = Color3.new(1,1,1)
moneyLabel.Parent = screenGui

-- Tsunami warning
local warningLabel = Instance.new("TextLabel")
warningLabel.Size = UDim2.new(1, 0, 0, 100)
warningLabel.Position = UDim2.new(0, 0, 0.5, -50)
warningLabel.Text = ""
warningLabel.BackgroundColor3 = Color3.new(1,0,0)
warningLabel.TextColor3 = Color3.new(1,1,1)
warningLabel.Visible = false
warningLabel.Parent = screenGui

-- Events
local TsunamiEvent = ReplicatedStorage:WaitForChild("TsunamiEvent")
local UpdateDataEvent = ReplicatedStorage:WaitForChild("UpdateDataEvent")

TsunamiEvent.OnClientEvent:Connect(function(action, time)
    if action == "Warning" then
        warningLabel.Text = "Tsunami Warning! " .. time .. " seconds left!"
        warningLabel.Visible = true
        wait(time)
        warningLabel.Visible = false
    elseif action == "Start" then
        warningLabel.Text = "Tsunami Incoming! Run!"
        warningLabel.Visible = true
    elseif action == "EarthquakeWarning" then
        warningLabel.Text = "Earthquake Warning! " .. time .. " seconds!"
        warningLabel.Visible = true
        wait(time)
        warningLabel.Visible = false
    elseif action == "Earthquake" then
        warningLabel.Text = "Earthquake! Hold on!"
        warningLabel.Visible = true
    elseif action == "VolcanoWarning" then
        warningLabel.Text = "Volcano Erupting Soon! " .. time .. " seconds!"
        warningLabel.Visible = true
        wait(time)
        warningLabel.Visible = false
    elseif action == "Volcano" then
        warningLabel.Text = "Volcano Erupting! Avoid lava!"
        warningLabel.Visible = true
    elseif action == "End" then
        warningLabel.Visible = false
    end
end)

UpdateDataEvent.OnClientEvent:Connect(function(data)
    moneyLabel.Text = "Money: " .. data.Money
end)

-- Collection
local CollectBrainrotEvent = ReplicatedStorage:WaitForChild("CollectBrainrotEvent")

-- Assume Brainrots have click detectors or touch
-- For simplicity, on touch
player.CharacterAdded:Connect(function(char)
    char.Humanoid.Touched:Connect(function(hit)
        if hit.Parent.Name == "Brainrot" then
            CollectBrainrotEvent:FireServer(hit.Parent)
        end
    end)
end)