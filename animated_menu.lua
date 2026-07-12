--[[
  EULEN STYLE - Drawing Edition (Xeno compatible)
  loadstring(game:HttpGet("https://raw.githubusercontent.com/ghosttttttt3232/Roblox-AnimatedMenu/master/animated_menu.lua"))()
--]]

local success, env = pcall(function()

task.wait(5)

local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

if not Drawing or not Drawing.new then return warn("Drawing API missing") end

-- Colors
local C = {
    accent = Color3.fromRGB(212, 135, 106),
    bg = Color3.fromRGB(14, 14, 18),
    panel = Color3.fromRGB(18, 18, 24),
    card = Color3.fromRGB(26, 26, 34),
    element = Color3.fromRGB(20, 20, 26),
    text = Color3.fromRGB(155, 155, 165),
    textActive = Color3.fromRGB(235, 235, 240),
    textDim = Color3.fromRGB(95, 95, 105),
    border = Color3.fromRGB(28, 28, 36),
    green = Color3.fromRGB(74, 224, 160),
    red = Color3.fromRGB(255, 77, 106),
}

-- Config
local Config = {
    esp = { enabled = false, box = true, lines = true, health = true, dist = true, teamCheck = true, distance = 1000 },
    aimbot = { enabled = false, fov = 100, showFov = true, smooth = 1, silent = false, part = "Head" },
    player = { ws = 16, jp = 50, fly = false, noclip = false },
    misc = { fullbright = false, antifreeze = false },
}

-- Drawing cache
local D = {}
function D:new(obj, props)
    local d = Drawing.new(obj)
    if props then for k, v in pairs(props) do d[k] = v end end
    return d
end

-- Menu state
local menuX, menuY = 300, 150
local menuOpen = false
local mouseDown = false
local tabs = {"ESP", "AIMBOT", "PLAYER", "MISC"}
local activeTab = 1
local hoverTab = nil
local hoverOpt = nil
local dragStart, dragging = nil, false
local dragOffX, dragOffY = 0, 0
local keyBind = Enum.KeyCode.RightShift
local keyBindName = "RightShift"

-- Load saved key
if isfile and isfile("eulen_key.txt") then
    local kn = readfile("eulen_key.txt")
    if kn and Enum.KeyCode[kn] then
        keyBind = Enum.KeyCode[kn]
        keyBindName = kn
    end
end

-- Tab options
local tabOptions = {
    [1] = { -- ESP
        {type="toggle", text="Enabled", key="esp.enabled"},
        {type="toggle", text="Box", key="esp.box"},
        {type="toggle", text="Lines", key="esp.lines"},
        {type="toggle", text="Health", key="esp.health"},
        {type="toggle", text="Distance", key="esp.dist"},
        {type="toggle", text="Team Check", key="esp.teamCheck"},
        {type="slider", text="Max Distance", key="esp.distance", min=100, max=5000, step=100},
    },
    [2] = { -- AIMBOT
        {type="toggle", text="Enabled", key="aimbot.enabled"},
        {type="toggle", text="Show FOV", key="aimbot.showFov", depends="aimbot.enabled"},
        {type="toggle", text="Silent Aim", key="aimbot.silent", depends="aimbot.enabled"},
        {type="slider", text="FOV", key="aimbot.fov", min=10, max=500, step=5, depends="aimbot.enabled"},
        {type="slider", text="Smooth", key="aimbot.smooth", min=0.1, max=2, step=0.1, depends="aimbot.enabled"},
        {type="select", text="Target", key="aimbot.part", options={"Head","HumanoidRootPart","UpperTorso"}, depends="aimbot.enabled"},
    },
    [3] = { -- PLAYER
        {type="toggle", text="Fly", key="player.fly"},
        {type="toggle", text="Noclip", key="player.noclip"},
        {type="slider", text="WalkSpeed", key="player.ws", min=16, max=200, step=1},
        {type="slider", text="JumpPower", key="player.jp", min=50, max=300, step=5},
    },
    [4] = { -- MISC
        {type="toggle", text="Fullbright", key="misc.fullbright"},
        {type="toggle", text="Anti-Freeze", key="misc.antifreeze"},
        {type="text", text="Key: "..keyBindName},
        {type="button", text="Change Key"},
    },
}

-- Create drawings for menu UI
local ui = {}

-- Menu background (4 border lines + fill squares)
ui.borders = {}
for i = 1, 4 do
    ui.borders[i] = D:new("Line", {Thickness=1, Color=C.border, Visible=false})
end

ui.bgTop = D:new("Line", {Thickness=30, Color=C.bg, Visible=false})
ui.titleBg = D:new("Line", {Thickness=38, Color=Color3.fromRGB(10, 10, 14), Visible=false})
ui.titleText = D:new("Text", {Text="EULEN", Color=C.accent, Size=16, Center=true, Outline=true, Visible=false})
ui.closeText = D:new("Text", {Text="X", Color=C.red, Size=14, Center=true, Outline=true, Visible=false})

-- Tabs
ui.tabBg = {}
ui.tabTexts = {}
for i = 1, #tabs do
    ui.tabBg[i] = D:new("Line", {Thickness=28, Color=C.panel, Visible=false})
    ui.tabTexts[i] = D:new("Text", {Text=tabs[i], Color=C.text, Size=12, Center=true, Outline=true, Visible=false})
end

-- Options
ui.optBgs = {}
ui.optTexts = {}
ui.optToggles = {}
ui.optToggleTexts = {}
ui.optSliderBgs = {}
ui.optSliderFills = {}
ui.optSliderTexts = {}

for ti = 1, #tabs do
    ui.optBgs[ti] = {}
    ui.optTexts[ti] = {}
    ui.optToggles[ti] = {}
    ui.optToggleTexts[ti] = {}
    ui.optSliderBgs[ti] = {}
    ui.optSliderFills[ti] = {}
    ui.optSliderTexts[ti] = {}
    for oi = 1, #tabOptions[ti] do
        local opt = tabOptions[ti][oi]
        ui.optBgs[ti][oi] = D:new("Line", {Thickness=36, Color=C.element, Visible=false})
        ui.optTexts[ti][oi] = D:new("Text", {Text=opt.text, Color=C.text, Size=12, Center=false, Outline=true, Visible=false})
        if opt.type == "toggle" then
            ui.optToggles[ti][oi] = D:new("Line", {Thickness=18, Color=C.border, Visible=false})
            ui.optToggleTexts[ti][oi] = D:new("Text", {Text="OFF", Color=C.red, Size=10, Center=true, Outline=true, Visible=false})
        end
        if opt.type == "slider" then
            ui.optSliderBgs[ti][oi] = D:new("Line", {Thickness=6, Color=C.border, Visible=false})
            ui.optSliderFills[ti][oi] = D:new("Line", {Thickness=6, Color=C.accent, Visible=false})
            ui.optSliderTexts[ti][oi] = D:new("Text", {Text="0", Color=C.text, Size=10, Center=true, Outline=true, Visible=false})
        end
    end
end

-- ESP drawings
local espDrawings = {}
local fovCircle = D:new("Circle", {Thickness=2, Color=Color3.fromRGB(255,255,255), NumSides=32, Filled=false, Transparency=0.5, Visible=false})

-- Functions
function getConfig(key)
    local t = {esp=Config.esp, aimbot=Config.aimbot, player=Config.player, misc=Config.misc}
    local parts = {}
    for part in string.gmatch(key, "[^.]+") do table.insert(parts, part) end
    local val = t
    for _, p in ipairs(parts) do val = val[p] end
    return val
end

function setConfig(key, value)
    local code = {}
    for part in string.gmatch(key, "[^.]+") do table.insert(code, '["'..part..'"]') end
    loadstring("Config"..table.concat(code).."="..tostring(value))()
end

function createESP(player)
    if espDrawings[player] then return end
    local esp = {
        box = {},
        name = D:new("Text", {Text=player.Name, Color=Color3.fromRGB(255,255,255), Size=13, Center=true, Outline=true, Visible=false}),
        dist = D:new("Text", {Text="", Color=Color3.fromRGB(255,255,255), Size=12, Center=true, Outline=true, Visible=false}),
        health = D:new("Text", {Text="", Color=C.green, Size=12, Center=true, Outline=true, Visible=false}),
        line = D:new("Line", {Thickness=1, Color=C.accent, Visible=false, Transparency=0.5}),
    }
    for i = 1, 4 do
        esp.box[i] = D:new("Line", {Thickness=2, Color=Color3.fromRGB(0,255,136), Visible=false})
    end
    espDrawings[player] = esp
end

function removeESP(player)
    if espDrawings[player] then
        for _, v in pairs(espDrawings[player]) do
            if type(v) == "table" then
                for _, d in pairs(v) do d:Remove() end
            else
                v:Remove()
            end
        end
        espDrawings[player] = nil
    end
end

function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP then
            if not espDrawings[player] then createESP(player) end
            local esp = espDrawings[player]
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local head = char and char:FindFirstChild("Head")
            local hum = char and char:FindFirstChild("Humanoid")

            local show = Config.esp.enabled and hrp and head and hum and hum.Health > 0
            if Config.esp.teamCheck and player.Team and LP.Team and player.Team == LP.Team then show = false end
            if show then
                local dist = hrp and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") and (hrp.Position - LP.Character.HumanoidRootPart.Position).Magnitude or 9999
                if dist > Config.esp.distance then show = false end
            end

            if show then
                local sp, on = Camera:WorldToViewportPoint(head.Position)
                local sp2, _ = Camera:WorldToViewportPoint(hrp.Position)
                local pos = Vector2.new(sp.X, sp.Y)

                -- Box
                if Config.esp.box then
                    local size = char:GetExtentsSize()
                    local cf = hrp.CFrame
                    local w, h = size.X/2, size.Y/2
                    local corners = {
                        (cf * CFrame.new(-w, h, 0)).p, (cf * CFrame.new(w, h, 0)).p,
                        (cf * CFrame.new(w, -h, 0)).p, (cf * CFrame.new(-w, -h, 0)).p,
                    }
                    local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
                    for _, cp in pairs(corners) do
                        local v = Camera:WorldToViewportPoint(cp)
                        if v.Z > 0 then
                            if v.X < minX then minX = v.X end
                            if v.Y < minY then minY = v.Y end
                            if v.X > maxX then maxX = v.X end
                            if v.Y > maxY then maxY = v.Y end
                        end
                    end
                    if minX ~= math.huge then
                        esp.box[1].From = Vector2.new(minX, minY)
                        esp.box[1].To = Vector2.new(maxX, minY)
                        esp.box[1].Visible = true
                        esp.box[2].From = Vector2.new(maxX, minY)
                        esp.box[2].To = Vector2.new(maxX, maxY)
                        esp.box[2].Visible = true
                        esp.box[3].From = Vector2.new(maxX, maxY)
                        esp.box[3].To = Vector2.new(minX, maxY)
                        esp.box[3].Visible = true
                        esp.box[4].From = Vector2.new(minX, maxY)
                        esp.box[4].To = Vector2.new(minX, minY)
                        esp.box[4].Visible = true
                    else for i = 1, 4 do esp.box[i].Visible = false end end
                else for i = 1, 4 do esp.box[i].Visible = false end end

                -- Name
                esp.name.Position = Vector2.new(sp2.X, sp2.Y - 50)
                esp.name.Visible = true

                -- Distance
                if Config.esp.dist then
                    local d = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") and (hrp.Position - LP.Character.HumanoidRootPart.Position).Magnitude or 0
                    esp.dist.Position = Vector2.new(sp2.X, sp2.Y - 35)
                    esp.dist.Text = string.format("%.0fm", d)
                    esp.dist.Visible = true
                else esp.dist.Visible = false end

                -- Health
                if Config.esp.health then
                    esp.health.Position = Vector2.new(sp2.X, sp2.Y - 20)
                    esp.health.Text = string.format("HP: %.0f", hum.Health)
                    esp.health.Color = hum.Health > 50 and C.green or (hum.Health > 25 and Color3.fromRGB(255, 190, 60) or C.red)
                    esp.health.Visible = true
                else esp.health.Visible = false end

                -- Line
                if Config.esp.lines then
                    esp.line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                    esp.line.To = Vector2.new(sp2.X, sp2.Y)
                    esp.line.Visible = true
                else esp.line.Visible = false end
            else
                esp.name.Visible = false
                esp.dist.Visible = false
                esp.health.Visible = false
                esp.line.Visible = false
                for i = 1, 4 do esp.box[i].Visible = false end
            end
        end
    end
end

-- Aimbot
function getClosest()
    if not Config.aimbot.enabled then return nil end
    local mp = UIS:GetMouseLocation()
    local closest, closestDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild(Config.aimbot.part) then
            local part = p.Character[Config.aimbot.part]
            local sp, on = Camera:WorldToViewportPoint(part.Position)
            if on then
                local d = (Vector2.new(sp.X, sp.Y) - mp).Magnitude
                if d < Config.aimbot.fov and d < closestDist then
                    closest = p; closestDist = d
                end
            end
        end
    end
    return closest
end

-- Player functions
function toggleFly()
    if not Config.player.fly then
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp:FindFirstChild("BodyVelocity") and hrp.BodyVelocity:Destroy()
            hrp:FindFirstChild("BodyGyro") and hrp.BodyGyro:Destroy()
        end
        return
    end
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(100000, 100000, 100000); bv.Parent = hrp
    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(100000, 100000, 100000); bg.P = 10000; bg.Parent = hrp
    RS.RenderStepped:Connect(function()
        if not Config.player.fly then
            pcall(function() bv:Destroy() end); pcall(function() bg:Destroy() end); return
        end
        local dir = Vector3.new()
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0,1,0) end
        bv.Velocity = dir * (Config.player.ws * 3)
        bg.CFrame = Camera.CFrame
    end)
