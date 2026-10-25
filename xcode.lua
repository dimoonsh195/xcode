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

-- ==========================================================
-- THEME
-- ==========================================================
local Theme = {
    Dark = {
        bg = Color3.fromRGB(30, 30, 30), header = Color3.fromRGB(25, 25, 25),
        editorBg = Color3.fromRGB(20, 20, 20), outputBg = Color3.fromRGB(15, 15, 15),
        text = Color3.fromRGB(200, 200, 200), lineNum = Color3.fromRGB(100, 100, 100),
        btn = Color3.fromRGB(50, 50, 50), btnText = Color3.fromRGB(200, 200, 200),
        accent = Color3.fromRGB(255, 200, 100),
    },
    Light = {
        bg = Color3.fromRGB(230, 230, 230), header = Color3.fromRGB(210, 210, 210),
        editorBg = Color3.fromRGB(250, 250, 250), outputBg = Color3.fromRGB(240, 240, 240),
        text = Color3.fromRGB(30, 30, 30), lineNum = Color3.fromRGB(120, 120, 120),
        btn = Color3.fromRGB(180, 180, 180), btnText = Color3.fromRGB(30, 30, 30),
        accent = Color3.fromRGB(200, 100, 0),
    }
}
local CurrentTheme = "Dark"
local FontColor = nil
local FontSize = 14

local function T() return Theme[CurrentTheme] end
local function fontColor() return FontColor or T().text end

-- ==========================================================
-- ROOT
-- ==========================================================
local xGui = Instance.new("ScreenGui")
xGui.Name = "XcodeGui"
xGui.ResetOnSpawn = false
xGui.IgnoreGuiInset = true
xGui.DisplayOrder = 6000
xGui.Parent = guiParent

local xWin = Instance.new("Frame")
xWin.Size = UDim2.new(0, 900, 0, 540)
xWin.Position = UDim2.new(0.5, -450, 0.5, -270)
xWin.BackgroundColor3 = T().bg
xWin.BorderSizePixel = 0
xWin.Active = true
xWin.Draggable = true
xWin.Parent = xGui
Instance.new("UICorner", xWin).CornerRadius = UDim.new(0, 6)

local xHeader = Instance.new("Frame")
xHeader.Size = UDim2.new(1, 0, 0, 32)
xHeader.BackgroundColor3 = T().header
xHeader.Parent = xWin
Instance.new("UICorner", xHeader).CornerRadius = UDim.new(0, 6)

local xTitle = Instance.new("TextLabel")
xTitle.Size = UDim2.new(0, 120, 1, 0)
xTitle.Position = UDim2.new(0, 10, 0, 0)
xTitle.BackgroundTransparency = 1
xTitle.Text = "Xcode"
xTitle.TextColor3 = T().btnText
xTitle.Font = Enum.Font.Code
xTitle.TextSize = 14
xTitle.TextXAlignment = Enum.TextXAlignment.Left
xTitle.Parent = xHeader

local function makeHeaderBtn(text, xOffset, width)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, width, 0, 22)
    btn.Position = UDim2.new(1, xOffset, 0, 5)
    btn.BackgroundColor3 = T().btn
    btn.Text = text
    btn.TextColor3 = T().btnText
    btn.Font = Enum.Font.Code
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.Parent = xHeader
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    return btn
end

-- Кнопки справа налево, с промежутками
local btnSettings  = makeHeaderBtn("Settings",   -70,  62)
local btnHelp      = makeHeaderBtn("Help",       -138, 58)
local btnSelectAll = makeHeaderBtn("Select All", -206, 76)
local btnSave      = makeHeaderBtn("Save",       -274, 54)
local btnClearCode = makeHeaderBtn("Clear Code", -362, 80)
local btnClearOut  = makeHeaderBtn("Clear Out",  -450, 80)
local btnExecute   = makeHeaderBtn("Execute",    -512, 54)

-- ==========================================================
-- EDITOR
-- ==========================================================
local editorContainer = Instance.new("Frame")
editorContainer.Size = UDim2.new(0.6, -15, 1, -84)
editorContainer.Position = UDim2.new(0, 10, 0, 37)
editorContainer.BackgroundColor3 = T().editorBg
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
lineNumbers.TextColor3 = T().lineNum
lineNumbers.Font = Enum.Font.Code
lineNumbers.TextSize = FontSize
lineNumbers.TextXAlignment = Enum.TextXAlignment.Right
lineNumbers.TextYAlignment = Enum.TextYAlignment.Top
lineNumbers.Parent = editorScroll

