-- ============================================================
-- 🦅 ARCANIX (Original + Auto Shot) - Part 1
-- ============================================================

local P = game:GetService("Players")
local U = game:GetService("UserInputService")
local R = game:GetService("RunService")
local T = game:GetService("TweenService")
local L = game:GetService("Lighting")
local W = game:GetService("Workspace")
local C = game:GetService("CoreGui")
local LP = P.LocalPlayer
local Camera = W.CurrentCamera

-- ANTI-KICK
pcall(function()
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" and not checkcaller() then return nil end
        return old(self, ...)
    end)
    setreadonly(mt, true)
end)

local function protect(gui)
    if gethui then pcall(function() gui.Parent = gethui() end) 
    elseif syn and syn.protect_gui then pcall(function() syn.protect_gui(gui) end) 
    else gui.Parent = C end
end

local function corner(o, r) local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, r) c.Parent = o end
local function stroke(o, c, t, tr) local s = Instance.new("UIStroke") s.Color = c s.Thickness = t s.Transparency = tr or 0 s.Parent = o return s end

-- СИСТЕМА КЛЮЧА И БАНА
local banFile = "ArcanixBanV6.txt"
local isBanned = false
local banEndTime = 0
local hasFS = writefile and readfile and isfile

if hasFS and isfile(banFile) then
    local s, t = pcall(function() return tonumber(readfile(banFile)) end)
    if s and t and t > os.time() then isBanned = true; banEndTime = t end
end
if not isBanned and getgenv().ArcBan and getgenv().ArcBan > os.time() then isBanned = true; banEndTime = getgenv().ArcBan end

local keyGui = Instance.new("ScreenGui")
keyGui.IgnoreGuiInset = true
protect(keyGui)

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.fromRGB(10,10,15)
bg.Parent = keyGui

local tnt = Instance.new("ImageLabel")
tnt.Size = UDim2.new(0,100,0,100)
tnt.AnchorPoint = Vector2.new(0.5,0.5)
tnt.Position = UDim2.new(0.5,0,-0.2,0)
tnt.BackgroundTransparency = 1
tnt.Image = "rbxassetid://1007305922"
tnt.Parent = keyGui

local flash = Instance.new("Frame")
flash.Size = UDim2.new(1,0,1,0)
flash.BackgroundColor3 = Color3.fromRGB(255,255,255)
flash.BackgroundTransparency = 1
flash.Parent = keyGui

local kFrame = Instance.new("Frame")
kFrame.Size = UDim2.new(0,300,0,200)
kFrame.Position = UDim2.new(0.5,-150,0.5,-100)
kFrame.BackgroundColor3 = Color3.fromRGB(25,25,30)
kFrame.Visible = false
kFrame.Parent = keyGui
corner(kFrame, 12)
stroke(kFrame, Color3.fromRGB(80, 150, 255), 2)

local kTitle = Instance.new("TextLabel")
kTitle.Size = UDim2.new(1,0,0,40)
kTitle.BackgroundTransparency = 1
kTitle.Text = "🔒 ARCANIX KEY"
kTitle.TextColor3 = Color3.fromRGB(255,255,255)
kTitle.Font = Enum.Font.Arcade
kTitle.TextSize = 18
kTitle.Parent = kFrame

local kTimer = Instance.new("TextLabel")
kTimer.Size = UDim2.new(1,0,0,20)
kTimer.Position = UDim2.new(0,0,0,35)
kTimer.BackgroundTransparency = 1
kTimer.TextColor3 = Color3.fromRGB(255,200,50)
kTimer.Font = Enum.Font.Arcade
kTimer.TextSize = 14
kTimer.Parent = kFrame

local kInput = Instance.new("TextBox")
kInput.Size = UDim2.new(0,260,0,40)
kInput.Position = UDim2.new(0,20,0,60)
kInput.BackgroundColor3 = Color3.fromRGB(40,40,45)
kInput.TextColor3 = Color3.fromRGB(255,255,255)
kInput.Font = Enum.Font.Arcade
kInput.TextSize = 16
kInput.Parent = kFrame
corner(kInput, 6)

local kBtn = Instance.new("TextButton")
kBtn.Size = UDim2.new(0,260,0,40)
kBtn.Position = UDim2.new(0,20,0,110)
kBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
kBtn.Text = "ПРОВЕРИТЬ"
kBtn.TextColor3 = Color3.fromRGB(255,255,255)
kBtn.Font = Enum.Font.Arcade
kBtn.TextSize = 16
kBtn.Parent = kFrame
corner(kBtn, 6)

local kErr = Instance.new("TextLabel")
kErr.Size = UDim2.new(1,0,0,20)
kErr.Position = UDim2.new(0,0,1,-25)
kErr.BackgroundTransparency = 1
kErr.TextColor3 = Color3.fromRGB(255,80,80)
kErr.Font = Enum.Font.Arcade
kErr.TextSize = 12
kErr.Parent = kFrame

