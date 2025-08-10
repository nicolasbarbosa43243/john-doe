-- UTG BY NICOLASPIETRO - GUI COM SCROLLING E ABAS (Melhorada por ChatGPT)
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local RunService = game:GetService("RunService")

local function addBlueBorder(guiObject, cornerRadius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = cornerRadius or UDim.new(0, 8)
    corner.Parent = guiObject

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Parent = guiObject

    local t = 0
    RunService.RenderStepped:Connect(function()
        t = (t + 0.01) % 1
        -- Varia o azul entre 0.5 e 1.0, mantendo vermelho e verde baixos para ficar azul
        local blueValue = 0.5 + 0.5 * math.sin(t * 2 * math.pi) * 0.5 + 0.5 -- entre 0.5 e 1
        stroke.Color = Color3.new(0, 0, blueValue)
    end)
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UTG_BY_NICOLASPIETRO"
screenGui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 720, 0, 377)
mainFrame.Position = UDim2.new(0, 10, 0, 0.1)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.Active = true
mainFrame.Draggable = false
mainFrame.Parent = screenGui

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Função para tween
local function tweenSize(guiObject, size, time)
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local tween = TweenService:Create(guiObject, tweenInfo, {Size = size})
    tween:Play()
end

-- Após criar mainFrame:
mainFrame.Draggable = false

-- Criar a barra de arrastar, 6 pixels abaixo do mainFrame
local dragBar = Instance.new("Frame")
dragBar.Size = UDim2.new(1, -12, 0, 10) -- largura do mainFrame menos 12 (6px cada lado)
dragBar.Position = UDim2.new(0, 6, 1, 6) -- 6 px da borda esquerda e 6 px abaixo do mainFrame
dragBar.BackgroundColor3 = Color3.new(1, 1, 1)
dragBar.BackgroundTransparency = 0.85
dragBar.Parent = mainFrame

-- Bordas arredondadas da barra
local dragBarCorner = Instance.new("UICorner")
dragBarCorner.CornerRadius = UDim.new(0, 6)
dragBarCorner.Parent = dragBar

-- Barra cresce ao passar mouse
dragBar.MouseEnter:Connect(function()
    tweenSize(dragBar, UDim2.new(1, -12, 0, 20), 0.2)
end)
dragBar.MouseLeave:Connect(function()
    tweenSize(dragBar, UDim2.new(1, -12, 0, 10), 0.2)
end)

-- Variáveis drag
local dragging = false
local dragInput
local dragStart
local startPos

-- Começa arrastar ao clicar na dragBar
dragBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

dragBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

-- Enquanto arrasta, move o mainFrame junto
UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Arredondar bordas da UI principal
local cornerMain = Instance.new("UICorner")
cornerMain.CornerRadius = UDim.new(0,11)
cornerMain.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(0, 0, 100)
title.TextColor3 = Color3.fromRGB(0, 0, 0)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.Text = "UTG BY KJ_32261"
title.Parent = mainFrame

-- Detector de dono
local owners = {
    ["nicksonn0999"] = "the alt of kj_32261 (nicksonn0999) is in game he are owner of script",
    ["kj_32261ALT"] = "the alt of KJ_32261 (kj_32261ALT) is in game he are owner of script"
}

if owners[player.Name] then
    title.Text = "UTG OWNER DETECTED"

    game.StarterGui:SetCore("SendNotification", {
        Title = "UTG OWNER DETECTED",
        Text = owners[player.Name],
        Duration = 5
    })

    local sound = Instance.new("Sound", workspace)
    sound.SoundId = "rbxassetid://95305396196239"
    sound.Volume = 2
    sound.Looped = true
    sound:Play()
end

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(0, 0, 100)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.Text = "X"
closeButton.Parent = mainFrame