local codeBox = Instance.new("TextBox")
codeBox.Size = UDim2.new(1, -40, 1, 0)
codeBox.Position = UDim2.new(0, 40, 0, 0)
codeBox.BackgroundTransparency = 1
codeBox.TextColor3 = fontColor()
codeBox.Font = Enum.Font.Code
codeBox.TextSize = FontSize
codeBox.TextXAlignment = Enum.TextXAlignment.Left
codeBox.TextYAlignment = Enum.TextYAlignment.Top
codeBox.ClearTextOnFocus = false
codeBox.MultiLine = true
codeBox.TextWrapped = true
codeBox.Parent = editorScroll

-- ==========================================================
-- OUTPUT
-- ==========================================================
local outputContainer = Instance.new("Frame")
outputContainer.Size = UDim2.new(0.4, -15, 1, -84)
outputContainer.Position = UDim2.new(0.6, 5, 0, 37)
outputContainer.BackgroundColor3 = T().outputBg
outputContainer.BorderSizePixel = 0
outputContainer.Parent = xWin
Instance.new("UICorner", outputContainer).CornerRadius = UDim.new(0, 4)

local outputLabel = Instance.new("TextLabel")
outputLabel.Size = UDim2.new(1, -10, 0, 18)
outputLabel.Position = UDim2.new(0, 5, 0, 3)
outputLabel.BackgroundTransparency = 1
outputLabel.Text = "OUTPUT (Roblox)"
outputLabel.TextColor3 = T().accent
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
    label.TextColor3 = color or fontColor()
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
    local color = fontColor()
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

-- ==========================================================
-- HINT BAR (short labels)
-- ==========================================================
local hintBar = Instance.new("Frame")
hintBar.Size = UDim2.new(1, -20, 0, 22)
hintBar.Position = UDim2.new(0, 10, 1, -42)
hintBar.BackgroundColor3 = T().header
hintBar.BorderSizePixel = 0
hintBar.Parent = xWin
Instance.new("UICorner", hintBar).CornerRadius = UDim.new(0, 4)

local hintLabel = Instance.new("TextLabel")
hintLabel.Size = UDim2.new(1, -10, 1, 0)
hintLabel.Position = UDim2.new(0, 10, 0, 0)
hintLabel.BackgroundTransparency = 1
hintLabel.Text = "0"
hintLabel.TextColor3 = fontColor()
hintLabel.Font = Enum.Font.Code
hintLabel.TextSize = 12
hintLabel.TextXAlignment = Enum.TextXAlignment.Left
hintLabel.Parent = hintBar

-- ==========================================================
-- UPDATE VISUALS + HINT
-- ==========================================================
local function updateEditorVisuals()
    local text = codeBox.Text
    local lines = {}
    for line in text:gmatch("([^\n]*)\n?") do table.insert(lines, line) end
    if text:sub(-1) == "\n" then table.insert(lines, "") end
    local numStr = ""
    for i, line in ipairs(lines) do
        numStr = numStr .. i .. "\n"
        local lineSize = TextService:GetTextSize(line, FontSize, Enum.Font.Code, Vector2.new(codeBox.AbsoluteSize.X, math.huge))
        local extraLines = math.floor((lineSize.Y - 18) / 18)
        for j = 1, extraLines do numStr = numStr .. "\n" end
    end
    lineNumbers.Text = numStr
    local totalSize = TextService:GetTextSize(text, FontSize, Enum.Font.Code, Vector2.new(codeBox.AbsoluteSize.X, math.huge))
    local textHeight = totalSize.Y + 30
    editorScroll.CanvasSize = UDim2.new(0, 0, 0, math.max(textHeight, editorScroll.AbsoluteSize.Y))
    lineNumbers.Size = UDim2.new(0, 30, 0, math.max(textHeight, editorScroll.AbsoluteSize.Y))
end

