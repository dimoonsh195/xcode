-- ============================================================
-- Xcode v. 1.0.5 — Templates + RU localization + XYIELD
-- ============================================================
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

-- ============================================================
-- ТЕМА
-- ============================================================
local Theme = {
    Dark = {
        bg = Color3.fromRGB(30,30,30), header = Color3.fromRGB(25,25,25),
        editorBg = Color3.fromRGB(20,20,20), outputBg = Color3.fromRGB(15,15,15),
        text = Color3.fromRGB(220,220,220), lineNum = Color3.fromRGB(100,100,100),
        btn = Color3.fromRGB(50,50,50), btnText = Color3.fromRGB(220,220,220),
        accent = Color3.fromRGB(255,200,100),
    },
    Light = {
        bg = Color3.fromRGB(210,210,210), header = Color3.fromRGB(190,190,190),
        editorBg = Color3.fromRGB(235,235,235), outputBg = Color3.fromRGB(225,225,225),
        text = Color3.fromRGB(20,20,20), lineNum = Color3.fromRGB(110,110,110),
        btn = Color3.fromRGB(165,165,165), btnText = Color3.fromRGB(20,20,20),
        accent = Color3.fromRGB(180,90,0),
    }
}
local CurrentTheme = "Dark"
local FontColor = nil
local FontSize = 14
local Lang = "EN"

-- FORWARD DECLARATIONS (чтобы кнопки не крашились до объявления)
local showTab, refreshAllText, rebuildHelp, applyTheme, loadTemplate

local function T() return Theme[CurrentTheme] end
local function fontColor()
    if FontColor then return FontColor end
    return (CurrentTheme == "Dark") and Color3.fromRGB(220,220,220) or Color3.fromRGB(20,20,20)
end
local function lineHeight() return FontSize + 4 end

-- ============================================================
-- ЛОКАЛИЗАЦИЯ
-- ============================================================
local I18N = {
    EN = {
        title="Xcode", help="Help", settings="Settings", editor="Editor",
        templates="Templates", selectAll="Select All", save="Save",
        clearCode="Clear Code", clearOut="Clear Out", execute="Execute",
        output="OUTPUT (Roblox)", palette="PALETTE",
        themeBtn="Theme: Dark / Light",
        langBtn="Language: English / Русский",
        fcWhite="Font color: White", fcBlack="Font color: Black",
        fcGreen="Font color: Green", fcCyan="Font color: Cyan",
        fcDefault="Font color: Default",
        fontSize="Font size: cycle 12 / 14 / 16",
        fmtIndent="Format Indent (whole code)",
        dupLine="Duplicate Line", delLine="Delete Line",
        commentLine="Comment / Uncomment Line",
        upperAll="Uppercase (all)", lowerAll="Lowercase (all)",
        copyAll="Copy All to Clipboard", pasteClip="Paste from Clipboard",
        saveFile="Save File (writefile)", loadFile="Load File (readfile)",
        settingsActions="Actions",
        tplTitle="Templates — click to load into editor",
        tplCalc="Calculator (closable)",
        tplFly="Fly (E toggle) — closable",
        tplNoclip="Noclip — closable",
        tplInfJump="Infinite Jump — closable",
        tplESP="Simple ESP — closable",
        tplCheatMenu="Mini Cheat Menu (ESP/Noclip/InfJump)",
        tplXYIELD="XYIELD Console",
        tplLoreBook="Lore Book (all code words)",
        tplHello="Hello World",
        tplLoop="For Loop 1..10",
        tplRainbow="Rainbow Part",
        tplTween="Tween Animation",
        tplNotif="Notification",
        tplButton="Beautiful Button",
        tplMenu="Menu (3 buttons)",
        tplSpeed="Speed Boost",
        tplAntiAfk="Anti-AFK",
        tplTeleport="Teleport to Spawn",
        tplPartSpawner="Part Spawner",
        tplKillBrick="Kill Brick",
        tplInfiniteYield="Infinite Yield (console)",
        hintFmt="line %d/%d | indent %d | hint %s | in TextBox: %d",
        loaded="Loaded into editor: ",
        helpRows = {
            {"local", "declare a local variable"},
            {"function", "declare a function"},
            {"return", "return a value from a function"},
            {"if ... then", "if condition is true"},
            {"elseif ... then", "else if another condition"},
            {"else", "otherwise"},
            {"end", "closes if / for / while / function"},
            {"for i = 1, 10 do", "loop i from 1 to 10"},
            {"while cond do", "loop while condition is true"},
            {"break", "exit the loop"},
            {"and / or / not", "logical operators"},
            {"==", "equal to"},
            {"~=", "not equal to"},
            {"<", "less than"},
            {">", "greater than"},
            {"<=", "less or equal"},
            {">=", "greater or equal"},
            {"nil", "no value / empty"},
            {"true / false", "boolean values"},
            {"\"text\"", "string (in quotes)"},
            {"123", "number"},
            {"{ }", "table (list or dict)"},
            {"#table", "length of a table"},
            {"table[1]", "first element"},
            {"table.key", "element by name"},
            {"-- text", "single-line comment"},
            {"--[[ text ]]", "multi-line comment"},
            {"print(...)", "print to output"},
            {"warn(...)", "warning to output"},
            {"error(...)", "error to output"},
            {"game:GetService()", "get a Roblox service"},
            {"Instance.new()", "create a new object"},
            {"task.wait()", "wait (yield)"},
            {"task.spawn()", "run in a new thread"},
            {"Vector3.new()", "3D vector"},
            {"Color3.fromRGB()", "color from RGB"},
            {"UDim2.new()", "size / position"},
            {"CFrame.new()", "position + rotation"},
            {"Workspace", "the 3D world"},
            {"Players", "player service"},
            {"ReplicatedStorage", "shared storage"},
        },
    },
    RU = {
        title="Xcode", help="Справка", settings="Настройки", editor="Редактор",
        templates="Шаблоны", selectAll="Выделить всё", save="Сохранить",
        clearCode="Очистить код", clearOut="Очистить вывод", execute="Запустить",
        output="ВЫВОД (Roblox)", palette="ПАЛИТРА",
        themeBtn="Тема: Тёмная / Светлая",
        langBtn="Язык: English / Русский",
        fcWhite="Цвет шрифта: Белый", fcBlack="Цвет шрифта: Чёрный",
        fcGreen="Цвет шрифта: Зелёный", fcCyan="Цвет шрифта: Голубой",
        fcDefault="Цвет шрифта: По умолчанию",
        fontSize="Размер шрифта: 12 / 14 / 16",
        fmtIndent="Форматировать отступы (весь код)",
        dupLine="Дублировать строку", delLine="Удалить строку",
        commentLine="Закомментировать / Раскомментировать",
        upperAll="ВЕРХНИЙ РЕГИСТР (всё)", lowerAll="нижний регистр (всё)",
        copyAll="Копировать всё в буфер", pasteClip="Вставить из буфера",
        saveFile="Сохранить в файл (writefile)", loadFile="Загрузить из файла (readfile)",
        settingsActions="Действия",
        tplTitle="Шаблоны — клик вставит код в редактор",
        tplCalc="Калькулятор (закрывается)",
        tplFly="Полёт (E вкл/выкл) — закрывается",
        tplNoclip="Noclip — закрывается",
        tplInfJump="Бесконечный прыжок — закрывается",
        tplESP="Простой ESP — закрывается",
        tplCheatMenu="Мини чит-меню (ESP/Noclip/InfJump)",
        tplXYIELD="Консоль XYIELD",
        tplLoreBook="Книга знаний (все слова кода)",
        tplHello="Привет мир",
        tplLoop="Цикл For 1..10",
        tplRainbow="Радужный Part",
        tplTween="Tween анимация",
        tplNotif="Уведомление",
        tplButton="Красивая кнопка",
        tplMenu="Меню (3 кнопки)",
        tplSpeed="Ускорение",
        tplAntiAfk="Анти-АФК",
        tplTeleport="Телепорт на спавн",
        tplPartSpawner="Спавнер частей",
        tplKillBrick="Убийственный кирпич",
        tplInfiniteYield="Infinite Yield (консоль)",
        hintFmt="строка %d/%d | отступ %d | подсказка %s | в TextBox: %d",
        loaded="Загружено в редактор: ",
        helpRows = {
            {"local", "локальная переменная"},
            {"function", "объявить функцию"},
            {"return", "вернуть значение из функции"},
            {"if ... then", "если условие истинно"},
            {"elseif ... then", "иначе если другое условие"},
            {"else", "иначе"},
            {"end", "закрывает if / for / while / function"},
            {"for i = 1, 10 do", "цикл i от 1 до 10"},
            {"while cond do", "цикл пока условие истинно"},
            {"break", "выйти из цикла"},
            {"and / or / not", "логические операторы"},
            {"==", "равно"},
            {"~=", "не равно"},
            {"<", "меньше"},
            {">", "больше"},
            {"<=", "меньше или равно"},
            {">=", "больше или равно"},
            {"nil", "нет значения / пусто"},
            {"true / false", "логические значения"},
            {"\"текст\"", "строка (в кавычках)"},
            {"123", "число"},
            {"{ }", "таблица (список или словарь)"},
            {"#table", "длина таблицы"},
            {"table[1]", "первый элемент"},
            {"table.key", "элемент по имени"},
            {"-- текст", "однострочный комментарий"},
            {"--[[ текст ]]", "многострочный комментарий"},
            {"print(...)", "вывод в консоль"},
            {"warn(...)", "предупреждение в консоль"},
            {"error(...)", "ошибка в консоль"},
            {"game:GetService()", "получить сервис Roblox"},
            {"Instance.new()", "создать новый объект"},
            {"task.wait()", "подождать (задержка)"},
            {"task.spawn()", "запустить в новом потоке"},
            {"Vector3.new()", "3D-вектор"},
            {"Color3.fromRGB()", "цвет из RGB"},
            {"UDim2.new()", "размер / позиция"},
            {"CFrame.new()", "позиция + поворот"},
            {"Workspace", "3D-мир"},
            {"Players", "сервис игроков"},
            {"ReplicatedStorage", "общее хранилище"},
        },
    },
}
local function L(k) return I18N[Lang][k] or k end

