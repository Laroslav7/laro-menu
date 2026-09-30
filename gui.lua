-- ==================================================
--      Читы by laroslav7  |  v3 MEGA PACK
-- ==================================================
local CoreGui    = game:GetService("CoreGui")
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput  = game:GetService("UserInputService")
local Tween      = game:GetService("TweenService")
local lp         = Players.LocalPlayer

pcall(function()
    local o = CoreGui:FindFirstChild("YaroslavUI")
    if o then o:Destroy() end
end)

-- ============ STATE ============
local State = {
    speed     = {enabled=false, value=16,  key=nil},
    jump      = {enabled=false, value=50,  key=nil},
    fly       = {enabled=false, speed=60,  key=nil},
    noclip    = {enabled=false, key=nil},
    godmode   = {enabled=false, key=nil},
    highlight = {enabled=false, key=nil},
    esp       = {enabled=false, key=nil},
    vehicle   = {enabled=false, value=250, key=nil},
    anim534   = {enabled=false, key=nil},
    anim342   = {enabled=false, key=nil},
    freecam   = {enabled=false, key=nil},
    speedSpoof= {enabled=false, key=nil},
}

local flyBV, flyBG
local hlFolder, espFolder
local anim534M, anim342M, animIsR6, animChar
local awaitingKey = nil
local origWS = 16
local freecamPos, freecamConn
local origSpeedMeta = nil

-- ============ SAFE EXPLOIT WRAPPERS ============
local hasRawMeta   = type(getrawmetatable) == "function"
local hasHookMeta  = type(hookmetamethod) == "function"
local hasNilInst   = type(getnilinstances) == "function"

-- ============ GUI ============
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YaroslavUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 460, 0, 580)
Main.Position = UDim2.new(0.5, -230, 0.5, -290)
Main.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Visible = false
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Color = Color3.fromRGB(0, 170, 255)
mainStroke.Thickness = 2
mainStroke.Transparency = 0.35

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
Title.BorderSizePixel = 0
Title.Text = "  ⚡ by laroslav7  |  v3"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main
local tc = Instance.new("UICorner", Title)
tc.CornerRadius = UDim.new(0, 12)

-- Right side of title bar (minimize / close)
local BtnHolder = Instance.new("Frame")
BtnHolder.Size = UDim2.new(0, 80, 0, 40)
BtnHolder.Position = UDim2.new(1, -80, 0, 0)
BtnHolder.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
BtnHolder.BorderSizePixel = 0
BtnHolder.Parent = Main
local bhc = Instance.new("UICorner", BtnHolder)
bhc.CornerRadius = UDim.new(0, 12)

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 32, 0, 26)
MinBtn.Position = UDim2.new(0, 6, 0, 7)
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
MinBtn.BorderSizePixel = 0
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 16
MinBtn.Parent = BtnHolder
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 26)
CloseBtn.Position = UDim2.new(0, 42, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(140, 40, 40)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = BtnHolder
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -12, 1, -48)
Scroll.Position = UDim2.new(0, 6, 0, 44)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.Parent = Main

local UIL = Instance.new("UIListLayout", Scroll)
UIL.Padding = UDim.new(0, 6)
UIL.SortOrder = Enum.SortOrder.LayoutOrder
local UIP = Instance.new("UIPadding", Scroll)
UIP.PaddingTop = UDim.new(0, 6)
UIP.PaddingLeft = UDim.new(0, 6)
UIP.PaddingRight = UDim.new(0, 6)
UIP.PaddingBottom = UDim.new(0, 6)

-- Resize handle (bottom right)
local Resizer = Instance.new("TextButton")
Resizer.Size = UDim2.new(0, 18, 0, 18)
Resizer.Position = UDim2.new(1, -20, 1, -20)
Resizer.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Resizer.Text = ""
Resizer.BorderSizePixel = 0
Resizer.Parent = Main
Instance.new("UICorner", Resizer).CornerRadius = UDim.new(0, 4)

local resizeDrag = false
local resizeStart
Resizer.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        resizeDrag = true
        resizeStart = {x = i.Position.X, y = i.Position.Y, sx = Main.AbsoluteSize.X, sy = Main.AbsoluteSize.Y}
    end
