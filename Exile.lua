local remoteEvent = game.ReplicatedStorage:WaitForChild("AttackEvent")

remoteEvent.OnServerEvent:Connect(function(player, position)
    local character = player.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local distance = (humanoidRootPart.Position - position).magnitude
            
            if distance <= 100 then -- Check if within attack range
                -- Find an enemy within range (for demonstration, use a specific NPC)
                local enemy = workspace:FindFirstChild("EnemyNPC") -- Make sure you have an NPC named "EnemyNPC"
                
                if enemy and (enemy.Position - humanoidRootPart.Position).magnitude <= 100 then
                    -- Deal damage to the enemy
                    local enemyHealth = enemy:FindFirstChild("Humanoid")
                    if enemyHealth then
                        enemyHealth:TakeDamage(100) -- Change the number to adjust damage
                    end
                end
            end
        end
    end
end)