-- ============================================================
-- КОРЕНЬ GUI
-- ============================================================
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

local btnHelp      = makeHeaderBtn("?", -70, 54)
local btnSettings  = makeHeaderBtn("?", -132, 62)
local btnTemplates = makeHeaderBtn("?", -202, 62)
local btnEditor    = makeHeaderBtn("?", -272, 58)
local btnSelectAll = makeHeaderBtn("?", -340, 76)
local btnSave      = makeHeaderBtn("?", -408, 54)
local btnClearCode = makeHeaderBtn("?", -496, 80)
local btnClearOut  = makeHeaderBtn("?", -584, 80)
local btnExecute   = makeHeaderBtn("?", -646, 54)

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -84)
contentFrame.Position = UDim2.new(0, 10, 0, 37)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = xWin

-- ============================================================
-- EDITOR TAB
-- ============================================================
local tabEditor = Instance.new("Frame")
tabEditor.Size = UDim2.new(1, 0, 1, 0)
tabEditor.BackgroundTransparency = 1
tabEditor.Visible = true
tabEditor.Parent = contentFrame

local editorContainer = Instance.new("Frame")
editorContainer.Size = UDim2.new(0.6, -5, 1, 0)
editorContainer.BackgroundColor3 = T().editorBg
editorContainer.BorderSizePixel = 0
editorContainer.Parent = tabEditor
Instance.new("UICorner", editorContainer).CornerRadius = UDim.new(0, 4)

local editorScroll = Instance.new("ScrollingFrame")
editorScroll.Size = UDim2.new(1, 0, 1, 0)
editorScroll.BackgroundTransparency = 1
editorScroll.BorderSizePixel = 0
editorScroll.ScrollBarThickness = 8
editorScroll.ScrollBarImageColor3 = Color3.fromRGB(80,80,80)
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
codeBox.TextWrapped = false
codeBox.Position = UDim2.new(0, 40, 0, 0)
codeBox.Size = UDim2.new(1, -40, 0, 0)
codeBox.Parent = editorScroll

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
outputLabel.Text = L("output")
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
outputScroll.ScrollBarImageColor3 = Color3.fromRGB(80,80,80)
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

-- ============================================================
-- SETTINGS / HELP / TEMPLATES TABS
-- ============================================================
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

local tabTemplates = Instance.new("Frame")
tabTemplates.Size = UDim2.new(1, 0, 1, 0)
tabTemplates.BackgroundColor3 = T().bg
tabTemplates.BorderSizePixel = 0
tabTemplates.Visible = false
tabTemplates.Parent = contentFrame
Instance.new("UICorner", tabTemplates).CornerRadius = UDim.new(0, 4)

local tplTitle = Instance.new("TextLabel")
tplTitle.Size = UDim2.new(1, -20, 0, 20)
tplTitle.Position = UDim2.new(0, 10, 0, 6)
tplTitle.BackgroundTransparency = 1
tplTitle.Text = L("tplTitle")
tplTitle.TextColor3 = T().accent
tplTitle.Font = Enum.Font.Code
tplTitle.TextSize = 12
tplTitle.TextXAlignment = Enum.TextXAlignment.Left
tplTitle.Parent = tabTemplates

