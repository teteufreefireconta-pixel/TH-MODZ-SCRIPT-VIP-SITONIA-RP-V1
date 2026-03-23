-- =================================================================
-- TH MODZ SCRIPT V1 - V110 (ULTIMATE EDITION)
-- STATUS: TUDO VOLTOU | ESP DISTANCE | AIMBOT | RADARES | F1 & X
-- =================================================================

local Player = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")

local Settings = {
    Aimbot = false, 
    ShowFOV = false,
    FOVSize = 150,
    ESP = false, 
    Fly = false, 
    FlySpeed = 70,
    AutoAction = false, 
    WalkEating = false,
    RadarStaff = false,
    RadarUser = false
}

-- 1. FOV CENTRALIZADO
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(255, 0, 150)
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Visible = false

-- 2. FUNÇÃO DRAG (ARRASTAR)
local function Drag(obj)
    local d, s, sp
    obj.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true s = i.Position sp = obj.Position end end)
    UIS.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - s
        obj.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
    end end)
    obj.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
end

-- 3. ESP DISTÂNCIA (FIXED)
local function CreateESP(Target)
    local Text = Drawing.new("Text")
    Text.Visible = false; Text.Center = true; Text.Outline = true; Text.Font = 2; Text.Size = 13; Text.Color = Color3.fromRGB(255, 255, 255)
    RS.RenderStepped:Connect(function()
        if Settings.ESP and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") and Target ~= Player then
            local Root = Target.Character.HumanoidRootPart
            local Pos, OnScreen = Camera:WorldToViewportPoint(Root.Position)
            if OnScreen then
                local Dist = math.floor((Player.Character.HumanoidRootPart.Position - Root.Position).Magnitude)
                Text.Position = Vector2.new(Pos.X, Pos.Y); Text.Text = Target.Name .. " [" .. Dist .. "m]"; Text.Visible = true
            else Text.Visible = false end
        else Text.Visible = false end
        if not (Target and Target.Parent) then Text:Remove() end
    end)
end
for _, v in pairs(game.Players:GetPlayers()) do CreateESP(v) end
game.Players.PlayerAdded:Connect(CreateESP)