-- Анимация динамита
task.spawn(function()
    task.wait(0.5)
    T:Create(tnt, TweenInfo.new(0.6, Enum.EasingStyle.Bounce), {Position = UDim2.new(0.5,0,0.5,0)}):Play()
    task.wait(0.8)
    T:Create(flash, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    T:Create(tnt, TweenInfo.new(0.3), {Size = UDim2.new(0,300,0,300), ImageTransparency = 1}):Play()
    task.wait(0.3)
    T:Create(flash, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    kFrame.Visible = true
    tnt:Destroy()
end)

local attempts = 0
local function showBanUI()
    kInput.Text = "🔒"
    kInput.TextEditable = false
    kInput.BackgroundColor3 = Color3.fromRGB(50,50,50)
    kBtn.Active = false
    kBtn.Text = "ЗАБЛОКИРОВАНО"
    kBtn.BackgroundColor3 = Color3.fromRGB(100,50,50)
    kErr.Text = "ВЫ ЗАБЛОКИРОВАНЫ НА 24 ЧАСА"
    
    task.spawn(function()
        while isBanned do
            local t = banEndTime - os.time()
            if t <= 0 then
                isBanned = false
                if hasFS and isfile(banFile) then pcall(function() delfile(banFile) end) end
                getgenv().ArcBan = nil
                kInput.Text = ""
                kInput.TextEditable = true
                kInput.BackgroundColor3 = Color3.fromRGB(40,40,45)
                kBtn.Active = true
                kBtn.Text = "ПРОВЕРИТЬ"
                kBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
                kErr.Text = ""
                kTimer.Text = ""
                attempts = 0
                break
            end
            kTimer.Text = string.format("⏳ %02d:%02d:%02d", math.floor(t/3600), math.floor((t%3600)/60), t%60)
            task.wait(1)
        end
    end)
end
if isBanned then task.wait(2.5); showBanUI() end

local function LoadArcanix()
    keyGui:Destroy()
    -- Сюда будет вставлена Часть 2
end

kBtn.MouseButton1Click:Connect(function()
    if isBanned then return end
    if kInput.Text == "free" then
        kBtn.Text = "УСПЕХ!"
        kBtn.BackgroundColor3 = Color3.fromRGB(80,255,130)
        task.wait(0.5)
        LoadArcanix()
    else
        attempts = attempts + 1
        kErr.Text = "Неверный ключ! Попытка " .. attempts .. "/10"
        kInput.Text = ""
        
        if attempts >= 10 then
            isBanned = true
            banEndTime = os.time() + 86400
            if hasFS then pcall(function() writefile(banFile, tostring(banEndTime)) end) else getgenv().ArcBan = banEndTime end
            showBanUI()
        else
            local op = kFrame.Position
            for i = 1, 4 do
                T:Create(kFrame, TweenInfo.new(0.05), {Position = op + UDim2.new(0,10,0,0)}):Play()
                task.wait(0.05)
                T:Create(kFrame, TweenInfo.new(0.05), {Position = op - UDim2.new(0,10,0,0)}):Play()
                task.wait(0.05)
            end
            T:Create(kFrame, TweenInfo.new(0.05), {Position = op}):Play()
        end
    end
end)
-- ============================================================
-- 🦅 ARCANIX (Original + Auto Shot) - Part 2
-- ============================================================

-- ПЕРЕМЕННЫЕ СОСТОЯНИЯ
local Accent = Color3.fromRGB(80, 150, 255)
local ESP_Enabled = false
local ESP_Names = false
local ESP_TeamCheck = false
local Aim_Enabled = false
local Aim_WallCheck = true
local AutoShot_Enabled = false -- НОВАЯ ФУНКЦИЯ
local Aim_FOV = 150
local Aim_Smooth = 50
local Fly_Enabled = false
local Fly_Speed = 50
local FPS_Boost = false

local Theme = "Dark"
local Themes = {
    Dark = { Bg = Color3.fromRGB(20, 20, 25), Side = Color3.fromRGB(25, 25, 30), Text = Color3.fromRGB(240, 240, 240), Sub = Color3.fromRGB(35, 35, 40) },
    Light = { Bg = Color3.fromRGB(240, 240, 245), Side = Color3.fromRGB(220, 220, 225), Text = Color3.fromRGB(30, 30, 30), Sub = Color3.fromRGB(255, 255, 255) }
}

-- ГЛАВНОЕ ОКНО
local gui = Instance.new("ScreenGui")
gui.Name = "ArcanixMain"
gui.IgnoreGuiInset = true
protect(gui)

-- КНОПКА ОТКРЫТИЯ
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 75, 0, 60)
toggleBtn.Position = UDim2.new(0, 15, 0.5, -30)
toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
toggleBtn.Text = "ARCANIX\nv2.0"
toggleBtn.TextColor3 = Accent
toggleBtn.Font = Enum.Font.Arcade
toggleBtn.TextSize = 13
toggleBtn.TextWrapped = true
toggleBtn.AutoButtonColor = false
toggleBtn.Parent = gui
corner(toggleBtn, 12)
stroke(toggleBtn, Accent, 2)

-- ОКНО МЕНЮ
local win = Instance.new("CanvasGroup")
win.AnchorPoint = Vector2.new(0.5, 0.5)
win.Position = UDim2.new(0.5, 0, 0.5, 0)
win.Size = UDim2.new(0, 520, 0, 340)
win.BackgroundColor3 = Themes[Theme].Bg
win.GroupTransparency = 1
win.Visible = false
win.ClipsDescendants = true
win.Parent = gui
corner(win, 12)
stroke(win, Color3.fromRGB(50, 50, 60), 1.5)

local uiScale = Instance.new("UIScale")
uiScale.Scale = 1
uiScale.Parent = win

-- САЙДБАР
local side = Instance.new("Frame")
side.Size = UDim2.new(0, 150, 1, 0)
side.BackgroundColor3 = Themes[Theme].Side
side.BorderSizePixel = 0
side.Parent = win

local logo = Instance.new("TextLabel")
logo.Size = UDim2.new(1, 0, 0, 45)
logo.BackgroundTransparency = 1
logo.Text = "ARCANIX"
logo.TextColor3 = Accent
logo.Font = Enum.Font.Arcade
logo.TextSize = 20
logo.Parent = side

-- ПРОФИЛЬ ИГРОКА (Ник и Аватарка)
local profileFrame = Instance.new("Frame")
profileFrame.Size = UDim2.new(1, -20, 0, 45)
profileFrame.Position = UDim2.new(0, 10, 1, -55)
profileFrame.BackgroundColor3 = Themes[Theme].Sub
profileFrame.Parent = side
corner(profileFrame, 8)

local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.new(0, 30, 0, 30)
avatar.Position = UDim2.new(0, 8, 0.5, -15)
avatar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LP.UserId .. "&w=150&h=150"
avatar.Parent = profileFrame
corner(avatar, 15)

local pName = Instance.new("TextLabel")
pName.Size = UDim2.new(1, -45, 1, 0)
pName.Position = UDim2.new(0, 45, 0, 0)
pName.BackgroundTransparency = 1
pName.Text = LP.Name
pName.TextColor3 = Accent
pName.Font = Enum.Font.Arcade
pName.TextSize = 13
pName.TextXAlignment = Enum.TextXAlignment.Left
pName.TextTruncate = Enum.TextTruncate.AtEnd
pName.Parent = profileFrame

-- КОНТЕНТ
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -160, 1, -20)
content.Position = UDim2.new(0, 155, 0, 10)
content.BackgroundTransparency = 1
content.Parent = win

