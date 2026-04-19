-- ==========================================
-- EDSON SCRIPT - UI PREMIUM
-- ==========================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Remove interface antiga se existir
if CoreGui:FindFirstChild("EdsonScriptUI") then
    CoreGui.EdsonScriptUI:Destroy()
end

-- ScreenGui Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EdsonScriptUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- ==========================================
-- BOTÃO BOLINHA (TOGGLE RAINBOW)
-- ==========================================
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBolinha"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.Position = UDim2.new(0, 50, 0, 50)
ToggleBtn.Size = UDim2.new(0, 100, 0, 50)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "EDSON SCRIPT"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 12
ToggleBtn.AutoButtonColor = false

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = ToggleBtn
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Efeito Rainbow na Borda da Bolinha
RunService.RenderStepped:Connect(function()
    local hue = tick() % 5 / 5
    UIStroke.Color = Color3.fromHSV(hue, 1, 1)
end)

-- ==========================================
-- MENU PRINCIPAL (PREMIUM)
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBlack
Title.Text = "EDSON SCRIPT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20

local TitleLine = Instance.new("Frame")
TitleLine.Parent = MainFrame
TitleLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TitleLine.Position = UDim2.new(0, 0, 0, 40)
TitleLine.Size = UDim2.new(1, 0, 0, 1)

local ButtonContainer = Instance.new("ScrollingFrame")
ButtonContainer.Parent = MainFrame
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Position = UDim2.new(0, 10, 0, 50)
ButtonContainer.Size = UDim2.new(1, -20, 1, -60)
ButtonContainer.ScrollBarThickness = 4
ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, 350)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ButtonContainer
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

-- ==========================================
-- SISTEMA DE CRIAR BOTÕES
-- ==========================================
local Toggles = {
    EspLinha = false,
    EspVida = false,
    EspNome = false,
    EspEsqueleto = false,
    AimbotRage = false,
    AimbotLegit = false
}

local function CreateToggle(name, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Parent = ButtonContainer
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Btn.Size = UDim2.new(1, -10, 0, 40)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.TextSize = 14
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Btn
    
    Btn.MouseButton1Click:Connect(function()
        Toggles[name] = not Toggles[name]
        
        local targetColor = Toggles[name] and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(30, 30, 35)
        local targetTextColor = Toggles[name] and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
        
        TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = targetColor, TextColor3 = targetTextColor}):Play()
        
        callback(Toggles[name])
    end)
end

-- ==========================================
-- VARIÁVEIS GLOBAIS PARA ESP E AIMBOT
-- ==========================================
local ESPConnections = {} -- guarda as conexões do RenderStepped para ESP
local AimbotConnection = nil
local AimTarget = nil

-- Função auxiliar para verificar se um jogador é válido para ESP/Aimbot
local function IsValidTarget(player)
    local character = player.Character
    if not character then return false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    local head = character:FindFirstChild("Head")
    if not head then return false end
    return true
end

-- Função para obter posição 2D na tela a partir de posição 3D
local function WorldToScreen(position)
    local screenPos, onScreen = Camera:WorldToViewportPoint(position)
    return Vector2.new(screenPos.X, screenPos.Y), onScreen, screenPos.Z
end

-- ==========================================
-- IMPLEMENTAÇÃO DAS FUNÇÕES DE ESP
-- ==========================================

-- ESP Linha (Tracers)
local function UpdateEspLinha()
    local drawings = {}
    local function clear()
        for _, d in pairs(drawings) do
            if d.Remove then d:Remove() end
        end
        drawings = {}
    end
    
    local function update()
        clear()
        if not Toggles.EspLinha then return end
        
        local center = Camera.ViewportSize / 2
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and IsValidTarget(player) then
                local head = player.Character.Head
                local screenPos, onScreen = WorldToScreen(head.Position)
                if onScreen then
                    local line = Drawing.new("Line")
                    line.Visible = true
                    line.From = center
                    line.To = screenPos
                    line.Color = Color3.fromRGB(255, 255, 255)
                    line.Thickness = 1
                    line.Transparency = 1
                    table.insert(drawings, line)
                end
            end
        end
    end
    
    if Toggles.EspLinha then
        ESPConnections.EspLinha = RunService.RenderStepped:Connect(update)
        update()
    else
        if ESPConnections.EspLinha then
            ESPConnections.EspLinha:Disconnect()
            ESPConnections.EspLinha = nil
        end
        clear()
    end
