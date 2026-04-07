local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local GUI_PARENT = (gethui and gethui()) or CoreGui
local GROUP_ID = 186105853

local MIN_STAFF_RANK = 51
local REFRESH_EVERY = 8
local DEFAULT_NOTIFY = true

local BLACKLIST_ROLES = {
	["tester"] = true,
}

local GUI_NAME = "HiraCode_EsenyurtYetkiliList_UltimateV2"

local FULL_HOLDER_SIZE = UDim2.new(0, 440, 0, 570)
local FULL_MAIN_SIZE = UDim2.new(0, 400, 0, 530)
local MIN_HOLDER_SIZE = UDim2.new(0, 440, 0, 250)
local MIN_MAIN_SIZE = UDim2.new(0, 400, 0, 210)

local entries = {}
local minimized = false
local refreshCountdown = REFRESH_EVERY
local currentThemeName = "Crystal"
local joinNotifyEnabled = DEFAULT_NOTIFY
local uiOpen = true
local animationTick = 0
local bindingMode = false
local themeFxVersion = 0
local hoverRegistry = {}

local toggleBind = {
	kind = "KeyCode",
	value = Enum.KeyCode.RightShift
}

local ThemeOrder = { "Crystal", "Diamond", "Ocean", "Gold", "Crimson", "Neon" }

local Themes = {
	Crystal = {
		Background = Color3.fromRGB(8, 11, 18),
		Background2 = Color3.fromRGB(11, 17, 27),
		Panel = Color3.fromRGB(14, 19, 31),
		Panel2 = Color3.fromRGB(21, 28, 43),
		Panel3 = Color3.fromRGB(29, 39, 59),
		Card = Color3.fromRGB(22, 30, 46),
		Card2 = Color3.fromRGB(31, 41, 62),
		HeaderA = Color3.fromRGB(74, 116, 180),
		HeaderB = Color3.fromRGB(184, 231, 255),
		Accent = Color3.fromRGB(184, 232, 255),
		Accent2 = Color3.fromRGB(112, 182, 255),
		Text = Color3.fromRGB(244, 248, 255),
		Sub = Color3.fromRGB(170, 186, 210),
		Good = Color3.fromRGB(128, 255, 196),
		Danger = Color3.fromRGB(255, 128, 154),
		Warning = Color3.fromRGB(255, 223, 154),
		Shadow = Color3.fromRGB(116, 175, 255),
	},
	Diamond = {
		Background = Color3.fromRGB(12, 12, 16),
		Background2 = Color3.fromRGB(18, 19, 26),
		Panel = Color3.fromRGB(20, 22, 31),
		Panel2 = Color3.fromRGB(28, 31, 43),
		Panel3 = Color3.fromRGB(37, 41, 58),
		Card = Color3.fromRGB(29, 32, 45),
		Card2 = Color3.fromRGB(37, 41, 58),
		HeaderA = Color3.fromRGB(96, 104, 129),
		HeaderB = Color3.fromRGB(236, 241, 255),
		Accent = Color3.fromRGB(228, 237, 255),
		Accent2 = Color3.fromRGB(176, 198, 255),
		Text = Color3.fromRGB(249, 250, 255),
		Sub = Color3.fromRGB(184, 191, 206),
		Good = Color3.fromRGB(138, 255, 206),
		Danger = Color3.fromRGB(255, 131, 162),
		Warning = Color3.fromRGB(255, 224, 163),
		Shadow = Color3.fromRGB(222, 233, 255),
	},
	Ocean = {
		Background = Color3.fromRGB(6, 17, 22),
		Background2 = Color3.fromRGB(8, 25, 32),
		Panel = Color3.fromRGB(10, 25, 34),
		Panel2 = Color3.fromRGB(14, 35, 46),
		Panel3 = Color3.fromRGB(21, 47, 61),
		Card = Color3.fromRGB(16, 40, 52),
		Card2 = Color3.fromRGB(21, 50, 64),
		HeaderA = Color3.fromRGB(14, 110, 136),
		HeaderB = Color3.fromRGB(95, 236, 226),
		Accent = Color3.fromRGB(124, 244, 236),
		Accent2 = Color3.fromRGB(76, 209, 218),
		Text = Color3.fromRGB(239, 252, 255),
		Sub = Color3.fromRGB(156, 202, 209),
		Good = Color3.fromRGB(126, 255, 195),
		Danger = Color3.fromRGB(255, 129, 156),
		Warning = Color3.fromRGB(255, 221, 150),
		Shadow = Color3.fromRGB(84, 220, 221),
	},
	Gold = {
		Background = Color3.fromRGB(18, 11, 7),
		Background2 = Color3.fromRGB(27, 17, 10),
		Panel = Color3.fromRGB(24, 17, 11),
		Panel2 = Color3.fromRGB(35, 24, 15),
		Panel3 = Color3.fromRGB(49, 35, 19),
		Card = Color3.fromRGB(41, 29, 17),
		Card2 = Color3.fromRGB(52, 36, 22),
		HeaderA = Color3.fromRGB(126, 78, 28),
		HeaderB = Color3.fromRGB(255, 224, 149),
		Accent = Color3.fromRGB(255, 223, 155),
		Accent2 = Color3.fromRGB(255, 187, 98),
		Text = Color3.fromRGB(255, 248, 237),
		Sub = Color3.fromRGB(214, 188, 158),
		Good = Color3.fromRGB(133, 255, 193),
		Danger = Color3.fromRGB(255, 131, 149),
		Warning = Color3.fromRGB(255, 228, 172),
		Shadow = Color3.fromRGB(255, 209, 124),
	},
	Crimson = {
		Background = Color3.fromRGB(17, 7, 11),
		Background2 = Color3.fromRGB(26, 10, 15),
		Panel = Color3.fromRGB(28, 11, 16),
		Panel2 = Color3.fromRGB(40, 15, 23),
		Panel3 = Color3.fromRGB(56, 21, 32),
		Card = Color3.fromRGB(48, 18, 29),
		Card2 = Color3.fromRGB(61, 24, 38),
		HeaderA = Color3.fromRGB(141, 27, 53),
		HeaderB = Color3.fromRGB(255, 151, 183),
		Accent = Color3.fromRGB(255, 164, 191),
		Accent2 = Color3.fromRGB(255, 108, 151),
		Text = Color3.fromRGB(255, 242, 247),
		Sub = Color3.fromRGB(220, 174, 188),
		Good = Color3.fromRGB(138, 255, 205),
		Danger = Color3.fromRGB(255, 107, 144),
		Warning = Color3.fromRGB(255, 214, 151),
		Shadow = Color3.fromRGB(255, 119, 157),
	},
	Neon = {
		Background = Color3.fromRGB(7, 8, 14),
		Background2 = Color3.fromRGB(10, 11, 20),
		Panel = Color3.fromRGB(11, 16, 27),
		Panel2 = Color3.fromRGB(15, 24, 39),
		Panel3 = Color3.fromRGB(23, 36, 58),
		Card = Color3.fromRGB(18, 29, 47),
		Card2 = Color3.fromRGB(22, 39, 63),
		HeaderA = Color3.fromRGB(32, 88, 204),
		HeaderB = Color3.fromRGB(74, 255, 236),
		Accent = Color3.fromRGB(90, 255, 238),
		Accent2 = Color3.fromRGB(98, 176, 255),
		Text = Color3.fromRGB(240, 252, 255),
		Sub = Color3.fromRGB(160, 193, 213),
		Good = Color3.fromRGB(133, 255, 190),
		Danger = Color3.fromRGB(255, 114, 156),
		Warning = Color3.fromRGB(255, 223, 149),
		Shadow = Color3.fromRGB(78, 255, 234),
	},
}