-- СТРАНИЦЫ
local pages = {}
local function makePage(name, visible)
    local p = Instance.new("ScrollingFrame")
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.ScrollBarThickness = 2
    p.ScrollBarImageColor3 = Accent
    p.CanvasSize = UDim2.new(0, 0, 0, 0)
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    p.Visible = visible
    p.Parent = content
    local l = Instance.new("UIListLayout")
    l.Padding = UDim.new(0, 8)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.Parent = p
    pages[name] = p
end

makePage("ESP", true)
makePage("AimBot", false)
makePage("Misc", false)
makePage("Settings", false)

-- ВКЛАДКИ
local tabESP, tabAim, tabMisc, tabSet
local function makeTab(name, text, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Themes[Theme].Sub
    btn.Text = text
    btn.TextColor3 = Themes[Theme].Text
    btn.Font = Enum.Font.Arcade
    btn.TextSize = 13
    btn.Parent = side
    corner(btn, 8)
    
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        pages[name].Visible = true
        for _, v in pairs(side:GetChildren()) do
            if v:IsA("TextButton") and v ~= toggleBtn then
                T:Create(v, TweenInfo.new(0.2), {BackgroundColor3 = Themes[Theme].Sub, TextColor3 = Themes[Theme].Text}):Play()
            end
        end
        T:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Accent, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
    end)
    return btn
end

tabESP = makeTab("ESP", "Визуалы", 50)
tabAim = makeTab("AimBot", "AimBot", 90)
tabMisc = makeTab("Misc", "Misc", 130)
tabSet = makeTab("Settings", "Настройки", 170)

tabESP.BackgroundColor3 = Accent
tabESP.TextColor3 = Color3.fromRGB(255, 255, 255)

-- КОМПОНЕНТЫ UI
local function createToggle(parent, txt, default, cb)
    local h = Instance.new("Frame")
    h.Size = UDim2.new(1, 0, 0, 38)
    h.BackgroundColor3 = Themes[Theme].Sub
    h.Parent = parent
    corner(h, 8)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -50, 1, 0)
    l.Position = UDim2.new(0, 12, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = txt
    l.TextColor3 = Themes[Theme].Text
    l.Font = Enum.Font.Arcade
    l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = h

    local sw = Instance.new("Frame")
    sw.Size = UDim2.new(0, 34, 0, 18)
    sw.Position = UDim2.new(1, -46, 0.5, -9)
    sw.BackgroundColor3 = default and Accent or Color3.fromRGB(60, 60, 65)
    sw.Parent = h
    corner(sw, 9)

    local kn = Instance.new("Frame")
    kn.Size = UDim2.new(0, 14, 0, 14)
    kn.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    kn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    kn.Parent = sw
    corner(kn, 7)

    local isOn = default
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = h
    btn.MouseButton1Click:Connect(function()
        isOn = not isOn
        local tp = isOn and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        local tc = isOn and Accent or Color3.fromRGB(60, 60, 65)
        T:Create(kn, TweenInfo.new(0.2), {Position = tp}):Play()
        T:Create(sw, TweenInfo.new(0.2), {BackgroundColor3 = tc}):Play()
        if cb then cb(isOn) end
    end)
    return h
end

local function createSlider(parent, txt, minV, maxV, default, cb)
    local h = Instance.new("Frame")
    h.Size = UDim2.new(1, 0, 0, 46)
    h.BackgroundColor3 = Themes[Theme].Sub
    h.Parent = parent
    corner(h, 8)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -80, 0, 18)
    l.Position = UDim2.new(0, 12, 0, 4)
    l.BackgroundTransparency = 1
    l.Text = txt
    l.TextColor3 = Themes[Theme].Text
    l.Font = Enum.Font.Arcade
    l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = h

    local vl = Instance.new("TextLabel")
    vl.Size = UDim2.new(0, 60, 0, 18)
    vl.Position = UDim2.new(1, -70, 0, 4)
    vl.BackgroundTransparency = 1
    vl.Text = tostring(default)
    vl.TextColor3 = Accent
    vl.Font = Enum.Font.Arcade
    vl.TextSize = 14
    vl.TextXAlignment = Enum.TextXAlignment.Right
    vl.Parent = h

    local tr = Instance.new("Frame")
    tr.Size = UDim2.new(1, -24, 0, 6)
    tr.Position = UDim2.new(0, 12, 1, -14)
    tr.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    tr.Parent = h
    corner(tr, 3)

    local fl = Instance.new("Frame")
    fl.Size = UDim2.new((default - minV) / (maxV - minV), 0, 1, 0)
    fl.BackgroundColor3 = Accent
    fl.Parent = tr
    corner(fl, 3)

    local kn = Instance.new("Frame")
    kn.Size = UDim2.new(0, 14, 0, 14)
    kn.AnchorPoint = Vector2.new(0.5, 0.5)
    kn.Position = UDim2.new((default - minV) / (maxV - minV), 0, 0.5, 0)
    kn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    kn.Parent = tr
    corner(kn, 7)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -24, 0, 24)
    btn.Position = UDim2.new(0, 12, 1, -24)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = h

    local drag = false
    local function update(x)
        local rel = math.clamp((x - tr.AbsolutePosition.X) / tr.AbsoluteSize.X, 0, 1)
        local val = math.floor(minV + (maxV - minV) * rel + 0.5)
        fl.Size = UDim2.new(rel, 0, 1, 0)
        kn.Position = UDim2.new(rel, 0, 0.5, 0)
        vl.Text = tostring(val)
        if cb then cb(val) end
    end

    btn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = true; update(i.Position.X) end end)
    U.InputChanged:Connect(function(i) if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then update(i.Position.X) end end)
    U.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end end)
    return h