end

-- ESP Vida (Barra de vida)
local function UpdateEspVida()
    local drawings = {}
    local function clear()
        for _, d in pairs(drawings) do
            if d.Remove then d:Remove() end
        end
        drawings = {}
    end
    
    local function update()
        clear()
        if not Toggles.EspVida then return end
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and IsValidTarget(player) then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                local head = player.Character.Head
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                if not root then continue end
                
                local health = humanoid.Health / humanoid.MaxHealth
                local pos2D, onScreen = WorldToScreen(head.Position + Vector3.new(0, 2, 0))
                if not onScreen then continue end
                
                local barWidth = 50
                local barHeight = 6
                local barX = pos2D.X - barWidth/2
                local barY = pos2D.Y - 30
                
                -- Fundo
                local bg = Drawing.new("Square")
                bg.Visible = true
                bg.Position = Vector2.new(barX, barY)
                bg.Size = Vector2.new(barWidth, barHeight)
                bg.Color = Color3.fromRGB(30, 30, 30)
                bg.Filled = true
                table.insert(drawings, bg)
                
                -- Barra de vida (cor varia de verde a vermelho)
                local fill = Drawing.new("Square")
                fill.Visible = true
                fill.Position = Vector2.new(barX, barY)
                fill.Size = Vector2.new(barWidth * health, barHeight)
                fill.Color = Color3.fromRGB(255 * (1 - health), 255 * health, 0)
                fill.Filled = true
                table.insert(drawings, fill)
                
                -- Borda
                local border = Drawing.new("Square")
                border.Visible = true
                border.Position = Vector2.new(barX, barY)
                border.Size = Vector2.new(barWidth, barHeight)
                border.Color = Color3.fromRGB(0, 0, 0)
                border.Thickness = 1
                border.Filled = false
                table.insert(drawings, border)
            end
        end
    end
    
    if Toggles.EspVida then
        ESPConnections.EspVida = RunService.RenderStepped:Connect(update)
        update()
    else
        if ESPConnections.EspVida then
            ESPConnections.EspVida:Disconnect()
            ESPConnections.EspVida = nil
        end
        clear()
    end
end

-- ESP Nome
local function UpdateEspNome()
    local drawings = {}
    local function clear()
        for _, d in pairs(drawings) do
            if d.Remove then d:Remove() end
        end
        drawings = {}
    end
    
    local function update()
        clear()
        if not Toggles.EspNome then return end
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and IsValidTarget(player) then
                local head = player.Character.Head
                local pos2D, onScreen = WorldToScreen(head.Position + Vector3.new(0, 2.5, 0))
                if onScreen then
                    local text = Drawing.new("Text")
                    text.Visible = true
                    text.Text = player.Name
                    text.Position = pos2D
                    text.Color = Color3.fromRGB(255, 255, 255)
                    text.Size = 14
                    text.Center = true
                    text.Outline = true
                    text.OutlineColor = Color3.new(0,0,0)
                    table.insert(drawings, text)
                end
            end
        end
    end
    
    if Toggles.EspNome then
        ESPConnections.EspNome = RunService.RenderStepped:Connect(update)
        update()
    else
        if ESPConnections.EspNome then
            ESPConnections.EspNome:Disconnect()
            ESPConnections.EspNome = nil
        end
        clear()
    end
end

