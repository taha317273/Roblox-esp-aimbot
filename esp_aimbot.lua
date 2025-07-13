local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local AimPart = "Head"
local AimEnabled = false

-- GUI Oluşturma
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ESP_Aimbot_Gui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0, 120, 0, 50)
Button.Position = UDim2.new(0.85, 0, 0.9, 0)
Button.BackgroundColor3 = Color3.new(0.4, 0, 0)
Button.BackgroundTransparency = 0.3
Button.TextColor3 = Color3.new(1, 1, 1)
Button.TextScaled = true
Button.Font = Enum.Font.GothamBold
Button.Text = "Aimbot OFF"
Button.Parent = ScreenGui

-- Buton sürükleme fonksiyonu
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    Button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                              startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Button.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Aimbot aç/kapa
Button.MouseButton1Click:Connect(function()
    AimEnabled = not AimEnabled
    if AimEnabled then
        Button.Text = "Aimbot ON"
        Button.BackgroundColor3 = Color3.new(0, 0.6, 0)
    else
        Button.Text = "Aimbot OFF"
        Button.BackgroundColor3 = Color3.new(0.4, 0, 0)
    end
end)

-- Gelişmiş ESP fonksiyonu
local function CreateESP(player)
    if player == LocalPlayer then return end
    player.CharacterAdded:Connect(function(character)
        wait(1)
        local head = character:WaitForChild("Head", 5)
        local humanoid = character:WaitForChild("Humanoid", 5)
        if head and humanoid then
            if not head:FindFirstChild("ESP") then
                local BillboardGui = Instance.new("BillboardGui")
                BillboardGui.Name = "ESP"
                BillboardGui.Size = UDim2.new(0, 120, 0, 60)
                BillboardGui.Adornee = head
                BillboardGui.AlwaysOnTop = true
                BillboardGui.Parent = head

                local NameLabel = Instance.new("TextLabel", BillboardGui)
                NameLabel.Name = "NameLabel"
                NameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                NameLabel.BackgroundTransparency = 1
                NameLabel.TextColor3 = Color3.new(1, 0, 0)
                NameLabel.TextScaled = true
                NameLabel.Font = Enum.Font.GothamBold
                NameLabel.Text = player.Name

                local HealthBarBG = Instance.new("Frame", BillboardGui)
                HealthBarBG.Name = "HealthBarBG"
                HealthBarBG.Size = UDim2.new(1, 0, 0.2, 0)
                HealthBarBG.Position = UDim2.new(0, 0, 0.5, 0)
                HealthBarBG.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
                HealthBarBG.BorderSizePixel = 0
                HealthBarBG.BackgroundTransparency = 0.5
                HealthBarBG.ClipsDescendants = true

                local HealthBar = Instance.new("Frame", HealthBarBG)
                HealthBar.Name = "HealthBar"
                HealthBar.Size = UDim2.new(1, 0, 1, 0)
                HealthBar.BackgroundColor3 = Color3.new(0, 1, 0)
                HealthBar.BorderSizePixel = 0

                local DistanceLabel = Instance.new("TextLabel", BillboardGui)
                DistanceLabel.Name = "DistanceLabel"
                DistanceLabel.Size = UDim2.new(1, 0, 0.3, 0)
                DistanceLabel.Position = UDim2.new(0, 0, 0.7, 0)
                DistanceLabel.BackgroundTransparency = 1
                DistanceLabel.TextColor3 = Color3.new(1, 1, 1)
                DistanceLabel.TextScaled = true
                DistanceLabel.Font = Enum.Font.GothamBold
                DistanceLabel.Text = "0m"
            end
        end
    end)
end

for _, player in pairs(Players:GetPlayers()) do
    CreateESP(player)
end

Players.PlayerAdded:Connect(function(player)
    CreateESP(player)
end)

RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("Humanoid") then
            local head = player.Character.Head
            local humanoid = player.Character.Humanoid
            local espGui = head:FindFirstChild("ESP")
            if espGui then
                local nameLabel = espGui:FindFirstChild("NameLabel")
                local healthBar = espGui:FindFirstChild("HealthBarBG") and espGui.HealthBarBG:FindFirstChild("HealthBar")
                local distanceLabel = espGui:FindFirstChild("DistanceLabel")

                if nameLabel then
                    nameLabel.Text = player.Name
                end
                if healthBar then
                    local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                    healthBar.Size = UDim2.new(healthPercent, 0, 1, 0)
                    if healthPercent > 0.5 then
                        healthBar.BackgroundColor3 = Color3.new(0, 1, 0)
                    elseif healthPercent > 0.2 then
                        healthBar.BackgroundColor3 = Color3.new(1, 1, 0)
                    else
                        healthBar.BackgroundColor3 = Color3.new(1, 0, 0)
                    end
                end
                if distanceLabel and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    distanceLabel.Text = string.format("%.0fm", dist)
                end
            end
        end
    end
end)

-- En yakın hedefi bul
local function GetClosestTarget()
    local camera = workspace.CurrentCamera
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(AimPart) and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local screenPos, onScreen = camera:WorldToViewportPoint(player.Character[AimPart].Position)
            if onScreen then
                local dist = (Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if dist < shortestDistance and dist < 150 then
                    closestPlayer = player
                    shortestDistance = dist
                end
            end
        end
    end

    return closestPlayer
end

-- Smooth kamera dönüşü
local function SmoothLookAt(targetPosition)
    local camera = workspace.CurrentCamera
    local newCFrame = CFrame.new(camera.CFrame.Position, targetPosition)
    local tween = TweenService:Create(camera, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        CFrame = newCFrame
    })
    tween:Play()
end

-- Aimbot update
RunService.RenderStepped:Connect(function()
    if AimEnabled then
        local target = GetClosestTarget()
        if target and target.Character and target.Character:FindFirstChild(AimPart) then
            SmoothLookAt(target.Character[AimPart].Position)
        end
    end
end)

-- Base Timer Rainbow ESP
-- Base objesini bul
local base = workspace:FindFirstChild("Base") or workspace:FindFirstChild("BaseDoor")
if base then
    -- Timer isimli NumberValue bekle
    local timerValue = base:FindFirstChild("Timer")

    local gui = Instance.new("BillboardGui")
    gui.Name = "BaseTimerESP"
    gui.Adornee = base
    gui.Size = UDim2.new(0, 200, 0, 50)
    gui.StudsOffset = Vector3.new(0, 4, 0)
    gui.AlwaysOnTop = true
    gui.Parent = base

    local label = Instance.new("TextLabel")
    label.Parent = gui
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextStrokeTransparency = 0.3
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Text = "Base Timer: ..."

    local hue = 0
    RunService.RenderStepped:Connect(function()
        hue = (hue + 0.005) % 1
        label.TextColor3 = Color3.fromHSV(hue, 1, 1)

        if timerValue and timerValue:IsA("NumberValue") then
            local seconds = math.floor(timerValue.Value)
            label.Text = "Base Açılıyor: " .. tostring(seconds) .. " sn"
        else
            label.Text = "Base Açıldı!"
        end
    end)
end