end)
UserInput.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then resizeDrag = false end
end)
UserInput.InputChanged:Connect(function(i)
    if resizeDrag and i.UserInputType == Enum.UserInputType.MouseMovement then
        local dx = i.Position.X - resizeStart.x
        local dy = i.Position.Y - resizeStart.y
        Main.Size = UDim2.new(0, math.max(320, resizeStart.sx + dx), 0, math.max(180, resizeStart.sy + dy))
    end
end)

-- ============ GUI HELPERS ============
local function makeHeader(text)
    local h = Instance.new("TextLabel")
    h.Size = UDim2.new(1, 0, 0, 26)
    h.BackgroundColor3 = Color3.fromRGB(32, 32, 46)
    h.BorderSizePixel = 0
    h.Text = "  ▸ " .. text
    h.TextColor3 = Color3.fromRGB(0, 170, 255)
    h.Font = Enum.Font.GothamBold
    h.TextSize = 13
    h.TextXAlignment = Enum.TextXAlignment.Left
    h.Parent = Scroll
    Instance.new("UICorner", h).CornerRadius = UDim.new(0, 6)
end

local function updateKB(btn, key)
    if key then
        btn.Text = "["..key.Name.."]"
        btn.TextColor3 = Color3.fromRGB(0, 170, 255)
    else
        btn.Text = "Клавиша: -"
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end

local function makeToggleRow(name, st, callback)
    st.onToggle = callback
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 36)
    row.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    row.BorderSizePixel = 0
    row.Parent = Scroll
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.5, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local kbBtn = Instance.new("TextButton")
    kbBtn.Size = UDim2.new(0, 100, 0, 26)
    kbBtn.Position = UDim2.new(1, -158, 0.5, -13)
    kbBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    kbBtn.BorderSizePixel = 0
    kbBtn.Font = Enum.Font.Gotham
    kbBtn.TextSize = 11
    kbBtn.Parent = row
    Instance.new("UICorner", kbBtn).CornerRadius = UDim.new(0, 6)
    updateKB(kbBtn, st.key)

    kbBtn.MouseButton1Click:Connect(function()
        if awaitingKey and awaitingKey.btn then updateKB(awaitingKey.btn, awaitingKey.st.key) end
        awaitingKey = {st = st, btn = kbBtn}
        kbBtn.Text = "Нажми..."
        kbBtn.TextColor3 = Color3.fromRGB(255, 200, 0)
    end)

    local tgBtn = Instance.new("TextButton")
    tgBtn.Size = UDim2.new(0, 50, 0, 26)
    tgBtn.Position = UDim2.new(1, -54, 0.5, -13)
    tgBtn.BorderSizePixel = 0
    tgBtn.Font = Enum.Font.GothamBold
    tgBtn.TextSize = 11
    tgBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tgBtn.Parent = row
    Instance.new("UICorner", tgBtn).CornerRadius = UDim.new(0, 6)

    local function refresh()
        if st.enabled then
            tgBtn.Text = "ON"
            tgBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 70)
        else
            tgBtn.Text = "OFF"
            tgBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
        end
    end

    tgBtn.MouseButton1Click:Connect(function()
        st.enabled = not st.enabled
        refresh()
        if st.onToggle then st.onToggle(st.enabled) end
    end)

    st.toggleUI = function()
        st.enabled = not st.enabled
        refresh()
        if st.onToggle then st.onToggle(st.enabled) end
    end
    refresh()
end

local function makeSliderRow(name, st, min, max, vKey)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 48)
    row.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    row.BorderSizePixel = 0
    row.Parent = Scroll
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 18)
    lbl.Position = UDim2.new(0, 12, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.Text = name .. ": " .. tostring(st[vKey])
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -20, 0, 12)
    bar.Position = UDim2.new(0, 10, 0, 28)
    bar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    bar.BorderSizePixel = 0
    bar.Parent = row
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 6)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((st[vKey]-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    fill.BorderSizePixel = 0
    fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 6)

    local drag = false
    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true end
    end)
    UserInput.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
    end)
    UserInput.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            local v = math.floor(min + (max - min) * rel)
            st[vKey] = v
            lbl.Text = name .. ": " .. v
        end
    end)