closeButton.MouseButton1Click:Connect(function()
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    local tweenSize = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 0, 0, 0)})
    local tweenPos = TweenService:Create(mainFrame, tweenInfo, {Position = UDim2.new(mainFrame.Position.X.Scale, mainFrame.Position.X.Offset, mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset + 20)})

    tweenSize:Play()
    tweenPos:Play()
    tweenSize.Completed:Wait()

    screenGui:Destroy()
end)


local tabButtons = Instance.new("Frame")
tabButtons.Size = UDim2.new(1, 0, 0, 30)
tabButtons.Position = UDim2.new(0, 0, 0, 40)
tabButtons.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
tabButtons.Parent = mainFrame

local function createTab(name, position)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 80, 1, 0)
    button.Position = UDim2.new(0, position * 80, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 14
    button.Text = name
    button.Name = name
    button.Parent = tabButtons

    -- Arredondar abas
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button

    return button
end

local tabFrames = {}
local tabNames = {"executor", "Scripts", "requires", "guis", "reanimation", "fix the game", "guns", "funny", "convert"}

for _, name in ipairs(tabNames) do
    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, 0, 1, -70)
    frame.Position = UDim2.new(0, 0, 0, 70)
    frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    frame.ScrollBarThickness = 8
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Name = name
    frame.Parent = mainFrame

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    layout.Parent = frame

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        frame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)

    tabFrames[name] = frame
end

tabFrames["executor"].Visible = true

-- Criar frame e elementos da aba executor
local executorFrame = tabFrames["executor"]

local executorBox = Instance.new("TextBox")
executorBox.Size = UDim2.new(1, -20, 0, 200)
executorBox.Position = UDim2.new(0, 10, 0, 10)
executorBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
executorBox.TextColor3 = Color3.fromRGB(255, 255, 255)
executorBox.Font = Enum.Font.Code
executorBox.TextSize = 18
executorBox.ClearTextOnFocus = false
executorBox.MultiLine = true
executorBox.TextWrapped = true
executorBox.Text = ""
executorBox.PlaceholderText = "Put u Script Here!..."
executorBox.Parent = executorFrame

-- Arredondar executor
local cornerExec = Instance.new("UICorner")
cornerExec.CornerRadius = UDim.new(0, 8)
cornerExec.Parent = executorBox

-- Limite gigante
executorBox:GetPropertyChangedSignal("Text"):Connect(function()
    if #executorBox.Text > 5000000000 then
        executorBox.Text = executorBox.Text:sub(1, 5000000000)
    end
end)

local executeBtn = Instance.new("TextButton")
executeBtn.Size = UDim2.new(0.45, -10, 0, 40)
executeBtn.Position = UDim2.new(0, 10, 0, 220)
executeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
executeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
executeBtn.Font = Enum.Font.SourceSansBold
executeBtn.TextSize = 20
executeBtn.Text = "Execute"
executeBtn.Parent = executorFrame

local cornerExecBtn = Instance.new("UICorner")
cornerExecBtn.CornerRadius = UDim.new(0, 6)
cornerExecBtn.Parent = executeBtn

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0.45, -10, 0, 40)
clearBtn.Position = UDim2.new(0.55, 0, 0, 220)
clearBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearBtn.Font = Enum.Font.SourceSansBold
clearBtn.TextSize = 20
clearBtn.Text = "Clear"
clearBtn.Parent = executorFrame

local cornerClearBtn = Instance.new("UICorner")
cornerClearBtn.CornerRadius = UDim.new(0, 6)
cornerClearBtn.Parent = clearBtn

executeBtn.MouseButton1Click:Connect(function()
    local code = executorBox.Text
    local success, err = pcall(function()
        loadstring(code)()
    end)
    if not success then
        warn("Erro ao executar código: " .. tostring(err))
    else
        print("Código executado com sucesso!")
    end
end)

clearBtn.MouseButton1Click:Connect(function()
    executorBox.Text = ""
end)

for i, name in ipairs(tabNames) do
    local button = createTab(name, i - 1)
    button.MouseButton1Click:Connect(function()
        for _, frame in pairs(tabFrames) do
            frame.Visible = false
        end
        tabFrames[name].Visible = true
    end)