local function theme()
	return Themes[currentThemeName]
end

local function blend(a, b, t)
	return Color3.new(
		a.R + (b.R - a.R) * t,
		a.G + (b.G - a.G) * t,
		a.B + (b.B - a.B) * t
	)
end

local function makeCorner(obj, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = obj
	return c
end

local function makeStroke(obj, thickness, transparency)
	local s = Instance.new("UIStroke")
	s.Thickness = thickness or 1
	s.Transparency = transparency or 0
	s.Parent = obj
	return s
end

local function makeGradient(obj, rotation, colors)
	local g = Instance.new("UIGradient")
	g.Rotation = rotation or 0
	g.Color = ColorSequence.new(colors)
	g.Parent = obj
	return g
end

local function trim(s)
	return tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function normalizeRole(role)
	local clean = trim(role)
	return clean, string.lower(clean)
end

local function registerHover(button)
	if hoverRegistry[button] then
		return
	end

	hoverRegistry[button] = {
		normal = button.BackgroundColor3,
		hover = button.BackgroundColor3,
	}

	button.MouseEnter:Connect(function()
		local data = hoverRegistry[button]
		if data then
			TweenService:Create(button, TweenInfo.new(0.14), {
				BackgroundColor3 = data.hover
			}):Play()
		end
	end)

	button.MouseLeave:Connect(function()
		local data = hoverRegistry[button]
		if data then
			TweenService:Create(button, TweenInfo.new(0.14), {
				BackgroundColor3 = data.normal
			}):Play()
		end
	end)
end

local function setHoverColors(button, normalColor, hoverColor)
	registerHover(button)
	hoverRegistry[button].normal = normalColor
	hoverRegistry[button].hover = hoverColor
end

local function inputToText(bind)
	if bind.kind == "KeyCode" then
		return bind.value.Name
	elseif bind.kind == "MouseButton2" then
		return "Mouse 2"
	elseif bind.kind == "MouseButton3" then
		return "Mouse 3"
	end
	return "RightShift"
end

local function matchesToggleInput(input)
	if toggleBind.kind == "KeyCode" then
		return input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == toggleBind.value
	elseif toggleBind.kind == "MouseButton2" then
		return input.UserInputType == Enum.UserInputType.MouseButton2
	elseif toggleBind.kind == "MouseButton3" then
		return input.UserInputType == Enum.UserInputType.MouseButton3
	end
	return false
end

local function safeNotify(title, text, duration)
	if not joinNotifyEnabled then
		return
	end

	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title,
			Text = text,
			Duration = duration or 4
		})
	end)
end

local function getRoleStyle(role, rank)
	local t = theme()
	local roleLower = string.lower(role or "")

	if roleLower == "owner" or rank >= 255 then
		return {
			accent = blend(t.Danger, t.Warning, 0.25),
			soft = blend(t.Danger, t.Panel, 0.75),
			text = "OWNER"
		}
	elseif roleLower == "founder" then
		return {
			accent = t.Warning,
			soft = blend(t.Warning, t.Panel, 0.78),
			text = "FOUNDER"
		}
	elseif roleLower == "head developer" then
		return {
			accent = blend(t.Accent, Color3.fromRGB(192, 132, 255), 0.45),
			soft = blend(Color3.fromRGB(136, 91, 208), t.Panel, 0.80),
			text = "HEAD DEV"
		}
	elseif roleLower == "developer" then
		return {
			accent = blend(t.Accent, Color3.fromRGB(110, 145, 255), 0.35),
			soft = blend(Color3.fromRGB(72, 96, 176), t.Panel, 0.82),
			text = "DEVELOPER"
		}
	elseif roleLower == "management" then
		return {
			accent = blend(t.Warning, Color3.fromRGB(255, 166, 90), 0.42),
			soft = blend(Color3.fromRGB(136, 78, 30), t.Panel, 0.80),
			text = "MANAGEMENT"
		}
	elseif roleLower == "head moderator" then
		return {
			accent = blend(t.Accent, Color3.fromRGB(92, 222, 255), 0.45),
			soft = blend(Color3.fromRGB(34, 101, 137), t.Panel, 0.80),
			text = "HEAD MOD"
		}
	else
		return {
			accent = t.Accent,
			soft = blend(t.Accent2, t.Panel, 0.80),
			text = "STAFF"
		}
	end
end

local old = GUI_PARENT:FindFirstChild(GUI_NAME)
if old then
	old:Destroy()
end

local Holder = Instance.new("Frame")
Holder.Name = GUI_NAME
Holder.Parent = GUI_PARENT
Holder.BackgroundTransparency = 1
Holder.Size = FULL_HOLDER_SIZE
Holder.Position = UDim2.new(1, -490, 0.08, -10)
Holder.Active = true
Holder.Draggable = true

local ShadowGlow = Instance.new("Frame")
ShadowGlow.Parent = Holder
ShadowGlow.Size = UDim2.new(0, 440, 0, 570)
ShadowGlow.Position = UDim2.new(0, 0, 0, 0)
ShadowGlow.BackgroundTransparency = 0.72
ShadowGlow.BorderSizePixel = 0
makeCorner(ShadowGlow, 32)

local Shadow = Instance.new("Frame")
Shadow.Parent = Holder
Shadow.Size = UDim2.new(0, 420, 0, 550)
Shadow.Position = UDim2.new(0, 10, 0, 10)
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.43
Shadow.BorderSizePixel = 0
makeCorner(Shadow, 30)

local Main = Instance.new("Frame")
Main.Parent = Holder
Main.Size = FULL_MAIN_SIZE
Main.Position = UDim2.new(0, 20, 0, 20)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
makeCorner(Main, 30)

local MainStroke = makeStroke(Main, 1.5, 0.1)
local MainGradient = makeGradient(Main, 90, {
	ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 20)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 14))
})

local TopGlow = Instance.new("Frame")
TopGlow.Parent = Main
TopGlow.Size = UDim2.new(1, 0, 0, 150)
TopGlow.BackgroundTransparency = 0.14
TopGlow.BorderSizePixel = 0
makeCorner(TopGlow, 30)

local Header = Instance.new("Frame")
Header.Parent = Main
Header.Size = UDim2.new(1, 0, 0, 116)
Header.BackgroundColor3 = Color3.fromRGB(24, 8, 10)
Header.BorderSizePixel = 0
makeCorner(Header, 30)

local HeaderFix = Instance.new("Frame")
HeaderFix.Parent = Header
HeaderFix.Size = UDim2.new(1, 0, 0, 28)
HeaderFix.Position = UDim2.new(0, 0, 1, -28)
HeaderFix.BackgroundColor3 = Header.BackgroundColor3
HeaderFix.BorderSizePixel = 0

local HeaderGradient = makeGradient(Header, 18, {
	ColorSequenceKeypoint.new(0, Color3.fromRGB(95, 8, 8)),
	ColorSequenceKeypoint.new(0.55, Color3.fromRGB(35, 12, 22)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 14, 28))
})

local ThemeFX = Instance.new("Frame")
ThemeFX.Parent = Header
ThemeFX.Size = UDim2.new(1, 0, 1, 0)
ThemeFX.BackgroundTransparency = 1
ThemeFX.ClipsDescendants = true

local HeaderShine = Instance.new("Frame")
HeaderShine.Parent = Header
HeaderShine.AnchorPoint = Vector2.new(0.5, 0)
HeaderShine.Size = UDim2.new(0.34, 0, 1.2, 0)
HeaderShine.Position = UDim2.new(-0.24, 0, -0.1, 0)
HeaderShine.BackgroundTransparency = 0.80
HeaderShine.BorderSizePixel = 0
HeaderShine.Rotation = 18
makeCorner(HeaderShine, 44)
makeGradient(HeaderShine, 0, {
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})

