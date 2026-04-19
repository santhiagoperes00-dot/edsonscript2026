-- ==========================================
-- EDSON SCRIPT - UI PREMIUM PRO (v6 - REDESIGN)
-- Adicionado: Fundo Transparente, Botão Flutuante Móvel, Switches Animados
-- Corrigido: Foco apenas em inimigos (ignora aliados do mesmo time)
-- ==========================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
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
ScreenGui.IgnoreGuiInset = true

-- Paleta de Cores Premium (Dark/Transparente)
local Colors = {
    Background = Color3.fromRGB(10, 10, 12),
    Surface = Color3.fromRGB(20, 20, 24),
    SurfaceHighlight = Color3.fromRGB(40, 40, 48),
    Primary = Color3.fromRGB(88, 101, 242), -- Azul Blurple
    Text = Color3.fromRGB(255, 255, 255),
    TextMuted = Color3.fromRGB(160, 160, 170),
    Danger = Color3.fromRGB(237, 66, 69)
}

-- ==========================================
-- LÓGICA DE ARRASTAR (DRAGGABLE)
-- ==========================================
local function MakeDraggable(topbarobject, object)
    local Dragging = false
    local DragInput
    local DragStart
    local StartPosition

    local function Update(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        TweenService:Create(object, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = pos}):Play()
    end

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

-- ==========================================
-- BOTÃO BOLINHA (MÓVEL E RAINBOW)
-- ==========================================
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBolinha"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
ToggleBtn.BackgroundTransparency = 0.3
ToggleBtn.Position = UDim2.new(0, 50, 0, 50)
ToggleBtn.Size = UDim2.new(0, 120, 0, 45)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "EDSON SCRIPT"
ToggleBtn.TextColor3 = Colors.Text
ToggleBtn.TextSize = 12
ToggleBtn.AutoButtonColor = false

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

local UIStrokeToggle = Instance.new("UIStroke")
UIStrokeToggle.Parent = ToggleBtn
UIStrokeToggle.Thickness = 2
UIStrokeToggle.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Fazendo o botão flutuante ser móvel
MakeDraggable(ToggleBtn, ToggleBtn)

-- Efeito Rainbow
RunService.RenderStepped:Connect(function()
    local hue = tick() % 5 / 5
    UIStrokeToggle.Color = Color3.fromHSV(hue, 0.8, 1)
end)

-- ==========================================
-- MENU PRINCIPAL (PREMIUM & TRANSPARENTE)
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BackgroundTransparency = 0.35 -- Deixa meio preto transparente
MainFrame.Position = UDim2.new(0.5, -220, 0.5, -200)
MainFrame.Size = UDim2.new(0, 440, 0, 430)
MainFrame.Visible = false
MainFrame.Active = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Thickness = 1
MainStroke.Color = Color3.fromRGB(60, 60, 65)
MainStroke.Transparency = 0.5

-- Fazendo o menu ser móvel arrastando pelo título
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundTransparency = 1
TopBar.Size = UDim2.new(1, 0, 0, 45)
MakeDraggable(TopBar, MainFrame)

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Font = Enum.Font.GothamBlack
Title.Text = " EDSON SCRIPT PRO"
Title.TextColor3 = Colors.Text
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0, 15, 0, 0)

local TitleLine = Instance.new("Frame")
TitleLine.Parent = MainFrame
TitleLine.BackgroundColor3 = Colors.SurfaceHighlight
TitleLine.Position = UDim2.new(0, 0, 0, 45)
TitleLine.Size = UDim2.new(1, 0, 0, 1)
TitleLine.BackgroundTransparency = 0.5

-- ==========================================
-- SISTEMA DE ABAS
-- ==========================================
local TabContainer = Instance.new("Frame")
TabContainer.Parent = MainFrame
TabContainer.BackgroundTransparency = 1
TabContainer.Position = UDim2.new(0, 15, 0, 55)
TabContainer.Size = UDim2.new(1, -30, 0, 32)

