-- =================================================================
-- TH SYSTEM V69 (VISIBLE CHECK + RADAR ADM)
-- STATUS: AIMBOT LEGIT ON | STAFF RADAR FIXED | FAST EAT
-- =================================================================

local Player = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")

local Settings = {Aimbot = false, ESP = false, Fly = false, FastActions = false, Radar = false}
local FlySpeed = 1.8

-- 1. TELA DE LOGIN COM CAMPO DE KEY
local LoginGui = Instance.new("ScreenGui", Player.PlayerGui)
local Main = Instance.new("Frame", LoginGui)
Main.Size = UDim2.new(0, 320, 0, 300)
Main.Position = UDim2.new(0.5, -160, 0.4, -150)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Instance.new("UICorner", Main)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 0, 150)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Text = "TH SYSTEM"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 28
Title.BackgroundTransparency = 1

local KeyInput = Instance.new("TextBox", Main)
KeyInput.Size = UDim2.new(0.8, 0, 0, 40)
KeyInput.Position = UDim2.new(0.1, 0, 0.4, 0)
KeyInput.PlaceholderText = "COLE SUA KEY AQUI..."
KeyInput.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", KeyInput)

local LogBtn = Instance.new("TextButton", Main)
LogBtn.Size = UDim2.new(0.8, 0, 0, 45)
LogBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
LogBtn.Text = "LOGAR"
LogBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 150)
LogBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LogBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", LogBtn)

-- FUNÇÃO DRAG (ARRASTAR TUDO)
local function Drag(obj)
    local d, i, s, sp
    obj.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then d = true s = inp.Position sp = obj.Position end end)
    UIS.InputChanged:Connect(function(inp) if d and inp.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = inp.Position - s
        obj.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
    end end)
    obj.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
end