local tplScroll = Instance.new("ScrollingFrame")
tplScroll.Size = UDim2.new(1, -20, 1, -34)
tplScroll.Position = UDim2.new(0, 10, 0, 28)
tplScroll.BackgroundTransparency = 1
tplScroll.BorderSizePixel = 0
tplScroll.ScrollBarThickness = 6
tplScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
tplScroll.Parent = tabTemplates
local tplLayout = Instance.new("UIListLayout", tplScroll)
tplLayout.Padding = UDim.new(0, 4)

-- HINT BAR
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

-- ============================================================
-- BUFFER STATE + EDITOR LOGIC
-- ============================================================
local WINDOW_LINES = 300
local buffer = {""}
local viewStart = 1
local viewEnd = 1
local suppress = false

local function splitLines(s)
    local out = {}
    for line in (s .. "\n"):gmatch("([^\n]*)\n") do out[#out + 1] = line end
    if #out == 0 then out[1] = "" end
    return out
end
local function bufferText() return table.concat(buffer, "\n") end
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
    for i = viewStart, viewEnd do nums[#nums + 1] = tostring(i) end
    lineNumbers.Text = table.concat(nums, "\n")
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
    for i = viewStart, viewEnd do lines[#lines + 1] = buffer[i] or "" end
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
    for i = viewStart, viewEnd do oldLines[#oldLines + 1] = buffer[i] or "" end
    local firstDiff = 1
    local minLen = math.min(#newLines, #oldLines)
    while firstDiff <= minLen and newLines[firstDiff] == oldLines[firstDiff] do
        firstDiff = firstDiff + 1
    end
    if firstDiff > #newLines and firstDiff > #oldLines then return end
    local lastNew = #newLines
    local lastOld = #oldLines
    while lastOld >= firstDiff and lastNew >= firstDiff
          and newLines[lastNew] == oldLines[lastOld] do
        lastNew = lastNew - 1
        lastOld = lastOld - 1
    end
    local prefixEnd = viewStart + firstDiff - 2
    local suffixStart = viewStart + lastOld
    local newBuffer = {}
    for i = 1, math.min(prefixEnd, #buffer) do newBuffer[#newBuffer + 1] = buffer[i] end
    for i = firstDiff, lastNew do newBuffer[#newBuffer + 1] = newLines[i] end
    for i = suffixStart, #buffer do newBuffer[#newBuffer + 1] = buffer[i] end
    if #newBuffer == 0 then newBuffer[1] = "" end
    buffer = newBuffer
    viewEnd = math.min(#buffer, math.max(viewEnd, viewStart + #newLines - 1))
    updateEditorLayout()
end

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
        editorScroll.CanvasPosition = Vector2.new(editorScroll.CanvasPosition.X, math.max(0, cursorY - lh * 2))
    elseif cursorY + lh > viewTop + viewH - lh then
        editorScroll.CanvasPosition = Vector2.new(editorScroll.CanvasPosition.X, math.max(0, cursorY - viewH + lh * 3))
    end
end

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
    elseif trimmed:match("^end") or trimmed:match("^else") or trimmed:match("^elseif") or trimmed:match("^until") then label = "-4"
    elseif trimmed:match("then%s*$") or trimmed:match("^do%s*$") or trimmed:match("do%s*$") or trimmed:match("function%s*%(") then label = "+4 (end)"
    elseif trimmed:match("repeat%s*$") or trimmed:match("{%s*$") then label = "+4"
    end
    local bufLine = getBufferCursorLine()
    hintLabel.Text = string.format(L("hintFmt"), bufLine, #buffer, indent, label, #text)
end

codeBox:GetPropertyChangedSignal("Text"):Connect(function()
    if suppress then return end
    syncEditToBuffer(); updateHint(); keepCursorVisible()
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

-- ============================================================
-- LOG → OUTPUT
-- ============================================================
local logConnection = LogService.MessageOut:Connect(function(message, messageType)
    if not outputScroll or not outputScroll.Parent then
        if logConnection then logConnection:Disconnect() end
        return
    end
    local color = fontColor()
    local prefix = "[OUT]"
    if messageType == Enum.MessageType.MessageError then        color = Color3.fromRGB(255,100,100); prefix = "[ERR]"
    elseif messageType == Enum.MessageType.MessageWarning then
        color = Color3.fromRGB(255,200,100); prefix = "[WARN]"
    elseif messageType == Enum.MessageType.MessageInfo then
        color = Color3.fromRGB(150,150,255); prefix = "[INFO]"
    end
    addOutput(prefix .. " " .. tostring(message), color)
end)

-- ============================================================
-- SETTINGS BUTTONS
-- ============================================================
local function makeSettingBtn(key, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 28)
    b.BackgroundColor3 = T().btn
    b.Text = "  " .. L(key)
    b.TextColor3 = T().btnText
    b.Font = Enum.Font.Code
    b.TextSize = 12
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.BorderSizePixel = 0
    b.Parent = settingsScroll
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.MouseButton1Click:Connect(callback)
    b:SetAttribute("I18NKey", key)
    return b
end

local actionsHeader = Instance.new("TextLabel")
actionsHeader.Size = UDim2.new(1, -20, 0, 20)
actionsHeader.BackgroundTransparency = 1
actionsHeader.Text = "  " .. L("settingsActions")
actionsHeader.TextColor3 = T().accent
actionsHeader.Font = Enum.Font.Code
actionsHeader.TextSize = 12
actionsHeader.TextXAlignment = Enum.TextXAlignment.Left
actionsHeader.Parent = settingsScroll
actionsHeader:SetAttribute("I18NKey", "settingsActions")

makeSettingBtn("help", function() showTab("help") end)
makeSettingBtn("templates", function() showTab("templates") end)
makeSettingBtn("save", function()
    if type(writefile) == "function" then
        local ok, err = pcall(function() writefile("Xcode_Script.lua", bufferText()) end)
        if not ok then addOutput("Save error: " .. tostring(err), Color3.fromRGB(255,100,100)) end
    end
end)
makeSettingBtn("themeBtn", function()
    CurrentTheme = (CurrentTheme == "Dark") and "Light" or "Dark"
    FontColor = nil
    applyTheme()
end)
makeSettingBtn("langBtn", function()
    Lang = (Lang == "RU") and "EN" or "RU"
    refreshAllText()
end)
makeSettingBtn("fcWhite",   function() FontColor = Color3.fromRGB(255,255,255); applyTheme() end)
makeSettingBtn("fcBlack",   function() FontColor = Color3.fromRGB(0,0,0); applyTheme() end)
makeSettingBtn("fcGreen",   function() FontColor = Color3.fromRGB(120,255,120); applyTheme() end)
makeSettingBtn("fcCyan",    function() FontColor = Color3.fromRGB(120,220,255); applyTheme() end)
makeSettingBtn("fcDefault", function() FontColor = nil; applyTheme() end)
makeSettingBtn("fontSize", function()
    FontSize = (FontSize == 12) and 14 or ((FontSize == 14) and 16 or 12)
    applyTheme()
end)
makeSettingBtn("fmtIndent", function()
    local INDENT = "    "
    local lvl = 0
    local out = {}
    for _, line in ipairs(buffer) do
        local trimmed = line:match("^%s*(.-)%s*$")
        if trimmed:match("^end") or trimmed:match("^else") or trimmed:match("^elseif") or trimmed:match("^until") then
            lvl = math.max(0, lvl - 1)
        end
        table.insert(out, trimmed ~= "" and (string.rep(INDENT, lvl) .. trimmed) or "")
        if trimmed:match("then%s*$") or trimmed:match("do%s*$") or trimmed:match("function%s*%(") or trimmed:match("repeat%s*$") then
            lvl = lvl + 1
        end
    end
    if #out == 0 then out = {""} end
    buffer = out; renderWindow(); updateHint()
end)
makeSettingBtn("dupLine", function()
    local cursor = codeBox.CursorPosition or 1
    local text = codeBox.Text
    local lineStart = (text:sub(1, cursor - 1):find("\n[^\n]*$") or 0)
    local lineEnd = (text:find("\n", cursor) or (#text + 1))
    local line = text:sub(lineStart + 1, lineEnd - 1)
    codeBox.Text = text:sub(1, lineEnd) .. "\n" .. line .. text:sub(lineEnd + 1)
end)
makeSettingBtn("delLine", function()
    local cursor = codeBox.CursorPosition or 1
    local text = codeBox.Text
    local lineStart = (text:sub(1, cursor - 1):find("\n[^\n]*$") or 0) + 1
    local lineEnd = (text:find("\n", cursor) or (#text + 1)) - 1
    local removeEnd = (text:sub(lineEnd + 1, lineEnd + 1) == "\n") and lineEnd + 1 or lineEnd
    codeBox.Text = text:sub(1, lineStart - 1) .. text:sub(removeEnd + 1)
end)
makeSettingBtn("commentLine", function()
    local cursor = codeBox.CursorPosition or 1
    local text = codeBox.Text
    local lineStart = (text:sub(1, cursor - 1):find("\n[^\n]*$") or 0) + 1
    local lineEnd = (text:find("\n", cursor) or (#text + 1)) - 1
    local line = text:sub(lineStart, lineEnd)
    if line:match("^%s*%-%-") then
        codeBox.Text = text:sub(1, lineStart - 1) .. line:gsub("^(%s*)%-%-%s?", "%1", 1) .. text:sub(lineEnd + 1)
    else
        codeBox.Text = text:sub(1, lineStart - 1) .. line:gsub("^(%s*)", "%1-- ", 1) .. text:sub(lineEnd + 1)
    end
end)
makeSettingBtn("upperAll", function()
    for i = 1, #buffer do buffer[i] = buffer[i]:upper() end
    renderWindow()
end)
makeSettingBtn("lowerAll", function()
    for i = 1, #buffer do buffer[i] = buffer[i]:lower() end
    renderWindow()
end)
makeSettingBtn("copyAll", function()
    if setclipboard then setclipboard(bufferText()) end
end)
makeSettingBtn("pasteClip", function()
    if not getclipboard then return end
    local data = getclipboard()
    if not data or data == "" then return end
    local cursor = codeBox.CursorPosition or #codeBox.Text + 1
    codeBox.Text = codeBox.Text:sub(1, cursor - 1) .. data .. codeBox.Text:sub(cursor)
end)
makeSettingBtn("saveFile", function()
    if type(writefile) == "function" then pcall(writefile, "Xcode_Script.lua", bufferText()) end
end)
makeSettingBtn("loadFile", function()
    if type(readfile) == "function" then
        local ok, data = pcall(readfile, "Xcode_Script.lua")
        if ok and data then
            buffer = splitLines(data); viewStart = 1
            renderWindow(); updateHint()
        end
    end
end)

-- ============================================================
-- HELP RENDER
-- ============================================================
rebuildHelp = function()
    for _, c in ipairs(helpScroll:GetChildren()) do c:Destroy() end
    for _, pair in ipairs(I18N[Lang].helpRows) do
        local row = Instance.new("TextLabel")
        row.Size = UDim2.new(1, -20, 0, 20)
        row.BackgroundTransparency = 1
        row.Text = "  " .. pair[1] .. " — " .. pair[2]
        row.TextColor3 = fontColor()
        row.Font = Enum.Font.Code
        row.TextSize = 12
        row.TextXAlignment = Enum.TextXAlignment.Left
        row.Parent = helpScroll
    end
end

-- ============================================================
-- ШАБЛОНЫ (TEMPLATES) — [==[ и ]==] для защиты от ]] внутри
-- ============================================================
local Templates = {
    tplCalc = [==[
-- Calculator (closable)
local sg = Instance.new("ScreenGui")
sg.Name = "CalcGui"
sg.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
sg.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(220, 280)
frame.Position = UDim2.new(0.5, -110, 0.5, -140)
frame.BackgroundColor3 = Color3.fromRGB(35,35,40)
frame.BorderSizePixel = 0
frame.Parent = sg
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(24, 24)
close.Position = UDim2.new(1, -28, 0, 4)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200,60,60)
close.TextColor3 = Color3.new(1,1,1)
close.Font = Enum.Font.GothamBold
close.Parent = frame
close.MouseButton1Click:Connect(function() sg:Destroy() end)

local display = Instance.new("TextBox")
display.Size = UDim2.new(1, -20, 0, 40)
display.Position = UDim2.new(0, 10, 0, 36)
display.BackgroundColor3 = Color3.fromRGB(20,20,24)
display.TextColor3 = Color3.new(1,1,1)
display.Font = Enum.Font.Code
display.TextSize = 20
display.Text = "0"
display.ClearTextOnFocus = false
display.Parent = frame

local buttons = {"7","8","9","/","4","5","6","*","1","2","3","-","0",".","=","+"}
for i, label in ipairs(buttons) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(46, 40)
    b.Position = UDim2.new(0, 10 + ((i-1)%4)*50, 0, 86 + math.floor((i-1)/4)*46)
    b.BackgroundColor3 = Color3.fromRGB(60,60,70)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 16
    b.Text = label
    b.Parent = frame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function()
        if label == "=" then
            local ok, res = pcall(function() return loadstring("return "..display.Text)() end)
            display.Text = ok and tostring(res) or "Error"
        else
            if display.Text == "0" then display.Text = label else display.Text = display.Text .. label end
        end
    end)
end
]==],

    tplFly = [==[
-- Fly (E toggle) — closable
local sg = Instance.new("ScreenGui")
sg.Name = "FlyGui"
sg.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
sg.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(180, 60)
frame.Position = UDim2.new(0.5, -90, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(30,30,35)
frame.BorderSizePixel = 0
frame.Parent = sg
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(20, 20)
close.Position = UDim2.new(1, -24, 0, 4)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200,60,60)
close.TextColor3 = Color3.new(1,1,1)
close.Font = Enum.Font.GothamBold
close.Parent = frame
close.MouseButton1Click:Connect(function() sg:Destroy() end)

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -10, 1, 0)
label.Position = UDim2.new(0, 5, 0, 0)
label.BackgroundTransparency = 1
label.Text = "Fly: OFF (press E)"
label.TextColor3 = Color3.new(1,1,1)
label.Font = Enum.Font.Gotham
label.TextSize = 14
label.Parent = frame

local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local flying = false
local speed = 60
local bodyVel, bodyGyro

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.E then
        flying = not flying
        label.Text = "Fly: " .. (flying and "ON" or "OFF") .. " (press E)"
        if flying then
            bodyVel = Instance.new("BodyVelocity", hrp)
            bodyVel.Velocity = Vector3.new(0,0,0)
            bodyVel.MaxForce = Vector3.new(1e5,1e5,1e5)
            bodyGyro = Instance.new("BodyGyro", hrp)
            bodyGyro.P = 1e4
            bodyGyro.MaxTorque = Vector3.new(1e5,1e5,1e5)
        else
            if bodyVel then bodyVel:Destroy() end
            if bodyGyro then bodyGyro:Destroy() end
        end
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if flying and bodyVel then
        local cam = workspace.CurrentCamera
        local move = Vector3.new()
        if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end
        bodyVel.Velocity = move.Unit * speed
    end
end)
]==],

    tplNoclip = [==[
-- Noclip — closable
local sg = Instance.new("ScreenGui")
sg.Name = "NoclipGui"
sg.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
sg.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(160, 50)
frame.Position = UDim2.new(0.5, -80, 0, 90)
frame.BackgroundColor3 = Color3.fromRGB(30,30,35)
frame.BorderSizePixel = 0
frame.Parent = sg
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(20, 20)
close.Position = UDim2.new(1, -24, 0, 4)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200,60,60)
close.TextColor3 = Color3.new(1,1,1)
close.Font = Enum.Font.GothamBold
close.Parent = frame
close.MouseButton1Click:Connect(function() sg:Destroy() end)

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -10, 1, 0)
label.Position = UDim2.new(0, 5, 0, 0)
label.BackgroundTransparency = 1
label.Text = "Noclip: ON"
label.TextColor3 = Color3.new(1,1,1)
label.Font = Enum.Font.Gotham
label.TextSize = 14
label.Parent = frame

local player = game.Players.LocalPlayer
local noclip = true
game:GetService("RunService").Stepped:Connect(function()
    if noclip and player.Character then
        for _, p in ipairs(player.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)
]==],

    tplInfJump = [==[
-- Infinite Jump — closable
local sg = Instance.new("ScreenGui")
sg.Name = "InfJumpGui"
sg.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
sg.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(180, 50)
frame.Position = UDim2.new(0.5, -90, 0, 150)
frame.BackgroundColor3 = Color3.fromRGB(30,30,35)
frame.BorderSizePixel = 0
frame.Parent = sg
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(20, 20)
close.Position = UDim2.new(1, -24, 0, 4)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200,60,60)
close.TextColor3 = Color3.new(1,1,1)
close.Font = Enum.Font.GothamBold
close.Parent = frame
close.MouseButton1Click:Connect(function() sg:Destroy() end)

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -10, 1, 0)
label.Position = UDim2.new(0, 5, 0, 0)
label.BackgroundTransparency = 1
label.Text = "InfJump: ON"
label.TextColor3 = Color3.new(1,1,1)
label.Font = Enum.Font.Gotham
label.TextSize = 14
label.Parent = frame

local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
UIS.JumpRequest:Connect(function()
    hum:ChangeState(Enum.HumanoidStateType.Jumping)
end)
]==],

    tplESP = [==[
-- Simple ESP — closable
local sg = Instance.new("ScreenGui")
sg.Name = "ESPGui"
sg.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
sg.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(160, 50)
frame.Position = UDim2.new(0.5, -80, 0, 210)
frame.BackgroundColor3 = Color3.fromRGB(30,30,35)
frame.BorderSizePixel = 0
frame.Parent = sg
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(20, 20)
close.Position = UDim2.new(1, -24, 0, 4)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200,60,60)
close.TextColor3 = Color3.new(1,1,1)
close.Font = Enum.Font.GothamBold
close.Parent = frame
close.MouseButton1Click:Connect(function() sg:Destroy() end)

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -10, 1, 0)
label.Position = UDim2.new(0, 5, 0, 0)
label.BackgroundTransparency = 1
label.Text = "ESP: ON"
label.TextColor3 = Color3.new(1,1,1)
label.Font = Enum.Font.Gotham
label.TextSize = 14
label.Parent = frame

local player = game.Players.LocalPlayer
local function addESP(plr)
    if plr == player then return end
    local function make()
        local hl = Instance.new("Highlight")
        hl.Name = "ESP_" .. plr.Name
        hl.Parent = plr.Character
        hl.FillColor = Color3.fromRGB(255,60,60)
        hl.OutlineColor = Color3.fromRGB(255,255,255)
        hl.FillTransparency = 0.6
    end
    if plr.Character then make() end
    plr.CharacterAdded:Connect(make)
end
for _, p in ipairs(game.Players:GetPlayers()) do addESP(p) end
game.Players.PlayerAdded:Connect(addESP)
]==],

    tplCheatMenu = [==[
-- Mini Cheat Menu (ESP / Noclip / InfJump)
local sg = Instance.new("ScreenGui")
sg.Name = "CheatMenuGui"
sg.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
sg.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(200, 200)
frame.Position = UDim2.new(0.5, -100, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(35,35,40)
frame.BorderSizePixel = 0
frame.Parent = sg
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(24, 24)
close.Position = UDim2.new(1, -28, 0, 4)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200,60,60)
close.TextColor3 = Color3.new(1,1,1)
close.Font = Enum.Font.GothamBold
close.Parent = frame
close.MouseButton1Click:Connect(function() sg:Destroy() end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Cheat Menu"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 6)
list.Parent = frame
Instance.new("UIPadding", frame).PaddingTop = UDim.new(0, 40)

local function makeBtn(text, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 32)
    b.BackgroundColor3 = Color3.fromRGB(60,60,70)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.Text = text
    b.Parent = frame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(cb)
end

makeBtn("Toggle ESP", function()
    local player = game.Players.LocalPlayer
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character then
            local old = p.Character:FindFirstChild("ESP_" .. p.Name)
            if old then old:Destroy() else
                local hl = Instance.new("Highlight")
                hl.Name = "ESP_" .. p.Name
                hl.Parent = p.Character
                hl.FillColor = Color3.fromRGB(255,60,60)
                hl.FillTransparency = 0.6
            end
        end
    end
end)

makeBtn("Toggle Noclip", function()
    local player = game.Players.LocalPlayer
    if player.Character then
        for _, p in ipairs(player.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = not p.CanCollide end
        end
    end
end)

makeBtn("Infinite Jump", function()
    local UIS = game:GetService("UserInputService")
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    UIS.JumpRequest:Connect(function()
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end)
end)
]==],

    tplXYIELD = [==[
-- XYIELD Console
local sg = Instance.new("ScreenGui")
sg.Name = "XYIELD"
sg.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
sg.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(360, 280)
frame.Position = UDim2.new(0.5, -180, 0.5, -140)
frame.BackgroundColor3 = Color3.fromRGB(20,20,24)
frame.BorderSizePixel = 0
frame.Parent = sg
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(24, 24)
close.Position = UDim2.new(1, -28, 0, 4)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200,60,60)
close.TextColor3 = Color3.new(1,1,1)
close.Font = Enum.Font.GothamBold
close.Parent = frame
close.MouseButton1Click:Connect(function() sg:Destroy() end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 28)
title.BackgroundTransparency = 1
title.Text = "XYIELD"
title.TextColor3 = Color3.fromRGB(255,200,100)
title.Font = Enum.Font.Code
title.TextSize = 18
title.Parent = frame

local log = Instance.new("ScrollingFrame")
log.Size = UDim2.new(1, -20, 1, -90)
log.Position = UDim2.new(0, 10, 0, 32)
log.BackgroundColor3 = Color3.fromRGB(15,15,18)
log.BorderSizePixel = 0
log.ScrollBarThickness = 6
log.CanvasSize = UDim2.new(0,0,0,0)
log.Parent = frame
Instance.new("UICorner", log).CornerRadius = UDim.new(0, 6)

local logLayout = Instance.new("UIListLayout", log)
logLayout.Padding = UDim.new(0, 2)

local function logMsg(txt)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -6, 0, 18)
    l.BackgroundTransparency = 1
    l.Text = "> " .. txt
    l.TextColor3 = Color3.fromRGB(180,255,180)
    l.Font = Enum.Font.Code
    l.TextSize = 13
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = log
    log.CanvasSize = UDim2.new(0,0,0, logLayout.AbsoluteContentSize.Y + 10)
    log.CanvasPosition = Vector2.new(0, log.CanvasSize.Y.Offset)
end

local input = Instance.new("TextBox")
input.Size = UDim2.new(1, -20, 0, 32)
input.Position = UDim2.new(0, 10, 1, -38)
input.BackgroundColor3 = Color3.fromRGB(40,40,48)
input.TextColor3 = Color3.new(1,1,1)
input.PlaceholderText = "enter command..."
input.Font = Enum.Font.Code
input.TextSize = 14
input.ClearTextOnFocus = false
input.Parent = frame
Instance.new("UICorner", input).CornerRadius = UDim.new(0, 6)

local commands = {
    esp = function()
        local player = game.Players.LocalPlayer
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character then
                local old = p.Character:FindFirstChild("ESP_" .. p.Name)
                if old then old:Destroy() else
                    local hl = Instance.new("Highlight")
                    hl.Name = "ESP_" .. p.Name
                    hl.Parent = p.Character
                    hl.FillColor = Color3.fromRGB(255,60,60)
                    hl.FillTransparency = 0.6
                end
            end
        end
        return "ESP toggled"
    end,
    noclip = function()
        local player = game.Players.LocalPlayer
        if player.Character then
            for _, p in ipairs(player.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = not p.CanCollide end
            end
        end
        return "Noclip toggled"
    end,
    infjump = function()
        local UIS = game:GetService("UserInputService")
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local hum = char:WaitForChild("Humanoid")
        UIS.JumpRequest:Connect(function()
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
        return "Infinite jump enabled"
    end,
    speed = function()
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 80
        end
        return "Speed set to 80"
    end,
}

input.FocusLost:Connect(function(enter)
    if not enter then return end
    local cmd = input.Text:lower():gsub("%s+", "")
    input.Text = ""
    if commands[cmd] then
        logMsg(commands[cmd]())
    else
        logMsg("unknown command: " .. cmd)
    end
end)

logMsg("XYIELD ready. Commands: esp, noclip, infjump, speed")
]==],

    tplLoreBook = [==[
-- Lore Book: all code words
local sg = Instance.new("ScreenGui")
sg.Name = "LoreBookGui"
sg.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
sg.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(420, 340)
frame.Position = UDim2.new(0.5, -210, 0.5, -170)
frame.BackgroundColor3 = Color3.fromRGB(25,25,30)
frame.BorderSizePixel = 0
frame.Parent = sg
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(24, 24)
close.Position = UDim2.new(1, -28, 0, 4)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200,60,60)
close.TextColor3 = Color3.new(1,1,1)
close.Font = Enum.Font.GothamBold
close.Parent = frame
close.MouseButton1Click:Connect(function() sg:Destroy() end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 26)
title.BackgroundTransparency = 1
title.Text = "Lore Book — code words"
title.TextColor3 = Color3.fromRGB(255,200,100)
title.Font = Enum.Font.Code
title.TextSize = 16
title.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -40)
scroll.Position = UDim2.new(0, 10, 0, 30)
scroll.BackgroundColor3 = Color3.fromRGB(15,15,18)
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 6
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.Parent = frame
Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 6)

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 2)

local words = {
    {"local", "declare a local variable"},
    {"function", "declare a function"},
    {"return", "return a value"},
    {"if ... then", "if condition"},
    {"elseif ... then", "else if"},
    {"else", "otherwise"},
    {"end", "closes block"},
    {"for i = 1, 10 do", "loop 1..10"},
    {"while cond do", "loop while"},
    {"break", "exit loop"},
    {"and / or / not", "logical operators"},
    {"==", "equal"},
    {"~=", "not equal"},
    {"<", "less than"},
    {">", "greater than"},
    {"<=", "less or equal"},
    {">=", "greater or equal"},
    {"nil", "no value"},
    {"true / false", "boolean"},
    {"\"text\"", "string"},
    {"123", "number"},
    {"{ }", "table"},
    {"#table", "length"},
    {"table[1]", "first element"},
    {"table.key", "by name"},
    {"-- text", "comment"},
    {"--[[ text ]]", "multi-line comment"},
    {"print(...)", "print to output"},
    {"warn(...)", "warning"},
    {"error(...)", "error"},
    {"game:GetService()", "get service"},
    {"Instance.new()", "new object"},
    {"task.wait()", "wait"},
    {"task.spawn()", "new thread"},
    {"Vector3.new()", "3D vector"},
    {"Color3.fromRGB()", "color"},
    {"UDim2.new()", "size/position"},
    {"CFrame.new()", "position+rotation"},
    {"Workspace", "3D world"},
    {"Players", "player service"},
    {"ReplicatedStorage", "shared storage"},
}
for _, w in ipairs(words) do
    local row = Instance.new("TextLabel")
    row.Size = UDim2.new(1, -6, 0, 18)
    row.BackgroundTransparency = 1
    row.Text = "  " .. w[1] .. "  —  " .. w[2]
    row.TextColor3 = Color3.fromRGB(200,200,200)
    row.Font = Enum.Font.Code
    row.TextSize = 12
    row.TextXAlignment = Enum.TextXAlignment.Left
    row.Parent = scroll
end
scroll.CanvasSize = UDim2.new(0,0,0, layout.AbsoluteContentSize.Y + 10)
]==],

    tplHello = [==[print("Hello, world!")]==],
    tplLoop = [==[for i = 1, 10 do print("i = " .. i) task.wait(1) end]==],
    tplRainbow = [==[
local part = Instance.new("Part")
part.Parent = workspace
part.Size = Vector3.new(4,1,4)
part.Position = Vector3.new(0,5,0)
part.Anchored = true
game:GetService("RunService").Heartbeat:Connect(function()
    part.Color = Color3.fromHSV(tick() % 1, 1, 1)
end)
]==],
    tplTween = [==[
local obj = Instance.new("Part")
obj.Parent = workspace
obj.Position = Vector3.new(0,5,0)
obj.Anchored = true
local ts = game:GetService("TweenService")
local info = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
ts:Create(obj, info, {Position = Vector3.new(0,20,0)}):Play()
]==],
    tplNotif = [==[
local sg = Instance.new("ScreenGui")
sg.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local n = Instance.new("TextLabel")
n.Size = UDim2.fromOffset(280,60)
n.Position = UDim2.new(1,-300,0,40)
n.BackgroundColor3 = Color3.fromRGB(40,50,70)
n.TextColor3 = Color3.new(1,1,1)
n.Font = Enum.Font.GothamBold
n.TextSize = 15
n.Text = "Notification"
n.Parent = sg
Instance.new("UICorner", n).CornerRadius = UDim.new(0,10)
task.wait(3)
n:Destroy()
]==],
    tplButton = [==[
local sg = Instance.new("ScreenGui")
sg.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local btn = Instance.new("TextButton")
btn.Size = UDim2.fromOffset(220,64)
btn.Position = UDim2.new(0.5,-110,0.5,-32)
btn.BackgroundColor3 = Color3.fromRGB(220,60,60)
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 18
btn.Text = "Click Me"
btn.Parent = sg
Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)
btn.MouseButton1Click:Connect(function() print("clicked!") end)
]==],
    tplMenu = [==[
local sg = Instance.new("ScreenGui")
sg.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(280,200)
frame.Position = UDim2.new(0.5,-140,0.5,-100)
frame.BackgroundColor3 = Color3.fromRGB(35,35,40)
frame.Parent = sg
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)
local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0,6)
list.Parent = frame
Instance.new("UIPadding", frame).PaddingTop = UDim.new(0,50)
for i=1,3 do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-20,0,36)
    b.BackgroundColor3 = Color3.fromRGB(60,60,70)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 15
    b.Text = "Option " .. i
    b.Parent = frame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    b.MouseButton1Click:Connect(function() print("click " .. i) end)
end
]==],
    tplSpeed = [==[
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
char:WaitForChild("Humanoid").WalkSpeed = 80
]==],
    tplAntiAfk = [==[
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)
]==],
    tplTeleport = [==[
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
char:MoveTo(workspace.SpawnLocation.Position + Vector3.new(0,5,0))
]==],
    tplPartSpawner = [==[
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
mouse.Button1Down:Connect(function()
    local part = Instance.new("Part")
    part.Size = Vector3.new(2,2,2)
    part.Position = mouse.Hit.Position + Vector3.new(0,2,0)
    part.Anchored = true
    part.Parent = workspace
end)
]==],
    tplKillBrick = [==[
local part = Instance.new("Part")
part.Size = Vector3.new(4,1,4)
part.Position = Vector3.new(0,0.5,0)
part.Anchored = true
part.Parent = workspace
part.Touched:Connect(function(hit)
    local hum = hit.Parent and hit.Parent:FindFirstChild("Humanoid")
    if hum then hum.Health = 0 end
end)
]==],
    tplInfiniteYield = [==[
-- Infinite Yield style console (simplified)
local sg = Instance.new("ScreenGui")
sg.Name = "IY"
sg.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(400,300)
frame.Position = UDim2.new(0.5,-200,0.5,-150)
frame.BackgroundColor3 = Color3.fromRGB(20,20,24)
frame.Parent = sg
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)
local input = Instance.new("TextBox")
input.Size = UDim2.new(1,-20,0,30)
input.Position = UDim2.new(0,10,0,10)
input.BackgroundColor3 = Color3.fromRGB(40,40,48)
input.TextColor3 = Color3.new(1,1,1)
input.PlaceholderText = "command..."
input.Font = Enum.Font.Code
input.Parent = frame
Instance.new("UICorner", input).CornerRadius = UDim.new(0,6)
local output = Instance.new("TextLabel")
output.Size = UDim2.new(1,-20,1,-50)
output.Position = UDim2.new(0,10,0,45)
output.BackgroundTransparency = 1
output.TextColor3 = Color3.fromRGB(180,255,180)
output.Font = Enum.Font.Code
output.TextSize = 13
output.TextXAlignment = Enum.TextXAlignment.Left
output.TextYAlignment = Enum.TextYAlignment.Top
output.Text = "IY console ready"
output.Parent = frame
input.FocusLost:Connect(function(enter)
    if not enter then return end
    local cmd = input.Text:lower()
    input.Text = ""
    output.Text = "> " .. cmd
    if cmd == "help" then output.Text = "commands: help, esp, noclip, speed"
    elseif cmd == "esp" then
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character then
                local hl = Instance.new("Highlight")
                hl.Parent = p.Character
            end
        end
        output.Text = "ESP on"
    elseif cmd == "noclip" then
        local char = game.Players.LocalPlayer.Character
        if char then for _, p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
        output.Text = "Noclip on"
    elseif cmd == "speed" then
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = 80 end
        output.Text = "Speed 80"
    end
end)
]==],
}