end

-- Cursor ao passar o mouse
local grabCursor = "rbxasset://textures/GrabCursor.png"
local function setGrabCursorOnHover(guiObject)
    guiObject.MouseEnter:Connect(function()
        mouse.Icon = grabCursor
    end)
    guiObject.MouseLeave:Connect(function()
        mouse.Icon = ""
    end)
end

for _, btn in pairs(tabButtons:GetChildren()) do
    if btn:IsA("TextButton") then
        setGrabCursorOnHover(btn)
    end
end
setGrabCursorOnHover(executeBtn)
setGrabCursorOnHover(clearBtn)

-- Botões de scripts
local isExecuting = false
local function createButton(name, url, musicId, parent)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 40)
    button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 18
    button.Text = name
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button

    button.MouseButton1Click:Connect(function()
        if isExecuting then return end
        isExecuting = true

        local clickSound = Instance.new("Sound", workspace)
        clickSound.SoundId = "rbxassetid://156785206"
        clickSound.Volume = 3
        clickSound:Play()
        game:GetService("Debris"):AddItem(clickSound, 2)

        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("Sound") then
                obj:Stop()
                obj:Destroy()
            end
        end

        if musicId and musicId ~= "" then
            local sound = Instance.new("Sound", workspace)
            sound.SoundId = "rbxassetid://" .. musicId
            sound.Volume = 2
            sound.Looped = true
            sound:Play()
        end

        local success, result = pcall(function()
            loadstring(game:HttpGet(url))()
        end)
        if not success then
            warn("Erro ao executar o script: " .. tostring(result))
        end

        task.wait(2)
        isExecuting = false
    end)
end