local function updateHint()
    local text = codeBox.Text
    local cursor = codeBox.CursorPosition or 1
    if text == "" then hintLabel.Text = "0"; return end
    local beforeCursor = text:sub(1, cursor - 1)
    local lineStart = beforeCursor:find("\n[^\n]*$") or 0
    local lineEnd = text:find("\n", cursor) or (#text + 1)
    local line = text:sub(lineStart + 1, lineEnd - 1)
    local trimmed = line:match("^%s*(.-)%s*$")
    local indent = #(line:match("^(%s*)") or "")
    local label = "0"
    if trimmed == "" then label = "0"
    elseif trimmed:match("^end") or trimmed:match("^else") or trimmed:match("^elseif") or trimmed:match("^until") then
        label = "-4"
    elseif trimmed:match("then%s*$") or trimmed:match("do%s*$") or trimmed:match("function%s*%(") or trimmed:match("function%s+%w+%s*%(") then
        label = "+4 (end)"
    elseif trimmed:match("repeat%s*$") or trimmed:match("{%s*$") then
        label = "+4"
    end
    hintLabel.Text = label .. "   |   current: " .. indent
end

codeBox:GetPropertyChangedSignal("Text"):Connect(function() updateEditorVisuals(); updateHint() end)
codeBox:GetPropertyChangedSignal("CursorPosition"):Connect(updateHint)
editorScroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    lineNumbers.Position = UDim2.new(0, 5, 0, -editorScroll.CanvasPosition.Y)
end)

-- ==========================================================
-- APPLY THEME
-- ==========================================================
local function applyTheme()
    xWin.BackgroundColor3 = T().bg
    xHeader.BackgroundColor3 = T().header
    xTitle.TextColor3 = T().btnText
    editorContainer.BackgroundColor3 = T().editorBg
    outputContainer.BackgroundColor3 = T().outputBg
    lineNumbers.TextColor3 = T().lineNum
    codeBox.TextColor3 = fontColor()
    codeBox.TextSize = FontSize
    lineNumbers.TextSize = FontSize
    outputLabel.TextColor3 = T().accent
    hintBar.BackgroundColor3 = T().header
    hintLabel.TextColor3 = fontColor()
    for _, btn in ipairs(xHeader:GetChildren()) do
        if btn:IsA("TextButton") then
            btn.BackgroundColor3 = T().btn
            btn.TextColor3 = T().btnText
        end
    end
    for _, lbl in ipairs(outputScroll:GetChildren()) do
        if lbl:IsA("TextLabel") then
            if lbl.Text:match("^%[ERR%]") then lbl.TextColor3 = Color3.fromRGB(255,100,100)
            elseif lbl.Text:match("^%[WARN%]") then lbl.TextColor3 = Color3.fromRGB(255,200,100)
            elseif lbl.Text:match("^%[INFO%]") then lbl.TextColor3 = Color3.fromRGB(200,200,255)
            else lbl.TextColor3 = fontColor() end
        end
    end
    updateEditorVisuals()
end

-- ==========================================================
-- SETTINGS PANEL (10+ functions)
-- ==========================================================
local settingsFrame = Instance.new("Frame")
settingsFrame.Size = UDim2.new(0, 280, 0, 440)
settingsFrame.Position = UDim2.new(0.5, -140, 0.5, -220)
settingsFrame.BackgroundColor3 = T().header
settingsFrame.Visible = false
settingsFrame.ZIndex = 100
settingsFrame.Parent = xGui
Instance.new("UICorner", settingsFrame).CornerRadius = UDim.new(0, 6)
local sStroke = Instance.new("UIStroke", settingsFrame)
sStroke.Color = T().accent

local sTitle = Instance.new("TextLabel")
sTitle.Size = UDim2.new(1, -30, 0, 24)
sTitle.Position = UDim2.new(0, 5, 0, 5)
sTitle.BackgroundTransparency = 1
sTitle.Text = "Settings"
sTitle.TextColor3 = fontColor()
sTitle.Font = Enum.Font.Code
sTitle.TextSize = 14
sTitle.Parent = settingsFrame