end

local function makeButton(name, cb, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 34)
    b.BackgroundColor3 = color or Color3.fromRGB(40, 90, 160)
    b.BorderSizePixel = 0
    b.Text = name
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.Parent = Scroll
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function()
        local ok, err = pcall(cb)
        if not ok then warn("[Yaroslav] "..tostring(err)) end
    end)
    return b
end

-- ============ FEATURE: FLY ============
local function startFly()
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if flyBV then flyBV:Destroy() end
    if flyBG then flyBG:Destroy() end
    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    flyBV.Velocity = Vector3.zero
    flyBV.Parent = hrp
    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    flyBG.P = 15000
    flyBG.D = 800
    flyBG.Parent = hrp
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = true end
end

local function stopFly()
    if flyBV then flyBV:Destroy() flyBV = nil end
    if flyBG then flyBG:Destroy() flyBG = nil end
    local char = lp.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end

-- ============ FEATURE: VISUALS ============
local function clearVisuals()
    if hlFolder then hlFolder:Destroy() hlFolder = nil end
    if espFolder then espFolder:Destroy() espFolder = nil end
end

local function createVisuals()
    clearVisuals()
    hlFolder = Instance.new("Folder", ScreenGui) hlFolder.Name = "HL"
    espFolder = Instance.new("Folder", ScreenGui) espFolder.Name = "ESP"
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= lp and plr.Character then
            local char = plr.Character
            if State.highlight.enabled then
                local h = Instance.new("Highlight")
                h.FillColor = Color3.fromRGB(0, 170, 255)
                h.OutlineColor = Color3.fromRGB(255, 255, 255)
                h.FillTransparency = 0.55
                h.Adornee = char
                h.Parent = hlFolder
            end
            if State.esp.enabled then
                local head = char:FindFirstChild("Head")
                if head then
                    local bb = Instance.new("BillboardGui")
                    bb.Size = UDim2.new(0, 220, 0, 46)
                    bb.StudsOffset = Vector3.new(0, 3, 0)
                    bb.AlwaysOnTop = true
                    bb.Adornee = head
                    bb.Parent = espFolder
                    local n = Instance.new("TextLabel", bb)
                    n.Size = UDim2.new(1, 0, 0.55, 0)
                    n.BackgroundTransparency = 1
                    n.Text = plr.Name
                    n.TextColor3 = Color3.fromRGB(0, 170, 255)
                    n.TextStrokeTransparency = 0
                    n.Font = Enum.Font.GothamBold
                    n.TextSize = 14
                    local d = Instance.new("TextLabel", bb)
                    d.Name = "Dist"
                    d.Size = UDim2.new(1, 0, 0.45, 0)
                    d.Position = UDim2.new(0, 0, 0.55, 0)
                    d.BackgroundTransparency = 1
                    d.Text = "0m"
                    d.TextColor3 = Color3.fromRGB(255, 255, 255)
                    d.TextStrokeTransparency = 0
                    d.Font = Enum.Font.Gotham
                    d.TextSize = 12
                end
            end
        end
    end
end

local function refreshVisuals()
    if State.highlight.enabled or State.esp.enabled then createVisuals() else clearVisuals() end
end

