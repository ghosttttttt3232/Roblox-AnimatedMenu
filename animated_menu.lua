--[[
  EULEN STYLE - Safe Edition (Xeno compatible, no crash)
  loadstring(game:HttpGet("https://raw.githubusercontent.com/ghosttttttt3232/Roblox-AnimatedMenu/master/animated_menu.lua"))()
--]]

local ok, err = pcall(function()

task.wait(5)

local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

if not Drawing or not Drawing.new then return end

-- Config
local Cfg = { esp=false, box=true, aim=false, fov=100, ws=16, jp=50, fb=false }
local menuOn = false
local tab = 1
local mx, my = 0, 0
local cx, cy = 300, 200
local drag = false
local dx, dy = 0, 0
local mDown = false
local keyB = Enum.KeyCode.RightShift

-- Pre-create ALL drawings (fix amount, no runtime creation)
local D = {}
for i = 1, 50 do
    D[i] = Drawing.new("Line")
    D[i].Visible = false
end
for i = 51, 70 do
    D[i] = Drawing.new("Text")
    D[i].Visible = false
    D[i].Outline = true
    D[i].Center = true
end

local L = 1
local function line(a, from, to, thick, color)
    local l = D[a]
    if not l then return end
    l.From = from
    l.To = to
    l.Thickness = thick or 1
    l.Color = color or Color3.fromRGB(28,28,36)
    l.Transparency = 0
    l.Visible = true
end

local function txt(n, pos, text, size, color)
    local t = D[n]
    if not t then return end
    t.Position = pos
    t.Text = text
    t.Size = size or 12
    t.Color = color or Color3.fromRGB(155,155,165)
    t.Visible = true
end

local function hideAll()
    for i = 1, 70 do D[i].Visible = false end
end

-- ESP limits
local espPlayers = {}
local function espClear()
    for _, v in pairs(espPlayers) do
        for _, d in pairs(v) do
            if d then d.Visible = false end
        end
    end
    espPlayers = {}
end

local function ensureESP(p)
    if espPlayers[p] then return end
    local d = {}
    d[1] = Drawing.new("Line"); d[2] = Drawing.new("Line"); d[3] = Drawing.new("Line"); d[4] = Drawing.new("Line")
    d[5] = Drawing.new("Text"); d[6] = Drawing.new("Text"); d[7] = Drawing.new("Text"); d[8] = Drawing.new("Line")
    for i = 1, 8 do d[i].Visible = false end
    d[5].Outline = true; d[5].Center = true
    d[6].Outline = true; d[6].Center = true
    d[7].Outline = true; d[7].Center = true
    d[8].Transparency = 0.5
    espPlayers[p] = d
end

-- Functions
local function updateESP()
    if not Cfg.esp then
        for _, v in pairs(espPlayers) do for i = 1, 8 do v[i].Visible = false end end
        return
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP then
            ensureESP(p)
            local d = espPlayers[p]
            local char, hrp, head, hum = p.Character, nil, nil, nil
            if char then
                hrp = char:FindFirstChild("HumanoidRootPart")
                head = char:FindFirstChild("Head")
                hum = char:FindFirstChild("Humanoid")
            end

            local show = hrp and head and hum and hum.Health > 0

            if show then
                local dist = 9999
                local myChar = LP.Character
                local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if myHRP then dist = (hrp.Position - myHRP.Position).Magnitude end
                if dist > 1000 then show = false end
            end

            if show then
                local sp, on = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,2,0))
                local sp2, _ = Camera:WorldToViewportPoint(hrp.Position)
                local vsp = Vector2.new(sp.X, sp.Y)
                local vsp2 = Vector2.new(sp2.X, sp2.Y)

                if on then
                    -- Box (simple)
                    if Cfg.box then
                        local s = char:GetExtentsSize()
                        local cf = hrp.CFrame
                        local hw, hh = s.X/2, s.Y/2
                        local c1 = Camera:WorldToViewportPoint((cf * CFrame.new(-hw, hh, 0)).p)
                        local c2 = Camera:WorldToViewportPoint((cf * CFrame.new(hw, hh, 0)).p)
                        local c3 = Camera:WorldToViewportPoint((cf * CFrame.new(hw, -hh, 0)).p)
                        local c4 = Camera:WorldToViewportPoint((cf * CFrame.new(-hw, -hh, 0)).p)
                        if c1.Z > 0 and c2.Z > 0 and c3.Z > 0 and c4.Z > 0 then
                            local minX = math.min(c1.X,c2.X,c3.X,c4.X)
                            local maxX = math.max(c1.X,c2.X,c3.X,c4.X)
                            local minY = math.min(c1.Y,c2.Y,c3.Y,c4.Y)
                            local maxY = math.max(c1.Y,c2.Y,c3.Y,c4.Y)
                            d[1].From = Vector2.new(minX,minY); d[1].To = Vector2.new(maxX,minY)
                            d[2].From = Vector2.new(maxX,minY); d[2].To = Vector2.new(maxX,maxY)
                            d[3].From = Vector2.new(maxX,maxY); d[3].To = Vector2.new(minX,maxY)
                            d[4].From = Vector2.new(minX,maxY); d[4].To = Vector2.new(minX,minY)
                            for i = 1,4 do d[i].Visible = true; d[i].Thickness = 2; d[i].Color = Color3.fromRGB(0,255,136) end
                        end
                    end

                    -- Name
                    d[5].Position = vsp2 - Vector2.new(0, 40)
                    d[5].Text = p.Name
                    d[5].Visible = true

                    -- Health
                    d[7].Position = vsp2 - Vector2.new(0, 25)
                    d[7].Text = "HP: " .. math.floor(hum.Health)
                    d[7].Color = hum.Health > 50 and Color3.fromRGB(74,224,160) or (hum.Health > 25 and Color3.fromRGB(255,190,60) or Color3.fromRGB(255,77,106))
                    d[7].Visible = true

                    -- Line
                    d[8].From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                    d[8].To = vsp2
                    d[8].Visible = true
                    d[8].Color = Color3.fromRGB(212,135,106)
                else
                    for i = 1,8 do d[i].Visible = false end
                end
            else
                for i = 1,8 do d[i].Visible = false end
            end
        end
    end