end

-- Noclip
RS.Stepped:Connect(function()
    if Config.player.noclip and LP.Character then
        for _, p in pairs(LP.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

-- Fullbright
function toggleFB()
    local L = game:GetService("Lighting")
    L.Brightness = Config.misc.fullbright and 2 or 1
    L.GlobalShadows = not Config.misc.fullbright
    L.OutdoorAmbient = Config.misc.fullbright and Color3.fromRGB(128,128,128) or Color3.fromRGB(70,70,70)
end

-- Anti freeze
RS.RenderStepped:Connect(function()
    if Config.misc.antifreeze then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local hum = p.Character:FindFirstChild("Humanoid")
                if hum and hum.Health > 0 then
                    hum.PlatformStand = false
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and hrp.Velocity.Magnitude < 1 then
                        hrp.Velocity = Vector3.new(0, -5, 0)
                    end
                end
            end
        end
    end
end)

-- Key binding prompt
local function showKeyPrompt()
    local prompt = {}
    local lines = {}
    for i = 1, 4 do lines[i] = D:new("Line", {Thickness=1, Color=C.border, Visible=true}) end
    local bg = D:new("Line", {Thickness=80, Color=C.panel, Visible=true})
    local titleT = D:new("Text", {Text="Press any key to bind", Color=C.accent, Size=16, Center=true, Outline=true, Visible=true})
    local hintT = D:new("Text", {Text="Recommended: INSERT / DELETE / HOME", Color=C.textDim, Size=12, Center=true, Outline=true, Visible=true})
    local waitT = D:new("Text", {Text="WAITING...", Color=C.text, Size=14, Center=true, Outline=true, Visible=true})

    local cx, cy = Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2
    bg.From = Vector2.new(cx-150, cy-40); bg.To = Vector2.new(cx+150, cy-40)
    lines[1].From = Vector2.new(cx-150, cy-40); lines[1].To = Vector2.new(cx+150, cy-40)
    lines[2].From = Vector2.new(cx+150, cy-40); lines[2].To = Vector2.new(cx+150, cy+40)
    lines[3].From = Vector2.new(cx+150, cy+40); lines[3].To = Vector2.new(cx-150, cy+40)
    lines[4].From = Vector2.new(cx-150, cy+40); lines[4].To = Vector2.new(cx-150, cy-40)
    titleT.Position = Vector2.new(cx, cy-25)
    hintT.Position = Vector2.new(cx, cy-8)
    waitT.Position = Vector2.new(cx, cy+18)

    local conn = UIS.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Keyboard then
            local kc = inp.KeyCode
            local kn = kc.Name
            if kn ~= "Unknown" then
                keyBind = kc; keyBindName = kn
                waitT.Text = kn; waitT.Color = C.green; bg.Color = C.card
                if writefile then pcall(function() writefile("eulen_key.txt", kn) end) end
                task.wait(1.5)
                for _, l in pairs(lines) do l.Visible = false end
                bg.Visible = false; titleT.Visible = false; hintT.Visible = false; waitT.Visible = false
                conn:Disconnect()

                local notif = D:new("Text", {Text="Press "..kn.." to toggle menu", Color=Color3.fromRGB(255,255,255), Size=14, Center=true, Outline=true, Visible=true})
                notif.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y * 0.9)
                task.wait(3); notif.Visible = false
            end
        end
    end)