local AccentLine = Instance.new("Frame")
AccentLine.Parent = Main
AccentLine.Size = UDim2.new(1, -42, 0, 2)
AccentLine.Position = UDim2.new(0, 21, 0, 124)
AccentLine.BorderSizePixel = 0
makeCorner(AccentLine, 999)

local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 18, 0, 12)
Title.Size = UDim2.new(1, -160, 0, 28)
Title.Font = Enum.Font.GothamBlack
Title.Text = "Esenyurt Yetkili List"
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

local Subtitle = Instance.new("TextLabel")
Subtitle.Parent = Header
Subtitle.BackgroundTransparency = 1
Subtitle.Position = UDim2.new(0, 18, 0, 38)
Subtitle.Size = UDim2.new(1, -160, 0, 18)
Subtitle.Font = Enum.Font.Gotham
Subtitle.Text = "Crystal · Diamond · Ocean · Gold · Crimson · Neon"
Subtitle.TextSize = 10
Subtitle.TextXAlignment = Enum.TextXAlignment.Left

local RefreshText = Instance.new("TextLabel")
RefreshText.Parent = Header
RefreshText.BackgroundTransparency = 1
RefreshText.Position = UDim2.new(0, 18, 0, 60)
RefreshText.Size = UDim2.new(1, -160, 0, 16)
RefreshText.Font = Enum.Font.GothamBold
RefreshText.Text = "Auto Refresh: " .. REFRESH_EVERY .. "s"
RefreshText.TextSize = 10
RefreshText.TextXAlignment = Enum.TextXAlignment.Left

local ThemeButton = Instance.new("TextButton")
ThemeButton.Parent = Header
ThemeButton.Size = UDim2.new(0, 92, 0, 30)
ThemeButton.Position = UDim2.new(1, -148, 0, 14)
ThemeButton.Text = currentThemeName
ThemeButton.Font = Enum.Font.GothamBold
ThemeButton.TextSize = 10
ThemeButton.BorderSizePixel = 0
makeCorner(ThemeButton, 999)
local ThemeButtonStroke = makeStroke(ThemeButton, 1, 0.30)

local SettingsButton = Instance.new("TextButton")
SettingsButton.Parent = Header
SettingsButton.Size = UDim2.new(0, 30, 0, 30)
SettingsButton.Position = UDim2.new(1, -52, 0, 14)
SettingsButton.Text = "⚙"
SettingsButton.Font = Enum.Font.GothamBold
SettingsButton.TextSize = 14
SettingsButton.BorderSizePixel = 0
makeCorner(SettingsButton, 999)

local Minimize = Instance.new("TextButton")
Minimize.Parent = Header
Minimize.Size = UDim2.new(0, 30, 0, 30)
Minimize.Position = UDim2.new(1, -86, 0, 14)
Minimize.Text = "–"
Minimize.Font = Enum.Font.GothamBold
Minimize.TextSize = 18
Minimize.BorderSizePixel = 0
makeCorner(Minimize, 999)

local Close = Instance.new("TextButton")
Close.Parent = Header
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -18, 0, 14)
Close.AnchorPoint = Vector2.new(1, 0)
Close.Text = "✕"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 13
Close.BorderSizePixel = 0
makeCorner(Close, 999)

local CounterWrap = Instance.new("Frame")
CounterWrap.Parent = Main
CounterWrap.Position = UDim2.new(0, 16, 0, 138)
CounterWrap.Size = UDim2.new(1, -32, 0, 64)
CounterWrap.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
CounterWrap.BorderSizePixel = 0
makeCorner(CounterWrap, 20)

local CounterWrapGradient = makeGradient(CounterWrap, 0, {
	ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 24)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(26, 26, 32))
})
local CounterStroke = makeStroke(CounterWrap, 1, 0.28)

local CounterDot = Instance.new("Frame")
CounterDot.Parent = CounterWrap
CounterDot.Size = UDim2.new(0, 11, 0, 11)
CounterDot.Position = UDim2.new(0, 14, 0.5, -6)
CounterDot.BorderSizePixel = 0
makeCorner(CounterDot, 999)

local CounterText = Instance.new("TextLabel")
CounterText.Parent = CounterWrap
CounterText.BackgroundTransparency = 1
CounterText.Position = UDim2.new(0, 32, 0, 10)
CounterText.Size = UDim2.new(0.34, 0, 0, 16)
CounterText.Font = Enum.Font.GothamBold
CounterText.Text = "Yetkili sayı: 0"
CounterText.TextSize = 12
CounterText.TextXAlignment = Enum.TextXAlignment.Left

local CounterSub = Instance.new("TextLabel")
CounterSub.Parent = CounterWrap
CounterSub.BackgroundTransparency = 1
CounterSub.Position = UDim2.new(0, 32, 0, 31)
CounterSub.Size = UDim2.new(0.34, 0, 0, 14)
CounterSub.Font = Enum.Font.Gotham
CounterSub.Text = "51+ yetkililer görünür"
CounterSub.TextSize = 10
CounterSub.TextXAlignment = Enum.TextXAlignment.Left

local CountdownText = Instance.new("TextLabel")
CountdownText.Parent = CounterWrap
CountdownText.BackgroundTransparency = 1
CountdownText.Position = UDim2.new(0.38, 0, 0, 10)
CountdownText.Size = UDim2.new(0.23, 0, 0, 16)
CountdownText.Font = Enum.Font.GothamBold
CountdownText.Text = "Yenilenme: " .. refreshCountdown .. "s"
CountdownText.TextSize = 11
CountdownText.TextXAlignment = Enum.TextXAlignment.Right

local ThemePreviewWrap = Instance.new("Frame")
ThemePreviewWrap.Parent = CounterWrap
ThemePreviewWrap.Size = UDim2.new(0, 118, 0, 12)
ThemePreviewWrap.Position = UDim2.new(1, -134, 0, 10)
ThemePreviewWrap.BackgroundTransparency = 1

local Preview1 = Instance.new("Frame")
Preview1.Parent = ThemePreviewWrap
Preview1.Size = UDim2.new(0, 34, 1, 0)
Preview1.Position = UDim2.new(0, 0, 0, 0)
Preview1.BorderSizePixel = 0
makeCorner(Preview1, 999)

local Preview2 = Instance.new("Frame")
Preview2.Parent = ThemePreviewWrap
Preview2.Size = UDim2.new(0, 34, 1, 0)
Preview2.Position = UDim2.new(0, 40, 0, 0)
Preview2.BorderSizePixel = 0
makeCorner(Preview2, 999)

local Preview3 = Instance.new("Frame")
Preview3.Parent = ThemePreviewWrap
Preview3.Size = UDim2.new(0, 34, 1, 0)
Preview3.Position = UDim2.new(0, 80, 0, 0)
Preview3.BorderSizePixel = 0
makeCorner(Preview3, 999)

local ThemeChip = Instance.new("Frame")
ThemeChip.Parent = CounterWrap
ThemeChip.Size = UDim2.new(0, 94, 0, 24)
ThemeChip.Position = UDim2.new(1, -110, 0, 26)
ThemeChip.BorderSizePixel = 0
makeCorner(ThemeChip, 999)
local ThemeChipStroke = makeStroke(ThemeChip, 1, 0.28)

local ThemeChipText = Instance.new("TextLabel")
ThemeChipText.Parent = ThemeChip
ThemeChipText.BackgroundTransparency = 1
ThemeChipText.Size = UDim2.new(1, -10, 1, 0)
ThemeChipText.Position = UDim2.new(0, 5, 0, 0)
ThemeChipText.Font = Enum.Font.GothamBold
ThemeChipText.Text = currentThemeName
ThemeChipText.TextSize = 10
ThemeChipText.TextXAlignment = Enum.TextXAlignment.Center