local settingsScroll = Instance.new("ScrollingFrame")
settingsScroll.Size = UDim2.new(1, -10, 1, -35)
settingsScroll.Position = UDim2.new(0, 5, 0, 30)
settingsScroll.BackgroundTransparency = 1
settingsScroll.BorderSizePixel = 0
settingsScroll.ScrollBarThickness = 6
settingsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
settingsScroll.Parent = settingsFrame
local sLayout = Instance.new("UIListLayout", settingsScroll)
sLayout.Padding = UDim.new(0, 4)
sLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function makeSettingBtn(text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -10, 0, 26)
    b.BackgroundColor3 = T().btn
    b.Text = text
    b.TextColor3 = T().btnText
    b.Font = Enum.Font.Code
    b.TextSize = 12
    b.BorderSizePixel = 0
    b.Parent = settingsScroll
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.MouseButton1Click:Connect(callback)
    return b
end

-- helper: работа с текущей строкой
local function getCurrentLine()
    local text = codeBox.Text
    local cursor = codeBox.CursorPosition or 1
    local before = text:sub(1, cursor - 1)
    local startPos = (before:find("\n[^\n]*$") or 0) + 1
    local endPos = (text:find("\n", cursor) or (#text + 1)) - 1
    return startPos, endPos, text:sub(startPos, endPos)
end

-- 1. Тема
makeSettingBtn("Theme: Dark / Light", function()
    CurrentTheme = (CurrentTheme == "Dark") and "Light" or "Dark"
    settingsFrame.BackgroundColor3 = T().header
    sStroke.Color = T().accent
    sTitle.TextColor3 = fontColor()
    applyTheme()
end)

-- 2-6. Цвета шрифта
makeSettingBtn("Font color: White", function() FontColor = Color3.fromRGB(255,255,255); applyTheme() end)
makeSettingBtn("Font color: Black", function() FontColor = Color3.fromRGB(0,0,0); applyTheme() end)
makeSettingBtn("Font color: Green", function() FontColor = Color3.fromRGB(120,255,120); applyTheme() end)
makeSettingBtn("Font color: Cyan", function() FontColor = Color3.fromRGB(120,220,255); applyTheme() end)
makeSettingBtn("Font color: Default", function() FontColor = nil; applyTheme() end)

-- 7. Размер шрифта
makeSettingBtn("Font size: cycle 12/14/16", function()
    FontSize = (FontSize == 12) and 14 or ((FontSize == 14) and 16 or 12)
    applyTheme()
end)

-- 8. Format Indent (для всего кода)
makeSettingBtn("Format Indent (whole code)", function()
    local INDENT = "    "
    local lines = {}
    for line in codeBox.Text:gmatch("([^\n]*)\n?") do table.insert(lines, line) end
    local lvl = 0
    local out = {}
    for _, line in ipairs(lines) do
        local trimmed = line:match("^%s*(.-)%s*$")
        if trimmed:match("^end") or trimmed:match("^else") or trimmed:match("^elseif") or trimmed:match("^until") then
            lvl = math.max(0, lvl - 1)
        end
        if trimmed ~= "" then
            table.insert(out, string.rep(INDENT, lvl) .. trimmed)
        else
            table.insert(out, "")
        end
        if trimmed:match("then%s*$") or trimmed:match("do%s*$") or trimmed:match("function%s*%(") or trimmed:match("repeat%s*$") then
            lvl = lvl + 1
        end
    end
    codeBox.Text = table.concat(out, "\n")
end)

-- 9. Duplicate Line
makeSettingBtn("Duplicate Line", function()
    local s, e, line = getCurrentLine()
    local text = codeBox.Text
    codeBox.Text = text:sub(1, e) .. "\n" .. line .. text:sub(e + 1)
end)

-- 10. Delete Line
makeSettingBtn("Delete Line", function()
    local s, e, line = getCurrentLine()
    local text = codeBox.Text
    local removeEnd = (text:sub(e + 1, e + 1) == "\n") and e + 1 or e
    codeBox.Text = text:sub(1, s - 1) .. text:sub(removeEnd + 1)
end)

-- 11. Comment / Uncomment
makeSettingBtn("Comment / Uncomment Line", function()
    local s, e, line = getCurrentLine()
    local text = codeBox.Text
    if line:match("^%s*%-%-") then
        local newLine = line:gsub("^(%s*)%-%-%s?", "%1", 1)
        codeBox.Text = text:sub(1, s - 1) .. newLine .. text:sub(e + 1)
    else
        local newLine = line:gsub("^(%s*)", "%1-- ", 1)
        codeBox.Text = text:sub(1, s - 1) .. newLine .. text:sub(e + 1)
    end
end)

-- 12. Uppercase selected/all
makeSettingBtn("Uppercase (all)", function()
    codeBox.Text = codeBox.Text:upper()
end)

-- 13. Lowercase selected/all
makeSettingBtn("Lowercase (all)", function()
    codeBox.Text = codeBox.Text:lower()
end)

-- 14. Copy All
makeSettingBtn("Copy All to Clipboard", function()
    if setclipboard then setclipboard(codeBox.Text); addOutput("Copied to clipboard", T().accent)
    else addOutput("setclipboard unavailable", Color3.fromRGB(255,100,100)) end
end)

-- 15. Paste
makeSettingBtn("Paste from Clipboard", function()
    if getclipboard then codeBox.Text = codeBox.Text .. getclipboard()
    else addOutput("getclipboard unavailable", Color3.fromRGB(255,100,100)) end
end)

-- 16. Save to file
makeSettingBtn("Save File (writefile)", function()
    if type(writefile) == "function" then
        local ok, err = pcall(function() writefile("Xcode_Script.lua", codeBox.Text) end)
        if ok then addOutput("Saved Xcode_Script.lua", T().accent)
        else addOutput("Save error: " .. tostring(err), Color3.fromRGB(255,100,100)) end
    else addOutput("writefile unavailable", Color3.fromRGB(255,100,100)) end
end)

-- 17. Load from file
makeSettingBtn("Load File (readfile)", function()
    if type(readfile) == "function" then
        local ok, data = pcall(readfile, "Xcode_Script.lua")
        if ok and data then codeBox.Text = data; addOutput("Loaded Xcode_Script.lua", T().accent)
        else addOutput("Load error: " .. tostring(data), Color3.fromRGB(255,100,100)) end
    else addOutput("readfile unavailable", Color3.fromRGB(255,100,100)) end
end)

local closeSettings = Instance.new("TextButton")
closeSettings.Size = UDim2.new(0, 24, 0, 24)
closeSettings.Position = UDim2.new(1, -28, 0, 4)
closeSettings.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeSettings.Text = "X"
closeSettings.TextColor3 = Color3.new(1,1,1)
closeSettings.Font = Enum.Font.Code
closeSettings.TextSize = 12
closeSettings.BorderSizePixel = 0
closeSettings.ZIndex = 101
closeSettings.Parent = settingsFrame
Instance.new("UICorner", closeSettings).CornerRadius = UDim.new(0, 4)
closeSettings.MouseButton1Click:Connect(function() settingsFrame.Visible = false end)

-- ==========================================================
-- HELP PANEL (English)
-- ==========================================================
local helpFrame = Instance.new("Frame")
helpFrame.Size = UDim2.new(0, 420, 0, 420)
helpFrame.Position = UDim2.new(0.5, -210, 0.5, -210)
helpFrame.BackgroundColor3 = T().header
helpFrame.Visible = false
helpFrame.ZIndex = 100
helpFrame.Parent = xGui
Instance.new("UICorner", helpFrame).CornerRadius = UDim.new(0, 6)
local hStroke = Instance.new("UIStroke", helpFrame); hStroke.Color = T().accent

local hTitle = Instance.new("TextLabel")
hTitle.Size = UDim2.new(1, -30, 0, 24)
hTitle.Position = UDim2.new(0, 5, 0, 5)
hTitle.BackgroundTransparency = 1
hTitle.Text = "Help — Lua keywords"
hTitle.TextColor3 = fontColor()
hTitle.Font = Enum.Font.Code
hTitle.TextSize = 14
hTitle.Parent = helpFrame

local helpScroll = Instance.new("ScrollingFrame")
helpScroll.Size = UDim2.new(1, -10, 1, -35)
helpScroll.Position = UDim2.new(0, 5, 0, 30)
helpScroll.BackgroundTransparency = 1
helpScroll.BorderSizePixel = 0
helpScroll.ScrollBarThickness = 6
helpScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
helpScroll.Parent = helpFrame
local hLayout = Instance.new("UIListLayout", helpScroll)
hLayout.Padding = UDim.new(0, 2)

local helpData = {
    { "local", "declares a local variable" },
    { "=", "assignment (set value)" },
    { "==", "equality comparison" },
    { "~=", "not equal" },
    { ">", "greater than" },
    { "<", "less than" },
    { ">=", "greater or equal" },
    { "<=", "less or equal" },
    { "nil", "no value / empty" },
    { "true", "boolean true" },
    { "false", "boolean false" },
    { "\"text\"", "string (text in quotes)" },
    { "123", "number" },
    { "if ... then", "if condition is true, run block" },
    { "elseif ... then", "else if another condition is true" },
    { "else", "otherwise" },
    { "end", "closes if/for/while/function" },
    { "and", "logical AND" },
    { "or", "logical OR" },
    { "not", "logical NOT" },
    { "for i = 1, 10 do", "loop i from 1 to 10" },
    { "while cond do", "loop while condition is true" },
    { "do", "starts a loop/block body" },
    { "break", "exit the loop" },
    { "function", "declare a function" },
    { "return", "return a value from function" },
    { "print(...)", "print to output" },
    { "{ }", "table (list or dictionary)" },
    { "#table", "length of a table" },
    { "table[1]", "first element of a table" },
    { "table.key", "element by name" },
    { "-- text", "single-line comment" },
    { "--[[ text ]]", "multi-line comment" },
}
for _, pair in ipairs(helpData) do
    local row = Instance.new("TextLabel")
    row.Size = UDim2.new(1, -10, 0, 20)
    row.BackgroundTransparency = 1
    row.Text = pair[1] .. "  —  " .. pair[2]
    row.TextColor3 = fontColor()
    row.Font = Enum.Font.Code
    row.TextSize = 12
    row.TextXAlignment = Enum.TextXAlignment.Left
    row.Parent = helpScroll
end
helpScroll.CanvasSize = UDim2.new(0, 0, 0, hLayout.AbsoluteContentSize.Y + 10)

local closeHelp = Instance.new("TextButton")
closeHelp.Size = UDim2.new(0, 24, 0, 24)
closeHelp.Position = UDim2.new(1, -28, 0, 4)
closeHelp.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeHelp.Text = "X"
closeHelp.TextColor3 = Color3.new(1,1,1)
closeHelp.Font = Enum.Font.Code
closeHelp.TextSize = 12
closeHelp.BorderSizePixel = 0
closeHelp.ZIndex = 101
closeHelp.Parent = helpFrame
Instance.new("UICorner", closeHelp).CornerRadius = UDim.new(0, 4)
closeHelp.MouseButton1Click:Connect(function() helpFrame.Visible = false end)

-- ==========================================================
-- BUTTON HANDLERS
-- ==========================================================
btnExecute.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        local func = loadstring(codeBox.Text)
        if func then func() else error("Compilation error (empty code)") end
    end)
    if not success then warn("[Xcode Error] " .. tostring(err)) end
end)

