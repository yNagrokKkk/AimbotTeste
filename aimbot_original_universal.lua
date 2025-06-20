local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Configurações iniciais
local aimbotAtivo = false
local espAtivo = false
local fov = 150
local fovMin, fovMax = 50, 400
local alvoParte = "Head" -- Pode ser "Head", "Torso" (peito), ou "LeftLeg" (perna)

-- Criar GUI principal
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AimbotMenu"
screenGui.Parent = playerGui

-- Criar frame do menu (arrastável)
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 250, 0, 350)
menuFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuFrame.BorderSizePixel = 0
menuFrame.Parent = screenGui

local dragging, dragInput, dragStart, startPos

menuFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = menuFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

menuFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

RunService.Heartbeat:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        menuFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Botão para abrir/fechar o menu
local toggleMenuBtn = Instance.new("TextButton")
toggleMenuBtn.Size = UDim2.new(0, 100, 0, 40)
toggleMenuBtn.Position = UDim2.new(0.05, 0, 0.25, -50)
toggleMenuBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleMenuBtn.TextColor3 = Color3.new(1,1,1)
toggleMenuBtn.Text = "Abrir Menu"
toggleMenuBtn.Parent = screenGui

local menuAberto = true
toggleMenuBtn.MouseButton1Click:Connect(function()
    menuAberto = not menuAberto
    menuFrame.Visible = menuAberto
    toggleMenuBtn.Text = menuAberto and "Fechar Menu" or "Abrir Menu"
end)

-- Função para criar botões dentro do menu
local function criarBotao(texto, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 210, 0, 40)
    btn.Position = UDim2.new(0, 20, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Text = texto
    btn.Parent = menuFrame
    return btn
end

-- Botões principais
local aimbotToggleBtn = criarBotao("Ativar Aimbot", 20)
local fovIncreaseBtn = criarBotao("Aumentar FOV", 70)
local fovDecreaseBtn = criarBotao("Diminuir FOV", 120)
local alvoHeadBtn = criarBotao("Mirar na Cabeça", 170)
local alvoTorsoBtn = criarBotao("Mirar no Peito", 220)
local alvoPernaBtn = criarBotao("Mirar na Perna", 270)
local espToggleBtn = criarBotao("Ativar ESP", 320)

-- Label do FOV
local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(0, 210, 0, 30)
fovLabel.Position = UDim2.new(0, 20, 0, 320 + 50)
fovLabel.BackgroundTransparency = 1
fovLabel.TextColor3 = Color3.new(1,1,1)
fovLabel.Font = Enum.Font.GothamBold
fovLabel.TextScaled = true
fovLabel.Text = "FOV: ".. tostring(fov)
fovLabel.Parent = menuFrame

-- Círculo do FOV na tela
local fovCircle = Instance.new("Frame")
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.new(0.5,0,0.5,0)
fovCircle.Size = UDim2.new(0, fov*2, 0, fov*2)
fovCircle.BackgroundTransparency = 1
fovCircle.Parent = screenGui

local circleStroke = Instance.new("UIStroke")
circleStroke.Parent = fovCircle
circleStroke.Color = Color3.fromRGB(255, 0, 0)
circleStroke.Thickness = 2
circleStroke.Transparency = 0.4
circleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Funções para atualizar o círculo do FOV
local function atualizarFOVVisual()
    fovCircle.Size = UDim2.new(0, fov*2, 0, fov*2)
end

-- Eventos dos botões
aimbotToggleBtn.MouseButton1Click:Connect(function()
    aimbotAtivo = not aimbotAtivo
    aimbotToggleBtn.Text = aimbotAtivo and "Desativar Aimbot" or "Ativar Aimbot"
    aimbotToggleBtn.BackgroundColor3 = aimbotAtivo and Color3.fromRGB(200, 30, 30) or Color3.fromRGB(60, 60, 60)
end)

fovIncreaseBtn.MouseButton1Click:Connect(function()
    fov = math.min(fov + 25, fovMax)
    fovLabel.Text = "FOV: ".. tostring(fov)
    atualizarFOVVisual()
end)

fovDecreaseBtn.MouseButton1Click:Connect(function()
    fov = math.max(fov - 25, fovMin)
    fovLabel.Text = "FOV: ".. tostring(fov)
    atualizarFOVVisual()
end)

alvoHeadBtn.MouseButton1Click:Connect(function()
    alvoParte = "Head"
    alvoHeadBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    alvoTorsoBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    alvoPernaBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
end)

alvoTorsoBtn.MouseButton1Click:Connect(function()
    alvoParte = "Torso"
    alvoTorsoBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    alvoHeadBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    alvoPernaBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
end)

alvoPernaBtn.MouseButton1Click:Connect(function()
    alvoParte = "LeftLeg"
    alvoPernaBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    alvoTorsoBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    alvoHeadBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
end)

espToggleBtn.MouseButton1Click:Connect(function()
    espAtivo = not espAtivo
    espToggleBtn.Text = espAtivo and "Desativar ESP" or "Ativar ESP"
    espToggleBtn.BackgroundColor3 = espAtivo and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(60, 60, 60)
end)

-- ESP simples: cria caixas em volta dos jogadores
local espBoxes = {}

local function criarESPBox(player)
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = player.Character and player.Character:FindFirstChild(alvoParte)
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Color3 = Color3.new(0, 1, 0)
    box.Transparency = 0.5
    box.Size = Vector3.new(4, 6, 1)
    box.Parent = workspace.CurrentCamera
    return box
end

RunService.RenderStepped:Connect(function()
    -- Atualizar círculo FOV na tela (posicionado no centro da tela)
    atualizarFOVVisual()

    -- Atualizar ESP
    for player, box in pairs(espBoxes) do
        if not player.Character or not player.Character:FindFirstChild(alvoParte) or not espAtivo then
            box:Destroy()
            espBoxes[player] = nil
        else
            box.Adornee = player.Character[alvoParte]
        end
    end

    if espAtivo then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild(alvoParte) and not espBoxes[plr] then
                espBoxes[plr] = criarESPBox(plr)
            end
        end
    end

    -- Aimbot
    if aimbotAtivo then
        local camera = workspace.CurrentCamera
        local alvoMaisProximo
        local menorDistancia = fov

        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team and plr.Character and plr.Character:FindFirstChild(alvoParte) and plr.Character.Humanoid.Health > 0 then
                local pos, naTela = camera:WorldToViewportPoint(plr.Character[alvoParte].Position)
                if naTela then
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                    if dist < menorDistancia then
                        menorDistancia = dist
                        alvoMaisProximo = plr
                    end
                end
            end
        end

        if alvoMaisProximo and alvoMaisProximo.Character and alvoMaisProximo.Character:FindFirstChild(alvoParte) then
            camera.CFrame = CFrame.new(camera.CFrame.Position, alvoMaisProximo.Character[alvoParte].Position)
        end
    end
end)

-- Inicializar cores dos botões da mira
alvoHeadBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
alvoTorsoBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
alvoPernaBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

-- Inicializar cores do ESP e Aimbot
espToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
aimbotToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
