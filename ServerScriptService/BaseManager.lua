-- ServerScriptService: BaseManager.lua
-- Creates a basic base for players

local Workspace = game:GetService("Workspace")

local spawnLocation = Instance.new("SpawnLocation")
spawnLocation.Size = Vector3.new(10, 1, 10)
spawnLocation.Anchored = true
spawnLocation.Position = Vector3.new(0, 1, 0)
spawnLocation.BrickColor = BrickColor.new("Bright green")
spawnLocation.Parent = Workspace

local safeZone = Instance.new("Part")
safeZone.Size = Vector3.new(20, 10, 20)
safeZone.Anchored = true
safeZone.Position = Vector3.new(0, 45, 0)
safeZone.BrickColor = BrickColor.new("Bright blue")
safeZone.Transparency = 0.5
safeZone.CanCollide = true
safeZone.Parent = Workspace

-- Label
local label = Instance.new("SurfaceGui")
label.Adornee = safeZone
label.Face = Enum.NormalId.Top
local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 1, 0)
textLabel.Text = "SAFE ZONE"
textLabel.BackgroundTransparency = 1
textLabel.TextColor3 = Color3.new(1, 1, 1)
textLabel.TextScaled = true
textLabel.Parent = label
label.Parent = safeZone