local TabESP = Instance.new("TextButton")
TabESP.Parent = TabContainer
TabESP.BackgroundColor3 = Colors.Primary
TabESP.BackgroundTransparency = 0.2
TabESP.Size = UDim2.new(0.5, -5, 1, 0)
TabESP.Position = UDim2.new(0, 0, 0, 0)
TabESP.Font = Enum.Font.GothamBold
TabESP.Text = "VISUAIS (ESP)"
TabESP.TextColor3 = Colors.Text
TabESP.TextSize = 13
TabESP.AutoButtonColor = false
Instance.new("UICorner", TabESP).CornerRadius = UDim.new(0, 8)

local TabAim = Instance.new("TextButton")
TabAim.Parent = TabContainer
TabAim.BackgroundColor3 = Colors.Surface
TabAim.BackgroundTransparency = 0.5
TabAim.Size = UDim2.new(0.5, -5, 1, 0)
TabAim.Position = UDim2.new(0.5, 5, 0, 0)
TabAim.Font = Enum.Font.GothamBold
TabAim.Text = "COMBATE (AIM)"
TabAim.TextColor3 = Colors.TextMuted
TabAim.TextSize = 13
TabAim.AutoButtonColor = false
Instance.new("UICorner", TabAim).CornerRadius = UDim.new(0, 8)

-- Frames das abas
local PageESP = Instance.new("Frame")
PageESP.Parent = MainFrame
PageESP.BackgroundTransparency = 1
PageESP.Position = UDim2.new(0, 15, 0, 95)
PageESP.Size = UDim2.new(1, -30, 1, -110)
PageESP.Visible = true

local PageAim = Instance.new("Frame")
PageAim.Parent = MainFrame
PageAim.BackgroundTransparency = 1
PageAim.Position = UDim2.new(0, 15, 0, 95)
PageAim.Size = UDim2.new(1, -30, 1, -110)
PageAim.Visible = false

local function CreateScrollingFrame(parent)
    local sf = Instance.new("ScrollingFrame")
    sf.Parent = parent
    sf.BackgroundTransparency = 1
    sf.Size = UDim2.new(1, 0, 1, 0)
    sf.ScrollBarThickness = 2
    sf.ScrollBarImageColor3 = Colors.Primary
    sf.CanvasSize = UDim2.new(0, 0, 0, 0)
    sf.BorderSizePixel = 0
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = sf
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sf.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    
    return sf, layout
end

local ESPContainer, ESPLayout = CreateScrollingFrame(PageESP)
local AimContainer, AimLayout = CreateScrollingFrame(PageAim)

-- ==========================================
-- VARIÁVEIS DE ESTADO
-- ==========================================
local Toggles = {
    ESPMaster = false, AimbotMaster = false, EspLinha = false, EspCaixa = false,
    EspVida = false, EspNome = false, EspEsqueleto = false,
    AimbotRage = false, AimbotLegit = false, ShowFOV = false
}

local AimPart = "Head" 
local LineOrigin = "Bottom" 
local FOVRadius = 150
local ESPConnections = {}
local AimbotConnection = nil
local AimTarget = nil
local ESPDrawings = { Lines = {}, Texts = {}, Squares = {} }

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Color = Colors.Primary
FOVCircle.Thickness = 1
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.NumSides = 64

local function ClearAllDrawings()
    for _, drawingList in pairs(ESPDrawings) do
        for _, d in ipairs(drawingList) do
            pcall(function() d:Remove() end)
        end
        table.clear(drawingList)
    end
end