loadTemplate = function(key)
    local code = Templates[key]
    if not code then return end
    buffer = splitLines(code)
    viewStart = 1
    renderWindow()
    updateHint()
    addOutput(L("loaded") .. L(key), Color3.fromRGB(180,220,180))
    showTab("editor")
end

local tplButtons = {}
for key, _ in pairs(Templates) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -6, 0, 30)
    b.BackgroundColor3 = T().btn
    b.Text = "  " .. L(key)
    b.TextColor3 = T().btnText
    b.Font = Enum.Font.Code
    b.TextSize = 12
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.BorderSizePixel = 0
    b.Parent = tplScroll
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.MouseButton1Click:Connect(function() loadTemplate(key) end)
    b:SetAttribute("I18NKey", key)
    tplButtons[#tplButtons + 1] = b
end

tplLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    tplScroll.CanvasSize = UDim2.new(0, 0, 0, tplLayout.AbsoluteContentSize.Y + 10)
end)

-- ============================================================
-- TAB SWITCHING
-- ============================================================
local activeTab = "editor"
showTab = function(name)
    if activeTab == name and name ~= "editor" then name = "editor" end
    activeTab = name
    tabEditor.Visible    = (name == "editor")
    tabSettings.Visible  = (name == "settings")
    tabHelp.Visible      = (name == "help")
    tabTemplates.Visible = (name == "templates")