end

-- Keybind prompt on first use
if not isfile or not isfile("eulen_key.txt") then showKeyPrompt() end

-- Toggle / click handling
function handleClick(ti, oi)
    local opt = tabOptions[ti][oi]
    if opt.type == "toggle" then
        local val = getConfig(opt.key)
        setConfig(opt.key, not val)
        if opt.key == "player.fly" then toggleFly() end
        if opt.key == "misc.fullbright" then toggleFB() end
    elseif opt.type == "button" and opt.text == "Change Key" then
        showKeyPrompt()
    end
end

-- Render loop
RS.RenderStepped:Connect(function()
    local mx, my = UIS:GetMouseLocation().X, UIS:GetMouseLocation().Y
    local w, h = 500, 400
    local cx, cy = menuX, menuY

    -- Drag
    if dragging then
        menuX = mx - dragOffX
        menuY = my - dragOffY
        cx, cy = menuX, menuY
    end

    if menuOpen then
        -- Menu bg
        ui.bgTop.From = Vector2.new(cx, cy + 27); ui.bgTop.To = Vector2.new(cx + w, cy + 27); ui.bgTop.Visible = true
        ui.borders[1].From = Vector2.new(cx, cy); ui.borders[1].To = Vector2.new(cx+w, cy)
        ui.borders[2].From = Vector2.new(cx+w, cy); ui.borders[2].To = Vector2.new(cx+w, cy+h)
        ui.borders[3].From = Vector2.new(cx+w, cy+h); ui.borders[3].To = Vector2.new(cx, cy+h)
        ui.borders[4].From = Vector2.new(cx, cy+h); ui.borders[4].To = Vector2.new(cx, cy)
        for i = 1, 4 do ui.borders[i].Visible = true end

        -- Title
        ui.titleBg.From = Vector2.new(cx, cy + 19); ui.titleBg.To = Vector2.new(cx + w, cy + 19); ui.titleBg.Visible = true
        ui.titleText.Position = Vector2.new(cx + 20, cy + 9); ui.titleText.Visible = true
        ui.closeText.Position = Vector2.new(cx + w - 16, cy + 10); ui.closeText.Visible = true

        -- Tabs
        local tabStartY = cy + 42
        for i = 1, #tabs do
            local ty = tabStartY + (i-1) * 32
            ui.tabBg[i].From = Vector2.new(cx, ty + 14); ui.tabBg[i].To = Vector2.new(cx + 100, ty + 14)
            ui.tabBg[i].Visible = true
            ui.tabBg[i].Color = (i == activeTab) and C.card or C.panel
            ui.tabTexts[i].Position = Vector2.new(cx + 50, ty + 4); ui.tabTexts[i].Visible = true
            ui.tabTexts[i].Color = (i == activeTab) and C.accent or C.text
        end

        -- Options
        local oy = tabStartY + #tabs * 32 + 10
        local optStart = oy
        for oi = 1, #tabOptions[activeTab] do
            local opt = tabOptions[activeTab][oi]
            local tx = cx + 110

            -- Check dependency
            local isDep = opt.depends and not getConfig(opt.depends)
            local isVisible = not isDep
            local showOpt = isDep

            if not showOpt then
                ui.optBgs[activeTab][oi].From = Vector2.new(tx, oy + 18); ui.optBgs[activeTab][oi].To = Vector2.new(cx + w - 10, oy + 18)
                ui.optBgs[activeTab][oi].Visible = true
                ui.optTexts[activeTab][oi].Position = Vector2.new(tx + 10, oy + 8)
                ui.optTexts[activeTab][oi].Visible = true
                ui.optTexts[activeTab][oi].Color = (hoverOpt == oi and activeTab == activeTab) and C.textActive or C.text

                if opt.type == "toggle" then
                    local val = getConfig(opt.key)
                    local tox = cx + w - 40
                    ui.optToggles[activeTab][oi].From = Vector2.new(tox, oy + 18)
                    ui.optToggles[activeTab][oi].To = Vector2.new(tox + 26, oy + 18)
                    ui.optToggles[activeTab][oi].Visible = true
                    ui.optToggles[activeTab][oi].Color = val and C.green or C.border
                    ui.optToggleTexts[activeTab][oi].Position = Vector2.new(tox + 13, oy + 11)
                    ui.optToggleTexts[activeTab][oi].Text = val and "ON" or "OFF"
                    ui.optToggleTexts[activeTab][oi].Color = val and C.green or C.red
                    ui.optToggleTexts[activeTab][oi].Visible = true
                elseif opt.type == "slider" then
                    local val = getConfig(opt.key)
                    local slx = cx + w - 120
                    ui.optSliderBgs[activeTab][oi].From = Vector2.new(slx, oy + 18)
                    ui.optSliderBgs[activeTab][oi].To = Vector2.new(slx + 80, oy + 18)
                    ui.optSliderBgs[activeTab][oi].Visible = true
                    local pct = (val - opt.min) / (opt.max - opt.min)
                    ui.optSliderFills[activeTab][oi].From = Vector2.new(slx, oy + 18)
                    ui.optSliderFills[activeTab][oi].To = Vector2.new(slx + 80 * pct, oy + 18)
                    ui.optSliderFills[activeTab][oi].Visible = true
                    ui.optSliderTexts[activeTab][oi].Position = Vector2.new(slx + 90, oy + 11)
                    ui.optSliderTexts[activeTab][oi].Text = tostring(val)
                    ui.optSliderTexts[activeTab][oi].Visible = true
                elseif opt.type == "button" then
                    ui.optBgs[activeTab][oi].Color = C.card
                end

                oy = oy + 42
            end
        end

        -- Tab hover
        hoverTab = nil
        for i = 1, #tabs do
            local ty = tabStartY + (i-1) * 32
            if mx >= cx and mx <= cx + 100 and my >= ty and my <= ty + 28 then
                hoverTab = i
            end
        end

        -- Close X hover
        if mx >= cx + w - 26 and mx <= cx + w - 6 and my >= cy + 4 and my <= cy + 24 then
            ui.closeText.Color = Color3.fromRGB(255, 255, 255)
        else
            ui.closeText.Color = C.red
        end
    else
        for i = 1, 4 do ui.borders[i].Visible = false end
        ui.bgTop.Visible = false; ui.titleBg.Visible = false; ui.titleText.Visible = false; ui.closeText.Visible = false
        for i = 1, #tabs do
            ui.tabBg[i].Visible = false; ui.tabTexts[i].Visible = false
        end
        for ti = 1, #tabs do
            for oi = 1, #tabOptions[ti] do
                ui.optBgs[ti][oi].Visible = false; ui.optTexts[ti][oi].Visible = false
                if tabOptions[ti][oi].type == "toggle" then
                    ui.optToggles[ti][oi].Visible = false; ui.optToggleTexts[ti][oi].Visible = false
                end
                if tabOptions[ti][oi].type == "slider" then
                    ui.optSliderBgs[ti][oi].Visible = false; ui.optSliderFills[ti][oi].Visible = false
                    ui.optSliderTexts[ti][oi].Visible = false
                end
            end
        end
    end

    -- FOV circle
    if Config.aimbot.enabled and Config.aimbot.showFov then
        fovCircle.Position = UIS:GetMouseLocation()
        fovCircle.Radius = Config.aimbot.fov
        fovCircle.Visible = true
    else fovCircle.Visible = false end

    -- ESP update
    updateESP()
end)