-- ============ FEATURE: ANIMATIONS ============
local function getShoulderMotor(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return nil end
    local isR6 = hum.RigType == Enum.HumanoidRigType.R6
    local container
    if isR6 then container = char:FindFirstChild("Torso")
    else container = char:FindFirstChild("UpperTorso") end
    if not container then return nil end
    return container:FindFirstChild("Right Shoulder") or container:FindFirstChild("RightShoulder"), isR6
end

local function startAnimSetup()
    animChar = lp.Character
    if not animChar then return end
    anim534M, animIsR6 = getShoulderMotor(animChar)
    anim342M = anim534M
end

-- ============ FEATURE: FREECAM ============
local function startFreecam()
    local cam = workspace.CurrentCamera
    freecamPos = cam.CFrame
    cam.CameraType = Enum.CameraType.Scriptable
    freecamConn = RunService.RenderStepped:Connect(function(dt)
        if not State.freecam.enabled then return end
        local speed = 60 * dt
        if UserInput:IsKeyDown(Enum.KeyCode.LeftShift) then speed = speed * 3 end
        local move = Vector3.zero
        if UserInput:IsKeyDown(Enum.KeyCode.W) then move += freecamPos.LookVector end
        if UserInput:IsKeyDown(Enum.KeyCode.S) then move -= freecamPos.LookVector end
        if UserInput:IsKeyDown(Enum.KeyCode.A) then move -= freecamPos.RightVector end
        if UserInput:IsKeyDown(Enum.KeyCode.D) then move += freecamPos.RightVector end
        if UserInput:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
        if UserInput:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end
        freecamPos = freecamPos + move * speed
        cam.CFrame = freecamPos
    end)
end

local function stopFreecam()
    if freecamConn then freecamConn:Disconnect() freecamConn = nil end
    workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    local char = lp.Character
    if char and char:FindFirstChild("Humanoid") then
        workspace.CurrentCamera.CameraSubject = char.Humanoid
    end
end

-- ============ TOGGLE CALLBACKS ============
State.fly.onToggle = function(en) if en then startFly() else stopFly() end end
State.freecam.onToggle = function(en) if en then startFreecam() else stopFreecam() end end
State.highlight.onToggle = refreshVisuals
State.esp.onToggle = refreshVisuals
State.anim534.onToggle = function(en) if en then startAnimSetup() end end
State.anim342.onToggle = function(en) if en then startAnimSetup() end end

-- Speed spoof (metatable hook) — очень ненадёжно, только для демонстрации
State.speedSpoof.onToggle = function(en)
    if not hasRawMeta then
        -- fallback: будем просто писать WalkSpeed в цикле
        return
    end
    if en then
        pcall(function()
            local mt = getrawmetatable(game)
            local old = mt.__index
            if hasHookMeta then
                hookmetamethod(game, "__index", newcclosure(function(self, k)
                    if State.speedSpoof.enabled and self == lp.Character then
                        if k == "HumanoidRootPart" then end
                    end
                    return old(self, k)
                end))
            end
        end)
    end
end

-- ============ BUILD MENU ============
makeHeader("ДВИЖЕНИЕ")
makeToggleRow("Скорость", State.speed)
makeSliderRow("Скорость (ед)", State.speed, 16, 300, "value")
makeToggleRow("Прыжок", State.jump)
makeSliderRow("Прыжок (ед)", State.jump, 50, 500, "value")
makeToggleRow("Полёт (WASD+Space)", State.fly)
makeSliderRow("Скорость полёта", State.fly, 10, 500, "speed")
makeToggleRow("Noclip", State.noclip)
makeToggleRow("Freecam (LShift ускор)", State.freecam)

makeHeader("ЗАЩИТА")
makeToggleRow("Бессмертие", State.godmode)
makeToggleRow("Speed Spoof (Anti-AC)", State.speedSpoof)

makeHeader("ВИЗУАЛ")
makeToggleRow("Подсветка игроков", State.highlight)
makeToggleRow("ESP (ник + дист.)", State.esp)

makeHeader("ТРАНСПОРТ")
makeToggleRow("Ускорение транспорта", State.vehicle)
makeSliderRow("Скорость транспорта", State.vehicle, 50, 1500, "value")

makeHeader("АНИМАЦИИ")
makeToggleRow("Анимация 534 (тряска)", State.anim534)
makeToggleRow("Анимация 342 (палка)", State.anim342)

makeHeader("РЕЙДЖ / ПВП")
makeButton("💀 Kill All (NPC + флинг)", function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= lp and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum then
                pcall(function()
                    local bv = Instance.new("BodyAngularVelocity")
                    bv.AngularVelocity = Vector3.new(9999,9999,9999)
                    bv.MaxTorque = Vector3.new(1e9,1e9,1e9)
                    bv.Parent = hrp
                    task.delay(1, function() bv:Destroy() end)
                end)
                pcall(function() hum.Health = 0 end)
            end
        end
    end
    -- NPC
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Humanoid") and v.Parent ~= lp.Character then
            pcall(function() v.Health = 0 end)
        end
    end
end, Color3.fromRGB(160, 40, 40))

makeButton("🌀 Fling All (закрутить)", function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= lp and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                pcall(function()
                    local bv = Instance.new("BodyAngularVelocity")
                    bv.AngularVelocity = Vector3.new(5000,5000,5000)
                    bv.MaxTorque = Vector3.new(1e9,1e9,1e9)
                    bv.Parent = hrp
                    task.delay(2, function() bv:Destroy() end)
                end)
            end
        end
    end
end, Color3.fromRGB(160, 90, 40))

makeButton("🎯 Притянуть инструменты (Bring Items)", function()
    local cnt = 0
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Tool") then
            pcall(function()
                v.Parent = lp.Backpack
                cnt += 1
            end)
        end
    end
    print("[Yaroslav] Притянуто инструментов: "..cnt)
end, Color3.fromRGB(60, 130, 60))

makeButton("💎 Авто-кража предметов", function()
    task.spawn(function()
        for i = 1, 20 do
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("Tool") or (v:IsA("BasePart") and v.Name:lower():find("drop")) then
                    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and v:IsA("BasePart") then
                        pcall(function()
                            firetouchinterest(hrp, v, 0)
                            firetouchinterest(hrp, v, 1)
                        end)
                    elseif v:IsA("Tool") then
                        pcall(function() v.Parent = lp.Backpack end)
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end, Color3.fromRGB(60, 130, 60))

makeButton("🔍 Найти скрытые объекты (getnilinstances)", function()
    if not hasNilInst then
        print("[Yaroslav] Инжектор не поддерживает getnilinstances")
        return
    end
    local list = getnilinstances()
    print("[Yaroslav] Скрытых объектов: "..tostring(#list))
    for i = 1, math.min(#list, 30) do
        print("  "..i..": "..tostring(list[i] and list[i].ClassName).." | "..tostring(list[i] and list[i].Name))
    end
end, Color3.fromRGB(80, 80, 160))

makeHeader("📊 ЛИДЕРСТАТЫ (выдать значение)")

-- Динамический список лидерстатов
local LSFrame = Instance.new("Frame")
LSFrame.Size = UDim2.new(1, 0, 0, 200)
LSFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
LSFrame.BorderSizePixel = 0
LSFrame.Parent = Scroll
Instance.new("UICorner", LSFrame).CornerRadius = UDim.new(0, 6)

local LSList = Instance.new("ScrollingFrame")
LSList.Size = UDim2.new(1, -8, 1, -8)
LSList.Position = UDim2.new(0, 4, 0, 4)
LSList.BackgroundTransparency = 1
LSList.BorderSizePixel = 0
LSList.ScrollBarThickness = 3
LSList.CanvasSize = UDim2.new(0, 0, 0, 0)
LSList.AutomaticCanvasSize = Enum.AutomaticSize.Y
LSList.Parent = LSFrame
local LSL = Instance.new("UIListLayout", LSList)
LSL.Padding = UDim.new(0, 4)

local function refreshLeaderstats()
    for _, c in ipairs(LSList:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    local ls = lp:FindFirstChild("leaderstats")
    if not ls then
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 24)
        lbl.BackgroundTransparency = 1
        lbl.Text = "leaderstats не найден"
        lbl.TextColor3 = Color3.fromRGB(180, 180, 180)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.Parent = LSList
        return
    end
    for _, stat in ipairs(ls:GetChildren()) do
        if stat:IsA("IntValue") or stat:IsA("NumberValue") or stat:IsA("StringValue") then
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 30)
            row.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
            row.BorderSizePixel = 0
            row.Parent = LSList
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)

            local n = Instance.new("TextLabel", row)
            n.Size = UDim2.new(0, 100, 1, 0)
            n.Position = UDim2.new(0, 6, 0, 0)
            n.BackgroundTransparency = 1
            n.Text = stat.Name..": "..tostring(stat.Value)
            n.TextColor3 = Color3.fromRGB(255, 255, 255)
            n.Font = Enum.Font.Gotham
            n.TextSize = 11
            n.TextXAlignment = Enum.TextXAlignment.Left

            local tb = Instance.new("TextBox", row)
            tb.Size = UDim2.new(0, 90, 0, 22)
            tb.Position = UDim2.new(1, -160, 0.5, -11)
            tb.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
            tb.BorderSizePixel = 0
            tb.Text = ""
            tb.PlaceholderText = "значение"
            tb.TextColor3 = Color3.fromRGB(255, 255, 255)
            tb.Font = Enum.Font.Gotham
            tb.TextSize = 11
            Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 4)

            local sb = Instance.new("TextButton", row)
            sb.Size = UDim2.new(0, 55, 0, 22)
            sb.Position = UDim2.new(1, -64, 0.5, -11)
            sb.BackgroundColor3 = Color3.fromRGB(0, 130, 200)
            sb.BorderSizePixel = 0
            sb.Text = "Set"
            sb.TextColor3 = Color3.fromRGB(255, 255, 255)
            sb.Font = Enum.Font.GothamBold
            sb.TextSize = 11
            Instance.new("UICorner", sb).CornerRadius = UDim.new(0, 4)

            sb.MouseButton1Click:Connect(function()
                local v = tonumber(tb.Text)
                if not v then return end
                pcall(function()
                    if stat:IsA("StringValue") then stat.Value = tb.Text
                    else stat.Value = v end
                end)
                n.Text = stat.Name..":"..tostring(stat.Value)
            end)
        end
    end
end

refreshLeaderstats()

makeButton("🔄 Обновить список счётчиков", refreshLeaderstats, Color3.fromRGB(60, 60, 120))

-- ============ MINIMIZE / CLOSE ============
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        Scroll.Visible = false
        Resizer.Visible = false
        Main.Size = UDim2.new(0, 460, 0, 40)
        MinBtn.Text = "▢"
    else
        Scroll.Visible = true
        Resizer.Visible = true
        Main.Size = UDim2.new(0, 460, 0, 580)
        MinBtn.Text = "—"
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    -- выключить всё на всякий случай
    for _, st in pairs(State) do
        if st.enabled and st.toggleUI then st.toggleUI() end
    end
end)

-- ============ INPUT ============
UserInput.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        Main.Visible = not Main.Visible
        return
    end
    if awaitingKey then
        if input.KeyCode == Enum.KeyCode.Escape then
            awaitingKey.st.key = nil
            updateKB(awaitingKey.btn, nil)
        else
            awaitingKey.st.key = input.KeyCode
            updateKB(awaitingKey.btn, input.KeyCode)
        end
        awaitingKey = nil
        return
    end
    for _, st in pairs(State) do
        if st.key and st.toggleUI and input.KeyCode == st.key then
            st.toggleUI()
        end
    end
end)