end

-- Aimbot
local function aimTarget()
    if not Cfg.aim then return end
    local mp = UIS:GetMouseLocation()
    local best, bd = nil, Cfg.fov
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local h = p.Character:FindFirstChild("Head")
            if h then
                local sp, on = Camera:WorldToViewportPoint(h.Position)
                if on then
                    local d = (Vector2.new(sp.X, sp.Y) - mp).Magnitude
                    if d < bd then bd = d; best = p end
                end
            end
        end
    end
    if best and best.Character and best.Character:FindFirstChild("Head") then
        local h = best.Character.Head
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, h.Position)
    end
end

-- Render
RS.RenderStepped:Connect(function()
    mx, my = UIS:GetMouseLocation().X, UIS:GetMouseLocation().Y

    if drag then
        cx = mx - dx
        cy = my - dy
    end

    if menuOn then
        local w, h = 300, 50 + 4 * 36 + 10
        local posX, posY = cx, cy

        -- Box border
        line(1, Vector2.new(posX,posY), Vector2.new(posX+w,posY), 1)
        line(2, Vector2.new(posX+w,posY), Vector2.new(posX+w,posY+h), 1)
        line(3, Vector2.new(posX+w,posY+h), Vector2.new(posX,posY+h), 1)
        line(4, Vector2.new(posX,posY+h), Vector2.new(posX,posY), 1)

        -- Title
        D[51].Position = Vector2.new(posX + w/2, posY + 12)
        D[51].Text = "EULEN"
        D[51].Color = Color3.fromRGB(212,135,106)
        D[51].Size = 16
        D[51].Visible = true

        -- Tabs
        local tabs = {"ESP", "AIM", "PLAYER", "MISC"}
        for i = 1, 4 do
            local tx = posX + 10 + (i-1) * 72
            line(10+i, Vector2.new(tx, posY+30), Vector2.new(tx+65, posY+30), 22, i == tab and Color3.fromRGB(26,26,34) or Color3.fromRGB(18,18,24))
            D[55+i] and (function()
                D[55+i].Position = Vector2.new(tx+32, posY+21)
                D[55+i].Text = tabs[i]
                D[55+i].Size = 11
                D[55+i].Color = i == tab and Color3.fromRGB(212,135,106) or Color3.fromRGB(155,155,165)
                D[55+i].Visible = true
            end)()
        end

        -- Options
        local opts = {
            [1] = {{"ESP Enabled","tg","esp"}, {"Box","tg","box"}, {"","",""}},
            [2] = {{"Aimbot","tg","aim"}, {"FOV: "..Cfg.fov,"sl","fov"}, {"","",""}},
            [3] = {{"WalkSpeed","sp","ws"}, {"JumpPower","sp","jp"}, {"","",""}},
            [4] = {{"Fullbright","tg","fb"}, {"Key: "..tostring(keyB.Name or "RightShift"),"",""}, {"","",""}},
        }

        local oy = posY + 60
        for _, opt in pairs(opts[tab]) do
            if opt[1] ~= "" then
                line(100+_*10, Vector2.new(posX+10, oy+12), Vector2.new(posX+w-10, oy+12), 30, Color3.fromRGB(20,20,26))

                D[60+_*10] and (function()
                    D[60+_*10].Position = Vector2.new(posX+18, oy+4)
                    D[60+_*10].Text = opt[1]
                    D[60+_*10].Size = 11
                    D[60+_*10].Color = Color3.fromRGB(155,155,165)
                    D[60+_*10].Visible = true
                end)()

                if opt[2] == "tg" then
                    local val = Cfg[opt[3]]
                    local tox = posX + w - 30
                    line(200+_*10, Vector2.new(tox-13, oy+12), Vector2.new(tox+13, oy+12), 16, val and Color3.fromRGB(74,224,160) or Color3.fromRGB(40,40,50))
                    D[65+_*10] and (function()
                        D[65+_*10].Position = Vector2.new(tox, oy+5)
                        D[65+_*10].Text = val and "ON" or "OFF"
                        D[65+_*10].Size = 9
                        D[65+_*10].Color = val and Color3.fromRGB(74,224,160) or Color3.fromRGB(255,77,106)
                        D[65+_*10].Visible = true
                    end)()
                elseif opt[2] == "sl" then
                    D[65+_*10] and (function()
                        D[65+_*10].Position = Vector2.new(posX + w - 30, oy+4)
                        D[65+_*10].Text = tostring(Cfg[opt[3]])
                        D[65+_*10].Size = 11
                        D[65+_*10].Visible = true
                    end)()
                end
            end
            oy = oy + 36
        end
    else
        hideAll()
    end

    -- Aimbot
    if Cfg.aim and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        aimTarget()
    end

    -- ESP
    updateESP()

    -- Fullbright
    if Cfg.fb then
        game:GetService("Lighting").Brightness = 2
        game:GetService("Lighting").GlobalShadows = false
    end
end)

