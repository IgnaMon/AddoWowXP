local ADDON_NAME = ...

LevelPercentDB = LevelPercentDB or {}

local defaults = {
    point = "CENTER",
    relativePoint = "CENTER",
    x = 0,
    y = 160,
    locked = false,
    hidden = false,
    decimals = 1,
    width = 260,
    height = 52,
    showText = true,
    showRemaining = true,
}

local session = {
    startTime = nil,
    startXP = nil,
    lastXP = nil,
    xpGained = 0,
}

local function ApplyDefaults()
    for k, v in pairs(defaults) do
        if LevelPercentDB[k] == nil then
            LevelPercentDB[k] = v
        end
    end
end

local function FormatNumber(value)
    if BreakUpLargeNumbers then
        return BreakUpLargeNumbers(value or 0)
    end
    return tostring(value or 0)
end

local function FormatTime(seconds)
    seconds = tonumber(seconds) or 0
    if seconds <= 0 or seconds == math.huge then
        return "--"
    end

    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)

    if hours > 0 then
        return string.format("%dh %02dm", hours, minutes)
    end

    return string.format("%dm", math.max(1, minutes))
end

local frame = CreateFrame("Frame", "LevelPercentFrame", UIParent, "BackdropTemplate")
frame:SetSize(defaults.width, defaults.height)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetClampedToScreen(true)
frame:SetResizable(true)
frame:SetMinResize(190, 44)
frame:SetMaxResize(520, 90)
frame:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 12,
    insets = { left = 3, right = 3, top = 3, bottom = 3 }
})
frame:SetBackdropColor(0, 0, 0, 0.72)
frame:SetBackdropBorderColor(0.35, 0.35, 0.35, 1)

local titleText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
titleText:SetPoint("TOP", frame, "TOP", 0, -7)
titleText:SetText("LevelPercent")

local percentText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
percentText:SetPoint("CENTER", frame, "CENTER", 0, 1)
percentText:SetText("Nivel --: --%")

local remainingText = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
remainingText:SetPoint("BOTTOM", frame, "BOTTOM", 0, 6)
remainingText:SetText("Falta: -- XP")

local barBG = CreateFrame("StatusBar", nil, frame)
barBG:SetPoint("LEFT", frame, "LEFT", 12, 0)
barBG:SetPoint("RIGHT", frame, "RIGHT", -12, 0)
barBG:SetHeight(14)
barBG:SetPoint("CENTER", frame, "CENTER", 0, -1)
barBG:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
barBG:SetMinMaxValues(0, 100)
barBG:SetValue(100)
barBG:SetStatusBarColor(0.08, 0.08, 0.08, 0.9)

local bar = CreateFrame("StatusBar", nil, frame)
bar:SetPoint("LEFT", barBG, "LEFT", 0, 0)
bar:SetPoint("RIGHT", barBG, "RIGHT", 0, 0)
bar:SetHeight(14)
bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
bar:SetMinMaxValues(0, 100)
bar:SetValue(0)

local hint = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
hint:SetPoint("TOP", frame, "BOTTOM", 0, -2)
hint:SetText("Arrastra para mover | Shift + arrastrar borde para tamaño")

local resizeGrip = CreateFrame("Button", nil, frame)
resizeGrip:SetSize(16, 16)
resizeGrip:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -3, 3)
resizeGrip:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
resizeGrip:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
resizeGrip:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")

local function SavePosition()
    local point, _, relativePoint, x, y = frame:GetPoint()
    LevelPercentDB.point = point
    LevelPercentDB.relativePoint = relativePoint
    LevelPercentDB.x = x
    LevelPercentDB.y = y
end

local function SaveSize()
    LevelPercentDB.width = math.floor(frame:GetWidth() + 0.5)
    LevelPercentDB.height = math.floor(frame:GetHeight() + 0.5)
end

local function UpdateLayout()
    frame:SetSize(LevelPercentDB.width or defaults.width, LevelPercentDB.height or defaults.height)
    remainingText:SetShown(LevelPercentDB.showRemaining)
    percentText:SetShown(LevelPercentDB.showText)
