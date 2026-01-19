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
local moneyFrame = Instance.new("Frame")
moneyFrame.Size = UDim2.new(0, 220, 0, 60)
moneyFrame.Position = UDim2.new(0, 5, 0, 5)
moneyFrame.BackgroundColor3 = Color3.new(0, 0, 0)
moneyFrame.BackgroundTransparency = 0.5
moneyFrame.BorderSizePixel = 2
moneyFrame.BorderColor3 = Color3.new(1, 1, 1)
moneyFrame.Parent = screenGui

local moneyLabel = Instance.new("TextLabel")
moneyLabel.Size = UDim2.new(1, -10, 1, -10)
moneyLabel.Position = UDim2.new(0, 5, 0, 5)
moneyLabel.Text = "Money: 0"
moneyLabel.BackgroundTransparency = 1
moneyLabel.TextColor3 = Color3.new(1, 1, 0)
moneyLabel.TextScaled = true
moneyLabel.Font = Enum.Font.SourceSansBold
moneyLabel.Parent = moneyFrame

-- Tsunami warning
local warningLabel = Instance.new("TextLabel")
warningLabel.Size = UDim2.new(1, 0, 0, 100)
warningLabel.Position = UDim2.new(0, 0, 0.5, -50)
warningLabel.Text = ""
warningLabel.BackgroundColor3 = Color3.new(1,0,0)
warningLabel.BackgroundTransparency = 0.3
warningLabel.TextColor3 = Color3.new(1,1,1)
warningLabel.TextScaled = true
warningLabel.Font = Enum.Font.SourceSansBold
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
        -- Screen shake
        local camera = Workspace.CurrentCamera
        local originalCFrame = camera.CFrame
        for i = 1, 50 do
            camera.CFrame = originalCFrame * CFrame.new(math.random(-2,2), math.random(-2,2), math.random(-2,2))
            wait(0.1)
        end
        camera.CFrame = originalCFrame
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