-- Click handling
UIS.InputBegan:Connect(function(inp, gp)
    if gp then return end

    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        mDown = true
        if menuOn then
            local w, h = 300, 50 + 4 * 36 + 10
            -- Tabs
            for i = 1, 4 do
                local tx = cx + 10 + (i-1) * 72
                if mx >= tx and mx <= tx + 65 and my >= cy + 30 and my <= cy + 52 then
                    tab = i; return
                end
            end
            -- Toggle options
            local oy = cy + 60
            local opts = {
                [1] = {{"","esp"}, {"","box"}},
                [2] = {{"","aim"}, {"","fov"}},
                [3] = {{"","ws"}, {"","jp"}},
                [4] = {{"","fb"}, {"",""}},
            }
            for _, opt in pairs(opts[tab]) do
                if mx >= cx + 10 and mx <= cx + 290 and my >= oy and my <= oy + 30 then
                    local key = opt[2]
                    if key == "esp" then Cfg.esp = not Cfg.esp
                    elseif key == "box" then Cfg.box = not Cfg.box
                    elseif key == "aim" then Cfg.aim = not Cfg.aim
                    elseif key == "fb" then Cfg.fb = not Cfg.fb
                    elseif key == "ws" then
                        Cfg.ws = Cfg.ws >= 200 and 16 or Cfg.ws + 10
                        if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                            LP.Character.Humanoid.WalkSpeed = Cfg.ws
                        end
                    elseif key == "jp" then
                        Cfg.jp = Cfg.jp >= 300 and 50 or Cfg.jp + 25
                        if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                            LP.Character.Humanoid.JumpPower = Cfg.jp
                        end
                    elseif key == "fov" then
                        Cfg.fov = Cfg.fov >= 500 and 50 or Cfg.fov + 25
                    end
                    return
                end
                oy = oy + 36
            end
            -- Drag
            if my >= cy and my <= cy + 26 then
                drag = true; dx = mx - cx; dy = my - cy; return
            end
        end
        drag = true; dx = mx - cx; dy = my - cy
    end

    if inp.KeyCode == keyB then
        menuOn = not menuOn
        if not menuOn then hideAll() end
    end
end)

UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        mDown = false; drag = false
    end
end)

-- Keybind prompt
local kpTitle, kpWait
if not isfile or not isfile("eulen_key.txt") then
    hideAll()
    kpTitle = Drawing.new("Text"); kpTitle.Visible = true; kpTitle.Center = true; kpTitle.Outline = true
    kpTitle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2 - 10)
    kpTitle.Text = "Press any key to bind"
    kpTitle.Color = Color3.fromRGB(212,135,106)
    kpTitle.Size = 18

    kpWait = Drawing.new("Text"); kpWait.Visible = true; kpWait.Center = true; kpWait.Outline = true
    kpWait.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2 + 15)
    kpWait.Text = "WAITING..."
    kpWait.Color = Color3.fromRGB(155,155,165)
    kpWait.Size = 14

    local conn = UIS.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Keyboard then
            local kn = inp.KeyCode.Name
            if kn ~= "Unknown" then
                keyB = inp.KeyCode
                kpWait.Text = kn; kpWait.Color = Color3.fromRGB(74,224,160)
                if writefile then pcall(function() writefile("eulen_key.txt", kn) end) end
                task.wait(1.5)
                kpTitle.Visible = false; kpWait.Visible = false
                conn:Disconnect()
                menuOn = true
            end
        end
    end)
else
    menuOn = true
end

end)

if not ok then
    warn(tostring(err))
end