local NotifyPill = Instance.new("TextButton")
NotifyPill.Parent = CounterWrap
NotifyPill.Size = UDim2.new(0, 88, 0, 24)
NotifyPill.Position = UDim2.new(1, -204, 0, 26)
NotifyPill.Text = ""
NotifyPill.BorderSizePixel = 0
makeCorner(NotifyPill, 999)

local NotifyPillKnob = Instance.new("Frame")
NotifyPillKnob.Parent = NotifyPill
NotifyPillKnob.Size = UDim2.new(0, 18, 0, 18)
NotifyPillKnob.Position = UDim2.new(0, 3, 0.5, -9)
NotifyPillKnob.BorderSizePixel = 0
makeCorner(NotifyPillKnob, 999)

local NotifyPillText = Instance.new("TextLabel")
NotifyPillText.Parent = NotifyPill
NotifyPillText.BackgroundTransparency = 1
NotifyPillText.Size = UDim2.new(1, -28, 1, 0)
NotifyPillText.Position = UDim2.new(0, 24, 0, 0)
NotifyPillText.Font = Enum.Font.GothamBold
NotifyPillText.Text = "Bildirim"
NotifyPillText.TextSize = 10
NotifyPillText.TextXAlignment = Enum.TextXAlignment.Center

local SettingsPanel = Instance.new("Frame")
SettingsPanel.Parent = Main
SettingsPanel.Size = UDim2.new(0, 0, 0, 150)
SettingsPanel.Position = UDim2.new(1, -196, 0, 126)
SettingsPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
SettingsPanel.BorderSizePixel = 0
SettingsPanel.ClipsDescendants = true
SettingsPanel.Visible = false
makeCorner(SettingsPanel, 18)
local SettingsStroke = makeStroke(SettingsPanel, 1, 0.30)
local SettingsGradient = makeGradient(SettingsPanel, 90, {
	ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 24)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 28, 36))
})

local SettingsTitle = Instance.new("TextLabel")
SettingsTitle.Parent = SettingsPanel
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.Position = UDim2.new(0, 14, 0, 10)
SettingsTitle.Size = UDim2.new(1, -28, 0, 18)
SettingsTitle.Font = Enum.Font.GothamBold
SettingsTitle.Text = "Ayarlar"
SettingsTitle.TextSize = 12
SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left

local SettingsDesc = Instance.new("TextLabel")
SettingsDesc.Parent = SettingsPanel
SettingsDesc.BackgroundTransparency = 1
SettingsDesc.Position = UDim2.new(0, 14, 0, 28)
SettingsDesc.Size = UDim2.new(1, -28, 0, 16)
SettingsDesc.Font = Enum.Font.Gotham
SettingsDesc.Text = "Menüyü aç/kapat tuşu seç"
SettingsDesc.TextSize = 10
SettingsDesc.TextXAlignment = Enum.TextXAlignment.Left

local BindButton = Instance.new("TextButton")
BindButton.Parent = SettingsPanel
BindButton.Size = UDim2.new(1, -28, 0, 30)
BindButton.Position = UDim2.new(0, 14, 0, 52)
BindButton.Text = "Tuş Seç: " .. inputToText(toggleBind)
BindButton.Font = Enum.Font.GothamBold
BindButton.TextSize = 10
BindButton.BorderSizePixel = 0
makeCorner(BindButton, 12)
local BindStroke = makeStroke(BindButton, 1, 0.25)

local BindHelp = Instance.new("TextLabel")
BindHelp.Parent = SettingsPanel
BindHelp.BackgroundTransparency = 1
BindHelp.Position = UDim2.new(0, 14, 0, 84)
BindHelp.Size = UDim2.new(1, -28, 0, 28)
BindHelp.Font = Enum.Font.Gotham
BindHelp.Text = "Klavye tuşları ve Mouse 2 / Mouse 3 desteklenir."
BindHelp.TextWrapped = true
BindHelp.TextSize = 9
BindHelp.TextXAlignment = Enum.TextXAlignment.Left
BindHelp.TextYAlignment = Enum.TextYAlignment.Top

local SettingsThemeLabel = Instance.new("TextLabel")
SettingsThemeLabel.Parent = SettingsPanel
SettingsThemeLabel.BackgroundTransparency = 1
SettingsThemeLabel.Position = UDim2.new(0, 14, 0, 118)
SettingsThemeLabel.Size = UDim2.new(1, -28, 0, 16)
SettingsThemeLabel.Font = Enum.Font.GothamBold
SettingsThemeLabel.Text = "Tema: " .. currentThemeName
SettingsThemeLabel.TextSize = 10
SettingsThemeLabel.TextXAlignment = Enum.TextXAlignment.Left

local ListHolder = Instance.new("Frame")
ListHolder.Parent = Main
ListHolder.Position = UDim2.new(0, 16, 0, 216)
ListHolder.Size = UDim2.new(1, -32, 1, -266)
ListHolder.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
ListHolder.BorderSizePixel = 0
makeCorner(ListHolder, 24)

local ListHolderGradient = makeGradient(ListHolder, 90, {
	ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 14, 18)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(21, 21, 28))
})
local ListHolderStroke = makeStroke(ListHolder, 1, 0.42)

local ListHeader = Instance.new("Frame")
ListHeader.Parent = ListHolder
ListHeader.Size = UDim2.new(1, -16, 0, 40)
ListHeader.Position = UDim2.new(0, 8, 0, 8)
ListHeader.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
ListHeader.BorderSizePixel = 0
makeCorner(ListHeader, 16)
local ListHeaderStroke = makeStroke(ListHeader, 1, 0.55)

local ListHeaderLeft = Instance.new("TextLabel")
ListHeaderLeft.Parent = ListHeader
ListHeaderLeft.BackgroundTransparency = 1
ListHeaderLeft.Position = UDim2.new(0, 14, 0, 0)
ListHeaderLeft.Size = UDim2.new(0.55, 0, 1, 0)
ListHeaderLeft.Font = Enum.Font.GothamBold
ListHeaderLeft.Text = "Algılanan Yetkililer"
ListHeaderLeft.TextSize = 12
ListHeaderLeft.TextXAlignment = Enum.TextXAlignment.Left

local ListHeaderRight = Instance.new("TextLabel")
ListHeaderRight.Parent = ListHeader
ListHeaderRight.BackgroundTransparency = 1
ListHeaderRight.Position = UDim2.new(0.55, 0, 0, 0)
ListHeaderRight.Size = UDim2.new(0.38, 0, 1, 0)
ListHeaderRight.Font = Enum.Font.Gotham
ListHeaderRight.Text = "Rütbeye göre sıralı"
ListHeaderRight.TextSize = 10
ListHeaderRight.TextXAlignment = Enum.TextXAlignment.Right

local List = Instance.new("ScrollingFrame")
List.Parent = ListHolder
List.Position = UDim2.new(0, 8, 0, 56)
List.Size = UDim2.new(1, -16, 1, -64)
List.BackgroundTransparency = 1
List.BorderSizePixel = 0
List.ScrollBarThickness = 4
List.CanvasSize = UDim2.new(0, 0, 0, 0)

local Layout = Instance.new("UIListLayout")
Layout.Parent = List
Layout.Padding = UDim.new(0, 10)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

local Footer = Instance.new("TextLabel")
Footer.Parent = Main
Footer.BackgroundTransparency = 1
Footer.Position = UDim2.new(0, 16, 1, -42)
Footer.Size = UDim2.new(1, -32, 0, 20)
Footer.Font = Enum.Font.GothamBold
Footer.Text = "Developed By HiraCode Scripts"
Footer.TextSize = 11
Footer.TextXAlignment = Enum.TextXAlignment.Center