-- ESP Esqueleto (linhas conectando juntas)
local function UpdateEspEsqueleto()
    local drawings = {}
    local function clear()
        for _, d in pairs(drawings) do
            if d.Remove then d:Remove() end
        end
        drawings = {}
    end
    
    local function drawLine(from, to, color)
        local from2D, onScreen1 = WorldToScreen(from)
        local to2D, onScreen2 = WorldToScreen(to)
        if onScreen1 and onScreen2 then
            local line = Drawing.new("Line")
            line.Visible = true
            line.From = from2D
            line.To = to2D
            line.Color = color or Color3.fromRGB(255, 255, 255)
            line.Thickness = 1
            table.insert(drawings, line)
        end
    end
    
    local function update()
        clear()
        if not Toggles.EspEsqueleto then return end
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and IsValidTarget(player) then
                local char = player.Character
                local head = char:FindFirstChild("Head")
                local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
                local leftArm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm")
                local rightArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm")
                local leftLeg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg")
                local rightLeg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg")
                local humanoidRoot = char:FindFirstChild("HumanoidRootPart")
                
                if head and torso then
                    drawLine(head.Position, torso.Position)
                end
                if torso and leftArm then
                    drawLine(torso.Position, leftArm.Position)
                end
                if torso and rightArm then
                    drawLine(torso.Position, rightArm.Position)
                end
                if torso and humanoidRoot then
                    drawLine(torso.Position, humanoidRoot.Position)
                end
                if humanoidRoot and leftLeg then
                    drawLine(humanoidRoot.Position, leftLeg.Position)
                end
                if humanoidRoot and rightLeg then
                    drawLine(humanoidRoot.Position, rightLeg.Position)
                end
            end
        end
    end
    
    if Toggles.EspEsqueleto then
        ESPConnections.EspEsqueleto = RunService.RenderStepped:Connect(update)
        update()
    else
        if ESPConnections.EspEsqueleto then
            ESPConnections.EspEsqueleto:Disconnect()
            ESPConnections.EspEsqueleto = nil
        end
        clear()
    end
end

-- ==========================================
-- AIMBOT
-- ==========================================
local function GetClosestTargetToCrosshair()
    local closest = nil
    local minDistance = math.huge
    local center = Camera.ViewportSize / 2
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsValidTarget(player) then
            local head = player.Character.Head
            local screenPos, onScreen = WorldToScreen(head.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                if dist < minDistance then
                    minDistance = dist
                    closest = player
                end
            end
        end
    end
    return closest
end

local function UpdateAimbot()
    if not (Toggles.AimbotRage or Toggles.AimbotLegit) then
        AimTarget = nil
        return
    end
    
    local target = GetClosestTargetToCrosshair()
    if not target then 
        AimTarget = nil
        return 
    end
    AimTarget = target
    
    local head = target.Character.Head
    local cameraPos = Camera.CFrame.Position
    
    if Toggles.AimbotRage then
        -- Rage: mira instantânea
        Camera.CFrame = CFrame.new(cameraPos, head.Position)
    elseif Toggles.AimbotLegit then
        -- Legit: suavização com Tween
        local targetCF = CFrame.new(cameraPos, head.Position)
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        local tween = TweenService:Create(Camera, tweenInfo, {CFrame = targetCF})
        tween:Play()
    end
end

local function StartAimbotLoop()
    if AimbotConnection then AimbotConnection:Disconnect() end
    AimbotConnection = RunService.RenderStepped:Connect(UpdateAimbot)
end

local function StopAimbotLoop()
    if AimbotConnection then
        AimbotConnection:Disconnect()
        AimbotConnection = nil
    end
end

-- ==========================================
-- CONFIGURAÇÃO DOS CALLBACKS
-- ==========================================

CreateToggle("EspLinha", "ESP Linha (Tracers)", function(state)
    UpdateEspLinha()
end)

CreateToggle("EspVida", "ESP Vida", function(state)
    UpdateEspVida()
end)

CreateToggle("EspNome", "ESP Nome", function(state)
    UpdateEspNome()
end)

CreateToggle("EspEsqueleto", "ESP Esqueleto", function(state)
    UpdateEspEsqueleto()
end)

CreateToggle("AimbotRage", "Aimbot Rage (Puxa Rápido)", function(state)
    if state then
        Toggles.AimbotLegit = false
        -- Atualiza visual do botão Legit (se necessário)
        -- Para simplificar, apenas paramos o aimbot legítimo
    end
    if state or Toggles.AimbotLegit then
        StartAimbotLoop()
    else
        StopAimbotLoop()
    end
end)

CreateToggle("AimbotLegit", "Aimbot Legit (Smooth/Delay)", function(state)
    if state then
        Toggles.AimbotRage = false
    end
    if state or Toggles.AimbotRage then
        StartAimbotLoop()
    else
        StopAimbotLoop()
    end
end)

-- ==========================================
-- LÓGICA DE ABRIR/FECHAR MENU
-- ==========================================
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Limpeza ao remover o script (boa prática)
ScreenGui.Destroying:Connect(function()
    for _, conn in pairs(ESPConnections) do
        if conn then conn:Disconnect() end
    end
    if AimbotConnection then AimbotConnection:Disconnect() end
end)