end

local function GetBarColor(percent)
    if percent < 35 then
        return 0.90, 0.20, 0.20
    elseif percent < 70 then
        return 0.95, 0.70, 0.15
    end
    return 0.20, 0.85, 0.25
end

local function UpdateLockState()
    local unlocked = not LevelPercentDB.locked
    frame:EnableMouse(unlocked)
    resizeGrip:SetShown(unlocked and not LevelPercentDB.hidden)
    hint:SetShown(unlocked and not LevelPercentDB.hidden)
end

frame:SetScript("OnDragStart", function(self)
    if not LevelPercentDB.locked then
        self:StartMoving()
    end
end)

frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    SavePosition()
end)

resizeGrip:SetScript("OnMouseDown", function()
    if not LevelPercentDB.locked then
        frame:StartSizing("BOTTOMRIGHT")
    end
end)

resizeGrip:SetScript("OnMouseUp", function()
    frame:StopMovingOrSizing()
    SaveSize()
    UpdateLayout()
end)

local function UpdateSessionXP(currentXP, maxXP)
    if not session.startTime then
        session.startTime = GetTime()
        session.startXP = currentXP
        session.lastXP = currentXP
        session.xpGained = 0
        return
    end

    if currentXP < (session.lastXP or currentXP) then
        -- Subida de nivel: suma lo que faltaba del nivel anterior más el XP del nuevo nivel.
        session.xpGained = session.xpGained + math.max(0, maxXP - (session.lastXP or 0)) + currentXP
    else
        session.xpGained = session.xpGained + math.max(0, currentXP - (session.lastXP or currentXP))
    end

    session.lastXP = currentXP
end

local function GetXPPerHour()
    if not session.startTime or session.xpGained <= 0 then
        return 0
    end

    local elapsed = math.max(1, GetTime() - session.startTime)
    return session.xpGained / elapsed * 3600
end

local function UpdateTooltip(xp, maxXP, remaining, percent)
    frame:SetScript("OnEnter", function()
        local xpHour = GetXPPerHour()
        local eta = xpHour > 0 and (remaining / xpHour * 3600) or 0

        GameTooltip:SetOwner(frame, "ANCHOR_TOP")
        GameTooltip:AddLine("LevelPercent")
        GameTooltip:AddLine(string.format("Avance: %.1f%%", percent), 1, 1, 1)
        GameTooltip:AddLine(string.format("XP: %s / %s", FormatNumber(xp), FormatNumber(maxXP)), 1, 1, 1)
        GameTooltip:AddLine(string.format("Falta: %s XP", FormatNumber(remaining)), 1, 1, 1)
        GameTooltip:AddLine(string.format("XP/h sesión: %s", FormatNumber(math.floor(xpHour))), 1, 1, 1)
        GameTooltip:AddLine(string.format("Tiempo estimado: %s", FormatTime(eta)), 1, 1, 1)
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("Comandos: /lp help", 0.7, 0.7, 0.7)
        GameTooltip:Show()
    end)
    frame:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end

local function UpdateXP()
    if LevelPercentDB.hidden then
        frame:Hide()
        return
    end

    local xp = UnitXP("player") or 0
    local maxXP = UnitXPMax("player") or 0
    local level = UnitLevel("player") or 0

    if maxXP <= 0 then
        percentText:SetText(string.format("Nivel %d: máximo", level))
        remainingText:SetText("Sin XP pendiente")
        bar:SetValue(100)
        bar:SetStatusBarColor(0.20, 0.85, 0.25)
        frame:SetScript("OnEnter", nil)
        frame:SetScript("OnLeave", nil)
    else
        UpdateSessionXP(xp, maxXP)

        local percent = (xp / maxXP) * 100
        local remaining = maxXP - xp
        local decimals = tonumber(LevelPercentDB.decimals) or 1
        local red, green, blue = GetBarColor(percent)
        local xpHour = GetXPPerHour()
        local eta = xpHour > 0 and (remaining / xpHour * 3600) or 0

        percentText:SetText(string.format("Nivel %d: %." .. decimals .. "f%%", level, percent))
        remainingText:SetText(string.format("Falta: %s XP | ETA: %s", FormatNumber(remaining), FormatTime(eta)))
        bar:SetValue(percent)
        bar:SetStatusBarColor(red, green, blue)
        UpdateTooltip(xp, maxXP, remaining, percent)
    end

    frame:Show()
    UpdateLayout()
    UpdateLockState()