end

btnEditor.MouseButton1Click:Connect(function() showTab("editor") end)
btnSettings.MouseButton1Click:Connect(function() showTab("settings") end)
btnHelp.MouseButton1Click:Connect(function() showTab("help") end)
btnTemplates.MouseButton1Click:Connect(function() showTab("templates") end)

-- ============================================================
-- APPLY THEME
-- ============================================================
applyTheme = function()
    xWin.BackgroundColor3 = T().bg
    xHeader.BackgroundColor3 = T().header
    xTitle.TextColor3 = T().btnText
    editorContainer.BackgroundColor3 = T().editorBg
    outputContainer.BackgroundColor3 = T().outputBg
    tabSettings.BackgroundColor3 = T().bg
    tabHelp.BackgroundColor3 = T().bg
    tabTemplates.BackgroundColor3 = T().bg
    hintBar.BackgroundColor3 = T().header
    hintLabel.TextColor3 = fontColor()
    outputLabel.TextColor3 = T().accent
    tplTitle.TextColor3 = T().accent
    for _, btn in ipairs(xHeader:GetChildren()) do
        if btn:IsA("TextButton") then btn.BackgroundColor3 = T().btn; btn.TextColor3 = T().btnText end
    end
    for _, btn in ipairs(settingsScroll:GetChildren()) do
        if btn:IsA("TextButton") then btn.BackgroundColor3 = T().btn; btn.TextColor3 = T().btnText end
    end
    for _, btn in ipairs(tplScroll:GetChildren()) do
        if btn:IsA("TextButton") then btn.BackgroundColor3 = T().btn; btn.TextColor3 = T().btnText end
    end
    for _, lbl in ipairs(helpScroll:GetChildren()) do
        if lbl:IsA("TextLabel") then lbl.TextColor3 = fontColor() end
    end
    for _, lbl in ipairs(outputScroll:GetChildren()) do
        if lbl:IsA("TextLabel") then
            if lbl.Text:match("^%[ERR%]") then lbl.TextColor3 = Color3.fromRGB(255,100,100)
            elseif lbl.Text:match("^%[WARN%]") then lbl.TextColor3 = Color3.fromRGB(255,200,100)
            elseif lbl.Text:match("^%[INFO%]") then lbl.TextColor3 = Color3.fromRGB(150,150,255)
            else lbl.TextColor3 = fontColor() end
        end
    end
    renderWindow()