end

-- НАПОЛНЕНИЕ ВКЛАДОК (Интерфейс)
-- ESP
createToggle(pages["ESP"], "Включить ESP", false, function(v) ESP_Enabled = v end)
createToggle(pages["ESP"], "Показывать Ники", false, function(v) ESP_Names = v end)
createToggle(pages["ESP"], "Игнорировать союзников", false, function(v) ESP_TeamCheck = v end)

-- AIMBOT (С Auto Shot)
createToggle(pages["AimBot"], "Включить AimBot", false, function(v) Aim_Enabled = v end)
createToggle(pages["AimBot"], "Wall-Check", true, function(v) Aim_WallCheck = v end)
createToggle(pages["AimBot"], "Auto Shot (Мгновенный выстрел)", false, function(v) AutoShot_Enabled = v end)
createSlider(pages["AimBot"], "FOV (Радиус)", 50, 400, 150, function(v) Aim_FOV = v end)
createSlider(pages["AimBot"], "Сила лока (100 = СНАП)", 1, 100, 50, function(v) Aim_Smooth = v end)

-- MISC
local flySlider
createToggle(pages["Misc"], "Fly (Полет)", false, function(v) 
    Fly_Enabled = v 
    if flySlider then flySlider.Visible = v end 
end)
flySlider = createSlider(pages["Misc"], "Скорость полета", 10, 200, 50, function(v) Fly_Speed = v end)
flySlider.Visible = false

createToggle(pages["Misc"], "FPS Boost", false, function(v) 
    FPS_Boost = v 
    if v then
        L.GlobalShadows = false
        L.FogEnd = 100000
        L.Brightness = 2
        L.EnvironmentDiffuseScale = 0
        L.EnvironmentSpecularScale = 0
    else
        L.GlobalShadows = true
        L.FogEnd = 10000
        L.Brightness = 3
        L.EnvironmentDiffuseScale = 0.5
        L.EnvironmentSpecularScale = 0.5
    end
end)
-- ============================================================
-- 🦅 ARCANIX (Original + Auto Shot) - Part 3
-- ============================================================

local CurrentTarget = nil
local isAiming = false
local flyVel = nil

-- КРУГ FOV
local fovCircle = Instance.new("Frame")
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
fovCircle.Size = UDim2.new(0, Aim_FOV * 2, 0, Aim_FOV * 2)
fovCircle.BackgroundTransparency = 1
fovCircle.Visible = false
fovCircle.Parent = gui
corner(fovCircle, 9999)
stroke(fovCircle, Accent, 1.5, 0.3)

-- АНИМАЦИЯ И ПЕРЕТАСКИВАНИЕ
local function drag(frame, target)
    local d, s, p
    target.InputBegan:Connect(function(i) 
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
            d = true; s = i.Position; p = frame.Position 
        end 
    end)
    U.InputChanged:Connect(function(i) 
        if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then 
            local delta = i.Position - s 
            frame.Position = UDim2.new(p.X.Scale, p.X.Offset + delta.X, p.Y.Scale, p.Y.Offset + delta.Y) 
        end 
    end)
    U.InputEnded:Connect(function(i) 
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
            d = false 
        end 
    end)
end
drag(win, side)
drag(toggleBtn, toggleBtn)

local isOpen = false
local function toggleMenu(open)
    if open and not isOpen then
        isOpen = true
        win.Visible = true
        win.GroupTransparency = 1
        uiScale.Scale = 0.3
        T:Create(win, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {GroupTransparency = 0}):Play()
        T:Create(uiScale, TweenInfo.new(0.5, Enum.EasingStyle.Elastic), {Scale = 1}):Play()
    elseif not open and isOpen then
        isOpen = false
        local t1 = T:Create(win, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {GroupTransparency = 1})
        local t2 = T:Create(uiScale, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Scale = 0.3})
        t1:Play(); t2:Play()
        t1.Completed:Connect(function()
            if not isOpen then win.Visible = false end
        end)
    end