-- ==========================================
-- CRIADORES DE UI (COM ANIMAÇÃO SWITCH)
-- ==========================================
local function CreateToggle(parent, name, text, isMaster, callback)
    local Btn = Instance.new("TextButton")
    Btn.Parent = parent
    Btn.BackgroundColor3 = Colors.Surface
    Btn.BackgroundTransparency = 0.5 -- Fundo levemente transparente
    Btn.Size = UDim2.new(1, -5, 0, isMaster and 45 or 40)
    Btn.Font = isMaster and Enum.Font.GothamBlack or Enum.Font.GothamSemibold
    Btn.Text = "  " .. text
    Btn.TextColor3 = Colors.TextMuted
    Btn.TextSize = isMaster and 14 or 13
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.AutoButtonColor = false
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    
    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Parent = Btn
    BtnStroke.Thickness = 1
    BtnStroke.Color = Colors.SurfaceHighlight
    BtnStroke.Transparency = 0.5
    
    -- Switch Animation Background (Track)
    local Track = Instance.new("Frame")
    Track.Parent = Btn
    Track.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    Track.Size = UDim2.new(0, 36, 0, 20)
    Track.Position = UDim2.new(1, -46, 0.5, -10)
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    -- Switch Indicator (Knob)
    local Knob = Instance.new("Frame")
    Knob.Parent = Track
    Knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.Position = UDim2.new(0, 3, 0.5, -7)
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    Btn.MouseButton1Click:Connect(function()
        Toggles[name] = not Toggles[name]
        local state = Toggles[name]
        
        local targetBtnBg = state and Color3.fromRGB(35, 35, 45) or Colors.Surface
        local targetTextColor = state and Colors.Text or Colors.TextMuted
        
        -- Cores do Switch
        local targetTrackColor = state and (isMaster and Colors.Danger or Colors.Primary) or Color3.fromRGB(50, 50, 55)
        local targetKnobPos = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        local targetKnobColor = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
        
        -- Tween Animations
        local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        TweenService:Create(Btn, tweenInfo, {BackgroundColor3 = targetBtnBg, TextColor3 = targetTextColor}):Play()
        TweenService:Create(Track, tweenInfo, {BackgroundColor3 = targetTrackColor}):Play()
        TweenService:Create(Knob, tweenInfo, {Position = targetKnobPos, BackgroundColor3 = targetKnobColor}):Play()
        
        if callback then callback(state) end
    end)
    
    return Btn
end

local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Parent = parent
    Frame.BackgroundColor3 = Colors.Surface
    Frame.BackgroundTransparency = 0.5
    Frame.Size = UDim2.new(1, -5, 0, 55)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    
    local Title = Instance.new("TextLabel")
    Title.Parent = Frame
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 5)
    Title.Size = UDim2.new(1, -30, 0, 20)
    Title.Font = Enum.Font.GothamSemibold
    Title.Text = text .. ": " .. default
    Title.TextColor3 = Colors.Text
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local SliderBG = Instance.new("TextButton")
    SliderBG.Parent = Frame
    SliderBG.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    SliderBG.Position = UDim2.new(0, 15, 0, 35)
    SliderBG.Size = UDim2.new(1, -30, 0, 6)
    SliderBG.Text = ""
    SliderBG.AutoButtonColor = false
    Instance.new("UICorner", SliderBG).CornerRadius = UDim.new(1, 0)
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Parent = SliderBG
    SliderFill.BackgroundColor3 = Colors.Primary
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

    local dragging = false

    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
        TweenService:Create(SliderFill, TweenInfo.new(0.1), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
        local value = math.floor(min + ((max - min) * pos))
        Title.Text = text .. ": " .. value
        callback(value)
    end

    SliderBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
end

local function CreateDropdownBtn(parent, textPrefix, options, defaultIdx, callback)
    local Btn = Instance.new("TextButton")
    Btn.Parent = parent
    Btn.BackgroundColor3 = Colors.Surface
    Btn.BackgroundTransparency = 0.5
    Btn.Size = UDim2.new(1, -5, 0, 40)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.Text = "  " .. textPrefix .. ": " .. options[defaultIdx]
    Btn.TextColor3 = Colors.Text
    Btn.TextSize = 13
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.AutoButtonColor = false
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", Btn).Color = Colors.SurfaceHighlight

    local currentIdx = defaultIdx
    Btn.MouseButton1Click:Connect(function()
        currentIdx = currentIdx + 1
        if currentIdx > #options then currentIdx = 1 end
        Btn.Text = "  " .. textPrefix .. ": " .. options[currentIdx]
        callback(options[currentIdx])
    end)
end

-- ==========================================
-- UTILITÁRIOS E FUNÇÕES CORE (MANTIDAS INTACTAS)
-- ==========================================
local function IsValidTarget(player)
    -- Verifica se é aliado (mesmo time)
    if LocalPlayer.Team and player.Team == LocalPlayer.Team then
        return false -- Ignora jogadores do mesmo time
    end
    
    local character = player.Character
    if not character then return false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    local head = character:FindFirstChild("Head")
    if not head then return false end
    return true
end

local function WorldToScreen(position)
    local screenPos, onScreen = Camera:WorldToViewportPoint(position)
    return Vector2.new(screenPos.X, screenPos.Y), onScreen, screenPos.Z
end

local function IsVisible(targetPart)
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin).Unit * (targetPart.Position - origin).Magnitude
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    local rayResult = workspace:Raycast(origin, direction, raycastParams)
    if rayResult then
        return rayResult.Instance:IsDescendantOf(targetPart.Parent)
    end
    return true