local function clearThemeFX()
	for _, child in ipairs(ThemeFX:GetChildren()) do
		child:Destroy()
	end
end

local function buildThemeFX()
	themeFxVersion += 1
	local version = themeFxVersion
	local t = theme()

	clearThemeFX()

	if currentThemeName == "Ocean" then
		for i = 1, 3 do
			local wave = Instance.new("Frame")
			wave.Parent = ThemeFX
			wave.Size = UDim2.new(0.55, 0, 0, 26)
			wave.Position = UDim2.new(-0.2 + (i * 0.18), 0, 0.72 - (i * 0.06), 0)
			wave.BackgroundColor3 = i == 1 and t.Accent or (i == 2 and t.Accent2 or t.Warning)
			wave.BackgroundTransparency = 0.76
			wave.BorderSizePixel = 0
			wave.Rotation = i == 2 and -4 or 4
			makeCorner(wave, 999)

			task.spawn(function()
				local dir = i % 2 == 0 and 1 or -1
				while Holder.Parent and themeFxVersion == version do
					TweenService:Create(wave, TweenInfo.new(2.4 + i * 0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
						Position = wave.Position + UDim2.new(0, dir * 26, 0, 0)
					}):Play()
					task.wait(2.5 + i * 0.4)
					if not Holder.Parent or themeFxVersion ~= version then
						break
					end
					wave.Position = UDim2.new(-0.2 + (i * 0.18), 0, 0.72 - (i * 0.06), 0)
				end
			end)
		end
	elseif currentThemeName == "Diamond" then
		for i = 1, 6 do
			local spark = Instance.new("Frame")
			spark.Parent = ThemeFX
			spark.Size = UDim2.new(0, 8 + (i % 2) * 4, 0, 8 + (i % 2) * 4)
			spark.Position = UDim2.new(0.12 * i, 0, 0.18 + ((i % 3) * 0.18), 0)
			spark.BackgroundColor3 = i % 2 == 0 and t.Accent or t.Warning
			spark.BackgroundTransparency = 0.55
			spark.BorderSizePixel = 0
			spark.Rotation = 45
			makeCorner(spark, 2)

			task.spawn(function()
				while Holder.Parent and themeFxVersion == version do
					TweenService:Create(spark, TweenInfo.new(0.7 + i * 0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
						Size = UDim2.new(0, 14 + (i % 2) * 4, 0, 14 + (i % 2) * 4),
						BackgroundTransparency = 0.15
					}):Play()
					task.wait(0.72 + i * 0.05)
					if not Holder.Parent or themeFxVersion ~= version then
						break
					end
					TweenService:Create(spark, TweenInfo.new(0.7 + i * 0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
						Size = UDim2.new(0, 8 + (i % 2) * 4, 0, 8 + (i % 2) * 4),
						BackgroundTransparency = 0.55
					}):Play()
					task.wait(0.72 + i * 0.05)
				end
			end)
		end
	elseif currentThemeName == "Gold" then
		for i = 1, 2 do
			local shine = Instance.new("Frame")
			shine.Parent = ThemeFX
			shine.Size = UDim2.new(0.16, 0, 1.4, 0)
			shine.Position = UDim2.new(-0.22 - ((i - 1) * 0.28), 0, -0.2, 0)
			shine.BackgroundColor3 = i == 1 and t.Warning or t.Accent
			shine.BackgroundTransparency = 0.82
			shine.BorderSizePixel = 0
			shine.Rotation = 20
			makeCorner(shine, 30)

			task.spawn(function()
				while Holder.Parent and themeFxVersion == version do
					TweenService:Create(shine, TweenInfo.new(1.6 + (i * 0.2), Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Position = UDim2.new(1.25, 0, -0.2, 0)
					}):Play()
					task.wait(1.7 + (i * 0.2))
					if not Holder.Parent or themeFxVersion ~= version then
						break
					end
					shine.Position = UDim2.new(-0.22 - ((i - 1) * 0.28), 0, -0.2, 0)
					task.wait(0.2)
				end
			end)
		end
	elseif currentThemeName == "Crimson" then
		for i = 1, 5 do
			local bar = Instance.new("Frame")
			bar.Parent = ThemeFX
			bar.Size = UDim2.new(0, 14, 0.24 + (i * 0.05), 0)
			bar.Position = UDim2.new(0.08 + (i * 0.12), 0, 1, 0)
			bar.AnchorPoint = Vector2.new(0, 1)
			bar.BackgroundColor3 = i % 2 == 0 and t.Accent2 or t.Danger
			bar.BackgroundTransparency = 0.72
			bar.BorderSizePixel = 0
			makeCorner(bar, 999)

			task.spawn(function()
				while Holder.Parent and themeFxVersion == version do
					TweenService:Create(bar, TweenInfo.new(0.9 + i * 0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
						Size = UDim2.new(0, 14, 0.42 + (i * 0.04), 0),
						BackgroundTransparency = 0.45
					}):Play()
					task.wait(0.95 + i * 0.08)
					if not Holder.Parent or themeFxVersion ~= version then
						break
					end
					TweenService:Create(bar, TweenInfo.new(0.9 + i * 0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
						Size = UDim2.new(0, 14, 0.24 + (i * 0.05), 0),
						BackgroundTransparency = 0.72
					}):Play()
					task.wait(0.95 + i * 0.08)
				end
			end)
		end
	elseif currentThemeName == "Neon" then
		for i = 1, 4 do
			local line = Instance.new("Frame")
			line.Parent = ThemeFX
			line.Size = UDim2.new(0.18, 0, 0, 2)
			line.Position = UDim2.new(0.08 + ((i - 1) * 0.21), 0, 0.72 - ((i % 2) * 0.12), 0)
			line.BackgroundColor3 = i % 2 == 0 and t.Accent or t.Accent2
			line.BackgroundTransparency = 0.2
			line.BorderSizePixel = 0
			makeCorner(line, 999)

			task.spawn(function()
				while Holder.Parent and themeFxVersion == version do
					TweenService:Create(line, TweenInfo.new(0.8 + i * 0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
						Size = UDim2.new(0.28, 0, 0, 3),
						BackgroundTransparency = 0.0
					}):Play()
					task.wait(0.85 + i * 0.1)
					if not Holder.Parent or themeFxVersion ~= version then
						break
					end
					TweenService:Create(line, TweenInfo.new(0.8 + i * 0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
						Size = UDim2.new(0.18, 0, 0, 2),
						BackgroundTransparency = 0.2
					}):Play()
					task.wait(0.85 + i * 0.1)
				end
			end)
		end
	else
		for i = 1, 4 do
			local shard = Instance.new("Frame")
			shard.Parent = ThemeFX
			shard.Size = UDim2.new(0.12 + (i * 0.02), 0, 0.84, 0)
			shard.Position = UDim2.new(0.04 + (i * 0.15), 0, -0.08, 0)
			shard.BackgroundColor3 = i % 2 == 0 and t.Accent or t.Accent2
			shard.BackgroundTransparency = 0.84
			shard.BorderSizePixel = 0
			shard.Rotation = -16 + i * 8
			makeCorner(shard, 20)

			task.spawn(function()
				while Holder.Parent and themeFxVersion == version do
					TweenService:Create(shard, TweenInfo.new(1.6 + i * 0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
						BackgroundTransparency = 0.72
					}):Play()
					task.wait(1.7 + i * 0.1)
					if not Holder.Parent or themeFxVersion ~= version then
						break
					end
					TweenService:Create(shard, TweenInfo.new(1.6 + i * 0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
						BackgroundTransparency = 0.86
					}):Play()
					task.wait(1.7 + i * 0.1)
				end
			end)
		end
	end
