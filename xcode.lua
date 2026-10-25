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
        text = Color3.fromRGB(220, 220, 220), lineNum = Color3.fromRGB(100, 100, 100),
        btn = Color3.fromRGB(50, 50, 50), btnText = Color3.fromRGB(220, 220, 220),
        accent = Color3.fromRGB(255, 200, 100),
    },
    Light = {
        bg = Color3.fromRGB(210, 210, 210), header = Color3.fromRGB(190, 190, 190),
        editorBg = Color3.fromRGB(235, 235, 235), outputBg = Color3.fromRGB(225, 225, 225),
        text = Color3.fromRGB(20, 20, 20), lineNum = Color3.fromRGB(110, 110, 110),
        btn = Color3.fromRGB(165, 165, 165), btnText = Color3.fromRGB(20, 20, 20),
        accent = Color3.fromRGB(180, 90, 0),
    }
}
local CurrentTheme = "Dark"
local FontColor = nil
local FontSize = 14

local function T() return Theme[CurrentTheme] end
local function fontColor()
    if FontColor then return FontColor end
    return (CurrentTheme == "Dark") and Color3.fromRGB(220,220,220) or Color3.fromRGB(20,20,20)
end
local function lineHeight() return FontSize + 4 end

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

local btnHelp      = makeHeaderBtn("Help",       -70,  54)
local btnSettings  = makeHeaderBtn("Settings",   -132, 62)
local btnEditor    = makeHeaderBtn("Editor",     -194, 58)
local btnSelectAll = makeHeaderBtn("Select All", -262, 76)
local btnSave      = makeHeaderBtn("Save",       -330, 54)
local btnClearCode = makeHeaderBtn("Clear Code", -418, 80)
local btnClearOut  = makeHeaderBtn("Clear Out",  -506, 80)
local btnExecute   = makeHeaderBtn("Execute",    -568, 54)

-- ==========================================================
-- CONTENT
-- ==========================================================
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -84)
contentFrame.Position = UDim2.new(0, 10, 0, 37)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = xWin

-- ==========================================================
-- EDITOR TAB
-- ==========================================================
local tabEditor = Instance.new("Frame")
tabEditor.Size = UDim2.new(1, 0, 1, 0)
tabEditor.BackgroundTransparency = 1
tabEditor.Visible = true
tabEditor.Parent = contentFrame

local editorContainer = Instance.new("Frame")
editorContainer.Size = UDim2.new(0.6, -5, 1, 0)
editorContainer.Position = UDim2.new(0, 0, 0, 0)
editorContainer.BackgroundColor3 = T().editorBg
editorContainer.BorderSizePixel = 0
editorContainer.Parent = tabEditor
Instance.new("UICorner", editorContainer).CornerRadius = UDim.new(0, 4)

local editorScroll = Instance.new("ScrollingFrame")
editorScroll.Size = UDim2.new(1, 0, 1, 0)
editorScroll.BackgroundTransparency = 1
editorScroll.BorderSizePixel = 0
editorScroll.ScrollBarThickness = 8
editorScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
editorScroll.CanvasSize = UDim2.new(0, 0, 0, 1000)
editorScroll.ScrollingDirection = Enum.ScrollingDirection.XY
editorScroll.Parent = editorContainer

local lineNumbers = Instance.new("TextLabel")
lineNumbers.BackgroundTransparency = 1
lineNumbers.Text = "1"
lineNumbers.TextColor3 = T().lineNum
lineNumbers.Font = Enum.Font.Code
lineNumbers.TextSize = FontSize
lineNumbers.TextXAlignment = Enum.TextXAlignment.Right
lineNumbers.TextYAlignment = Enum.TextYAlignment.Top
lineNumbers.Position = UDim2.new(0, 5, 0, 0)
lineNumbers.Size = UDim2.new(0, 30, 0, 0)
lineNumbers.Parent = editorScroll