end

local function ResetPosition()
    LevelPercentDB.point = defaults.point
    LevelPercentDB.relativePoint = defaults.relativePoint
    LevelPercentDB.x = defaults.x
    LevelPercentDB.y = defaults.y
    LevelPercentDB.width = defaults.width
    LevelPercentDB.height = defaults.height
    frame:ClearAllPoints()
    frame:SetPoint(LevelPercentDB.point, UIParent, LevelPercentDB.relativePoint, LevelPercentDB.x, LevelPercentDB.y)
    UpdateLayout()
end

local function PrintHelp()
    print("LevelPercent comandos:")
    print("/lp show | hide | lock | unlock | reset")
    print("/lp text - activa/desactiva texto principal")
    print("/lp remaining - activa/desactiva XP restante")
    print("/lp decimals 0, 1 o 2 - cambia los decimales")
    print("También: /lp mostrar | ocultar | bloquear | desbloquear | reiniciar")
end

frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_XP_UPDATE")
frame:RegisterEvent("PLAYER_LEVEL_UP")
frame:RegisterEvent("UPDATE_EXHAUSTION")

frame:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        ApplyDefaults()
        frame:ClearAllPoints()
        frame:SetPoint(LevelPercentDB.point, UIParent, LevelPercentDB.relativePoint, LevelPercentDB.x, LevelPercentDB.y)
        UpdateLayout()
        UpdateLockState()
        UpdateXP()
    elseif event ~= "ADDON_LOADED" then
        UpdateXP()
    end
end)

SLASH_LEVELPERCENT1 = "/levelpercent"
SLASH_LEVELPERCENT2 = "/lp"
SlashCmdList["LEVELPERCENT"] = function(msg)
    msg = string.lower((msg or ""):match("^%s*(.-)%s*$"))

    local command, value = msg:match("^(%S+)%s*(.-)$")
    command = command or "help"

    if command == "show" or command == "mostrar" then
        LevelPercentDB.hidden = false
        UpdateXP()
        print("LevelPercent: mostrado.")
    elseif command == "hide" or command == "ocultar" then
        LevelPercentDB.hidden = true
        frame:Hide()
        print("LevelPercent: oculto. Usa /lp show para mostrarlo.")
    elseif command == "lock" or command == "bloquear" then
        LevelPercentDB.locked = true
        UpdateLockState()
        print("LevelPercent: bloqueado.")
    elseif command == "unlock" or command == "desbloquear" then
        LevelPercentDB.locked = false
        UpdateLockState()
        print("LevelPercent: desbloqueado. Arrastra para mover o usa la esquina para redimensionar.")
    elseif command == "reset" or command == "reiniciar" then
        ResetPosition()
        UpdateXP()
        print("LevelPercent: posición y tamaño reiniciados.")
    elseif command == "text" then
        LevelPercentDB.showText = not LevelPercentDB.showText
        UpdateXP()
        print("LevelPercent: texto principal " .. (LevelPercentDB.showText and "activado." or "desactivado."))
    elseif command == "remaining" then
        LevelPercentDB.showRemaining = not LevelPercentDB.showRemaining
        UpdateXP()
        print("LevelPercent: XP restante " .. (LevelPercentDB.showRemaining and "activada." or "desactivada."))
    elseif command == "decimals" then
        local decimals = tonumber(value)
        if decimals and decimals >= 0 and decimals <= 2 then
            LevelPercentDB.decimals = decimals
            UpdateXP()
            print("LevelPercent: decimales configurados en " .. decimals .. ".")
        else
            print("LevelPercent: usa /lp decimals 0, /lp decimals 1 o /lp decimals 2")
        end
    else
        PrintHelp()
    end
end