-- ============ LOOPS ============
-- Speed / Jump / Godmode
task.spawn(function()
    while task.wait(0.15) do
        local char = lp.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                if State.speed.enabled then hum.WalkSpeed = State.speed.value end
                if State.jump.enabled then
                    hum.UseJumpPower = true
                    hum.JumpPower = State.jump.value
                end
                if State.godmode.enabled then
                    hum.MaxHealth = math.huge
                    if hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
                end
            end
        end
    end
end)

-- Noclip
RunService.Stepped:Connect(function()
    if not State.noclip.enabled then return end
    local char = lp.Character
    if not char then return end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
    end
end)

-- Fly move
RunService.Heartbeat:Connect(function()
    if not State.fly.enabled or not flyBV or not flyBG then return end
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local cam = workspace.CurrentCamera
    local mv = Vector3.zero
    if UserInput:IsKeyDown(Enum.KeyCode.W) then mv += cam.CFrame.LookVector end
    if UserInput:IsKeyDown(Enum.KeyCode.S) then mv -= cam.CFrame.LookVector end
    if UserInput:IsKeyDown(Enum.KeyCode.A) then mv -= cam.CFrame.RightVector end
    if UserInput:IsKeyDown(Enum.KeyCode.D) then mv += cam.CFrame.RightVector end
    if UserInput:IsKeyDown(Enum.KeyCode.Space) then mv += Vector3.new(0,1,0) end
    if UserInput:IsKeyDown(Enum.KeyCode.LeftControl) then mv -= Vector3.new(0,1,0) end
    flyBV.Velocity = mv * State.fly.speed
    flyBG.CFrame = cam.CFrame
end)