end

-- ==========================================
-- SISTEMA DE ESP
-- ==========================================
local function UpdateESP()
    ClearAllDrawings()
    
    if not Toggles.ESPMaster then return end
    if not (Toggles.EspLinha or Toggles.EspCaixa or Toggles.EspVida or Toggles.EspNome or Toggles.EspEsqueleto) then return end
    
    local center = Camera.ViewportSize / 2
    local lineOriginPos = center
    if LineOrigin == "Bottom" then
        lineOriginPos = Vector2.new(center.X, Camera.ViewportSize.Y)
    elseif LineOrigin == "Top" then
        lineOriginPos = Vector2.new(center.X, 0)
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsValidTarget(player) then -- IsValidTarget já verifica time
            local char = player.Character
            local head = char.Head
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then continue end
            
            local headPos = head.Position
            local headPos2D, headOnScreen = WorldToScreen(headPos)
            
            if Toggles.EspLinha and headOnScreen then
                local line = Drawing.new("Line")
                line.Visible = true
                line.From = lineOriginPos
                line.To = headPos2D
                line.Color = Colors.Primary
                line.Thickness = 1.5
                line.Transparency = 1
                table.insert(ESPDrawings.Lines, line)
            end
            
            if Toggles.EspNome then
                local namePos = headPos + Vector3.new(0, 2.5, 0)
                local namePos2D, onScreen = WorldToScreen(namePos)
                if onScreen then
                    local text = Drawing.new("Text")
                    text.Visible = true
                    text.Text = player.Name
                    text.Position = namePos2D
                    text.Color = Colors.Text
                    text.Size = 14
                    text.Center = true
                    text.Outline = true
                    text.OutlineColor = Color3.new(0,0,0)
                    table.insert(ESPDrawings.Texts, text)
                end
            end
            
            if Toggles.EspVida then
                local barHeadPos = headPos + Vector3.new(0, 2, 0)
                local barPos2D, onScreen = WorldToScreen(barHeadPos)
                if onScreen and humanoid then
                    local health = humanoid.Health / humanoid.MaxHealth
                    local barWidth = 40
                    local barHeight = 4
                    local barX = barPos2D.X - barWidth/2
                    local barY = barPos2D.Y - 25
                    
                    local bg = Drawing.new("Square")
                    bg.Visible = true
                    bg.Position = Vector2.new(barX, barY)
                    bg.Size = Vector2.new(barWidth, barHeight)
                    bg.Color = Color3.fromRGB(20, 20, 20)
                    bg.Filled = true
                    table.insert(ESPDrawings.Squares, bg)
                    
                    local fill = Drawing.new("Square")
                    fill.Visible = true
                    fill.Position = Vector2.new(barX, barY)
                    fill.Size = Vector2.new(barWidth * health, barHeight)
                    fill.Color = Color3.fromRGB(255 * (1 - health), 255 * health, 0)
                    fill.Filled = true
                    table.insert(ESPDrawings.Squares, fill)
                end
            end
            
            if Toggles.EspEsqueleto then
                local function drawLine3D(p1, p2)
                    local p1_2D, on1 = WorldToScreen(p1)
                    local p2_2D, on2 = WorldToScreen(p2)
                    if on1 and on2 then
                        local line = Drawing.new("Line")
                        line.Visible = true
                        line.From = p1_2D
                        line.To = p2_2D
                        line.Color = Colors.Text
                        line.Thickness = 1
                        table.insert(ESPDrawings.Lines, line)
                    end
                end
                
                local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
                local leftArm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm")
                local rightArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm")
                local leftLeg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg")
                local rightLeg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg")
                
                if head and torso then drawLine3D(headPos, torso.Position) end
                if torso and leftArm then drawLine3D(torso.Position, leftArm.Position) end
                if torso and rightArm then drawLine3D(torso.Position, rightArm.Position) end
                if torso and root then drawLine3D(torso.Position, root.Position) end
                if root and leftLeg then drawLine3D(root.Position, leftLeg.Position) end
                if root and rightLeg then drawLine3D(root.Position, rightLeg.Position) end
            end
            
            if Toggles.EspCaixa then
                local cf = root.CFrame
                local size = char:GetExtentsSize()
                local half = size / 2
                
                local corners = {
                    Vector3.new(-half.X, -half.Y, -half.Z), Vector3.new( half.X, -half.Y, -half.Z),
                    Vector3.new(-half.X,  half.Y, -half.Z), Vector3.new( half.X,  half.Y, -half.Z),
                    Vector3.new(-half.X, -half.Y,  half.Z), Vector3.new( half.X, -half.Y,  half.Z),
                    Vector3.new(-half.X,  half.Y,  half.Z), Vector3.new( half.X,  half.Y,  half.Z),
                }
                
                local minX, minY = math.huge, math.huge
                local maxX, maxY = -math.huge, -math.huge
                local anyOnScreen = false
                
                for _, corner in ipairs(corners) do
                    local worldPos = cf:PointToWorldSpace(corner)
                    local screenPos, onScreen = WorldToScreen(worldPos)
                    if onScreen then
                        anyOnScreen = true
                        if screenPos.X < minX then minX = screenPos.X end
                        if screenPos.Y < minY then minY = screenPos.Y end
                        if screenPos.X > maxX then maxX = screenPos.X end
                        if screenPos.Y > maxY then maxY = screenPos.Y end
                    end
                end
                
                if anyOnScreen then
                    local box = Drawing.new("Square")
                    box.Visible = true
                    box.Position = Vector2.new(minX, minY)
                    box.Size = Vector2.new(maxX - minX, maxY - minY)
                    box.Color = Colors.Primary
                    box.Thickness = 1.5
                    box.Filled = false
                    table.insert(ESPDrawings.Squares, box)
                end
            end
        end
    end