local codeBox = Instance.new("TextBox")
codeBox.BackgroundTransparency = 1
codeBox.TextColor3 = fontColor()
codeBox.Font = Enum.Font.Code
codeBox.TextSize = FontSize
codeBox.TextXAlignment = Enum.TextXAlignment.Left
codeBox.TextYAlignment = Enum.TextYAlignment.Top
codeBox.ClearTextOnFocus = false
codeBox.MultiLine = true
codeBox.TextWrapped = false  -- ВАЖНО: равная высота строк → простая математика
codeBox.Position = UDim2.new(0, 40, 0, 0)
codeBox.Size = UDim2.new(1, -40, 0, 0)
codeBox.Parent = editorScroll

-- ==========================================================
-- OUTPUT PANEL
-- ==========================================================
local outputContainer = Instance.new("Frame")
outputContainer.Size = UDim2.new(0.4, -5, 1, 0)
outputContainer.Position = UDim2.new(0.6, 5, 0, 0)
outputContainer.BackgroundColor3 = T().outputBg
outputContainer.BorderSizePixel = 0
outputContainer.Parent = tabEditor
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

outputLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    outputScroll.CanvasSize = UDim2.new(0, 0, 0, outputLayout.AbsoluteContentSize.Y + 10)
end)

local MAX_OUTPUT = 200
local outputQueue = {}

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
    table.insert(outputQueue, label)
    while #outputQueue > MAX_OUTPUT do
        local oldest = table.remove(outputQueue, 1)
        if oldest then oldest:Destroy() end
    end
    task.defer(function()
        if outputScroll and outputScroll.Parent then
            outputScroll.CanvasPosition = Vector2.new(0, outputScroll.CanvasSize.Y.Offset)
        end
    end)
end

-- ==========================================================
-- SETTINGS TAB (GUI)
-- ==========================================================
local tabSettings = Instance.new("Frame")
tabSettings.Size = UDim2.new(1, 0, 1, 0)
tabSettings.BackgroundColor3 = T().bg
tabSettings.BorderSizePixel = 0
tabSettings.Visible = false
tabSettings.Parent = contentFrame
Instance.new("UICorner", tabSettings).CornerRadius = UDim.new(0, 4)

local settingsScroll = Instance.new("ScrollingFrame")
settingsScroll.Size = UDim2.new(1, 0, 1, 0)
settingsScroll.BackgroundTransparency = 1
settingsScroll.BorderSizePixel = 0
settingsScroll.ScrollBarThickness = 6
settingsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
settingsScroll.Parent = tabSettings
local sLayout = Instance.new("UIListLayout", settingsScroll)
sLayout.Padding = UDim.new(0, 4)
sLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ==========================================================
-- HELP TAB
-- ==========================================================
local tabHelp = Instance.new("Frame")
tabHelp.Size = UDim2.new(1, 0, 1, 0)
tabHelp.BackgroundColor3 = T().bg
tabHelp.BorderSizePixel = 0
tabHelp.Visible = false
tabHelp.Parent = contentFrame
Instance.new("UICorner", tabHelp).CornerRadius = UDim.new(0, 4)

local helpScroll = Instance.new("ScrollingFrame")
helpScroll.Size = UDim2.new(1, 0, 1, 0)
helpScroll.BackgroundTransparency = 1
helpScroll.BorderSizePixel = 0
helpScroll.ScrollBarThickness = 6
helpScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
helpScroll.Parent = tabHelp
local hLayout = Instance.new("UIListLayout", helpScroll)
hLayout.Padding = UDim.new(0, 2)

-- ==========================================================
-- HINT BAR
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
-- VIRTUAL BUFFER STATE
-- ==========================================================
local WINDOW_LINES = 300       -- сколько строк держим в TextBox одновременно
local buffer = {""}            -- полный текст, массив строк
local viewStart = 1            -- первая видимая строка буфера в окне
local viewEnd = 1              -- последняя видимая строка буфера в окне
local suppress = false         -- защита от рекурсии при программных изменениях