-- Input handling
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        mouseDown = true
        local mx, my = UIS:GetMouseLocation().X, UIS:GetMouseLocation().Y
        local cx, cy = menuX, menuY
        local w, h = 500, 400

        if menuOpen then
            -- Close button
            if mx >= cx + w - 26 and mx <= cx + w - 6 and my >= cy + 4 and my <= cy + 24 then
                menuOpen = false; return
            end
            -- Tab click
            local tabStartY = cy + 42
            for i = 1, #tabs do
                local ty = tabStartY + (i-1) * 32
                if mx >= cx and mx <= cx + 100 and my >= ty and my <= ty + 28 then
                    activeTab = i; return
                end
            end
            -- Option click
            local oy = tabStartY + #tabs * 32 + 10
            for oi = 1, #tabOptions[activeTab] do
                local opt = tabOptions[activeTab][oi]
                if not (opt.depends and not getConfig(opt.depends)) then
                    local tx = cx + 110
                    if mx >= tx and mx <= cx + w - 10 and my >= oy and my <= oy + 36 then
                        handleClick(activeTab, oi); return
                    end
                end
                oy = oy + 42
            end
            -- Title bar drag
            if mx >= cx and mx <= cx + 100 and my >= cy and my <= cy + 38 then
                dragging = true; dragOffX = mx - menuX; dragOffY = my - menuY; return
            end
            if my >= cy and my <= cy + 38 and mx >= cx and mx <= cx + w then
                dragging = true; dragOffX = mx - menuX; dragOffY = my - menuY; return
            end
        end

        -- Click through check for drag
        dragging = true; dragOffX = mx - menuX; dragOffY = my - menuY
    end

    if input.KeyCode == keyBind then
        menuOpen = not menuOpen
    end
    if input.KeyCode == Enum.KeyCode.RightShift then
        menuOpen = not menuOpen
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        mouseDown = false; dragging = false
    end
end)

-- Add players
Players.PlayerAdded:Connect(function(p)
    if p ~= LP then createESP(p) end
end)

Players.PlayerRemoving:Connect(function(p)
    removeESP(p)
end)

for _, p in pairs(Players:GetPlayers()) do
    if p ~= LP then createESP(p) end
end

menuOpen = true

end)

if not success then
    warn("Eulen Menu Error: " .. tostring(result))
end