end

toggleBtn.MouseButton1Click:Connect(function()
    toggleMenu(not isOpen)
end)

-- ==========================================
-- ЛОГИКА ESP
-- ==========================================
local ActiveESP = {}

local function createESP(plr)
    if plr == LP or (ESP_TeamCheck and plr.Team == LP.Team) then return end
    local char = plr.Character
    if not char then return end
    if ActiveESP[plr] then
        ActiveESP[plr].hl:Destroy()
        ActiveESP[plr].bb:Destroy()
    end

    local hl = Instance.new("Highlight")
    hl.Adornee = char
    hl.FillColor = Accent
    hl.FillTransparency = 0.5
    hl.OutlineColor = Accent
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = C

    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.new(0, 200, 0, 50)
    bb.StudsOffset = Vector3.new(0, 2.5, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = char:FindFirstChild("Head") or char
    bb.Parent = C

    local nl = Instance.new("TextLabel")
    nl.Size = UDim2.new(1, 0, 1, 0)
    nl.BackgroundTransparency = 1
    nl.Text = plr.Name
    nl.TextColor3 = Accent
    nl.TextStrokeTransparency = 0
    nl.TextSize = 14
    nl.Font = Enum.Font.Arcade
    nl.Parent = bb

    ActiveESP[plr] = { hl = hl, bb = bb, char = char }
end

R.Heartbeat:Connect(function()
    if not ESP_Enabled then
        for _, data in pairs(ActiveESP) do
            data.hl:Destroy()
            data.bb:Destroy()
        end
        ActiveESP = {}
        return
    end
    for _, plr in ipairs(P:GetPlayers()) do
        if plr ~= LP and plr.Character then
            if not ActiveESP[plr] or ActiveESP[plr].char ~= plr.Character then
                createESP(plr)
            else
                ActiveESP[plr].bb.Enabled = ESP_Names
            end
        end
    end
end)

P.PlayerRemoving:Connect(function(p)
    if ActiveESP[p] then
        ActiveESP[p].hl:Destroy()
        ActiveESP[p].bb:Destroy()
        ActiveESP[p] = nil
    end
end)

-- ==========================================
-- ЛОГИКА AIMBOT И AUTO SHOT
-- ==========================================
U.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.UserInputType == Enum.UserInputType.MouseButton2 then isAiming = true end
end)
U.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton2 then isAiming = false end
end)

local function hasLineOfSight(targetPart)
    if not Aim_WallCheck then return true end
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {LP.Character, Camera}
    local rayResult = W:Raycast(origin, direction, rayParams)
    if not rayResult then return true end
    if rayResult.Instance:IsDescendantOf(targetPart.Parent) then return true end
    return false
end

local function getTarget()
    -- Если уже есть цель и она жива
    if CurrentTarget and CurrentTarget.Parent and CurrentTarget.Parent:FindFirstChildOfClass("Humanoid") and CurrentTarget.Parent.Humanoid.Health > 0 then
        if hasLineOfSight(CurrentTarget) then return CurrentTarget end
    end
    
    CurrentTarget = nil
    local closest, shortest = nil, Aim_FOV
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    
    for _, plr in ipairs(P:GetPlayers()) do
        if plr ~= LP and (not ESP_TeamCheck or plr.Team ~= LP.Team) then
            local char = plr.Character
            if char then
                local targetPart = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if targetPart and hum and hum.Health > 0 then
                    local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if d < shortest then
                            if hasLineOfSight(targetPart) then
                                shortest = d
                                closest = targetPart
                            end
                        end
                    end
                end
            end
        end
    end
    CurrentTarget = closest
    return CurrentTarget
end

-- Хранилище для кулдауна выстрела
local lastShotTime = 0

R.RenderStepped:Connect(function(dt)
    fovCircle.Visible = Aim_Enabled
    if Aim_Enabled then
        fovCircle.Size = UDim2.new(0, Aim_FOV * 2, 0, Aim_FOV * 2)
        fovCircle.UIStroke.Color = Accent
    end

    if not Aim_Enabled then CurrentTarget = nil; return end
    
    local active = false
    if isAiming or true then -- Упрощенный режим, можно добавить настройки позже
        active = true
    end
    
    if not active then CurrentTarget = nil; return end
    
    local target = getTarget()
    
    -- ЛОГИКА АИМБОТА (Наведение камеры)
    if target then
        local current = Camera.CFrame
        local desired = CFrame.new(current.Position, target.Position)
        
        if Aim_Smooth >= 99 then
            Camera.CFrame = desired
        else
            local smooth = Aim_Smooth / 100
            local alpha = 1 - math.pow(1 - smooth, dt * 60)
            Camera.CFrame = current:Lerp(desired, alpha)
        end
        
        -- ЛОГИКА AUTO SHOT (Мгновенный выстрел)
        if AutoShot_Enabled and tick() - lastShotTime > 0.1 then
            local tool = LP.Character:FindFirstChildOfClass("Tool")
            if tool then
                pcall(function()
                    tool:Activate() -- Универсальный клик для оружия в Роблоксе
                end)
                lastShotTime = tick()
            end
        end
    end
end)

