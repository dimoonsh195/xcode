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
xWin.Size = UDim2.new(0, 700, 0, 450)
xWin.Position = UDim2.new(0.5, -350, 0.5, -225)
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

local function makeBtn(text, xOffset, width)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, width, 0, 22)
    btn.Position = UDim2.new(1, xOffset, 0, 4)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Code
    btn.TextSize = 12
    btn.Parent = xHeader
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    return btn
end

local btnExecute = makeBtn("Execute", -240, 60)
local btnClear = makeBtn("Clear", -170, 50)
local btnSelectAll = makeBtn("Select All", -110, 70)
local btnSave = makeBtn("Save", -30, 50)

local editorScroll = Instance.new("ScrollingFrame")
editorScroll.Size = UDim2.new(1, -20, 1, -60)
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
-- ЛОГИКА АВТООТСТУПОВ И АВТОЗАКРЫТИЯ БЛОКОВ
-- ==========================================

local INDENT = "    " -- 4 пробела
local indentLevel = 0

-- Функция для вычисления отступа текущей строки
local function getCurrentLineIndent(text, cursorPos)
    local beforeCursor = text:sub(1, cursorPos - 1)
    local lineStart = beforeCursor:find("\n[^\n]*$") or 0
    local line = beforeCursor:sub(lineStart + 1)
    local spaces = line:match("^(%s*)")
    return #spaces, line
end

-- Обработчик нажатия Enter в TextBox
codeBox.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Return then
        local text = codeBox.Text
        local cursor = codeBox.CursorPosition
        
        -- Получаем текущую строку и её отступ
        local currentIndent, currentLine = getCurrentLineIndent(text, cursor)
        local trimmedLine = currentLine:match("^%s*(.-)%s*$")
        
        -- Определяем, нужно ли увеличить отступ
        local increaseIndent = false
        local autoCloseEnd = false
        
        -- Проверяем ключевые слова, после которых нужен отступ
        if trimmedLine:match("then%s*$") or 
           trimmedLine:match("do%s*$") or 
           trimmedLine:match("function%s*%(") or
           trimmedLine:match("function%s+%w+%s*%(") or
           trimmedLine:match("repeat%s*$") or
           trimmedLine:match("{%s*$") then
            increaseIndent = true
        end
        
        -- Определяем, нужно ли автоматически закрыть блок
        if trimmedLine:match("then%s*$") or 
           trimmedLine:match("do%s*$") or 
           trimmedLine:match("function%s*%(") or
           trimmedLine:match("function%s+%w+%s*%(") then
            autoCloseEnd = true
        end
        
        -- Проверяем, не является ли текущая строка закрывающей
        local isClosing = trimmedLine:match("^end") or 
                          trimmedLine:match("^else") or 
                          trimmedLine:match("^elseif") or 
                          trimmedLine:match("^until") or
                          trimmedLine:match("^}")
        
        -- Вычисляем новый отступ
        local newIndent = currentIndent
        if isClosing and currentIndent >= #INDENT then
            newIndent = currentIndent - #INDENT
        elseif increaseIndent then
            newIndent = currentIndent + #INDENT
        end
        
        -- Формируем текст для вставки
        local insertText = "\n" .. string.rep(" ", newIndent)
        
        -- Если нужно автозакрытие, добавляем end и ставим курсор между ними
        if autoCloseEnd then
            local closeIndent = currentIndent
            insertText = insertText .. "\n" .. string.rep(" ", closeIndent) .. "end"
        end
        
        -- Вставляем текст
        local before = text:sub(1, cursor - 1)
        local after = text:sub(cursor)
        codeBox.Text = before .. insertText .. after
        
        -- Позиционируем курсор
        if autoCloseEnd then
            -- Курсор должен быть между новой строкой и end
            local newCursor = cursor + #insertText - #("\n" .. string.rep(" ", currentIndent) .. "end")
            codeBox.CursorPosition = newCursor
        else
            codeBox.CursorPosition = cursor + #insertText
        end
        
        -- Обновляем визуал
        updateEditorVisuals()
    end
end)

-- ==========================================
-- ОБНОВЛЕНИЕ ВИЗУАЛА
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

btnClear.MouseButton1Click:Connect(function() 
    codeBox.Text = ""
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
