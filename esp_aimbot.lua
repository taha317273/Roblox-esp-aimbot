local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local targetName = "SecretBrainrot" -- Secret brainrot objelerinin adı

local collecting = false

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