-- ==========================================
-- ЛОГИКА FLY
-- ==========================================
R.RenderStepped:Connect(function()
    if Fly_Enabled then
        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LP.Character.HumanoidRootPart
            if not flyVel then
                flyVel = Instance.new("BodyVelocity")
                flyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                flyVel.Velocity = Vector3.zero
                flyVel.Parent = hrp
            end
            
            local moveDir = Vector3.zero
            local camLook = Camera.CFrame.LookVector
            local camRight = Camera.CFrame.RightVector
            
            if U:IsKeyDown(Enum.KeyCode.W) then moveDir += camLook end
            if U:IsKeyDown(Enum.KeyCode.S) then moveDir -= camLook end
            if U:IsKeyDown(Enum.KeyCode.A) then moveDir -= camRight end
            if U:IsKeyDown(Enum.KeyCode.D) then moveDir += camRight end
            if U:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0,1,0) end
            
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.MoveDirection.Magnitude > 0.1 then
                local flatLook = Vector3.new(camLook.X, 0, camLook.Z).Unit
                local flatRight = Vector3.new(camRight.X, 0, camRight.Z).Unit
                moveDir += (camLook * hum.MoveDirection:Dot(flatLook)) + (camRight * hum.MoveDirection:Dot(flatRight))
            end

            if moveDir.Magnitude > 0 then
                flyVel.Velocity = moveDir.Unit * Fly_Speed
            else
                flyVel.Velocity = Vector3.zero
            end
        end
    else
        if flyVel then flyVel:Destroy(); flyVel = nil end
    end
end)

-- ЗАПУСК МЕНЮ ИЗ СИСТЕМЫ КЛЮЧА
local baseLoad = LoadArcanix
LoadArcanix = function()
    baseLoad()
    toggleMenu(true)
end

print("ARCANIX (Original + Auto Shot) Loaded")
-- ============================================================
-- 🦅 ARCANIX (Original + Auto Shot) - Part 4: Teleport
-- ============================================================

-- Переменные для телепорта
local TP = { Phase = "Idle", TargetPart = nil, Timer = 0 }

-- Меню Телепорта
local tpMenu = Instance.new("CanvasGroup")
tpMenu.AnchorPoint = Vector2.new(0.5, 0.5)
tpMenu.Size = UDim2.new(0, 250, 0, 300)
tpMenu.Position = UDim2.new(0.5, 0, 0.5, 0)
tpMenu.BackgroundColor3 = Themes[Theme].Bg
tpMenu.GroupTransparency = 1
tpMenu.Visible = false
tpMenu.Parent = gui
corner(tpMenu, 12)
stroke(tpMenu, Color3.fromRGB(50, 50, 60), 1.5)

local tpTitle = Instance.new("Frame")
tpTitle.Name = "TitleBar"
tpTitle.Size = UDim2.new(1, 0, 0, 35)
tpTitle.BackgroundTransparency = 1
tpTitle.Parent = tpMenu

local tpTitleLabel = Instance.new("TextLabel")
tpTitleLabel.Size = UDim2.new(1, -40, 1, 0)
tpTitleLabel.Position = UDim2.new(0, 12, 0, 0)
tpTitleLabel.BackgroundTransparency = 1
tpTitleLabel.Text = "ТЕЛЕПОРТ"
tpTitleLabel.TextColor3 = Themes[Theme].Text
tpTitleLabel.Font = Enum.Font.Arcade
tpTitleLabel.TextSize = 14
tpTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
tpTitleLabel.Parent = tpTitle

local tpCloseBtn = Instance.new("TextButton")
tpCloseBtn.Size = UDim2.new(0, 24, 0, 24)
tpCloseBtn.Position = UDim2.new(1, -30, 0.5, -12)
tpCloseBtn.BackgroundColor3 = Themes[Theme].Sub
tpCloseBtn.Text = "X"
tpCloseBtn.TextSize = 14
tpCloseBtn.TextColor3 = Themes[Theme].Text
tpCloseBtn.Font = Enum.Font.Arcade
tpCloseBtn.AutoButtonColor = false
tpCloseBtn.Parent = tpTitle
corner(tpCloseBtn, 6)

local tpScroll = Instance.new("ScrollingFrame")
tpScroll.Size = UDim2.new(1, -20, 1, -50)
tpScroll.Position = UDim2.new(0, 10, 0, 40)
tpScroll.BackgroundTransparency = 1
tpScroll.ScrollBarThickness = 4
tpScroll.ScrollBarImageColor3 = Accent
tpScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
tpScroll.Parent = tpMenu

local tpLayout = Instance.new("UIListLayout")
tpLayout.Padding = UDim.new(0, 6)
tpLayout.SortOrder = Enum.SortOrder.Name
tpLayout.Parent = tpScroll

-- Заполнение списка игроков
local function refreshTPList()
    for _, child in ipairs(tpScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, plr in ipairs(P:GetPlayers()) do
        if plr ~= LP then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -6, 0, 34)
            btn.BackgroundColor3 = Themes[Theme].Sub
            btn.Text = plr.Name
            btn.TextColor3 = Themes[Theme].Text
            btn.Font = Enum.Font.Arcade
            btn.TextSize = 14
            btn.AutoButtonColor = false
            btn.Parent = tpScroll
            corner(btn, 8)
            
            btn.MouseButton1Click:Connect(function()
                -- Запуск телепорта
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    TP.TargetPart = plr.Character.HumanoidRootPart
                    TP.Phase = "Glide"
                    TP.Timer = tick()
                    tpMenu.Visible = false
                    T:Create(tpMenu, TweenInfo.new(0.2), {GroupTransparency = 1}):Play()
                end
            end)
        end
    end
    tpScroll.CanvasSize = UDim2.new(0, 0, 0, tpLayout.AbsoluteContentSize.Y)
