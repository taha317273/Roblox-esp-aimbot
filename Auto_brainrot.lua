local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local targetName = "SecretBrainrot" -- Secret brainrot objelerinin adı

local collecting = false

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Script Çalıştı yazısı
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScriptStatusGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(0.4, 0, 0.1, 0)
TextLabel.Position = UDim2.new(0.3, 0, 0.45, 0)
TextLabel.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel.BackgroundTransparency = 0.5
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.TextScaled = true
TextLabel.Font = Enum.Font.GothamBold
TextLabel.Text = "Script Çalıştı!"
TextLabel.Parent = ScreenGui

delay(3, function()
    ScreenGui:Destroy()
end)

local function getClosestSecretBrainrot()
    local closest = nil
    local shortestDist = math.huge

    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name == targetName and obj:IsA("BasePart") then
            local dist = (obj.Position - HumanoidRootPart.Position).Magnitude
            if dist < shortestDist then
                closest = obj
                shortestDist = dist
            end
        end
    end

    return closest
end

local function moveToPosition(pos)
    -- Basit tween ile hareket
    local tweenInfo = TweenInfo.new((HumanoidRootPart.Position - pos).Magnitude / 16, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(pos.X, HumanoidRootPart.Position.Y, pos.Z)})
    tween:Play()
    tween.Completed:Wait()
end

-- Otomatik toplama döngüsü
spawn(function()
    while true do
        wait(0.1)
        if not collecting then
            local target = getClosestSecretBrainrot()
            if target then
                collecting = true
                -- Yürü hedefe
                moveToPosition(target.Position)

                -- Yaklaştığında topla (örneğin touch event yoksa doğrudan sil veya değiştir)
                if target and target.Parent then
                    target:Destroy() -- veya toplama eventini tetikleyebilirsin
                end
                collecting = false
            end
        end
    end
end)
