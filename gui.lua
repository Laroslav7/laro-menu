-- Сервисы Roblox
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- Проверка на повторный запуск (удаляет старую гуишку, если она уже открыта)
if CoreGui:FindFirstChild("LaroGui") then
    CoreGui.LaroGui:Destroy()
end

-- Переменные состояния
local noclipEnabled = false
local noclipConnection = nil

-- Создание основы GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LaroGui"
-- Пробуем поместить в CoreGui, если нет прав — в PlayerGui
screenGui.Parent = pcall(function() return CoreGui end) and CoreGui or player:WaitForChild("PlayerGui")

-- Главный фрейм (Окно)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 210)
mainFrame.Position = UDim2.new(0.5, -110, 0.4, -105)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true -- Можно перетаскивать мышкой
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 0, 30)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "Laro Menu"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.SourceSansBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame

-- Надпись By Laroslav7
local credits = Instance.new("TextLabel")
credits.Size = UDim2.new(1, -20, 0, 15)
credits.Position = UDim2.new(0, 10, 0, 32)
credits.BackgroundTransparency = 1
credits.Text = "By Laroslav7"
credits.TextColor3 = Color3.fromRGB(0, 170, 255)
credits.TextSize = 13
credits.Font = Enum.Font.SourceSansItalic
credits.TextXAlignment = Enum.TextXAlignment.Left
credits.Parent = mainFrame

-- Кнопка сворачивания
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 20, 0, 20)
toggleBtn.Position = UDim2.new(1, -25, 0, 5)
toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
toggleBtn.Text = "-"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 14
toggleBtn.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 4)
btnCorner.Parent = toggleBtn

-- Контейнер для кнопок
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -20, 0, 150)
content.Position = UDim2.new(0, 10, 0, 52)
content.BackgroundTransparency = 1
content.Parent = mainFrame

-- Функция для быстрого создания красивых кнопок
local function createButton(text, position, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(240, 240, 240)
    btn.TextSize = 14
    btn.Font = Enum.Font.SourceSansSemibold
    btn.Parent = content

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 6)
    bCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
    return btn
end

-- 1. Кнопка Noclip
local noclipBtn
noclipBtn = createButton("Noclip: ВЫКЛ", UDim2.new(0, 0, 0, 0), function()
    noclipEnabled = not noclipEnabled
    
    if noclipEnabled then
        noclipBtn.Text = "Noclip: ВКЛ"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
        
        -- Цикл отключения коллизий
        noclipConnection = RunService.Stepped:Connect(function()
            if player.Character then
                for _, part in ipairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        noclipBtn.Text = "Noclip: ВЫКЛ"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
    end
end)

-- Установка скорости
local function setSpeed(speed)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speed
    end
end

-- 2. Кнопки выбора скорости
createButton("Скорость: Обычная (16)", UDim2.new(0, 0, 0, 38), function()
    setSpeed(16)
end)

createButton("Скорость: Средняя (50)", UDim2.new(0, 0, 0, 76), function()
    setSpeed(50)
end)

createButton("Скорость: Высокая (100)", UDim2.new(0, 0, 0, 114), function()
    setSpeed(100)
end)

-- Логика сворачивания меню
local minimized = false
toggleBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    mainFrame.Size = minimized and UDim2.new(0, 220, 0, 50) or UDim2.new(0, 220, 0, 210)
    toggleBtn.Text = minimized and "+" or "-"
end)