end

tpCloseBtn.MouseButton1Click:Connect(function()
    tpMenu.Visible = false
    T:Create(tpMenu, TweenInfo.new(0.2), {GroupTransparency = 1}):Play()
end)

-- Кнопка открытия в Misc
local tpOpenBtn = Instance.new("TextButton")
tpOpenBtn.Size = UDim2.new(1, 0, 0, 38)
tpOpenBtn.BackgroundColor3 = Accent
tpOpenBtn.Text = "МЕНЮ ТЕЛЕПОРТА"
tpOpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpOpenBtn.Font = Enum.Font.Arcade
tpOpenBtn.TextSize = 14
tpOpenBtn.Parent = pages["Misc"]
corner(tpOpenBtn, 8)

tpOpenBtn.MouseButton1Click:Connect(function()
    refreshTPList()
    tpMenu.Visible = true
    T:Create(tpMenu, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {GroupTransparency = 0}):Play()
end)

-- Логика плавного полета (Glide -> Lock -> Release)
R.RenderStepped:Connect(function(dt)
    if TP.Phase == "Idle" or not TP.TargetPart or not LP.Character then return end
    local myHRP = LP.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP or not TP.TargetPart.Parent then TP.Phase = "Idle"; return end

    if TP.Phase == "Glide" then
        local dist = (TP.TargetPart.Position - myHRP.Position).Magnitude
        if dist < 4 then 
            TP.Phase = "Lock"
            TP.Timer = tick()
        else
            local speed = math.clamp(dist * 0.5, 5, 25) 
            local goal = CFrame.new(TP.TargetPart.Position - TP.TargetPart.CFrame.LookVector * 3, TP.TargetPart.Position)
            myHRP.CFrame = myHRP.CFrame:Lerp(goal, dt * speed)
        end
    elseif TP.Phase == "Lock" then
        local goal = CFrame.new(TP.TargetPart.Position - TP.TargetPart.CFrame.LookVector * 3, TP.TargetPart.Position)
        myHRP.CFrame = myHRP.CFrame:Lerp(goal, dt * 15)
        if tick() - TP.Timer > 1.5 then 
            TP.Phase = "Release"
            TP.Timer = tick()
        end
    elseif TP.Phase == "Release" then
        if tick() - TP.Timer > 0.5 then 
            TP.Phase = "Idle"
            TP.TargetPart = nil
        end
    end
end)

-- Перетаскивание меню телепорта
drag(tpMenu, tpTitle)

-- Финальный запуск
local finalBaseLoad = LoadArcanix
LoadArcanix = function()
    finalBaseLoad()
    toggleMenu(true)
end

print("ARCANIX v2.0 Fully Loaded (All Parts Included)")
-- ============================================================
-- 🦅 ARCANIX (Original + Auto Shot) - Part 5: Settings & Logic
-- ============================================================

local Aim_Mode = "ShiftLock"

-- Функция выбора режима Аимбота
local function createAimModeSelector(parent)
    local h = Instance.new("Frame")
    h.Size = UDim2.new(1, 0, 0, 60)
    h.BackgroundColor3 = Themes[Theme].Sub
    h.Parent = parent
    corner(h, 8)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -20, 0, 18)
    l.Position = UDim2.new(0, 12, 0, 4)
    l.BackgroundTransparency = 1
    l.Text = "Режим Аимбота:"
    l.TextColor3 = Themes[Theme].Text
    l.Font = Enum.Font.Arcade
    l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = h

    local bh = Instance.new("Frame")
    bh.Size = UDim2.new(1, -24, 0, 24)
    bh.Position = UDim2.new(0, 12, 0, 26)
    bh.BackgroundTransparency = 1
    bh.Parent = h
    local lay = Instance.new("UIListLayout")
    lay.FillDirection = Enum.FillDirection.Horizontal
    lay.Padding = UDim.new(0, 4)
    lay.Parent = bh

    local function makeBtn(name, mode)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 100, 1, 0)
        b.BackgroundColor3 = Aim_Mode == mode and Accent or Color3.fromRGB(60, 60, 65)
        b.Text = name
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.Font = Enum.Font.Arcade
        b.TextSize = 12
        b.Parent = bh
        corner(b, 6)
        
        b.MouseButton1Click:Connect(function()
            Aim_Mode = mode
            for _, v in ipairs(bh:GetChildren()) do
                if v:IsA("TextButton") then
                    T:Create(v, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 65)}):Play()
                end
            end
            T:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Accent}):Play()
        end)
    end
    makeBtn("ShiftLock", "ShiftLock")
    makeBtn("RMB", "RMB")
    makeBtn("Всегда", "Always")
end

createAimModeSelector(pages["AimBot"])

-- Кнопка смены цвета ESP
local colors = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 150, 255), Color3.fromRGB(255, 0, 255), Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 255, 255)}
local cIdx = 1

local colorBtn = Instance.new("TextButton")
colorBtn.Size = UDim2.new(1, 0, 0, 38)
colorBtn.BackgroundColor3 = Accent
colorBtn.Text = "Цвет ESP: КРАСНЫЙ"
colorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
colorBtn.Font = Enum.Font.Arcade
colorBtn.TextSize = 14
colorBtn.Parent = pages["ESP"]
corner(colorBtn, 8)

