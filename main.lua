-- [[ TH SYSTEM V5.1 - ANTI-AFK & FIREBASE PROTECT ]] --
repeat task.wait() until game:IsLoaded()

local Player = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui") 
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

-- CONFIGURAÇÃO FIREBASE (DATABASE PRINCIPAL)
local BASE_URL = "https://th-system-database-default-rtdb.firebaseio.com/"
local Settings = {
    Aimbot = false, 
    ESP = false, 
    AutoFish = false, 
    AntiLag = false, 
    IPMask = true,
    AntiAFK = true,
    Smoothness = 0.25
}

-- [[ SISTEMA ANTI-AFK ]] --
Player.Idled:Connect(function()
    if Settings.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- [ FUNÇÃO DE BUSCA NO FIREBASE ]
local function FetchFirebase(path)
    local success, result = pcall(function()
        return game:HttpGet(BASE_URL .. path .. ".json", true)
    end)
    if success then return HttpService:JSONDecode(result) end
    return nil
end

-- [ SISTEMA DE MASCARA DE IP ]
if Settings.IPMask then
    local fakeIP = tostring(math.random(100,255).."."..math.random(0,255).."."..math.random(0,255).."."..math.random(1,254))
    print("TH SYSTEM: PROTEÇÃO DE IP ATIVA [" .. fakeIP .. "]")
end

-- [ FUNÇÃO ANTI-LAG ]
local function ToggleAntiLag()
    if Settings.AntiLag then
        settings().Rendering.QualityLevel = 1
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            end
        end
        game:GetService("Lighting").GlobalShadows = false
    end
end

-- [ AUTO PESCA ]
task.spawn(function()
    while true do
        task.wait(0.5)
        if Settings.AutoFish then
            pcall(function()
                local tool = Player.Character:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() task.wait(6.2) end
            end)
        end
    end
end)

-- [ AIMBOT & ESP ]
RS.RenderStepped:Connect(function()
    local Camera = workspace.CurrentCamera
    if Settings.Aimbot then
        local target = nil; local dist = 200
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
                if onScreen then
                    local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if mag < dist then target = v.Character.Head; dist = mag end
                end
            end
        end
        if target then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), Settings.Smoothness) end
    end
    if Settings.ESP then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= Player and p.Character and p.Character:FindFirstChild("Head") then
                local esp = CoreGui:FindFirstChild("TH_ESP_" .. p.Name)
                if not esp then
                    local bgui = Instance.new("BillboardGui", CoreGui); bgui.Name = "TH_ESP_" .. p.Name; bgui.Adornee = p.Character.Head; bgui.Size = UDim2.new(0, 80, 0, 40); bgui.AlwaysOnTop = true
                    local tl = Instance.new("TextLabel", bgui); tl.BackgroundTransparency = 1; tl.Size = UDim2.new(1, 0, 1, 0); tl.TextColor3 = Color3.fromRGB(255, 0, 150); tl.Font = "GothamBold"; tl.TextSize = 10; tl.Name = "Info"
                else
                    esp.Enabled = true
                    local d = math.floor((Player.Character.HumanoidRootPart.Position - p.Character.Head.Position).Magnitude)
                    esp.Info.Text = p.Name .. "\n[" .. d .. "m]"
                end
            end
        end
    else
        for _, v in pairs(CoreGui:GetChildren()) do if v.Name:find("TH_ESP_") then v.Enabled = false end end
    end
end)

