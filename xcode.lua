local TextService = game:GetService("TextService")
local UIS = game:GetService("UserInputService")

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
xWin.Size = UDim2.new(0, 700, 0, 480) -- чуть выше, чтобы влезла подсказка
xWin.Position = UDim2.new(0.5, -350, 0.5, -240)
xWin.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
xWin.BorderSizePixel = 0
xWin.Active = true
xWin.Draggable = true
xWin.Parent = xGui
Instance.new("UICorner", xWin).CornerRadius = UDim.new(0, 6)

local xHeader = Instance.new("Frame")
xHeader.Size = UDim2.new(1, 0, 0, 30)
xHeader.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
xHeader.Parent = xWin
Instance.new("UICorner", xHeader).CornerRadius = UDim.new(0, 6)

local xTitle = Instance.new("TextLabel")
xTitle.Size = UDim2.new(0, 100, 1, 0)
xTitle.Position = UDim2.new(0, 10, 0, 0)
xTitle.BackgroundTransparency = 1
xTitle.Text = "Xcode"
xTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
xTitle.Font = Enum.Font.Code
xTitle.TextSize = 14
xTitle.TextXAlignment = Enum.TextXAlignment.Left
xTitle.Parent = xHeader

local function makeBtn(text, xOffset, width, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, width, 0, 22)
    btn.Position = UDim2.new(1, xOffset, 0, 4)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Code
    btn.TextSize = 12
    btn.Parent = parent or xHeader
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    return btn
end

local btnExecute = makeBtn("Execute", -240, 60)
local btnClear = makeBtn("Clear", -170, 50)
local btnSelectAll = makeBtn("Select All", -110, 70)
local btnSave = makeBtn("Save", -30, 50)

-- === НОВЫЕ КНОПКИ ДЛЯ ОТСТУПОВ ===
local btnIndent = makeBtn("Indent", -320, 55)
local btnDedent = makeBtn("Dedent", -380, 55)

local editorScroll = Instance.new("ScrollingFrame")
editorScroll.Size = UDim2.new(1, -20, 1, -95) -- уменьшил высоту, чтобы влезла подсказка
editorScroll.Position = UDim2.new(0, 10, 0, 35)
editorScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
editorScroll.BorderSizePixel = 0
editorScroll.ScrollBarThickness = 8
editorScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
editorScroll.CanvasSize = UDim2.new(0, 0, 0, 1000)
editorScroll.Parent = xWin
Instance.new("UICorner", editorScroll).CornerRadius = UDim.new(0, 4)

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
-- ПАНЕЛЬ ПОДСКАЗКИ ВНИЗУ
-- ==========================================
local hintBar = Instance.new("Frame")
hintBar.Size = UDim2.new(1, -20, 0, 40)
hintBar.Position = UDim2.new(0, 10, 1, -50)
hintBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
hintBar.BorderSizePixel = 0
hintBar.Parent = xWin
Instance.new("UICorner", hintBar).CornerRadius = UDim.new(0, 4)

local hintLabel = Instance.new("TextLabel")
hintLabel.Size = UDim2.new(1, -20, 1, 0)
hintLabel.Position = UDim2.new(0, 10, 0, 0)
hintLabel.BackgroundTransparency = 1
hintLabel.Text = "Подсказка: Enter после then/do/function — ставь +4 пробела"
hintLabel.TextColor3 = Color3.fromRGB(180, 220, 180)
hintLabel.Font = Enum.Font.Code
hintLabel.TextSize = 12
hintLabel.TextXAlignment = Enum.TextXAlignment.Left
hintLabel.TextYAlignment = Enum.TextYAlignment.Center
hintLabel.TextWrapped = true
hintLabel.Parent = hintBar