end

-- ============================================================
-- REFRESH ALL TEXT
-- ============================================================
refreshAllText = function()
    xTitle.Text = L("title")
    btnHelp.Text = L("help")
    btnSettings.Text = L("settings")
    btnTemplates.Text = L("templates")
    btnEditor.Text = L("editor")
    btnSelectAll.Text = L("selectAll")
    btnSave.Text = L("save")
    btnClearCode.Text = L("clearCode")
    btnClearOut.Text = L("clearOut")
    btnExecute.Text = L("execute")
    outputLabel.Text = L("output")
    tplTitle.Text = L("tplTitle")
    actionsHeader.Text = "  " .. L("settingsActions")
    for _, b in ipairs(settingsScroll:GetChildren()) do
        if b:IsA("TextButton") and b:GetAttribute("I18NKey") then
            b.Text = "  " .. L(b:GetAttribute("I18NKey"))
        end
    end
    for _, b in ipairs(tplButtons) do
        if b:GetAttribute("I18NKey") then
            b.Text = "  " .. L(b:GetAttribute("I18NKey"))
        end
    end
    rebuildHelp()
    updateHint()
end

-- ============================================================
-- HEADER BUTTON HANDLERS
-- ============================================================
btnExecute.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        local func = loadstring(bufferText())
        if func then func() else error("Compilation error (empty code)") end
    end)
    if not success then warn("[Xcode Error] " .. tostring(err)) end