end

local function updateCanvas()
	local count = 0
	for _ in pairs(entries) do
		count += 1
	end
	CounterText.Text = "Yetkili sayı: " .. count
	List.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
end

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

local function setCountdownText()
	CountdownText.Text = "Yenilenme: " .. tostring(refreshCountdown) .. "s"
	RefreshText.Text = "Auto Refresh: " .. tostring(refreshCountdown) .. "s"
end

local function updateNotifyPill()
	local t = theme()
	if joinNotifyEnabled then
		NotifyPill.BackgroundColor3 = t.Good
		NotifyPillKnob.BackgroundColor3 = t.Text
		NotifyPillText.TextColor3 = t.Background
		TweenService:Create(NotifyPillKnob, TweenInfo.new(0.18), {
			Position = UDim2.new(1, -21, 0.5, -9)
		}):Play()
	else
		NotifyPill.BackgroundColor3 = t.Panel3
		NotifyPillKnob.BackgroundColor3 = t.Sub
		NotifyPillText.TextColor3 = t.Text
		TweenService:Create(NotifyPillKnob, TweenInfo.new(0.18), {
			Position = UDim2.new(0, 3, 0.5, -9)
		}):Play()
	end
end

local function applyTheme()
	local t = theme()

	ShadowGlow.BackgroundColor3 = t.Shadow

	Main.BackgroundColor3 = t.Background
	MainStroke.Color = blend(t.Accent, t.Warning, 0.25)
	MainGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, t.Background2),
		ColorSequenceKeypoint.new(0.58, t.Background),
		ColorSequenceKeypoint.new(1, blend(t.Panel, t.Background, 0.34))
	})

	TopGlow.BackgroundColor3 = blend(t.Accent, t.Background, 0.78)

	Header.BackgroundColor3 = t.Panel
	HeaderFix.BackgroundColor3 = t.Panel
	HeaderGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, blend(t.HeaderA, t.Background2, 0.22)),
		ColorSequenceKeypoint.new(0.58, blend(t.HeaderB, t.HeaderA, 0.54)),
		ColorSequenceKeypoint.new(1, blend(t.Background2, t.Panel2, 0.34))
	})

	AccentLine.BackgroundColor3 = blend(t.Accent, t.Warning, 0.20)

	Title.TextColor3 = t.Text
	Subtitle.TextColor3 = t.Sub
	RefreshText.TextColor3 = t.Warning

	ThemeButton.BackgroundColor3 = t.Panel3
	ThemeButton.TextColor3 = t.Text
	ThemeButtonStroke.Color = t.Accent

	SettingsButton.BackgroundColor3 = t.Panel3
	SettingsButton.TextColor3 = t.Text

	Minimize.BackgroundColor3 = t.Warning
	Minimize.TextColor3 = t.Text

	Close.BackgroundColor3 = t.Danger
	Close.TextColor3 = t.Text

	CounterWrap.BackgroundColor3 = t.Panel
	CounterWrapGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, t.Panel),
		ColorSequenceKeypoint.new(1, t.Panel2)
	})
	CounterStroke.Color = t.Accent
	CounterText.TextColor3 = t.Text
	CounterSub.TextColor3 = t.Sub
	CountdownText.TextColor3 = t.Warning
	CounterDot.BackgroundColor3 = t.Good

	ThemeChip.BackgroundColor3 = t.Panel3
	ThemeChipStroke.Color = t.Accent
	ThemeChipText.TextColor3 = t.Text
	ThemeChipText.Text = currentThemeName

	Preview1.BackgroundColor3 = t.Accent
	Preview2.BackgroundColor3 = t.Accent2
	Preview3.BackgroundColor3 = t.Warning

	NotifyPillText.Text = "Bildirim"

	SettingsPanel.BackgroundColor3 = t.Panel
	SettingsStroke.Color = t.Accent
	SettingsGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, t.Panel),
		ColorSequenceKeypoint.new(1, t.Panel2)
	})
	SettingsTitle.TextColor3 = t.Text
	SettingsDesc.TextColor3 = t.Sub
	BindButton.BackgroundColor3 = t.Panel3
	BindButton.TextColor3 = t.Text
	BindStroke.Color = t.Accent
	BindHelp.TextColor3 = t.Sub
	SettingsThemeLabel.TextColor3 = t.Text
	SettingsThemeLabel.Text = "Tema: " .. currentThemeName
	BindButton.Text = bindingMode and "Bir tuşa bas..." or ("Tuş Seç: " .. inputToText(toggleBind))

	ListHolder.BackgroundColor3 = t.Panel
	ListHolderGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, t.Panel),
		ColorSequenceKeypoint.new(1, t.Panel2)
	})
	ListHolderStroke.Color = t.Accent

	ListHeader.BackgroundColor3 = t.Card
	ListHeaderStroke.Color = t.Accent
	ListHeaderLeft.TextColor3 = t.Text
	ListHeaderRight.TextColor3 = t.Sub

	Footer.TextColor3 = blend(t.Warning, t.Accent, 0.35)

	updateNotifyPill()

	setHoverColors(ThemeButton, ThemeButton.BackgroundColor3, blend(ThemeButton.BackgroundColor3, Color3.fromRGB(255, 255, 255), 0.08))
	setHoverColors(SettingsButton, SettingsButton.BackgroundColor3, blend(SettingsButton.BackgroundColor3, Color3.fromRGB(255, 255, 255), 0.08))
	setHoverColors(Minimize, Minimize.BackgroundColor3, blend(Minimize.BackgroundColor3, Color3.fromRGB(255, 255, 255), 0.10))
	setHoverColors(Close, Close.BackgroundColor3, blend(Close.BackgroundColor3, Color3.fromRGB(255, 255, 255), 0.08))
	setHoverColors(NotifyPill, NotifyPill.BackgroundColor3, blend(NotifyPill.BackgroundColor3, Color3.fromRGB(255, 255, 255), 0.08))
	setHoverColors(BindButton, BindButton.BackgroundColor3, blend(BindButton.BackgroundColor3, Color3.fromRGB(255, 255, 255), 0.08))

	for _, data in pairs(entries) do
		local style = getRoleStyle(data.StoredRole or "", data.StoredRank or 0)

		data.Frame.BackgroundColor3 = t.Card
		data.CardGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, style.soft),
			ColorSequenceKeypoint.new(0.46, t.Card),
			ColorSequenceKeypoint.new(1, t.Card2)
		})
		data.Stroke.Color = style.accent
		data.SideLine.BackgroundColor3 = style.accent
		data.AvatarWrap.BackgroundColor3 = t.Card2
		data.AvatarStroke.Color = style.accent
		data.Name.TextColor3 = t.Text
		data.Role.TextColor3 = style.accent
		data.Meta.TextColor3 = t.Sub
		data.BadgeFrame.BackgroundColor3 = style.soft
		data.BadgeStroke.Color = style.accent
		data.Badge.TextColor3 = style.accent
		data.RankChip.BackgroundColor3 = t.Panel3
		data.RankChipStroke.Color = t.Accent
		data.RankChipText.TextColor3 = t.Text
	end

	buildThemeFX()
end

local function cycleTheme()
	local currentIndex = table.find(ThemeOrder, currentThemeName) or 1
	currentIndex += 1
	if currentIndex > #ThemeOrder then
		currentIndex = 1
	end
	currentThemeName = ThemeOrder[currentIndex]
	ThemeButton.Text = currentThemeName
	applyTheme()
end

