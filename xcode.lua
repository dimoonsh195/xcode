local TextService = game:GetService("TextService")
local UIS = game:GetService("UserInputService")
local LogService = game:GetService("LogService")
local LocalPlayer = game:GetService("Players").LocalPlayer

local function getGuiParent()
    if type(gethui) == "function" then
        local ok, hui = pcall(gethui)
        if ok and hui then return hui end
    end
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then return cg end
    local ok2, pg = pcall(function() return LocalPlayer:WaitForChild("PlayerGui", 5) end)
    if ok2 and pg then return pg end
    return nil
end

local guiParent = getGuiParent()
if not guiParent then return end
if guiParent:FindFirstChild("XcodeGui") then guiParent.XcodeGui:Destroy() end

local xGui = Instance.new("ScreenGui")
xGui.Name = "XcodeGui"
xGui.ResetOnSpawn = false
xGui.IgnoreGuiInset = true
xGui.DisplayOrder = 6000
xGui.Parent = guiParent

local xWin = Instance.new("Frame")
xWin.Size = UDim2.new(0, 800, 0, 500)
xWin.Position = UDim2.new(0.5, -400, 0.5, -250)
xWin.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
xWin.BorderSizePixel = 0
xWin.Active = true
xWin.Draggable = true
xWin.Parent = xGui
Instance.new("UICorner", xWin).CornerRadius = UDim.new(0, 6)

-- ==========================================
-- ШАПКА
-- ==========================================
local xHeader = Instance.new("Frame")
xHeader.Size = UDim2.new(1, 0, 0, 32)
xHeader.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
xHeader.Parent = xWin
Instance.new("UICorner", xHeader).CornerRadius = UDim.new(0, 6)

local xTitle = Instance.new("TextLabel")
xTitle.Size = UDim2.new(0, 120, 1, 0)
xTitle.Position = UDim2.new(0, 10, 0, 0)
xTitle.BackgroundTransparency = 1
xTitle.Text = "Xcode"
xTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
xTitle.Font = Enum.Font.Code
xTitle.TextSize = 14
xTitle.TextXAlignment = Enum.TextXAlignment.Left
xTitle.Parent = xHeader

-- Кнопки шапки: справа налево, с промежутками 8 px
local function makeHeaderBtn(text, xOffset, width)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, width, 0, 22)
    btn.Position = UDim2.new(1, xOffset, 0, 5)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Code
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.Parent = xHeader
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    return btn
end

local btnSave      = makeHeaderBtn("Save",       -62,  54)
local btnClearCode = makeHeaderBtn("Clear Code", -150, 80)
local btnClearOut  = makeHeaderBtn("Clear Out",  -238, 80)
local btnExecute   = makeHeaderBtn("Execute",    -300, 54)

-- ==========================================
-- РЕДАКТОР (слева)
-- ==========================================
local editorContainer = Instance.new("Frame")
editorContainer.Size = UDim2.new(0.6, -15, 1, -52)
editorContainer.Position = UDim2.new(0, 10, 0, 37)
editorContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
editorContainer.BorderSizePixel = 0
editorContainer.Parent = xWin
Instance.new("UICorner", editorContainer).CornerRadius = UDim.new(0, 4)

local editorScroll = Instance.new("ScrollingFrame")
editorScroll.Size = UDim2.new(1, 0, 1, 0)
editorScroll.BackgroundTransparency = 1
editorScroll.BorderSizePixel = 0
editorScroll.ScrollBarThickness = 8
editorScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
editorScroll.CanvasSize = UDim2.new(0, 0, 0, 1000)
editorScroll.Parent = editorContainer

local lineNumbers = Instance.new("TextLabel")
lineNumbers.Size = UDim2.new(0, 30, 1, 0)
lineNumbers.Position = UDim2.new(0, 5, 0, 0)
lineNumbers.BackgroundTransparency = 1
lineNumbers.Text = "1"
lineNumbers.TextColor3 = Color3.fromRGB(100, 100, 100)
lineNumbers.Font = Enum.Font.Code
lineNumbers.TextSize = 14
lineNumbers.TextXAlignment = Enum.TextXAlignment.Right
lineNumbers.TextYAlignment = Enum.TextYAlignment.Top
lineNumbers.Parent = editorScroll

local codeBox = Instance.new("TextBox")
codeBox.Size = UDim2.new(1, -40, 1, 0)
codeBox.Position = UDim2.new(0, 40, 0, 0)
codeBox.BackgroundTransparency = 1
codeBox.TextColor3 = Color3.fromRGB(200, 200, 200)
codeBox.Font = Enum.Font.Code
codeBox.TextSize = 14
codeBox.TextXAlignment = Enum.TextXAlignment.Left
codeBox.TextYAlignment = Enum.TextYAlignment.Top
codeBox.ClearTextOnFocus = false
codeBox.MultiLine = true
codeBox.TextWrapped = true
codeBox.Parent = editorScroll

-- ==========================================
-- OUTPUT (справа) — зеркало Roblox
-- ==========================================
local outputContainer = Instance.new("Frame")
outputContainer.Size = UDim2.new(0.4, -15, 1, -52)
outputContainer.Position = UDim2.new(0.6, 5, 0, 37)
outputContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
outputContainer.BorderSizePixel = 0
outputContainer.Parent = xWin
Instance.new("UICorner", outputContainer).CornerRadius = UDim.new(0, 4)

local outputLabel = Instance.new("TextLabel")
outputLabel.Size = UDim2.new(1, -10, 0, 18)
outputLabel.Position = UDim2.new(0, 5, 0, 3)
outputLabel.BackgroundTransparency = 1
outputLabel.Text = "OUTPUT (Roblox)"
outputLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
outputLabel.Font = Enum.Font.Code
outputLabel.TextSize = 12
outputLabel.TextXAlignment = Enum.TextXAlignment.Left
outputLabel.Parent = outputContainer