createButton("ender V1", "https://raw.githubusercontent.com/nicolasbarbosa43243/john-doe/refs/heads/main/Untitled.txt", "", tabFrames["Scripts"])
createButton("baseplate", "https://raw.githubusercontent.com/nicolasbarbosa43243/john-doe/refs/heads/main/Just_A_Baseplate_Working_Reanimation.txt", "", tabFrames["reanimation"])
createButton("ender V2", "https://raw.githubusercontent.com/nicolasbarbosa43243/john-doe/refs/heads/main/gistfile1.txt", "", tabFrames["Scripts"])
createButton("zee hub v6", "https://raw.githubusercontent.com/nicolasbarbosa43243/john-doe/refs/heads/main/Zee%20Hub%20V6.lua.txt", "", tabFrames["reanimation"])
createButton("dual RGB sword", "https://raw.githubusercontent.com/nicolasbarbosa43243/john-doe/refs/heads/main/Dual%20Ultima%20RB%20Swords.txt", "78534559289195", tabFrames["Scripts"])
createButton("Grab Knife V3", "https://raw.githubusercontent.com/nicolasbarbosa43243/john-doe/refs/heads/main/YZnvHFFK.txt", "", tabFrames["requires"])
createButton("Grab Knife V4", "https://raw.githubusercontent.com/nicolasbarbosa323/grab-knife/refs/heads/main/Grab%20V4.txt", "16190760285", tabFrames["requires"])
createButton("Metal Pipe", "https://raw.githubusercontent.com/nicolasbarbosa43243/john-doe/refs/heads/main/metal%20pipe.txt", "", tabFrames["funny"])
createButton("Xester", "https://raw.githubusercontent.com/nicolasbarbosa323/xester/refs/heads/main/qC7MUFRJ.txt", "16190760285", tabFrames["requires"])
createButton("Blocks of Death", "https://raw.githubusercontent.com/nicolasbarbosa323/blocs-of-death/refs/heads/main/blocs%20of%20death", "", tabFrames["funny"])
createButton("Sin Dragon", "https://raw.githubusercontent.com/nicolasbarbosa43243/john-doe/refs/heads/main/Sin%20Dragon.txt", "", tabFrames["Scripts"])
createButton("Revenge Hands", "https://raw.githubusercontent.com/nicolasbarbosa323/sin-dragon/refs/heads/main/reevenge%20hands.txt", "112461424977148", tabFrames["Scripts"])
createButton("Vereus", "https://raw.githubusercontent.com/nicolasbarbosa323/xester/refs/heads/main/fLrx77PM.txt", "1845149698", tabFrames["Scripts"])
createButton("John Doe", "https://raw.githubusercontent.com/nicolasbarbosa43243/john-doe/refs/heads/main/John_doe_up_by_gojohdkaisenkt%20(2).txt", "", tabFrames["requires"])
createButton("Good Cop Bad Cop", "https://raw.githubusercontent.com/nicolasbarbosa43243/john-doe/refs/heads/main/KwuminKa.txt", "", tabFrames["Scripts"])
createButton("Gaster Hands", "https://raw.githubusercontent.com/nicolasbarbosa323/good-cop-bad-coop/refs/heads/main/GasterHands.txt", "1838626744", tabFrames["Scripts"])
createButton("Funnyfly", "https://raw.githubusercontent.com/nicolasbarbosa323/fix-game/refs/heads/main/funny%20fly", "", tabFrames["funny"])
createButton("Fix", "https://raw.githubusercontent.com/nicolasbarbosa323/fix-game/refs/heads/main/fix.lua", "", tabFrames["fix the game"])
createButton("CrystalDance", "https://raw.githubusercontent.com/nicolasbarbosa43243/john-doe/refs/heads/main/gistfile1%20(1).txt", "", tabFrames["Scripts"])
createButton("Goner", "https://raw.githubusercontent.com/nicolasbarbosa323/crytasl/refs/heads/main/goner.lua.txt", "1845149698", tabFrames["requires"])
createButton("Serveradmin", "https://raw.githubusercontent.com/nicolasbarbosa43243/john-doe/refs/heads/main/Server%20Admin.txt", "", tabFrames["requires"])
createButton("Ban hammer", "https://raw.githubusercontent.com/nicolasbarbosa323/ban-hammer/refs/heads/main/ban", "113920511880753", tabFrames["Scripts"])
createButton("grakeddar", "https://raw.githubusercontent.com/nicolasbarbosa323/grakkeda/refs/heads/main/Roblox%20Genkadda%20omega%20leaked.txt", "78534559289195", tabFrames["Scripts"])
createButton("kirito blades", "https://raw.githubusercontent.com/nicolasbarbosa43243/john-doe/refs/heads/main/Kirito%20Blades.txt", "", tabFrames["Scripts"])
createButton("THE angel", "https://raw.githubusercontent.com/nicolasbarbosa43243/john-doe/refs/heads/main/The%20Angel.txt", "", tabFrames["Scripts"])
createButton("The Sun", "https://raw.githubusercontent.com/nicolasbarbosa323/the-sun/refs/heads/main/the%20sun", "", tabFrames["Scripts"])
createButton("Killbot", "https://raw.githubusercontent.com/nicolasbarbosa323/rare/refs/heads/main/killbot.lua", "95305396196239", tabFrames["Scripts"])
createButton("script seacher", "https://rawscripts.net/raw/Universal-Script-Script-Searcher-23625", "", tabFrames["guis"])
createButton("coca espuma", "https://raw.githubusercontent.com/nicolasbarbosa323/cocacola-espuma/refs/heads/main/coca", "", tabFrames["funny"])
createButton("Steve", "raw.githubusercontent.com/nicolasbarbosa323/steve/refs/heads/main/rare.txt", "", tabFrames["funny"])
createButton("פרחים", "https://raw.githubusercontent.com/nicolasbarbosa43243/john-doe/refs/heads/main/WHISTLE", "", tabFrames["Scripts"])
createButton("john doe Forsaken", "https://raw.githubusercontent.com/nicolasrgbscripter/scripts/refs/heads/main/comp", "126602437560192", tabFrames["Scripts"])