btnClearCode.MouseButton1Click:Connect(function() codeBox.Text = "" end)
btnClearOut.MouseButton1Click:Connect(function()
    for _, child in ipairs(outputScroll:GetChildren()) do
        if child:IsA("TextLabel") then child:Destroy() end
    end
end)

btnSelectAll.MouseButton1Click:Connect(function()
    codeBox.CursorPosition = 1
    codeBox.SelectionStart = #codeBox.Text + 1
    codeBox:CaptureFocus()
end)

btnSave.MouseButton1Click:Connect(function()
    if type(writefile) == "function" then
        local ok, err = pcall(function() writefile("Xcode_Script.lua", codeBox.Text) end)
        if not ok then addOutput("Save error: " .. tostring(err), Color3.fromRGB(255, 100, 100)) end
    else addOutput("writefile недоступен", Color3.fromRGB(255, 100, 100)) end
end)

btnSettings.MouseButton1Click:Connect(function() settingsFrame.Visible = not settingsFrame.Visible end)
btnHelp.MouseButton1Click:Connect(function() helpFrame.Visible = not helpFrame.Visible end)

-- ==========================================================
-- RESIZE
-- ==========================================================
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
        xWin.Size = UDim2.new(0, math.max(600, xStartSize.X + delta.X), 0, math.max(340, xStartSize.Y + delta.Y))
        updateEditorVisuals()
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then xResizing = false end
end)

-- ==========================================================
-- START CODE
-- ==========================================================
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
updateHint()