colorBtn.MouseButton1Click:Connect(function()
    cIdx = cIdx % #colors + 1
    Accent = colors[cIdx]
    colorBtn.BackgroundColor3 = Accent
    local c = Accent
    colorBtn.TextColor3 = (c.R + c.G + c.B) > 1.5 and Color3.new(0,0,0) or Color3.new(1,1,1)
    colorBtn.Text = "Цвет ESP: " .. (c == colors[1] and "КРАСНЫЙ" or c == colors[2] and "ЗЕЛЕНЫЙ" or c == colors[3] and "СИНИЙ" or c == colors[4] and "РОЗОВЫЙ" or c == colors[5] and "ЖЕЛТЫЙ" or "БЕЛЫЙ")
    fovCircle.UIStroke.Color = Accent
    for _, p in pairs(ActiveESP) do
        p.hl.FillColor = Accent
        p.hl.OutlineColor = Accent
        p.nl.TextColor3 = Accent
    end
end)

-- Настройки (Размер меню и Тема)
local themeBtn = Instance.new("TextButton")
themeBtn.Size = UDim2.new(1, 0, 0, 38)
themeBtn.BackgroundColor3 = Themes[Theme].Sub
themeBtn.Text = "Тема: " .. Theme
themeBtn.TextColor3 = Themes[Theme].Text
themeBtn.Font = Enum.Font.Arcade
themeBtn.TextSize = 14
themeBtn.Parent = pages["Settings"]
corner(themeBtn, 8)

local sizeSlider = createSlider(pages["Settings"], "Размер меню", 50, 150, 100, function(v)
    uiScale.Scale = v / 100
end)

local function updateTheme()
    T:Create(win, TweenInfo.new(0.3), {BackgroundColor3 = Themes[Theme].Bg}):Play()
    T:Create(side, TweenInfo.new(0.3), {BackgroundColor3 = Themes[Theme].Side}):Play()
    T:Create(profileFrame, TweenInfo.new(0.3), {BackgroundColor3 = Themes[Theme].Sub}):Play()
    
    for _, p in pairs(pages) do
        for _, child in ipairs(p:GetChildren()) do
            if child:IsA("Frame") then
                child.BackgroundColor3 = Themes[Theme].Sub
                local lbl = child:FindFirstChildOfClass("TextLabel")
                if lbl then lbl.TextColor3 = Themes[Theme].Text end
            end
        end
    end
    
    for _, child in ipairs(side:GetChildren()) do
        if child:IsA("TextButton") and child ~= tabESP and child ~= tabAim and child ~= tabMisc and child ~= tabSet then
            child.BackgroundColor3 = Themes[Theme].Sub
            child.TextColor3 = Themes[Theme].Text
        end
    end
    T:Create(themeBtn, TweenInfo.new(0.3), {BackgroundColor3 = Themes[Theme].Sub, TextColor3 = Themes[Theme].Text}):Play()
end

themeBtn.MouseButton1Click:Connect(function()
    Theme = (Theme == "Dark") and "Light" or "Dark"
    themeBtn.Text = "Тема: " .. Theme
    updateTheme()
end)

-- ПЕРЕЗАПИСЬ ЛОГИКИ АИМБОТА С УЧЕТОМ РЕЖИМА
local isAiming = false
U.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.UserInputType == Enum.UserInputType.MouseButton2 then isAiming = true end
end)
U.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton2 then isAiming = false end
end)

local lastShotTime = 0

R.RenderStepped:Connect(function(dt)
    fovCircle.Visible = Aim_Enabled
    if Aim_Enabled then
        fovCircle.Size = UDim2.new(0, Aim_FOV * 2, 0, Aim_FOV * 2)
    end

    if not Aim_Enabled then CurrentTarget = nil; return end
    
    local active = false
    if Aim_Mode == "Always" then active = true
    elseif Aim_Mode == "RMB" then active = isAiming
    elseif Aim_Mode == "ShiftLock" then active = (U.MouseBehavior == Enum.MouseBehavior.LockCenter) end
    
    if not active then CurrentTarget = nil; return end
    
    local target = getTarget()
    
    if target then
        local current = Camera.CFrame
        local desired = CFrame.new(current.Position, target.Position)
        
        if Aim_Smooth >= 99 then
            Camera.CFrame = desired
        else
            local smooth = Aim_Smooth / 100
            local alpha = 1 - math.pow(1 - smooth, dt * 60)
            Camera.CFrame = current:Lerp(desired, alpha)
        end
        
        if AutoShot_Enabled and tick() - lastShotTime > 0.1 then
            local tool = LP.Character:FindFirstChildOfClass("Tool")
            if tool then
                pcall(function() tool:Activate() end)
                lastShotTime = tick()
            end
        end
    end
end)

-- Финальная сборка
local baseLoad = LoadArcanix
LoadArcanix = function()
    baseLoad()
    toggleMenu(true)
end

print("ARCANIX Fully Loaded (Original + Auto Shot + Settings)")
-- ============================================================
-- 🦅 ARCANIX (Original + Auto Shot) - Part 6: Anti-Fling & Final
-- ============================================================

-- СКРЫТЫЙ ANTI-FLING (Защита от вылета за карту)
-- Работает в фоне, сбрасывает скорость, если тебя пытаются раскрутить
R.Stepped:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LP.Character.HumanoidRootPart
        if hrp.Velocity.Magnitude > 1000 then
            hrp.Velocity = Vector3.zero
            hrp.RotVelocity = Vector3.zero
        end
    end
end)

-- ФИНАЛЬНЫЙ ЗАПУСК
local baseLoad = LoadArcanix
LoadArcanix = function()
    baseLoad()
    toggleMenu(true)
end

print("ARCANIX v2.0 (Original + Auto Shot) Fully Loaded")