-- ==========================================
-- АНАЛИЗ СТРОКИ И ПОДСКАЗКИ
-- ==========================================
local function getLineInfo(text, cursorPos)
    if not text or cursorPos < 1 then return 0, "", "" end
    local beforeCursor = text:sub(1, cursorPos - 1)
    local lineStart = beforeCursor:find("\n[^\n]*$") or 0
    local lineEnd = text:find("\n", cursorPos) or (#text + 1)
    local line = text:sub(lineStart + 1, lineEnd - 1)
    local trimmed = line:match("^%s*(.-)%s*$")
    local leadingSpaces = line:match("^(%s*)")
    return #leadingSpaces, trimmed, line
end

local function analyzeLine(text, cursorPos)
    local indent, trimmed, fullLine = getLineInfo(text, cursorPos)
    
    -- Пустая строка
    if trimmed == "" then
        return "Пустая строка — отступ 0 (или выровняй с блоком выше)", indent, "empty"
    end
    
    -- Строка начинается с закрывающего блока
    if trimmed:match("^end") then
        return "Строка с 'end' — отступ должен быть как у открывающего блока (обычно -4 пробела)", indent, "close"
    end
    if trimmed:match("^else") then
        return "Строка с 'else' — отступ как у 'if' (обычно -4 пробела)", indent, "close"
    end
    if trimmed:match("^elseif") then
        return "Строка с 'elseif' — отступ как у 'if' (обычно -4 пробела)", indent, "close"
    end
    if trimmed:match("^until") then
        return "Строка с 'until' — отступ как у 'repeat' (обычно -4 пробела)", indent, "close"
    end
    
    -- Строка открывает блок
    if trimmed:match("then%s*$") then
        return "После 'then' — новая строка с отступом +4 пробела", indent, "open"
    end
    if trimmed:match("do%s*$") then
        return "После 'do' — новая строка с отступом +4 пробела", indent, "open"
    end
    if trimmed:match("function%s*%(") then
        return "После 'function' — новая строка с отступом +4 пробела", indent, "open"
    end
    if trimmed:match("repeat%s*$") then
        return "После 'repeat' — новая строка с отступом +4 пробела", indent, "open"
    end
    if trimmed:match("{%s*$") then
        return "После '{' — новая строка с отступом +4 пробела", indent, "open"
    end
    
    -- Обычная строка
    return "Обычная строка — отступ " .. indent .. " (можно продолжить без изменений)", indent, "normal"
end

-- Обновление подсказки при изменении текста или позиции курсора
local function updateHint()
    if not codeBox:IsFocused() and codeBox.CursorPosition == 1 and #codeBox.Text == 0 then
        hintLabel.Text = "Подсказка: Enter после then/do/function — ставь +4 пробела"
        hintLabel.TextColor3 = Color3.fromRGB(180, 220, 180)
        return
    end
    
    local cursor = codeBox.CursorPosition or 1
    local hint, indent, type = analyzeLine(codeBox.Text, cursor)
    
    -- Меняем цвет в зависимости от типа
    if type == "open" then
        hintLabel.TextColor3 = Color3.fromRGB(180, 220, 255) -- синеватый
    elseif type == "close" then
        hintLabel.TextColor3 = Color3.fromRGB(255, 180, 180) -- красноватый
    elseif type == "empty" then
        hintLabel.TextColor3 = Color3.fromRGB(200, 200, 200) -- серый
    else
        hintLabel.TextColor3 = Color3.fromRGB(180, 220, 180) -- зелёный
    end
    
    hintLabel.Text = hint .. " | Текущий отступ: " .. indent .. " пробел(ов)"
end

codeBox:GetPropertyChangedSignal("Text"):Connect(updateHint)
codeBox:GetPropertyChangedSignal("CursorPosition"):Connect(updateHint)

-- ==========================================
-- КНОПКИ INDENT / DEDENT
-- ==========================================
local INDENT = "    " -- 4 пробела

btnIndent.MouseButton1Click:Connect(function()
    local text = codeBox.Text
    local cursor = codeBox.CursorPosition or 1
    local beforeCursor = text:sub(1, cursor - 1)
    local lineStart = beforeCursor:find("\n[^\n]*$") or 0
    local lineStartPos = lineStart + 1
    local newText = text:sub(1, lineStartPos - 1) .. INDENT .. text:sub(lineStartPos)
    codeBox.Text = newText
    codeBox.CursorPosition = cursor + #INDENT
    updateHint()
end)

btnDedent.MouseButton1Click:Connect(function()
    local text = codeBox.Text
    local cursor = codeBox.CursorPosition or 1
    local beforeCursor = text:sub(1, cursor - 1)
    local lineStart = beforeCursor:find("\n[^\n]*$") or 0
    local lineStartPos = lineStart + 1
    local lineEnd = text:find("\n", lineStartPos) or (#text + 1)
    local line = text:sub(lineStartPos, lineEnd - 1)
    local leadingSpaces = line:match("^(%s*)")
    if #leadingSpaces > 0 then
        local removeCount = math.min(#INDENT, #leadingSpaces)
        local newLine = line:sub(removeCount + 1)
        local newText = text:sub(1, lineStartPos - 1) .. newLine .. text:sub(lineEnd)
        codeBox.Text = newText
        codeBox.CursorPosition = math.max(lineStartPos, cursor - removeCount)
        updateHint()
    end
end)

-- ==========================================
-- ОБНОВЛЕНИЕ ВИЗУАЛА (номера строк, размер)
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
        for j = 1, extraLines do
            numStr = numStr .. "\n"
        end
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
-- КНОПКИ EXECUTE / CLEAR / SELECT ALL / SAVE
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

btnClear.MouseButton1Click:Connect(function() 
    codeBox.Text = ""
    updateHint()
end)

btnSelectAll.MouseButton1Click:Connect(function()
    codeBox.CursorPosition = 1
    codeBox.SelectionStart = #codeBox.Text + 1
    codeBox:CaptureFocus()
end)

btnSave.MouseButton1Click:Connect(function()
    if type(writefile) == "function" then
        local ok, err = pcall(function() writefile("Xcode_Script.lua", codeBox.Text) end)
        if not ok then
            warn("[Xcode Save Error] " .. tostring(err))
        end
    else
        warn("[Xcode] writefile is not available")
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
        local newWidth = math.max(400, xStartSize.X + delta.X)
        local newHeight = math.max(200, xStartSize.Y + delta.Y)
        xWin.Size = UDim2.new(0, newWidth, 0, newHeight)
        updateEditorVisuals()
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then xResizing = false end
end)

-- ==========================================
-- СТАРТОВЫЙ КОД
-- ==========================================
codeBox.Text = [[local xcode = (100 - 99)
if xcode == 1 then
    print("xcode test")
else
    print("xcode test")
end
]]
updateEditorVisuals()
updateHint()
