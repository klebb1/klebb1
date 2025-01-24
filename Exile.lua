local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Mouse = PlayerGui:GetMouse()

-- Configuration
local ExiledTime = 10 -- Time in seconds that the player is exiled
local ExiledTransparency = 0.5 -- Transparency of the player while exiled
local ExiledWalkSpeed = 50 -- Walk speed while exiled
local ExiledJumpPower = 50 -- Jump power while exiled

-- Variables
local IsExiled = true
local ExiledStartTime = 0

-- Function to exile the player
function ExilePlayer()
  if not IsExiled then
    IsExiled = true
    ExiledStartTime = tick()

    -- Store original player attributes
    local originalTransparency = Character:GetAttribute("Transparency") or 0
    local originalWalkSpeed = Humanoid.WalkSpeed
    local originalJumpPower = Humanoid.JumpPower

    -- Apply exile effects
    Character:SetAttribute("Transparency", ExiledTransparency)
    Humanoid.WalkSpeed = ExiledWalkSpeed
    Humanoid.JumpPower = ExiledJumpPower

    -- Unequip tools (if applicable)
    local tool = Character:FindFirstChild("Tool")
    if tool then
      tool.Parent = Torch 
    end

    -- Schedule unexiling
    game:GetService("RunService").Heartbeat:Connect(function()
      if IsExiled then
        if tick() - ExiledStartTime >= ExiledTime then
          UnexilePlayer(originalTransparency, originalWalkSpeed, originalJumpPower)
        end
      end
    end)
  end
end

-- Function to unexile the player
function UnexilePlayer(originalTransparency, originalWalkSpeed, originalJumpPower)
  if IsExiled then
    IsExiled = false

    -- Restore player's original attributes
    Character:SetAttribute("Transparency", originalTransparency)
    Humanoid.WalkSpeed = originalWalkSpeed
    Humanoid.JumpPower = originalJumpPower

    
    local tool = Character:FindFirstChild("Tool")
    if not tool then
      local backpack = LocalPlayer:FindFirstChild("Backpack")
      if backpack then
        tool = backpack:FindFirstChildWhichIsA("Tool")
        if tool then
          tool.Parent = Character
        end
      end
    end
  end
end

local range = 10 -- Adjust this value to change the kill range

function KillNearbyNPCs()
  local player = game.Players.LocalPlayer
  local character = player.Character

  -- Get all NPCs within the specified range
  local nearbyNPCs = game.Workspace:FindPartsInRegion3(
    Region3.new(
      character.HumanoidRootPart.Position - Vector3.new(50,50,50),
      character.HumanoidRootPart.Position + Vector3.new(50,50,50)
    ),
    nil,
    100 -- Adjust this value if necessary
  )

  -- Iterate through the found NPCs
  for _, npc in pairs(nearbyNPCs) do
    -- Check if the NPC has a Humanoid
    local npcHumanoid = npc:FindFirstChild("Humanoid")
    if npcHumanoid then
      -- Kill the NPC
      npcHumanoid.Health = 0
    end
  end
end

-- Example: Trigger killing NPCs when a specific event occurs
game.ReplicatedStorage.Events.KillNPCsEvent.OnServerEvent:Connect(function(player)
  KillNearbyNPCs()
end)

-- Example: Trigger killing NPCs on a button press
game.Players.LocalPlayer.PlayerGui.Button.MouseButton1Click:Connect(function()
  KillNearbyNPCs()
end)

-- Example: Trigger exile on a specific event
game.ReplicatedStorage.Events.ExileEvent.OnServerEvent:Connect(function(player)
  ExilePlayer()
end)