-- 4. LOGIN COM TEXTBOX E ANIMAÇÃO
local function CreateLogin()
    local LoginGui = Instance.new("ScreenGui", Player.PlayerGui); LoginGui.ResetOnSpawn = false
    local Main = Instance.new("Frame", LoginGui); Main.Size = UDim2.new(0, 320, 0, 320); Main.Position = UDim2.new(0.5, -160, 0.4, -160)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15); Instance.new("UICorner", Main); Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 0, 150)
    local Title = Instance.new("TextLabel", Main); Title.Size = UDim2.new(1, 0, 0, 80); Title.Text = "TH SYSTEM"; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.GothamBold; Title.TextSize = 24; Title.BackgroundTransparency = 1
    
    local KeyBox = Instance.new("TextBox", Main); KeyBox.Size = UDim2.new(0.8, 0, 0, 45); KeyBox.Position = UDim2.new(0.1, 0, 0.4, 0); KeyBox.PlaceholderText = "INSIRA SUA KEY..."; KeyBox.BackgroundColor3 = Color3.fromRGB(20, 20, 25); KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", KeyBox)
    local LogBtn = Instance.new("TextButton", Main); LogBtn.Size = UDim2.new(0.8, 0, 0, 45); LogBtn.Position = UDim2.new(0.1, 0, 0.65, 0); LogBtn.Text = "VERIFICAR"; LogBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 150); LogBtn.TextColor3 = Color3.fromRGB(255, 255, 255); LogBtn.Font = Enum.Font.GothamBold; Instance.new("UICorner", LogBtn)

    LogBtn.MouseButton1Click:Connect(function()
        LogBtn.Visible = false; KeyBox.Visible = false
        local BarBg = Instance.new("Frame", Main); BarBg.Size = UDim2.new(0.8, 0, 0, 10); BarBg.Position = UDim2.new(0.1, 0, 0.6, 0); BarBg.BackgroundColor3 = Color3.fromRGB(30, 30, 35); Instance.new("UICorner", BarBg)
        local Fill = Instance.new("Frame", BarBg); Fill.Size = UDim2.new(0, 0, 1, 0); Fill.BackgroundColor3 = Color3.fromRGB(255, 0, 150); Instance.new("UICorner", Fill)
        local Msgs = {"VERIFICANDO NA FIREBASE", "USUARIO CONFIRMADO", "SINCRONIZANDO...", "BEM VINDO, " .. Player.Name:upper()}
        for i, msg in ipairs(Msgs) do
            Title.Text = msg
            local Tw = TS:Create(Fill, TweenInfo.new(2, Enum.EasingStyle.Linear), {Size = UDim2.new(i/#Msgs, 0, 1, 0)})
            Tw:Play(); Tw.Completed:Wait()
        end
        LoginGui:Destroy(); LoadV1Menu()
    end)
end

-- 5. MENU PRINCIPAL (COM TUDO)
function LoadV1Menu()
    local HUD = Instance.new("ScreenGui", Player.PlayerGui); HUD.Name = "TH_V1"; HUD.ResetOnSpawn = false

    local function CreateRadar(name, color, pos)
        local R = Instance.new("Frame", HUD); R.Size = UDim2.new(0, 180, 0, 100); R.Position = pos; R.BackgroundColor3 = Color3.fromRGB(12, 12, 15); R.Visible = false; Instance.new("UICorner", R); Instance.new("UIStroke", R).Color = color; Drag(R)
        local L = Instance.new("TextLabel", R); L.Size = UDim2.new(1, -10, 1, -30); L.Position = UDim2.new(0, 5, 0, 30); L.TextColor3 = Color3.fromRGB(255, 255, 255); L.TextSize = 10; L.BackgroundTransparency = 1; L.TextYAlignment = Enum.TextYAlignment.Top; L.Text = "Limpo."
        local T = Instance.new("TextLabel", R); T.Size = UDim2.new(1, 0, 0, 25); T.Text = name; T.TextColor3 = color; T.Font = Enum.Font.GothamBold; T.BackgroundTransparency = 1
        return R, L
    end
    local RSF, TSF = CreateRadar("RADAR STAFF", Color3.fromRGB(255, 50, 50), UDim2.new(0.8, 0, 0.1, 0))
    local RUS, TUS = CreateRadar("RADAR USER", Color3.fromRGB(50, 150, 255), UDim2.new(0.8, 0, 0.25, 0))

    local Main = Instance.new("Frame", HUD); Main.Size = UDim2.new(0, 260, 0, 480); Main.Position = UDim2.new(0.5, -130, 0.4, -240); Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12); Instance.new("UICorner", Main); Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 0, 150); Drag(Main)
    
    local Top = Instance.new("Frame", Main); Top.Size = UDim2.new(1, 0, 0, 40); Top.BackgroundColor3 = Color3.fromRGB(255, 0, 150); Top.BackgroundTransparency = 0.8; Instance.new("UICorner", Top)
    local MTitle = Instance.new("TextLabel", Top); MTitle.Size = UDim2.new(1, -40, 1, 0); MTitle.Position = UDim2.new(0, 10, 0, 0); MTitle.Text = "TH MODZ V1"; MTitle.TextColor3 = Color3.fromRGB(255, 255, 255); MTitle.Font = Enum.Font.GothamBold; MTitle.BackgroundTransparency = 1; MTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local Close = Instance.new("TextButton", Top); Close.Size = UDim2.new(0, 30, 0, 30); Close.Position = UDim2.new(1, -35, 0.5, -15); Close.Text = "X"; Close.BackgroundColor3 = Color3.fromRGB(200, 0, 0); Close.TextColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", Close)
    Close.MouseButton1Click:Connect(function() HUD:Destroy() end)

    local Scroll = Instance.new("ScrollingFrame", Main); Scroll.Size = UDim2.new(1, -20, 1, -60); Scroll.Position = UDim2.new(0, 10, 0, 50); Scroll.BackgroundTransparency = 1; Scroll.ScrollBarThickness = 0; Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 8)

    local function AddSwitch(txt, key)
        local b = Instance.new("TextButton", Scroll); b.Size = UDim2.new(1, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(20, 20, 25); b.Text = "  " .. txt; b.TextColor3 = Color3.fromRGB(180, 180, 180); b.Font = Enum.Font.GothamBold; b.TextXAlignment = Enum.TextXAlignment.Left; Instance.new("UICorner", b)
        local Sw = Instance.new("Frame", b); Sw.Size = UDim2.new(0, 28, 0, 14); Sw.Position = UDim2.new(1, -35, 0.5, -7); Sw.BackgroundColor3 = Color3.fromRGB(45, 45, 50); Instance.new("UICorner", Sw).CornerRadius = UDim.new(1, 0)
        local Ball = Instance.new("Frame", Sw); Ball.Size = UDim2.new(0, 10, 0, 10); Ball.Position = UDim2.new(0, 2, 0.5, -5); Ball.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", Ball)
        b.MouseButton1Click:Connect(function()
            Settings[key] = not Settings[key]
            TS:Create(Ball, TweenInfo.new(0.2), {Position = Settings[key] and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)}):Play()
            TS:Create(Sw, TweenInfo.new(0.2), {BackgroundColor3 = Settings[key] and Color3.fromRGB(255, 0, 150) or Color3.fromRGB(45, 45, 50)}):Play()
            if key == "RadarStaff" then RSF.Visible = Settings[key] end
            if key == "RadarUser" then RUS.Visible = Settings[key] end
        end)
    end

    AddSwitch("AIMBOT (M2)", "Aimbot"); AddSwitch("EXIBIR FOV", "ShowFOV"); AddSwitch("ESP DISTANCIA", "ESP"); AddSwitch("VOAR (FLY)", "Fly"); AddSwitch("AUTO ACTION", "AutoAction"); AddSwitch("ANDAR COMENDO", "WalkEating"); AddSwitch("RADAR STAFF", "RadarStaff"); AddSwitch("RADAR USER", "RadarUser")

    UIS.InputBegan:Connect(function(i, g) if i.KeyCode == Enum.KeyCode.F1 then Main.Visible = not Main.Visible end end)

    RS.RenderStepped:Connect(function()
        FOVCircle.Visible = Settings.ShowFOV
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        FOVCircle.Radius = Settings.FOVSize

        local Char = Player.Character; if not (Char and Char:FindFirstChild("HumanoidRootPart")) then return end
        local HRP = Char.HumanoidRootPart

        if Settings.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local Target = nil; local MaxDist = Settings.FOVSize
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= Player and v.Character and v.Character:FindFirstChild("Head") then
                    local Pos, OnScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
                    if OnScreen then
                        local MouseDist = (Vector2.new(Pos.X, Pos.Y) - FOVCircle.Position).Magnitude
                        if MouseDist < MaxDist then Target = v.Character.Head; MaxDist = MouseDist end
                    end
                end
            end
            if Target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Position) end
        end

        if Settings.Fly then
            Char.Humanoid:ChangeState(11)
            local M = Vector3.new(0, 0.05, 0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then M = M + Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then M = M - Camera.CFrame.LookVector end
            HRP.Velocity = M * Settings.FlySpeed
        end

        local SData = ""
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("Head") then
                if v:GetRankInGroup(0) > 10 or v.Name:lower():find("admin") then 
                    SData = SData .. v.Name .. " [" .. math.floor((HRP.Position - v.Character.Head.Position).Magnitude) .. "m]\n" 
                end
            end
        end
        TSF.Text = SData ~= "" and SData or "Limpo."; TUS.Text = Player.Name .. " [VIP]"
        if Settings.AutoAction then local T = Char:FindFirstChildOfClass("Tool"); if T then T:Activate() end end
    end)
end

CreateLogin()