end

local function ManageESPLoop()
    if ESPConnections.Render then
        ESPConnections.Render:Disconnect()
        ESPConnections.Render = nil
    end
    if Toggles.ESPMaster then
        ESPConnections.Render = RunService.RenderStepped:Connect(UpdateESP)
    else
        ClearAllDrawings()
    end
end

-- ==========================================
-- SISTEMA DE AIMBOT E FOV
-- ==========================================
local function GetClosestTargetToCrosshair()
    local closest = nil
    local minDistance = Toggles.ShowFOV and FOVRadius or math.huge
    local center = Camera.ViewportSize / 2
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsValidTarget(player) then -- IsValidTarget já verifica time
            local char = player.Character
            local targetPart
            if AimPart == "Head" then targetPart = char:FindFirstChild("Head")
            elseif AimPart == "Torso" then targetPart = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
            elseif AimPart == "Pelvis" then targetPart = char:FindFirstChild("HumanoidRootPart") end
            
            if not targetPart or not IsVisible(targetPart) then continue end
            
            local screenPos, onScreen = WorldToScreen(targetPart.Position)
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
    FOVCircle.Position = Camera.ViewportSize / 2
    FOVCircle.Radius = FOVRadius
    FOVCircle.Visible = Toggles.ShowFOV

    if not Toggles.AimbotMaster then return end
    if not (Toggles.AimbotRage or Toggles.AimbotLegit) then return end
    
    local target = GetClosestTargetToCrosshair()
    if not target then AimTarget = nil return end
    AimTarget = target
    
    local targetPart
    if AimPart == "Head" then targetPart = target.Character:FindFirstChild("Head")
    elseif AimPart == "Torso" then targetPart = target.Character:FindFirstChild("UpperTorso") or target.Character:FindFirstChild("Torso")
    elseif AimPart == "Pelvis" then targetPart = target.Character:FindFirstChild("HumanoidRootPart") end
    if not targetPart then return end
    
    local cameraPos = Camera.CFrame.Position
    
    if Toggles.AimbotRage then
        Camera.CFrame = CFrame.new(cameraPos, targetPart.Position)
    elseif Toggles.AimbotLegit then
        local targetCF = CFrame.new(cameraPos, targetPart.Position)
        local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        TweenService:Create(Camera, tweenInfo, {CFrame = targetCF}):Play()
    end