local function splitLines(s)
    local out = {}
    for line in (s .. "\n"):gmatch("([^\n]*)\n") do
        out[#out + 1] = line
    end
    if #out == 0 then out[1] = "" end
    return out
end

local function bufferText()
    return table.concat(buffer, "\n")
end

local function clampViewStart()
    local maxStart = math.max(1, #buffer - WINDOW_LINES + 1)
    if viewStart > maxStart then viewStart = maxStart end
    if viewStart < 1 then viewStart = 1 end
end

local function getBufferCursorLine()
    local cursor = codeBox.CursorPosition or 1
    local before = codeBox.Text:sub(1, cursor - 1)
    local nl = 0
    for _ in before:gmatch("\n") do nl = nl + 1 end
    return viewStart + nl
end

local function updateEditorLayout()
    clampViewStart()
    viewEnd = math.min(#buffer, viewStart + WINDOW_LINES - 1)
    if viewEnd < viewStart then viewEnd = viewStart end

    local lh = lineHeight()
    local winCount = viewEnd - viewStart + 1
    local offsetY = (viewStart - 1) * lh
    local winHeight = winCount * lh

    codeBox.Position = UDim2.new(0, 40, 0, offsetY)
    codeBox.Size = UDim2.new(1, -40, 0, winHeight)
    codeBox.TextSize = FontSize
    codeBox.TextColor3 = fontColor()

    lineNumbers.Position = UDim2.new(0, 5, 0, offsetY)
    lineNumbers.Size = UDim2.new(0, 30, 0, winHeight)
    lineNumbers.TextSize = FontSize
    lineNumbers.TextColor3 = T().lineNum

    local nums = {}
    for i = viewStart, viewEnd do
        nums[#nums + 1] = tostring(i)
    end
    lineNumbers.Text = table.concat(nums, "\n")

    -- ширина канваса: из самой длинной строки в окне
    local maxLen = 0
    for i = viewStart, viewEnd do
        local t = buffer[i]
        if t and #t > maxLen then maxLen = #t end
    end
    local neededW = math.ceil(maxLen * FontSize * 0.62) + 80
    local viewW = editorScroll.AbsoluteWindowSize.X
    local canvasW = math.max(viewW, neededW)

    local totalH = #buffer * lh + 40
    editorScroll.CanvasSize = UDim2.new(0, canvasW, 0, totalH)
end

local function renderWindow()
    clampViewStart()
    viewEnd = math.min(#buffer, viewStart + WINDOW_LINES - 1)
    if viewEnd < viewStart then viewEnd = viewStart end

    local lines = {}
    for i = viewStart, viewEnd do
        lines[#lines + 1] = buffer[i] or ""
    end

    suppress = true
    codeBox.Text = table.concat(lines, "\n")
    codeBox.CursorPosition = 1
    suppress = false

    updateEditorLayout()
end

local function syncEditToBuffer()
    if suppress then return end

    local newLines = splitLines(codeBox.Text)
    local oldLines = {}
    for i = viewStart, viewEnd do
        oldLines[#oldLines + 1] = buffer[i] or ""
    end

    -- первая различающаяся строка
    local firstDiff = 1
    local minLen = math.min(#newLines, #oldLines)
    while firstDiff <= minLen and newLines[firstDiff] == oldLines[firstDiff] do
        firstDiff = firstDiff + 1
    end

    if firstDiff > #newLines and firstDiff > #oldLines then
        return
    end

    -- последняя совпадающая с конца
    local lastNew = #newLines
    local lastOld = #oldLines
    while lastOld >= firstDiff and lastNew >= firstDiff
          and newLines[lastNew] == oldLines[lastOld] do
        lastNew = lastNew - 1
        lastOld = lastOld - 1
    end

    local prefixEnd   = viewStart + firstDiff - 2  -- последняя строка до правки
    local suffixStart = viewStart + lastOld        -- первая строка после правки

    local newBuffer = {}
    for i = 1, math.min(prefixEnd, #buffer) do
        newBuffer[#newBuffer + 1] = buffer[i]
    end
    for i = firstDiff, lastNew do
        newBuffer[#newBuffer + 1] = newLines[i]
    end
    for i = suffixStart, #buffer do
        newBuffer[#newBuffer + 1] = buffer[i]
    end
    if #newBuffer == 0 then newBuffer[1] = "" end

    buffer = newBuffer

    -- если пользователь дописал в конец окна — расширяем видимое
    viewEnd = math.min(#buffer, math.max(viewEnd, viewStart + #newLines - 1))

    updateEditorLayout()
end

-- прокрутка, чтобы курсор оставался видимым
local function keepCursorVisible()
    local cursor = codeBox.CursorPosition or 1
    local before = codeBox.Text:sub(1, cursor - 1)
    local nl = 0
    for _ in before:gmatch("\n") do nl = nl + 1 end
    local lineInWindow = nl + 1
    local lh = lineHeight()
    local cursorY = (viewStart - 1 + lineInWindow - 1) * lh

    local viewTop = editorScroll.CanvasPosition.Y
    local viewH = editorScroll.AbsoluteWindowSize.Y

    if cursorY < viewTop + lh then
        editorScroll.CanvasPosition = Vector2.new(
            editorScroll.CanvasPosition.X,
            math.max(0, cursorY - lh * 2)
        )
    elseif cursorY + lh > viewTop + viewH - lh then
        editorScroll.CanvasPosition = Vector2.new(
            editorScroll.CanvasPosition.X,
            math.max(0, cursorY - viewH + lh * 3)
        )
    end
end

-- ==========================================================
-- UPDATE HINT
-- ==========================================================
local function updateHint()
    local text = codeBox.Text
    local cursor = codeBox.CursorPosition or 1
    local before = text:sub(1, cursor - 1)
    local lineStart = (before:find("\n[^\n]*$") or 0)
    local lineEnd = (text:find("\n", cursor) or (#text + 1))
    local line = text:sub(lineStart + 1, lineEnd - 1)
    local trimmed = line:match("^%s*(.-)%s*$")
    local indent = #(line:match("^(%s*)") or "")

    local label = "0"
    if trimmed == "" then label = "0"
    elseif trimmed:match("^end") or trimmed:match("^else") or
           trimmed:match("^elseif") or trimmed:match("^until") then label = "-4"
    elseif trimmed:match("then%s*$") or trimmed:match("^do%s*$") or
           trimmed:match("do%s*$") or trimmed:match("function%s*%(") then
        label = "+4 (end)"
    elseif trimmed:match("repeat%s*$") or trimmed:match("{%s*$") then label = "+4" end

    local bufLine = getBufferCursorLine()
    hintLabel.Text = string.format(
        "line %d/%d  |  indent %d  |  hint %s  |  in TextBox: %d",
        bufLine, #buffer, indent, label, #text
    )
end

-- ==========================================================
-- SIGNALS
-- ==========================================================
codeBox:GetPropertyChangedSignal("Text"):Connect(function()
    if suppress then return end
    syncEditToBuffer()
    updateHint()
    keepCursorVisible()
end)

codeBox:GetPropertyChangedSignal("CursorPosition"):Connect(updateHint)

editorScroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    if suppress then return end
    local lh = lineHeight()
    local topY = editorScroll.CanvasPosition.Y
    local viewH = editorScroll.AbsoluteWindowSize.Y
    local topLine = math.floor(topY / lh) + 1
    local botLine = math.floor((topY + viewH) / lh) + 1

    local margin = 100

    if codeBox:IsFocused() then
        -- не мешаем вводу, если окно всё ещё видно
        if botLine < viewStart or topLine > viewEnd then
            codeBox:ReleaseFocus()
            viewStart = math.max(1, topLine - margin)
            renderWindow()
        end
    else
        if topLine < viewStart + margin or botLine > viewEnd - margin then
            local newStart = math.max(1, topLine - margin)
            if newStart ~= viewStart then
                viewStart = newStart
                renderWindow()
            end
        end
    end
end)

-- ==========================================================
-- LOG OUTPUT
-- ==========================================================
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
        color = Color3.fromRGB(150, 150, 255); prefix = "[INFO]"
    end
    addOutput(prefix .. " " .. tostring(message), color)
end)

-- ==========================================================
-- SETTINGS BUTTONS
-- ==========================================================
local function makeSettingBtn(text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 28)
    b.BackgroundColor3 = T().btn
    b.Text = "  " .. text
    b.TextColor3 = T().btnText
    b.Font = Enum.Font.Code
    b.TextSize = 12
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.BorderSizePixel = 0
    b.Parent = settingsScroll
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.MouseButton1Click:Connect(callback)
    return b
end

local function getCurrentLineInWindow()
    local text = codeBox.Text
    local cursor = codeBox.CursorPosition or 1
    local before = text:sub(1, cursor - 1)
    local startPos = (before:find("\n[^\n]*$") or 0) + 1
    local endPos = (text:find("\n", cursor) or (#text + 1)) - 1
    return startPos, endPos, text:sub(startPos, endPos)
end

makeSettingBtn("Theme: Dark / Light", function()
    CurrentTheme = (CurrentTheme == "Dark") and "Light" or "Dark"
    FontColor = nil
    applyTheme()
end)
makeSettingBtn("Font color: White", function() FontColor = Color3.fromRGB(255,255,255); applyTheme() end)
makeSettingBtn("Font color: Black", function() FontColor = Color3.fromRGB(0,0,0); applyTheme() end)
makeSettingBtn("Font color: Green", function() FontColor = Color3.fromRGB(120,255,120); applyTheme() end)
makeSettingBtn("Font color: Cyan",  function() FontColor = Color3.fromRGB(120,220,255); applyTheme() end)
makeSettingBtn("Font color: Default", function() FontColor = nil; applyTheme() end)
makeSettingBtn("Font size: cycle 12 / 14 / 16", function()
    FontSize = (FontSize == 12) and 14 or ((FontSize == 14) and 16 or 12)
    applyTheme()
end)
makeSettingBtn("Format Indent (whole code)", function()
    local INDENT = "    "
    local lvl = 0
    local out = {}
    for _, line in ipairs(buffer) do
        local trimmed = line:match("^%s*(.-)%s*$")
        if trimmed:match("^end") or trimmed:match("^else") or
           trimmed:match("^elseif") or trimmed:match("^until") then
            lvl = math.max(0, lvl - 1)
        end
        if trimmed ~= "" then
            table.insert(out, string.rep(INDENT, lvl) .. trimmed)
        else
            table.insert(out, "")
        end
        if trimmed:match("then%s*$") or trimmed:match("do%s*$") or
           trimmed:match("function%s*%(") or trimmed:match("repeat%s*$") then
            lvl = lvl + 1
        end
    end
    if #out == 0 then out = {""} end
    buffer = out
    renderWindow()
    updateHint()
end)
makeSettingBtn("Duplicate Line", function()
    local s, e, line = getCurrentLineInWindow()
    codeBox.Text = codeBox.Text:sub(1, e) .. "\n" .. line .. codeBox.Text:sub(e + 1)
end)
makeSettingBtn("Delete Line", function()
    local s, e = getCurrentLineInWindow()
    local text = codeBox.Text
    local removeEnd = (text:sub(e + 1, e + 1) == "\n") and e + 1 or e
    codeBox.Text = text:sub(1, s - 1) .. text:sub(removeEnd + 1)
end)
makeSettingBtn("Comment / Uncomment Line", function()
    local s, e, line = getCurrentLineInWindow()
    local text = codeBox.Text
    if line:match("^%s*%-%-") then
        codeBox.Text = text:sub(1, s - 1) .. line:gsub("^(%s*)%-%-%s?", "%1", 1) .. text:sub(e + 1)
    else
        codeBox.Text = text:sub(1, s - 1) .. line:gsub("^(%s*)", "%1-- ", 1) .. text:sub(e + 1)
    end
end)
makeSettingBtn("Uppercase (all)", function()
    for i = 1, #buffer do buffer[i] = buffer[i]:upper() end
    renderWindow()
end)
makeSettingBtn("Lowercase (all)", function()
    for i = 1, #buffer do buffer[i] = buffer[i]:lower() end
    renderWindow()
end)
makeSettingBtn("Copy All to Clipboard", function()
    if setclipboard then setclipboard(bufferText()) end
end)
makeSettingBtn("Paste from Clipboard", function()
    if not getclipboard then return end
    local data = getclipboard()
    if not data or data == "" then return end
    local lineIdx = getBufferCursorLine()
    local pasteLines = splitLines(data)
    if #pasteLines == 1 then
        buffer[lineIdx] = (buffer[lineIdx] or "") .. pasteLines[1]
    else
        buffer[lineIdx] = (buffer[lineIdx] or "") .. pasteLines[1]
        for i = 2, #pasteLines do
            table.insert(buffer, lineIdx + i - 1, pasteLines[i])
        end
    end
    renderWindow()
end)
makeSettingBtn("Save File (writefile)", function()
    if type(writefile) == "function" then
        pcall(writefile, "Xcode_Script.lua", bufferText())
    end
end)
makeSettingBtn("Load File (readfile)", function()
    if type(readfile) == "function" then
        local ok, data = pcall(readfile, "Xcode_Script.lua")
        if ok and data then
            buffer = splitLines(data)
            viewStart = 1
            renderWindow()
            updateHint()
        end
    end
end)

-- ==========================================================
-- HELP LIST
-- ==========================================================
local helpData = {
    { "local", "declares a local variable" },
    { "=", "assignment" },
    { "==", "equality comparison" },
    { "~=", "not equal" },
    { ">", "greater than" },
    { "<", "less than" },
    { ">=", "greater or equal" },
    { "<=", "less or equal" },
    { "nil", "no value / empty" },
    { "true / false", "boolean values" },
    { "\"text\"", "string (in quotes)" },
    { "123", "number" },
    { "if ... then", "if condition is true" },
    { "elseif ... then", "else if another condition" },
    { "else", "otherwise" },
    { "end", "closes if/for/while/function" },
    { "and / or / not", "logical operators" },
    { "for i = 1, 10 do", "loop i from 1 to 10" },
    { "while cond do", "loop while condition is true" },
    { "break", "exit the loop" },
    { "function", "declare a function" },
    { "return", "return a value" },
    { "print(...)", "print to output" },
    { "{ }", "table (list or dict)" },
    { "#table", "length of a table" },
    { "table[1]", "first element" },
    { "table.key", "element by name" },
    { "-- text", "single-line comment" },
    { "--[[ text ]]", "multi-line comment" },
    { "Note", "Word wrap is OFF: long lines use horizontal scroll" },
    { "Note", "TextBox shows ~300 lines; scroll to see the rest" },
}
for _, pair in ipairs(helpData) do
    local row = Instance.new("TextLabel")
    row.Size = UDim2.new(1, -20, 0, 20)
    row.BackgroundTransparency = 1
    row.Text = "  " .. pair[1] .. "  —  " .. pair[2]
    row.TextColor3 = fontColor()
    row.Font = Enum.Font.Code
    row.TextSize = 12
    row.TextXAlignment = Enum.TextXAlignment.Left
    row.Parent = helpScroll
end

-- ==========================================================
-- TAB SWITCHING
-- ==========================================================
local activeTab = "editor"
local function showTab(name)
    if activeTab == name and name ~= "editor" then
        name = "editor"
    end
    activeTab = name
    tabEditor.Visible = (name == "editor")
    tabSettings.Visible = (name == "settings")
    tabHelp.Visible = (name == "help")
end

btnEditor.MouseButton1Click:Connect(function() showTab("editor") end)
btnSettings.MouseButton1Click:Connect(function() showTab("settings") end)
btnHelp.MouseButton1Click:Connect(function() showTab("help") end)

-- ==========================================================
-- APPLY THEME
-- ==========================================================
function applyTheme()
    xWin.BackgroundColor3 = T().bg
    xHeader.BackgroundColor3 = T().header
    xTitle.TextColor3 = T().btnText
    editorContainer.BackgroundColor3 = T().editorBg
    outputContainer.BackgroundColor3 = T().outputBg
    tabSettings.BackgroundColor3 = T().bg
    tabHelp.BackgroundColor3 = T().bg
    hintBar.BackgroundColor3 = T().header
    hintLabel.TextColor3 = fontColor()
    outputLabel.TextColor3 = T().accent

    for _, btn in ipairs(xHeader:GetChildren()) do
        if btn:IsA("TextButton") then
            btn.BackgroundColor3 = T().btn
            btn.TextColor3 = T().btnText
        end
    end
    for _, btn in ipairs(settingsScroll:GetChildren()) do
        if btn:IsA("TextButton") then
            btn.BackgroundColor3 = T().btn
            btn.TextColor3 = T().btnText
        end
    end
    for _, lbl in ipairs(helpScroll:GetChildren()) do
        if lbl:IsA("TextLabel") then lbl.TextColor3 = fontColor() end
    end
    for _, lbl in ipairs(outputScroll:GetChildren()) do
        if lbl:IsA("TextLabel") then
            if lbl.Text:match("^%[ERR%]") then
                lbl.TextColor3 = Color3.fromRGB(255,100,100)
            elseif lbl.Text:match("^%[WARN%]") then
                lbl.TextColor3 = Color3.fromRGB(255,200,100)
            elseif lbl.Text:match("^%[INFO%]") then
                lbl.TextColor3 = Color3.fromRGB(150,150,255)
            else
                lbl.TextColor3 = fontColor()
            end
        end
    end
    renderWindow()
end

-- ==========================================================
-- HEADER BUTTON HANDLERS
-- ==========================================================
btnExecute.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        local func = loadstring(bufferText())
        if func then func() else error("Compilation error (empty code)") end
    end)
    if not success then warn("[Xcode Error] " .. tostring(err)) end
end)

btnClearCode.MouseButton1Click:Connect(function()
    buffer = {""}
    viewStart = 1
    renderWindow()
    updateHint()
end)

btnClearOut.MouseButton1Click:Connect(function()
    for _, child in ipairs(outputScroll:GetChildren()) do
        if child:IsA("TextLabel") then child:Destroy() end
    end
    outputQueue = {}
end)

btnSelectAll.MouseButton1Click:Connect(function()
    codeBox.CursorPosition = 1
    codeBox.SelectionStart = #codeBox.Text + 1
    codeBox:CaptureFocus()
    addOutput(
        "[Xcode] Selected visible window only (buffer has " .. #buffer .. " lines)",
        Color3.fromRGB(180, 180, 120)
    )
end)

btnSave.MouseButton1Click:Connect(function()
    if type(writefile) == "function" then
        local ok, err = pcall(function() writefile("Xcode_Script.lua", bufferText()) end)
        if not ok then
            addOutput("Save error: " .. tostring(err), Color3.fromRGB(255, 100, 100))
        end
    else
        addOutput("writefile недоступен", Color3.fromRGB(255, 100, 100))
    end
end)

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
        xWin.Size = UDim2.new(
            0,
            math.max(600, xStartSize.X + delta.X),
            0,
            math.max(340, xStartSize.Y + delta.Y)
        )
        updateEditorLayout()
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then xResizing = false end
end)

-- ==========================================================
-- INIT
-- ==========================================================
buffer = splitLines([==[--- XCODE ---
local a = 1
if a == 1 then
    print("test0")
elseif a == 2 then
    print("test1")
else
    print("test2")
end
]==])
viewStart = 1

applyTheme()
renderWindow()
updateHint()

task.defer(function()
    settingsScroll.CanvasSize = UDim2.new(0, 0, 0, sLayout.AbsoluteContentSize.Y + 10)
    helpScroll.CanvasSize     = UDim2.new(0, 0, 0, hLayout.AbsoluteContentSize.Y + 10)
end)
showTab("editor")
