--[[
  EULEN MINIMAL - Xeno test version
  loadstring(game:HttpGet("https://raw.githubusercontent.com/ghosttttttt3232/Roblox-AnimatedMenu/master/animated_menu.lua"))()
--]]

pcall(function()
task.wait(5)

local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

if not Drawing or not Drawing.new then return end

-- Test drawing at startup
local test = Drawing.new("Text")
test.Text = "LOADING EULEN..."
test.Position = Vector2.new(400, 300)
test.Size = 20
test.Visible = true
task.wait(0.5)
test.Visible = false

-- Pre-create drawings
local L = {}
for i = 1, 20 do L[i] = Drawing.new("Line") end
local T = {}
for i = 1, 20 do T[i] = Drawing.new("Text"); T[i].Outline = true; T[i].Center = true end

local open = false
local tab = 1
local cx, cy = 300, 200
local drag, dx, dy = false, 0, 0
local mDown = false
local keyToggle = Enum.KeyCode.RightShift
local Cfg = { esp = false, aim = false, ws = 16 }
local optHover = 0

-- Keybind
if not isfile or not isfile("eulen_key.txt") then
    local kt = Drawing.new("Text")
    kt.Text = "Press any key to bind"
    kt.Position = Vector2.new(400, 285)
    kt.Size = 18
    kt.Color = Color3.fromRGB(212,135,106)
    kt.Visible = true

    local kw = Drawing.new("Text")
    kw.Text = "WAITING..."
    kw.Position = Vector2.new(400, 315)
    kw.Size = 14
    kw.Color = Color3.fromRGB(155,155,165)
    kw.Visible = true

    local conn = UIS.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Keyboard then
            local kn = inp.KeyCode.Name
            if kn ~= "Unknown" then
                keyToggle = inp.KeyCode
                kw.Text = kn
                kw.Color = Color3.fromRGB(74,224,160)
                if writefile then pcall(function() writefile("eulen_key.txt", kn) end) end
                task.wait(1.5)
                kt.Visible = false; kw.Visible = false
                conn:Disconnect()
                open = true
            end
        end
    end)
else
    open = true
end

-- Menu options per tab
local opts = {
    ["ESP"] = { {"ESP On/Off", "esp"}, {"WS: "..Cfg.ws, "ws"} },
    ["AIM"] = { {"Aimbot On/Off", "aim"} },
    ["+"] = { {"Key: "..tostring(keyToggle.Name), "key"} },
}

local tabNames = {"ESP", "AIM", "+"}

function hide()
    for i = 1, 20 do L[i].Visible = false; T[i].Visible = false end
end

RS.RenderStepped:Connect(function()
    local mx, my = UIS:GetMouseLocation().X, UIS:GetMouseLocation().Y
    if drag then cx = mx - dx; cy = my - dy end

    if open then
        local w, h = 280, 50 + #tabNames * 26 + #opts[tabNames[tab]] * 40 + 20
        local px, py = cx, cy

        -- Box
        L[1].From = Vector2.new(px,py); L[1].To = Vector2.new(px+w,py); L[1].Visible = true
        L[2].From = Vector2.new(px+w,py); L[2].To = Vector2.new(px+w,py+h); L[2].Visible = true
        L[3].From = Vector2.new(px+w,py+h); L[3].To = Vector2.new(px,py+h); L[3].Visible = true
        L[4].From = Vector2.new(px,py+h); L[4].To = Vector2.new(px,py); L[4].Visible = true

        -- Title
        T[1].Position = Vector2.new(px + w/2, py + 12)
        T[1].Text = "EULEN"
        T[1].Color = Color3.fromRGB(212,135,106)
        T[1].Size = 16
        T[1].Visible = true

        -- Tabs
        for i = 1, #tabNames do
            local tx = px + 10 + (i-1) * 85
            L[10+i].From = Vector2.new(tx, py+30); L[10+i].To = Vector2.new(tx+78, py+30)
            L[10+i].Thickness = 22
            L[10+i].Color = i == tab and Color3.fromRGB(26,26,34) or Color3.fromRGB(18,18,24)
            L[10+i].Visible = true

            T[10+i].Position = Vector2.new(tx+39, py+21)
            T[10+i].Text = tabNames[i]
            T[10+i].Size = 11
            T[10+i].Color = i == tab and Color3.fromRGB(212,135,106) or Color3.fromRGB(155,155,165)
            T[10+i].Visible = true
        end

        -- Options
        local oy = py + 58
        optHover = 0
        for oi = 1, #opts[tabNames[tab]] do
            local o = opts[tabNames[tab]][oi]
            local hov = mx >= px+10 and mx <= px+w-10 and my >= oy and my <= oy+35

            L[14+oi].From = Vector2.new(px+10, oy+17); L[14+oi].To = Vector2.new(px+w-10, oy+17)
            L[14+oi].Thickness = 30
            L[14+oi].Color = hov and Color3.fromRGB(26,26,34) or Color3.fromRGB(18,18,24)
            L[14+oi].Visible = true

            T[14+oi].Position = Vector2.new(px+20, oy+8)
            T[14+oi].Text = o[1]
            T[14+oi].Size = 11
            T[14+oi].Center = false
            T[14+oi].Color = hov and Color3.fromRGB(235,235,240) or Color3.fromRGB(155,155,165)
            T[14+oi].Visible = true

            if hov then optHover = oi end
            oy = oy + 40
        end
    else
        hide()
    end
end)

UIS.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        mDown = true
        local mx, my = UIS:GetMouseLocation().X, UIS:GetMouseLocation().Y
        if open then
            -- Tab click
            for i = 1, #tabNames do
                local tx = cx + 10 + (i-1) * 85
                if mx >= tx and mx <= tx+78 and my >= cy+30 and my <= cy+52 then
                    tab = i; return
                end
            end
            -- Option click
            local oy = cy + 58
            for oi = 1, #opts[tabNames[tab]] do
                if mx >= cx+10 and mx <= cx+270 and my >= oy and my <= oy+35 then
                    local key = opts[tabNames[tab]][oi][2]
                    if key == "esp" then Cfg.esp = not Cfg.esp
                    elseif key == "aim" then Cfg.aim = not Cfg.aim
                    elseif key == "ws" then Cfg.ws = Cfg.ws >= 200 and 16 or Cfg.ws + 10; opts[tabNames[tab]][oi][1] = "WS: "..Cfg.ws
                    elseif key == "key" then
                        local kt = Drawing.new("Text"); kt.Text = "Press any key"; kt.Position = Vector2.new(400,300); kt.Size = 16; kt.Visible = true
                        local conn = UIS.InputBegan:Connect(function(i2)
                            if i2.UserInputType == Enum.UserInputType.Keyboard then
                                keyToggle = i2.KeyCode; opts[tabNames[tab]][oi][1] = "Key: "..i2.KeyCode.Name
                                kt.Visible = false; conn:Disconnect()
                            end
                        end)
                    end
                    return
                end
                oy = oy + 40
            end
            -- Drag title
            if my >= cy and my <= cy+26 then
                drag = true; dx = mx - cx; dy = my - cy; return
            end
        end
        drag = true; dx = mx - cx; dy = my - cy
    end
    if inp.KeyCode == keyToggle then
        open = not open
        if not open then hide() end
    end
end)

UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        mDown = false; drag = false
    end
end)
end)