local outputScroll = Instance.new("ScrollingFrame")
outputScroll.Size = UDim2.new(1, -10, 1, -28)
outputScroll.Position = UDim2.new(0, 5, 0, 23)
outputScroll.BackgroundTransparency = 1
outputScroll.BorderSizePixel = 0
outputScroll.ScrollBarThickness = 6
outputScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
outputScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
outputScroll.Parent = outputContainer

local outputLayout = Instance.new("UIListLayout")
outputLayout.SortOrder = Enum.SortOrder.LayoutOrder
outputLayout.Padding = UDim.new(0, 2)
outputLayout.Parent = outputScroll

local function addOutput(text, color)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -5, 0, 18)
    label.BackgroundTransparency = 1
    label.Text = tostring(text)
    label.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Code
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.Parent = outputScroll
    outputScroll.CanvasSize = UDim2.new(0, 0, 0, outputLayout.AbsoluteContentSize.Y + 10)
    task.wait()
    outputScroll.CanvasPosition = Vector2.new(0, outputScroll.CanvasSize.Y.Offset)
end

local logConnection = LogService.MessageOut:Connect(function(message, messageType)
    if not outputScroll or not outputScroll.Parent then
        if logConnection then logConnection:Disconnect() end
        return
    end
    local color = Color3.fromRGB(200, 200, 200)
    local prefix = "[OUT]"
    if messageType == Enum.MessageType.MessageError then
        color = Color3.fromRGB(255, 100, 100); prefix = "[ERR]"
    elseif messageType == Enum.MessageType.MessageWarning then
        color = Color3.fromRGB(255, 200, 100); prefix = "[WARN]"
    elseif messageType == Enum.MessageType.MessageInfo then
        color = Color3.fromRGB(200, 200, 255); prefix = "[INFO]"
    end
    addOutput(prefix .. " " .. tostring(message), color)
end)

-- ==========================================
-- ВИЗУАЛ РЕДАКТОРА
-- ==========================================
local function updateEditorVisuals()
    local text = codeBox.Text
    local lines = {}
    for line in text:gmatch("([^\n]*)\n?") do table.insert(lines, line) end
    if text:sub(-1) == "\n" then table.insert(lines, "") end
    local numStr = ""
    for i, line in ipairs(lines) do
        numStr = numStr .. i .. "\n"
        local lineSize = TextService:GetTextSize(line, 14, Enum.Font.Code, Vector2.new(codeBox.AbsoluteSize.X, math.huge))
        local extraLines = math.floor((lineSize.Y - 18) / 18)
        for j = 1, extraLines do numStr = numStr .. "\n" end
    end
    lineNumbers.Text = numStr
    local totalSize = TextService:GetTextSize(text, 14, Enum.Font.Code, Vector2.new(codeBox.AbsoluteSize.X, math.huge))
    local textHeight = totalSize.Y + 30
    editorScroll.CanvasSize = UDim2.new(0, 0, 0, math.max(textHeight, editorScroll.AbsoluteSize.Y))
    lineNumbers.Size = UDim2.new(0, 30, 0, math.max(textHeight, editorScroll.AbsoluteSize.Y))
end

codeBox:GetPropertyChangedSignal("Text"):Connect(updateEditorVisuals)
editorScroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    lineNumbers.Position = UDim2.new(0, 5, 0, -editorScroll.CanvasPosition.Y)
end)

-- ==========================================
-- КНОПКИ
-- ==========================================
btnExecute.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        local func = loadstring(codeBox.Text)
        if func then func() else error("Compilation error (empty code)") end
    end)
    if not success then
        warn("[Xcode Error] " .. tostring(err))
    end
end)

btnClearCode.MouseButton1Click:Connect(function()
    codeBox.Text = ""
end)

btnClearOut.MouseButton1Click:Connect(function()
    for _, child in ipairs(outputScroll:GetChildren()) do
        if child:IsA("TextLabel") then child:Destroy() end
    end
end)

btnSave.MouseButton1Click:Connect(function()
    if type(writefile) == "function" then
        local ok, err = pcall(function() writefile("Xcode_Script.lua", codeBox.Text) end)
        if not ok then addOutput("Save error: " .. tostring(err), Color3.fromRGB(255, 100, 100)) end
    else
        addOutput("writefile недоступен", Color3.fromRGB(255, 100, 100))
    end
end)

-- ==========================================
-- РЕСАЙЗ
-- ==========================================
local xResize = Instance.new("TextButton")
xResize.Size = UDim2.new(0, 16, 0, 16)
xResize.Position = UDim2.new(1, -16, 1, -16)
xResize.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
xResize.Text = "◢"
xResize.TextColor3 = Color3.fromRGB(150, 150, 150)
xResize.Font = Enum.Font.Code
xResize.TextSize = 12
xResize.BorderSizePixel = 0
xResize.ZIndex = 5
xResize.Parent = xWin
Instance.new("UICorner", xResize).CornerRadius = UDim.new(0, 4)

local xResizing = false
local xStartSize, xStartMouse
xResize.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        xResizing = true
        xStartSize = xWin.AbsoluteSize
        xStartMouse = input.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if xResizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - xStartMouse
        xWin.Size = UDim2.new(0, math.max(500, xStartSize.X + delta.X), 0, math.max(300, xStartSize.Y + delta.Y))
        updateEditorVisuals()
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then xResizing = false end
end)

-- ==========================================
-- СТАРТОВЫЙ КОД
-- ==========================================
codeBox.Text = [==[--- XCODE ---
local a = 1
if a == 1 then
    print("test0")
elseif a == 2 then
    print("test1")
else
    print("test2")
end
]==]
updateEditorVisuals()