-- Pack 2 (Requires)
createButton("reanim", "https://raw.githubusercontent.com/nicolasbarbosa43243/john-doe/refs/heads/main/CurrentAngle_reanimate__one_axis_limb_reanimation__READ_DESC.txt", "", tabFrames["reanimation"])
createButton("Spectrum Glitcher", "https://raw.githubusercontent.com/nicolasbarbosa43243/john-doe/refs/heads/main/SpectrumG%20(1).txt", "88927553987952", tabFrames["requires"])
createButton("Nebula Glitcher", "https://raw.githubusercontent.com/nicolasbarbosa323/nebulaglitcher/refs/heads/main/Nebula's%20Star%20Glitcher%20(EDITED%20BY%20FENIX7667%20IMORTAL%20EDIT%20).txt", "1845149698", tabFrames["requires"])

-- Pack 3 (Server Des-)
createButton("snatch live server", "https://raw.githubusercontent.com/nicolasrgbscripter/scripts/refs/heads/main/snatch", "", tabFrames["funny"])
createButton("polaria v1", "https://raw.githubusercontent.com/nicolasbarbosa43243/john-doe/refs/heads/main/raw.txt", "", tabFrames["guis"])
createButton("Polaria v2", "https://pastefy.app/JmaD2ivk/raw", "", tabFrames["guis"])
createButton("Sypcerr", "https://raw.githubusercontent.com/sypcerr/FECollection/refs/heads/main/script.lua", "", tabFrames["guis"])
createButton("C00lCLAN", "https://raw.githubusercontent.com/Nicolasbarbosa321/musics/refs/heads/main/main.lua.txt", "", tabFrames["guis"])
createButton("ECCS execute", "https://raw.githubusercontent.com/nicolasbarbosa43243/john-doe/refs/heads/main/ECCS_execute.txt", "", tabFrames["guis"])
createButton("C00lGui", "https://raw.githubusercontent.com/nicolasbarbosa323/c00lgui/refs/heads/main/c00lguiv3rx.lua.txt", "", tabFrames["guis"])
createButton("RO-xploit", "https://rawscripts.net/raw/Universal-Script-ro-xploit-6-9233", "", tabFrames["guis"])
createButton("Ghost Hub", "https://rawscripts.net/raw/Universal-Script-X-Ghost-Hub-X-7595", "", tabFrames["guis"])
createButton("Angel Shotgun", "https://raw.githubusercontent.com/Nicolasbarbosa321/musics/refs/heads/main/angel_shotgun.txt", "", tabFrames["guns"])
createButton("Portal gun", "https://raw.githubusercontent.com/Nicolasbarbosa321/musics/refs/heads/main/portalgun.txt", "", tabFrames["guns"])
createButton("ARK-160", "https://raw.githubusercontent.com/Nicolasbarbosa321/musics/refs/heads/main/gun.txt", "97557092981429", tabFrames["guns"])
createButton("SB Shotgun", "https://raw.githubusercontent.com/Nicolasbarbosa321/musics/refs/heads/main/SB%20Shotgun.txt", "", tabFrames["guns"])
createButton("Kitchen Gun", "https://raw.githubusercontent.com/nicolasbarbosa323/rare/refs/heads/main/kitcher%20gun.lua", "88927553987952", tabFrames["guns"])
createButton("Ak-47", "https://raw.githubusercontent.com/sinret/rbxscript.com-scripts-reuploads-/main/ak47", "", tabFrames["guns"])
createButton("Limb", "https://raw.githubusercontent.com/nicolasrgbscripter/scripts/refs/heads/main/limb", "", tabFrames["reanimation"])
createButton("Pendulum", "https://raw.githubusercontent.com/Tescalus/Pendulum-Hubs-Source/main/ReanimMain.lua", "", tabFrames["reanimation"])
createButton("r15 to r6", "https://raw.githubusercontent.com/nicolasbarbosa43243/john-doe/refs/heads/main/R6_script_fe_paid.txt", "", tabFrames["convert"])