-- 2. CARREGAMENTO ANIMADO
local function StartLoading()
    LogBtn.Visible = false
    KeyInput.Visible = false
    local BarBg = Instance.new("Frame", Main)
    BarBg.Size = UDim2.new(0.8, 0, 0, 8)
    BarBg.Position = UDim2.new(0.1, 0, 0.6, 0)
    BarBg.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Instance.new("UICorner", BarBg)
    local Fill = Instance.new("Frame", BarBg)
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(255, 0, 150)
    Instance.new("UICorner", Fill)
    
    local msgs = {"Limpando Registros...", "Bypass Ativo!", "Injetando Funções...", "Sucesso!"}
    for i, m in ipairs(msgs) do
        TS:Create(Fill, TweenInfo.new(0.7), {Size = UDim2.new(i/#msgs, 0, 1, 0)}):Play()
        task.wait(0.7)
    end
    LoginGui:Destroy()
    LoadMain()
end

-- 3. MENU PRINCIPAL E RADAR
function LoadMain()
    local HUD = Instance.new("ScreenGui", Player.PlayerGui)
    
    -- JANELA RADAR ADM (SEPARADA E ARRASTÁVEL)
    local Radar = Instance.new("Frame", HUD)
    Radar.Size = UDim2.new(0, 180, 0, 100)
    Radar.Position = UDim2.new(0.8, 0, 0.1, 0)
    Radar.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    Radar.Visible = false
    Instance.new("UICorner", Radar)
    Instance.new("UIStroke", Radar).Color = Color3.fromRGB(255, 0, 0)
    Drag(Radar)
    
    local RTitle = Instance.new("TextLabel", Radar)
    RTitle.Size = UDim2.new(1, 0, 0, 25)
    RTitle.Text = "RADAR ADM"
    RTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    RTitle.BackgroundTransparency = 1
    
    local RList = Instance.new("TextLabel", Radar)
    RList.Size = UDim2.new(1, 0, 0.7, 0)
    RList.Position = UDim2.new(0, 0, 0.25, 0)
    RList.Text = "NENHUM STAFF"
    RList.TextColor3 = Color3.fromRGB(255, 255, 255)
    RList.BackgroundTransparency = 1

    -- JANELA PRINCIPAL
    local Menu = Instance.new("Frame", HUD)
    Menu.Size = UDim2.new(0, 220, 0, 300)
    Menu.Position = UDim2.new(0.1, 0, 0.4, 0)
    Menu.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Instance.new("UICorner", Menu)
    Instance.new("UIStroke", Menu).Color = Color3.fromRGB(255, 0, 150)
    Drag(Menu)

    -- BOTÕES X E -
    local Close = Instance.new("TextButton", Menu)
    Close.Size = UDim2.new(0, 30, 0, 30)
    Close.Position = UDim2.new(1, -35, 0, 5)
    Close.Text = "X"
    Close.TextColor3 = Color3.fromRGB(255, 0, 0)
    Close.BackgroundTransparency = 1
    Close.MouseButton1Click:Connect(function() HUD:Destroy() end)

    local Min = Instance.new("TextButton", Menu)
    Min.Size = UDim2.new(0, 30, 0, 30)
    Min.Position = UDim2.new(1, -65, 0, 5)
    Min.Text = "-"
    Min.TextColor3 = Color3.fromRGB(255, 255, 255)
    Min.BackgroundTransparency = 1

    local Ball = Instance.new("TextButton", HUD)
    Ball.Size = UDim2.new(0, 50, 0, 50)
    Ball.Position = UDim2.new(0.05, 0, 0.5, 0)
    Ball.Text = "TH"
    Ball.BackgroundColor3 = Color3.fromRGB(255, 0, 150)
    Ball.Visible = false
    Instance.new("UICorner", Ball).CornerRadius = UDim.new(1, 0)
    Drag(Ball)

    Min.MouseButton1Click:Connect(function() Menu.Visible = false Ball.Visible = true end)
    Ball.MouseButton1Click:Connect(function() Menu.Visible = true Ball.Visible = false end)

    -- LISTA DE BOTÕES
    local Scroll = Instance.new("ScrollingFrame", Menu)
    Scroll.Size = UDim2.new(1, -20, 1, -60)
    Scroll.Position = UDim2.new(0, 10, 0, 50)
    Scroll.BackgroundTransparency = 1
    Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 8)

    local function CreateToggle(name, key)
        local b = Instance.new("TextButton", Scroll)
        b.Size = UDim2.new(1, 0, 0, 38)
        b.Text = name .. ": OFF"
        b.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            Settings[key] = not Settings[key]
            b.Text = name .. (Settings[key] and ": ON" or ": OFF")
            b.TextColor3 = Settings[key] and Color3.fromRGB(255, 0, 150) or Color3.fromRGB(255, 255, 255)
            if key == "Radar" then Radar.Visible = Settings[key] end
        end)
    end

    CreateToggle("AIMBOT (VISIBLE)", "Aimbot")
    CreateToggle("ESP NOME/DIST", "ESP")
    CreateToggle("FAST EAT/DRINK", "FastActions")
    CreateToggle("RADAR ADM", "Radar")
    CreateToggle("FLY CFRAME (W)", "Fly")

    -- MOTOR DE FUNÇÕES
    local ESP_F = Instance.new("Folder", HUD)

    RS.Heartbeat:Connect(function()
        ESP_F:ClearAllChildren()
        local BestTarget = nil
        local BestDist = 500
        local StaffsFound = ""

        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("Head") then
                local head = v.Character.Head
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)

                -- 1. AIMBOT COM CHECK DE PAREDE
                if Settings.Aimbot and onScreen and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                    local mouse = UIS:GetMouseLocation()
                    local dist = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
                    
                    if dist < BestDist then
                        -- CHECK DE VISIBILIDADE (RAYCAST)
                        local rayParams = RaycastParams.new()
                        rayParams.FilterDescendantsInstances = {Player.Character, v.Character}
                        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                        
                        local result = workspace:Raycast(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * 500, rayParams)
                        
                        if not result then -- Se não bateu em nada (parede), o jogador está visível
                            BestTarget = head
                            BestDist = dist
                        end
                    end
                end

                -- 2. ESP
                if Settings.ESP and onScreen then
                    local d = math.floor((Player.Character.HumanoidRootPart.Position - head.Position).Magnitude)
                    local l = Instance.new("TextLabel", ESP_F)
                    l.Position = UDim2.new(0, pos.X - 50, 0, pos.Y - 50)
                    l.Size = UDim2.new(0, 100, 0, 20)
                    l.Text = v.Name .. " [" .. d .. "m]"
                    l.TextColor3 = Color3.fromRGB(255, 255, 255)
                    l.BackgroundTransparency = 1
                end

                -- 3. STAFF RADAR
                if v:GetRankInGroup(0) > 10 or v.Name:lower():find("admin") or v.Name:lower():find("mod") then
                    StaffsFound = StaffsFound .. v.Name .. "\n"
                end
            end
        end

        if BestTarget then Camera.CFrame = CFrame.new(Camera.CFrame.Position, BestTarget.Position) end
        if Settings.Radar then RList.Text = StaffsFound ~= "" and StaffsFound or "LIMPO" end
        
        -- FAST EAT/DRINK
        if Settings.FastActions then
            local tool = Player.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end

        -- FLY
        if Settings.Fly and UIS:IsKeyDown(Enum.KeyCode.W) then
            Player.Character.HumanoidRootPart.CFrame *= CFrame.new(0, 0, -FlySpeed)
        end
    end)
end

LogBtn.MouseButton1Click:Connect(function() if #KeyInput.Text > 0 then StartLoading() end end)
