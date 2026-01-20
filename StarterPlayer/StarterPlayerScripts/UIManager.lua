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

-- Brainrot management frame
local brainrotFrame = Instance.new("Frame")
brainrotFrame.Size = UDim2.new(0, 300, 0, 400)
brainrotFrame.Position = UDim2.new(1, -305, 0, 5)
brainrotFrame.BackgroundColor3 = Color3.new(0, 0, 0)
brainrotFrame.BackgroundTransparency = 0.5
brainrotFrame.BorderSizePixel = 2
brainrotFrame.BorderColor3 = Color3.new(1, 1, 1)
brainrotFrame.Parent = screenGui

local brainrotLabel = Instance.new("TextLabel")
brainrotLabel.Size = UDim2.new(1, -10, 0, 30)
brainrotLabel.Position = UDim2.new(0, 5, 0, 5)
brainrotLabel.Text = "Brainrots"
brainrotLabel.BackgroundTransparency = 1
brainrotLabel.TextColor3 = Color3.new(0, 1, 0)
brainrotLabel.TextScaled = true
brainrotLabel.Font = Enum.Font.SourceSansBold
brainrotLabel.Parent = brainrotFrame

local brainrotList = Instance.new("ScrollingFrame")
brainrotList.Size = UDim2.new(1, -10, 1, -175)
brainrotList.Position = UDim2.new(0, 5, 0, 40)
brainrotList.BackgroundTransparency = 1
brainrotList.Parent = brainrotFrame

local upgradeButton = Instance.new("TextButton")
upgradeButton.Size = UDim2.new(0.45, -5, 0, 30)
upgradeButton.Position = UDim2.new(0, 5, 1, -35)
upgradeButton.Text = "Upgrade Selected"
upgradeButton.BackgroundColor3 = Color3.new(0, 0.5, 0)
upgradeButton.TextColor3 = Color3.new(1, 1, 1)
upgradeButton.Parent = brainrotFrame

local placeButton = Instance.new("TextButton")
placeButton.Size = UDim2.new(0.45, -5, 0, 30)
placeButton.Position = UDim2.new(0.55, 0, 1, -35)
placeButton.Text = "Place Selected"
placeButton.BackgroundColor3 = Color3.new(0, 0, 0.5)
placeButton.TextColor3 = Color3.new(1, 1, 1)
placeButton.Parent = brainrotFrame

local upgradeBaseButton = Instance.new("TextButton")
upgradeBaseButton.Size = UDim2.new(1, -10, 0, 30)
upgradeBaseButton.Position = UDim2.new(0, 5, 1, -70)
upgradeBaseButton.Text = "Upgrade Base"
upgradeBaseButton.BackgroundColor3 = Color3.new(0.5, 0, 0.5)
upgradeBaseButton.TextColor3 = Color3.new(1, 1, 1)
upgradeBaseButton.Parent = brainrotFrame

local selectedIndex = nil
local brainrotButtons = {}

local function UpdateBrainrotList(data)
    -- Clear old buttons
    for _, btn in pairs(brainrotButtons) do
        btn:Destroy()
    end
    brainrotButtons = {}
    
    for i, brainrot in pairs(data.Brainrots or {}) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 30)
        btn.Position = UDim2.new(0, 5, 0, (i-1)*35)
        btn.Text = "Brainrot " .. i .. " (Lv " .. brainrot.Level .. ")"
        btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Parent = brainrotList
        
        btn.MouseButton1Click:Connect(function()
            selectedIndex = i
            for _, b in pairs(brainrotButtons) do
                b.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
            end
            btn.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
        end)
        
        table.insert(brainrotButtons, btn)
    end
    
    brainrotList.CanvasSize = UDim2.new(0, 0, 0, #data.Brainrots * 35)
end
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
    UpdateBrainrotList(data)
end)

local UpgradeEvent = ReplicatedStorage:WaitForChild("UpgradeEvent")
local PlaceEvent = ReplicatedStorage:WaitForChild("PlaceEvent")

upgradeButton.MouseButton1Click:Connect(function()
    if selectedIndex then
        UpgradeEvent:FireServer("Brainrot", selectedIndex)
    end
end)

placeButton.MouseButton1Click:Connect(function()
    if selectedIndex then
        -- Get position, perhaps near player
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local pos = char.HumanoidRootPart.Position + Vector3.new(5, 0, 0) -- offset
            PlaceEvent:FireServer(pos)
        end
    end
end)

upgradeBaseButton.MouseButton1Click:Connect(function()
    UpgradeEvent:FireServer("Base", 0)  -- index not used for base
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