-- ESP distance
RunService.RenderStepped:Connect(function()
    if not State.esp.enabled or not espFolder then return end
    local myHrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end
    for _, bb in ipairs(espFolder:GetChildren()) do
        if bb:IsA("BillboardGui") and bb.Adornee then
            local d = bb:FindFirstChild("Dist")
            if d then d.Text = math.floor((myHrp.Position - bb.Adornee.Position).Magnitude).."m" end
        end
    end
end)

-- Vehicle speed
RunService.Heartbeat:Connect(function()
    local char = lp.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local seat = hum and hum.SitPart
    local vehicle = nil
    if seat and seat:IsA("VehicleSeat") and seat.Parent then
        vehicle = seat.Parent.PrimaryPart or seat
    end
    -- cleanup
    for _, p in ipairs(workspace:GetDescendants()) do
        if p.Name == "YaroslavVehVel" and (not vehicle or p.Parent ~= vehicle) then
            p:Destroy()
        end
    end
    if not State.vehicle.enabled or not vehicle then return end
    local th = 0
    if UserInput:IsKeyDown(Enum.KeyCode.W) then th = 1 end
    if UserInput:IsKeyDown(Enum.KeyCode.S) then th = -1 end
    if th == 0 then
        local ex = vehicle:FindFirstChild("YaroslavVehVel")
        if ex then ex:Destroy() end
        return
    end
    local bv = vehicle:FindFirstChild("YaroslavVehVel")
    if not bv then
        bv = Instance.new("BodyVelocity")
        bv.Name = "YaroslavVehVel"
        bv.MaxForce = Vector3.new(1e9, 0, 1e9)
        bv.Parent = vehicle
    end
    local dir = seat.CFrame.LookVector * th
    bv.Velocity = Vector3.new(dir.X, 0, dir.Z).Unit * State.vehicle.value
end)