local function getAvatar(userId)
	local ok, content = pcall(function()
		return Players:GetUserThumbnailAsync(
			userId,
			Enum.ThumbnailType.HeadShot,
			Enum.ThumbnailSize.Size100x100
		)
	end)

	return ok and content or ""
end

local function removeEntry(player)
	local data = entries[player.UserId]
	if data and data.Frame then
		data.Frame:Destroy()
	end
	entries[player.UserId] = nil
	updateCanvas()
end

local function createEntry(player, role, rank)
	local t = theme()
	local style = getRoleStyle(role, rank)

	local Card = Instance.new("Frame")
	Card.Parent = List
	Card.Name = "U_" .. player.UserId
	Card.Size = UDim2.new(1, -2, 0, 86)
	Card.BackgroundColor3 = t.Card
	Card.BorderSizePixel = 0
	Card.LayoutOrder = -rank
	Card.BackgroundTransparency = 1
	makeCorner(Card, 18)

	local CardStroke = makeStroke(Card, 1.2, 0.12)
	local CardGradient = makeGradient(Card, 0, {
		ColorSequenceKeypoint.new(0, style.soft),
		ColorSequenceKeypoint.new(0.46, t.Card),
		ColorSequenceKeypoint.new(1, t.Card2)
	})

	local SideLine = Instance.new("Frame")
	SideLine.Parent = Card
	SideLine.Size = UDim2.new(0, 6, 1, 0)
	SideLine.BorderSizePixel = 0
	makeCorner(SideLine, 18)

	local AvatarWrap = Instance.new("Frame")
	AvatarWrap.Parent = Card
	AvatarWrap.Size = UDim2.new(0, 52, 0, 52)
	AvatarWrap.Position = UDim2.new(0, 14, 0.5, -26)
	AvatarWrap.BackgroundColor3 = t.Card2
	AvatarWrap.BorderSizePixel = 0
	makeCorner(AvatarWrap, 999)

	local AvatarStroke = makeStroke(AvatarWrap, 1, 0.12)

	local Avatar = Instance.new("ImageLabel")
	Avatar.Parent = AvatarWrap
	Avatar.Size = UDim2.new(1, -4, 1, -4)
	Avatar.Position = UDim2.new(0, 2, 0, 2)
	Avatar.BackgroundTransparency = 1
	Avatar.Image = getAvatar(player.UserId)
	makeCorner(Avatar, 999)

	local Name = Instance.new("TextLabel")
	Name.Parent = Card
	Name.BackgroundTransparency = 1
	Name.Position = UDim2.new(0, 80, 0, 11)
	Name.Size = UDim2.new(1, -178, 0, 20)
	Name.Font = Enum.Font.GothamBold
	Name.Text = player.Name
	Name.TextSize = 13
	Name.TextXAlignment = Enum.TextXAlignment.Left

	local RoleText = Instance.new("TextLabel")
	RoleText.Parent = Card
	RoleText.BackgroundTransparency = 1
	RoleText.Position = UDim2.new(0, 80, 0, 33)
	RoleText.Size = UDim2.new(1, -178, 0, 15)
	RoleText.Font = Enum.Font.GothamSemibold
	RoleText.Text = "[" .. role .. "]"
	RoleText.TextSize = 10
	RoleText.TextXAlignment = Enum.TextXAlignment.Left

	local MetaText = Instance.new("TextLabel")
	MetaText.Parent = Card
	MetaText.BackgroundTransparency = 1
	MetaText.Position = UDim2.new(0, 80, 0, 52)
	MetaText.Size = UDim2.new(1, -178, 0, 13)
	MetaText.Font = Enum.Font.Gotham
	MetaText.Text = "Rütbe " .. tostring(rank) .. " • Canlı algılandı"
	MetaText.TextSize = 9
	MetaText.TextXAlignment = Enum.TextXAlignment.Left

	local BadgeFrame = Instance.new("Frame")
	BadgeFrame.Parent = Card
	BadgeFrame.Size = UDim2.new(0, 88, 0, 26)
	BadgeFrame.Position = UDim2.new(1, -102, 0, 13)
	BadgeFrame.BorderSizePixel = 0
	makeCorner(BadgeFrame, 999)

	local BadgeStroke = makeStroke(BadgeFrame, 1, 0.12)

	local BadgeText = Instance.new("TextLabel")
	BadgeText.Parent = BadgeFrame
	BadgeText.BackgroundTransparency = 1
	BadgeText.Size = UDim2.new(1, -10, 1, 0)
	BadgeText.Position = UDim2.new(0, 5, 0, 0)
	BadgeText.Font = Enum.Font.GothamBold
	BadgeText.Text = style.text
	BadgeText.TextSize = 9
	BadgeText.TextXAlignment = Enum.TextXAlignment.Center

	local RankChip = Instance.new("Frame")
	RankChip.Parent = Card
	RankChip.Size = UDim2.new(0, 88, 0, 22)
	RankChip.Position = UDim2.new(1, -102, 0, 46)
	RankChip.BackgroundColor3 = t.Panel3
	RankChip.BorderSizePixel = 0
	makeCorner(RankChip, 999)

	local RankChipStroke = makeStroke(RankChip, 1, 0.55)

	local RankChipText = Instance.new("TextLabel")
	RankChipText.Parent = RankChip
	RankChipText.BackgroundTransparency = 1
	RankChipText.Size = UDim2.new(1, -10, 1, 0)
	RankChipText.Position = UDim2.new(0, 5, 0, 0)
	RankChipText.Font = Enum.Font.GothamBold
	RankChipText.Text = "RÜTBE " .. tostring(rank)
	RankChipText.TextSize = 9
	RankChipText.TextXAlignment = Enum.TextXAlignment.Center

	TweenService:Create(Card, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0
	}):Play()

	entries[player.UserId] = {
		Frame = Card,
		CardGradient = CardGradient,
		Name = Name,
		Role = RoleText,
		Meta = MetaText,
		AvatarWrap = AvatarWrap,
		AvatarStroke = AvatarStroke,
		Badge = BadgeText,
		BadgeFrame = BadgeFrame,
		BadgeStroke = BadgeStroke,
		Stroke = CardStroke,
		SideLine = SideLine,
		StoredRole = role,
		StoredRank = rank,
		RankChip = RankChip,
		RankChipStroke = RankChipStroke,
		RankChipText = RankChipText,
	}

	applyTheme()
end

local function addOrUpdateEntry(player, role, rank)
	local data = entries[player.UserId]

	if data and data.Frame then
		data.Frame.LayoutOrder = -rank
		data.Name.Text = player.Name
		data.Role.Text = "[" .. role .. "]"
		data.Meta.Text = "Rütbe " .. tostring(rank) .. " • Canlı algılandı"
		data.StoredRole = role
		data.StoredRank = rank
		data.RankChipText.Text = "RÜTBE " .. tostring(rank)

		local avatarImage = data.AvatarWrap and data.AvatarWrap:FindFirstChildOfClass("ImageLabel")
		if avatarImage then
			avatarImage.Image = getAvatar(player.UserId)
		end
	else
		createEntry(player, role, rank)
	end

	applyTheme()
	updateCanvas()
end

local function fetchGroupData(player)
	local okRole, role = pcall(function()
		return player:GetRoleInGroup(GROUP_ID)
	end)

	local okRank, rank = pcall(function()
		return player:GetRankInGroup(GROUP_ID)
	end)

	if not okRole then role = "Unknown" end
	if not okRank then rank = 0 end

	local cleanRole, lowerRole = normalizeRole(role)
	return cleanRole, lowerRole, tonumber(rank) or 0
end