end)
btnClearCode.MouseButton1Click:Connect(function()
    buffer = {""}; viewStart = 1
    renderWindow(); updateHint()
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
    addOutput("[Xcode] Selected visible window only (buffer has " .. #buffer .. " lines)", Color3.fromRGB(180,180,120))
end)
btnSave.MouseButton1Click:Connect(function()
    if type(writefile) == "function" then
        local ok, err = pcall(function() writefile("Xcode_Script.lua", bufferText()) end)
        if not ok then addOutput("Save error: " .. tostring(err), Color3.fromRGB(255,100,100)) end
    else
        addOutput("writefile недоступен", Color3.fromRGB(255,100,100))
    end
end)

-- ============================================================
-- RESIZE
-- ============================================================
local xResize = Instance.new("TextButton")
xResize.Size = UDim2.new(0, 16, 0, 16)
xResize.Position = UDim2.new(1, -16, 1, -16)
xResize.BackgroundColor3 = Color3.fromRGB(50,50,50)
xResize.Text = "◢"
xResize.TextColor3 = Color3.fromRGB(150,150,150)
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
        updateEditorLayout()
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then xResizing = false end
end)

-- ============================================================
-- INIT
-- ============================================================
buffer = splitLines([==[
--- XCODE ---
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

refreshAllText()
rebuildHelp()
applyTheme()
renderWindow()
updateHint()

task.defer(function()
    settingsScroll.CanvasSize = UDim2.new(0, 0, 0, sLayout.AbsoluteContentSize.Y + 10)
    helpScroll.CanvasSize = UDim2.new(0, 0, 0, hLayout.AbsoluteContentSize.Y + 10)
    tplScroll.CanvasSize = UDim2.new(0, 0, 0, tplLayout.AbsoluteContentSize.Y + 10)
end)

showTab("editor")