end

local function ManageAimbotLoop()
    if AimbotConnection then
        AimbotConnection:Disconnect()
        AimbotConnection = nil
    end
    AimbotConnection = RunService.RenderStepped:Connect(UpdateAimbot)
end

-- ==========================================
-- POPULANDO O MENU
-- ==========================================
CreateToggle(ESPContainer, "ESPMaster", "ATIVAR VISUAIS (MASTER)", true, function() ManageESPLoop() end)
CreateDropdownBtn(ESPContainer, "Origem da Linha", {"Bottom", "Center", "Top"}, 1, function(val) LineOrigin = val end)
CreateToggle(ESPContainer, "EspCaixa", "ESP Caixa (Box 2D)", false)
CreateToggle(ESPContainer, "EspLinha", "ESP Linha (Tracers)", false)
CreateToggle(ESPContainer, "EspNome", "ESP Nome do Jogador", false)
CreateToggle(ESPContainer, "EspVida", "ESP Barra de Vida", false)
CreateToggle(ESPContainer, "EspEsqueleto", "ESP Esqueleto 3D", false)

CreateToggle(AimContainer, "AimbotMaster", "ATIVAR AIMBOT (MASTER)", true)
CreateDropdownBtn(AimContainer, "Mirar no(a)", {"Head", "Torso", "Pelvis"}, 1, function(val) AimPart = val end)
CreateToggle(AimContainer, "AimbotRage", "Aimbot Rage (Instantâneo)", false, function(s) if s then Toggles.AimbotLegit = false end end)
CreateToggle(AimContainer, "AimbotLegit", "Aimbot Legit (Suave)", false, function(s) if s then Toggles.AimbotRage = false end end)
CreateToggle(AimContainer, "ShowFOV", "Mostrar FOV (Círculo Estático)", false)
CreateSlider(AimContainer, "Tamanho do FOV", 50, 600, 150, function(val) FOVRadius = val end)

-- ==========================================
-- LÓGICA DE TROCA DE ABAS E BOTÃO MENU
-- ==========================================
local function SwitchTab(tab)
    if tab == "ESP" then
        PageESP.Visible = true; PageAim.Visible = false
        TweenService:Create(TabESP, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Primary, TextColor3 = Colors.Text, BackgroundTransparency = 0.2}):Play()
        TweenService:Create(TabAim, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Surface, TextColor3 = Colors.TextMuted, BackgroundTransparency = 0.5}):Play()
    else
        PageESP.Visible = false; PageAim.Visible = true
        TweenService:Create(TabAim, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Primary, TextColor3 = Colors.Text, BackgroundTransparency = 0.2}):Play()
        TweenService:Create(TabESP, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Surface, TextColor3 = Colors.TextMuted, BackgroundTransparency = 0.5}):Play()
    end
end

TabESP.MouseButton1Click:Connect(function() SwitchTab("ESP") end)
TabAim.MouseButton1Click:Connect(function() SwitchTab("AIM") end)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

ManageAimbotLoop()

ScreenGui.Destroying:Connect(function()
    if ESPConnections.Render then ESPConnections.Render:Disconnect() end
    if AimbotConnection then AimbotConnection:Disconnect() end
    ClearAllDrawings()
    FOVCircle:Remove()
end)