local function shouldShow(roleLower, rank)
	if rank < MIN_STAFF_RANK then
		return false
	end

	if BLACKLIST_ROLES[roleLower] then
		return false
	end

	if roleLower == "guest" or rank <= 0 then
		return false
	end

	return true
end

local function checkPlayer(player, notifyJoin)
	if player == Players.LocalPlayer then
		return
	end

	task.spawn(function()
		task.wait(1.5)

		local role, roleLower, rank = fetchGroupData(player)

		if shouldShow(roleLower, rank) then
			local isNew = not entries[player.UserId]
			addOrUpdateEntry(player, role, rank)

			if notifyJoin and isNew then
				safeNotify("Yetkili oyuna girdi", player.Name .. " • " .. role .. " • " .. tostring(rank), 4)
			end
		else
			removeEntry(player)
		end
	end)
end

local function toggleSettings(open)
	if open == nil then
		open = not SettingsPanel.Visible or SettingsPanel.Size.X.Offset == 0
	end

	SettingsPanel.Visible = true

	if open then
		TweenService:Create(SettingsPanel, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 184, 0, 150)
		}):Play()
	else
		TweenService:Create(SettingsPanel, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 0, 0, 150)
		}):Play()
		task.delay(0.2, function()
			if SettingsPanel and SettingsPanel.Parent and SettingsPanel.Size.X.Offset <= 2 then
				SettingsPanel.Visible = false
			end
		end)
	end
end

registerHover(ThemeButton)
registerHover(SettingsButton)
registerHover(Minimize)
registerHover(Close)
registerHover(NotifyPill)
registerHover(BindButton)

ThemeButton.MouseButton1Click:Connect(function()
	cycleTheme()
end)

SettingsButton.MouseButton1Click:Connect(function()
	local open = not SettingsPanel.Visible or SettingsPanel.Size.X.Offset == 0
	toggleSettings(open)
end)

NotifyPill.MouseButton1Click:Connect(function()
	joinNotifyEnabled = not joinNotifyEnabled
	updateNotifyPill()
end)

BindButton.MouseButton1Click:Connect(function()
	bindingMode = true
	BindButton.Text = "Bir tuşa bas..."
end)

Minimize.MouseButton1Click:Connect(function()
	minimized = not minimized

	if minimized then
		Minimize.Text = "+"
		ListHolder.Visible = false
		Footer.Visible = false
		SettingsPanel.Visible = false
		TweenService:Create(Main, TweenInfo.new(0.22), {Size = MIN_MAIN_SIZE}):Play()
		TweenService:Create(Shadow, TweenInfo.new(0.22), {Size = UDim2.new(0, 420, 0, 230)}):Play()
		TweenService:Create(ShadowGlow, TweenInfo.new(0.22), {Size = UDim2.new(0, 440, 0, 250)}):Play()
		TweenService:Create(Holder, TweenInfo.new(0.22), {Size = MIN_HOLDER_SIZE}):Play()
	else
		Minimize.Text = "–"
		TweenService:Create(Main, TweenInfo.new(0.22), {Size = FULL_MAIN_SIZE}):Play()
		TweenService:Create(Shadow, TweenInfo.new(0.22), {Size = UDim2.new(0, 420, 0, 550)}):Play()
		TweenService:Create(ShadowGlow, TweenInfo.new(0.22), {Size = UDim2.new(0, 440, 0, 570)}):Play()
		TweenService:Create(Holder, TweenInfo.new(0.22), {Size = FULL_HOLDER_SIZE}):Play()

		task.delay(0.1, function()
			if Main and Main.Parent then
				ListHolder.Visible = true
				Footer.Visible = true
			end
		end)
	end
end)

Close.MouseButton1Click:Connect(function()
	Holder:Destroy()
end)

UserInputService.InputBegan:Connect(function(input, processed)
	if bindingMode and not processed then
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.Unknown then
			toggleBind = {
				kind = "KeyCode",
				value = input.KeyCode
			}
			bindingMode = false
			BindButton.Text = "Tuş Seç: " .. inputToText(toggleBind)
			return
		elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
			toggleBind = {
				kind = "MouseButton2",
				value = Enum.UserInputType.MouseButton2
			}
			bindingMode = false
			BindButton.Text = "Tuş Seç: " .. inputToText(toggleBind)
			return
		elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
			toggleBind = {
				kind = "MouseButton3",
				value = Enum.UserInputType.MouseButton3
			}
			bindingMode = false
			BindButton.Text = "Tuş Seç: " .. inputToText(toggleBind)
			return
		end
	end

	if processed then
		return
	end

	if matchesToggleInput(input) then
		uiOpen = not uiOpen
		Holder.Visible = uiOpen
	end
end)

Players.PlayerAdded:Connect(function(player)
	checkPlayer(player, true)
end)

Players.PlayerRemoving:Connect(function(player)
	removeEntry(player)
end)

for _, player in ipairs(Players:GetPlayers()) do
	checkPlayer(player, false)
end

task.spawn(function()
	while Holder.Parent do
		refreshCountdown = REFRESH_EVERY
		setCountdownText()

		while refreshCountdown > 0 and Holder.Parent do
			task.wait(1)
			refreshCountdown -= 1
			setCountdownText()
		end

		if not Holder.Parent then
			break
		end

		for _, player in ipairs(Players:GetPlayers()) do
			checkPlayer(player, false)
		end
	end
end)

task.spawn(function()
	while Holder.Parent do
		TweenService:Create(HeaderShine, TweenInfo.new(1.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.new(1.16, 0, -0.1, 0)
		}):Play()
		task.wait(1.85)
		if not Holder.Parent then
			break
		end
		HeaderShine.Position = UDim2.new(-0.24, 0, -0.1, 0)
		task.wait(1.1)
	end
end)

task.spawn(function()
	while Holder.Parent do
		local t = theme()
		TweenService:Create(ShadowGlow, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			BackgroundTransparency = 0.82
		}):Play()
		task.wait(1.2)
		if not Holder.Parent then
			break
		end
		ShadowGlow.BackgroundColor3 = t.Shadow
		TweenService:Create(ShadowGlow, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			BackgroundTransparency = 0.68
		}):Play()
		task.wait(1.2)
	end
end)

RunService.RenderStepped:Connect(function(dt)
	if not Holder.Parent then
		return
	end

	animationTick += dt
	local t = theme()
	local pulse = (math.sin(animationTick * 2) + 1) / 2

	CounterDot.BackgroundColor3 = blend(t.Good, Color3.fromRGB(255, 255, 255), pulse * 0.25)
	AccentLine.BackgroundColor3 = blend(t.Accent, t.Warning, pulse * 0.35)
end)

applyTheme()
setCountdownText()
toggleSettings(false)

local startPos = Holder.Position
Holder.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + 28, startPos.Y.Scale, startPos.Y.Offset)
Main.BackgroundTransparency = 1
Header.BackgroundTransparency = 1
CounterWrap.BackgroundTransparency = 1
ListHolder.BackgroundTransparency = 1

TweenService:Create(Holder, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Position = startPos
}):Play()

TweenService:Create(Main, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	BackgroundTransparency = 0
}):Play()

task.delay(0.04, function()
	if Header and Header.Parent then
		TweenService:Create(Header, TweenInfo.new(0.22), {
			BackgroundTransparency = 0
		}):Play()
	end
	if CounterWrap and CounterWrap.Parent then
		TweenService:Create(CounterWrap, TweenInfo.new(0.24), {
			BackgroundTransparency = 0
		}):Play()
	end
	if ListHolder and ListHolder.Parent then
		TweenService:Create(ListHolder, TweenInfo.new(0.26), {
			BackgroundTransparency = 0
		}):Play()
	end
end)

safeNotify("HiraCode Scripts", "Ultimate panel hazır.", 3)