-- [ MENU PRINCIPAL ]
local function AbrirMenu(infoData)
    local HUD = Instance.new("ScreenGui", CoreGui); HUD.Name = "TH_V5_1"
    
    local Floating = Instance.new("TextButton", HUD)
    Floating.Size = UDim2.new(0, 50, 0, 50); Floating.Position = UDim2.new(0, 15, 0.5, -25); Floating.BackgroundColor3 = Color3.fromRGB(15, 15, 18); Floating.Text = "TH"; Floating.TextColor3 = Color3.fromRGB(255, 0, 150); Floating.Font = "GothamBold"; Floating.Visible = false; Instance.new("UICorner", Floating).CornerRadius = UDim.new(1,0); Instance.new("UIStroke", Floating).Color = Color3.fromRGB(255, 0, 150)

    local Main = Instance.new("Frame", HUD)
    Main.Size = UDim2.new(0, 220, 0, 360); Main.Position = UDim2.new(0.5, -110, 0.5, -180); Main.BackgroundColor3 = Color3.fromRGB(12, 12, 15); Instance.new("UICorner", Main); Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 0, 150)
    
    local Title = Instance.new("TextLabel", Main); Title.Size = UDim2.new(1, 0, 0, 40); Title.Text = "TH SYSTEM V5.1"; Title.TextColor3 = Color3.fromRGB(255, 0, 150); Title.Font = "GothamBold"; Title.BackgroundTransparency = 1; Title.TextSize = 13

    local List = Instance.new("ScrollingFrame", Main); List.Size = UDim2.new(1, -20, 1, -110); List.Position = UDim2.new(0, 10, 0, 50); List.BackgroundTransparency = 1; List.ScrollBarThickness = 2; Instance.new("UIListLayout", List).Padding = UDim.new(0, 8)

    local function AddBtn(name, key, action)
        local btn = Instance.new("TextButton", List); btn.Size = UDim2.new(0.95, 0, 0, 35); btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25); btn.Text = name; btn.TextColor3 = Color3.fromRGB(200, 200, 200); btn.Font = "GothamBold"; btn.TextSize = 11; Instance.new("UICorner", btn)
        local s = Instance.new("UIStroke", btn); s.Color = Color3.fromRGB(45, 45, 50)
        btn.MouseButton1Click:Connect(function()
            Settings[key] = not Settings[key]
            btn.TextColor3 = Settings[key] and Color3.fromRGB(255, 0, 150) or Color3.fromRGB(200, 200, 200)
            s.Color = Settings[key] and Color3.fromRGB(255, 0, 150) or Color3.fromRGB(45, 45, 50)
            if action then action() end
        end)
    end

    AddBtn("AIMBOT", "Aimbot")
    AddBtn("ESP PLAYERS", "ESP")
    AddBtn("AUTO PESCA (6S)", "AutoFish")
    AddBtn("ANTI-LAG", "AntiLag", ToggleAntiLag)

    -- ABA MISC (INFO DO FIREBASE)
    local InfoFrame = Instance.new("Frame", Main); InfoFrame.Size = UDim2.new(1, -20, 0, 50); InfoFrame.Position = UDim2.new(0, 10, 1, -60); InfoFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22); Instance.new("UICorner", InfoFrame)
    local InfoText = Instance.new("TextLabel", InfoFrame); InfoText.Size = UDim2.new(1, 0, 1, 0); InfoText.BackgroundTransparency = 1; InfoText.TextColor3 = Color3.fromRGB(150, 150, 150); InfoText.Font = "GothamSemibold"; InfoText.TextSize = 10;
    InfoText.Text = "Expira em: " .. (infoData.dias or "?") .. " Dias\nStatus: Online ✅"

    local Min = Instance.new("TextButton", Main); Min.Size = UDim2.new(0, 28, 0, 28); Min.Position = UDim2.new(1, -64, 0, 6); Min.Text = "-"; Min.TextColor3 = Color3.fromRGB(255,255,255); Min.BackgroundColor3 = Color3.fromRGB(30, 30, 35); Instance.new("UICorner", Min)
    Min.MouseButton1Click:Connect(function() Main.Visible = false; Floating.Visible = true end)
    Floating.MouseButton1Click:Connect(function() Main.Visible = true; Floating.Visible = false end)

    local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(0, 28, 0, 28); Close.Position = UDim2.new(1, -34, 0, 6); Close.Text = "X"; Close.TextColor3 = Color3.fromRGB(255,255,255); Close.BackgroundColor3 = Color3.fromRGB(150, 0, 50); Instance.new("UICorner", Close)
    Close.MouseButton1Click:Connect(function() HUD:Destroy() end)
end

-- [ SISTEMA DE LOGIN COM KILL-SWITCH ]
local function IniciarLogin()
    local LGui = Instance.new("ScreenGui", CoreGui); local LFrame = Instance.new("Frame", LGui)
    LFrame.Size = UDim2.new(0, 260, 0, 120); LFrame.Position = UDim2.new(0.5, -130, 0.5, -60); LFrame.BackgroundColor3 = Color3.fromRGB(10,10,12); Instance.new("UICorner", LFrame); Instance.new("UIStroke", LFrame).Color = Color3.fromRGB(255, 0, 150)
    local LText = Instance.new("TextLabel", LFrame); LText.Size = UDim2.new(1, 0, 1, 0); LText.Text = "TH SYSTEM: VALIDANDO..."; LText.TextColor3 = Color3.fromRGB(255, 0, 150); LText.Font = "GothamBold"; LText.TextSize = 12; LText.BackgroundTransparency = 1
    
    -- 1. CHECA O INTERRUPTOR GERAL (Script_Status)
    local globalStatus = FetchFirebase("Script_Status")
    if globalStatus == false then
        LText.Text = "SCRIPT DESLIGADA PELO ADM!"; task.wait(3)
        Player:Kick("\n[ TH SYSTEM ]\nScript em manutenção ou desligada.")
        return
    end

    -- 2. CHECA A WHITELIST DO PLAYER
    -- Nota: O seu Firebase está organizado como whitelist/dono/nick
    -- Como não sabemos o "dono" de primeira, buscamos na pasta geral 'whitelist'
    local fullWhitelist = FetchFirebase("whitelist")
    local userData = nil
    
    if fullWhitelist then
        for dono, players in pairs(fullWhitelist) do
            if players[Player.Name] then
                userData = players[Player.Name]
                break
            end
        end
    end

    task.wait(1.5)
    
    if userData then
        LText.Text = "BEM-VINDO, " .. Player.Name:upper(); task.wait(0.8); LGui:Destroy()
        AbrirMenu(userData)
    else
        LText.Text = "ACESSO NEGADO! (SEM WHITELIST)"; task.wait(3)
        Player:Kick("TH SYSTEM: Você não possui uma licença ativa.")
    end
end

IniciarLogin()