-- ANIMATIONS 534 / 342 — работает и для R6 и для R15
RunService.RenderStepped:Connect(function()
    if not State.anim534.enabled and not State.anim342.enabled then return end
    local char = lp.Character
    if not char then return end
    if not anim534M or not anim534M.Parent or animChar ~= char then
        startAnimSetup()
        if not anim534M then return end
    end
    local m = anim534M
    if State.anim534.enabled then
        -- рука идёт в центр + быстро дёргается вперёд-назад
        local off = math.sin(tick() * 30) * 0.75
        m.Transform = CFrame.new(-1, 0, 0) * CFrame.Angles(off, 0, 0)
    elseif State.anim342.enabled then
        -- рука как палка между ногами (статично)
        m.Transform = CFrame.new(-1, 0, 0) * CFrame.Angles(0, 0, 0)
    end
end)

-- Player join/leave
Players.PlayerAdded:Connect(function()
    task.wait(1)
    if State.highlight.enabled or State.esp.enabled then refreshVisuals() end
end)
Players.PlayerRemoving:Connect(function()
    task.wait(0.5)
    if State.highlight.enabled or State.esp.enabled then refreshVisuals() end
end)

-- Respawn
lp.CharacterAdded:Connect(function()
    task.wait(0.6)
    if State.fly.enabled then startFly() end
    if State.highlight.enabled or State.esp.enabled then refreshVisuals() end
    startAnimSetup()
end)

-- ============ NOTIFY ============
local n = Instance.new("TextLabel")
n.Size = UDim2.new(0, 380, 0, 44)
n.Position = UDim2.new(0.5, -190, 0, 20)
n.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
n.BorderSizePixel = 0
n.Text = "✓ v3 MEGA загружено! INSERT — меню | by laroslav7"
n.TextColor3 = Color3.fromRGB(0, 170, 255)
n.Font = Enum.Font.GothamBold
n.TextSize = 14
n.Parent = ScreenGui
Instance.new("UICorner", n).CornerRadius = UDim.new(0, 8)
local ns = Instance.new("UIStroke", n)
ns.Color = Color3.fromRGB(0, 170, 255)
ns.Thickness = 2
task.wait(4)
n:Destroy()

print("[Yaroslav v3] Загружено. rawmeta="..tostring(hasRawMeta).." hookmeta="..tostring(hasHookMeta).." nilinst="..tostring(hasNilInst))
