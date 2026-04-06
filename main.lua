local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

local GUI_PARENT = (gethui and gethui()) or CoreGui
local GROUP_ID = 186105853

local MIN_STAFF_RANK = 51
local REFRESH_EVERY = 8
local SHOW_JOIN_NOTIFY = true

local BLACKLIST_ROLES = {
	["tester"] = true,
}

local GUI_NAME = "HiraCode_EsenyurtStaff_Elite"
local entries = {}
local minimized = false
local refreshCountdown = REFRESH_EVERY

local function trim(s)
	return tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function normalizeRole(role)
	local clean = trim(role)
	return clean, string.lower(clean)
end

local function getRoleStyle(role, rank)
	local roleLower = string.lower(role or "")

	if roleLower == "owner" or rank >= 255 then
		return {
			accent = Color3.fromRGB(255, 70, 70),
			soft = Color3.fromRGB(70, 20, 20),
			text = "OWNER"
		}
	elseif roleLower == "founder" then
		return {
			accent = Color3.fromRGB(255, 190, 60),
			soft = Color3.fromRGB(70, 45, 12),
			text = "FOUNDER"
		}
	elseif roleLower == "head developer" then
		return {
			accent = Color3.fromRGB(188, 110, 255),
			soft = Color3.fromRGB(45, 25, 70),
			text = "HEAD DEV"
		}
	elseif roleLower == "developer" then
		return {
			accent = Color3.fromRGB(130, 130, 255),
			soft = Color3.fromRGB(25, 30, 70),
			text = "DEVELOPER"
		}
	elseif roleLower == "management" then
		return {
			accent = Color3.fromRGB(255, 145, 65),
			soft = Color3.fromRGB(75, 35, 15),
			text = "MANAGEMENT"
		}
	elseif roleLower == "head moderator" then
		return {
			accent = Color3.fromRGB(80, 210, 255),
			soft = Color3.fromRGB(15, 45, 70),
			text = "HEAD MOD"
		}
	else
		return {
			accent = Color3.fromRGB(255, 100, 100),
			soft = Color3.fromRGB(65, 20, 20),
			text = "STAFF"
		}
	end
end

local function safeNotify(title, text, duration)
	if not SHOW_JOIN_NOTIFY then
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

local old = GUI_PARENT:FindFirstChild(GUI_NAME)
if old then
	old:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = GUI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = GUI_PARENT

local Shadow = Instance.new("Frame")
Shadow.Parent = ScreenGui
Shadow.Size = UDim2.new(0, 360, 0, 475)
Shadow.Position = UDim2.new(1, -384, 0.15, 5)
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.4
Shadow.BorderSizePixel = 0
Instance.new("UICorner", Shadow).CornerRadius = UDim.new(0, 20)

local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.Size = UDim2.new(0, 352, 0, 468)
Main.Position = UDim2.new(1, -380, 0.15, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = Main
MainStroke.Thickness = 1.6
MainStroke.Color = Color3.fromRGB(255, 90, 90)
MainStroke.Transparency = 0.08

local MainGradient = Instance.new("UIGradient")
MainGradient.Parent = Main
MainGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 12, 18)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 10, 14)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 10, 12))
})
MainGradient.Rotation = 90

local Header = Instance.new("Frame")
Header.Parent = Main
Header.Size = UDim2.new(1, 0, 0, 88)
Header.BackgroundColor3 = Color3.fromRGB(24, 8, 10)
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 20)

local HeaderFix = Instance.new("Frame")
HeaderFix.Parent = Header
HeaderFix.Size = UDim2.new(1, 0, 0, 22)
HeaderFix.Position = UDim2.new(0, 0, 1, -22)
HeaderFix.BackgroundColor3 = Header.BackgroundColor3
HeaderFix.BorderSizePixel = 0

local HeaderGradient = Instance.new("UIGradient")
HeaderGradient.Parent = Header
HeaderGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(95, 8, 8)),
	ColorSequenceKeypoint.new(0.55, Color3.fromRGB(35, 12, 22)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 14, 28))
})
HeaderGradient.Rotation = 18

local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 18, 0, 12)
Title.Size = UDim2.new(1, -110, 0, 24)
Title.Font = Enum.Font.GothamBlack
Title.Text = "AKTİF YETKİLİLƏR"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

local Subtitle = Instance.new("TextLabel")
Subtitle.Parent = Header
Subtitle.BackgroundTransparency = 1
Subtitle.Position = UDim2.new(0, 18, 0, 38)
Subtitle.Size = UDim2.new(1, -130, 0, 18)
Subtitle.Font = Enum.Font.Gotham
Subtitle.Text = "Robertp "
Subtitle.TextColor3 = Color3.fromRGB(255, 205, 205)
Subtitle.TextSize = 11
Subtitle.TextXAlignment = Enum.TextXAlignment.Left

local RefreshText = Instance.new("TextLabel")
RefreshText.Parent = Header
RefreshText.BackgroundTransparency = 1
RefreshText.Position = UDim2.new(0, 18, 0, 58)
RefreshText.Size = UDim2.new(1, -130, 0, 16)
RefreshText.Font = Enum.Font.GothamBold
RefreshText.Text = "Auto Refresh: " .. REFRESH_EVERY .. "s"
RefreshText.TextColor3 = Color3.fromRGB(255, 180, 125)
RefreshText.TextSize = 10
RefreshText.TextXAlignment = Enum.TextXAlignment.Left

local Minimize = Instance.new("TextButton")
Minimize.Parent = Header
Minimize.Size = UDim2.new(0, 30, 0, 30)
Minimize.Position = UDim2.new(1, -76, 0, 14)
Minimize.BackgroundColor3 = Color3.fromRGB(255, 170, 60)
Minimize.Text = "–"
Minimize.TextColor3 = Color3.fromRGB(255,255,255)
Minimize.TextSize = 18
Minimize.Font = Enum.Font.GothamBold
Minimize.BorderSizePixel = 0
Instance.new("UICorner", Minimize).CornerRadius = UDim.new(1, 0)

local Close = Instance.new("TextButton")
Close.Parent = Header
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -40, 0, 14)
Close.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
Close.Text = "✕"
Close.TextColor3 = Color3.fromRGB(255,255,255)
Close.TextSize = 14
Close.Font = Enum.Font.GothamBold
Close.BorderSizePixel = 0
Instance.new("UICorner", Close).CornerRadius = UDim.new(1, 0)

local CounterWrap = Instance.new("Frame")
CounterWrap.Parent = Main
CounterWrap.Position = UDim2.new(0, 16, 0, 100)
CounterWrap.Size = UDim2.new(1, -32, 0, 38)
CounterWrap.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
CounterWrap.BorderSizePixel = 0
Instance.new("UICorner", CounterWrap).CornerRadius = UDim.new(0, 999)

local CounterStroke = Instance.new("UIStroke")
CounterStroke.Parent = CounterWrap
CounterStroke.Thickness = 1
CounterStroke.Color = Color3.fromRGB(255, 100, 100)
CounterStroke.Transparency = 0.3

local CounterDot = Instance.new("Frame")
CounterDot.Parent = CounterWrap
CounterDot.Size = UDim2.new(0, 11, 0, 11)
CounterDot.Position = UDim2.new(0, 13, 0.5, -5)
CounterDot.BackgroundColor3 = Color3.fromRGB(255, 82, 82)
CounterDot.BorderSizePixel = 0
Instance.new("UICorner", CounterDot).CornerRadius = UDim.new(1, 0)

local CounterText = Instance.new("TextLabel")
CounterText.Parent = CounterWrap
CounterText.BackgroundTransparency = 1
CounterText.Position = UDim2.new(0, 31, 0, 0)
CounterText.Size = UDim2.new(0.5, -20, 1, 0)
CounterText.Font = Enum.Font.GothamBold
CounterText.Text = "Yetkili sayı: 0"
CounterText.TextColor3 = Color3.fromRGB(245,245,245)
CounterText.TextSize = 12
CounterText.TextXAlignment = Enum.TextXAlignment.Left

local CountdownText = Instance.new("TextLabel")
CountdownText.Parent = CounterWrap
CountdownText.BackgroundTransparency = 1
CountdownText.Position = UDim2.new(0.5, 0, 0, 0)
CountdownText.Size = UDim2.new(0.5, -12, 1, 0)
CountdownText.Font = Enum.Font.Gotham
CountdownText.Text = "Yenilənmə: " .. refreshCountdown .. "s"
CountdownText.TextColor3 = Color3.fromRGB(255, 195, 140)
CountdownText.TextSize = 11
CountdownText.TextXAlignment = Enum.TextXAlignment.Right

local ListHolder = Instance.new("Frame")
ListHolder.Parent = Main
ListHolder.Position = UDim2.new(0, 16, 0, 148)
ListHolder.Size = UDim2.new(1, -32, 1, -204)
ListHolder.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
ListHolder.BorderSizePixel = 0
Instance.new("UICorner", ListHolder).CornerRadius = UDim.new(0, 16)

local ListHolderStroke = Instance.new("UIStroke")
ListHolderStroke.Parent = ListHolder
ListHolderStroke.Thickness = 1
ListHolderStroke.Color = Color3.fromRGB(255, 100, 100)
ListHolderStroke.Transparency = 0.45

local List = Instance.new("ScrollingFrame")
List.Parent = ListHolder
List.Position = UDim2.new(0, 8, 0, 8)
List.Size = UDim2.new(1, -16, 1, -16)
List.BackgroundTransparency = 1
List.BorderSizePixel = 0
List.ScrollBarThickness = 4
List.CanvasSize = UDim2.new(0, 0, 0, 0)

local Layout = Instance.new("UIListLayout")
Layout.Parent = List
Layout.Padding = UDim.new(0, 8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

local Footer = Instance.new("TextLabel")
Footer.Parent = Main
Footer.BackgroundTransparency = 1
Footer.Position = UDim2.new(0, 16, 1, -38)
Footer.Size = UDim2.new(1, -32, 0, 18)
Footer.Font = Enum.Font.GothamBold
Footer.Text = "Developed By HiraCode Scripts"
Footer.TextColor3 = Color3.fromRGB(255, 180, 110)
Footer.TextSize = 11
Footer.TextXAlignment = Enum.TextXAlignment.Center

local function updateCanvas()
	local count = 0
	for _ in pairs(entries) do
		count += 1
	end
	CounterText.Text = "Yetkili sayı: " .. count
	List.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 6)
end

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

local function setCountdownText()
	CountdownText.Text = "Yenilənmə: " .. tostring(refreshCountdown) .. "s"
	RefreshText.Text = "Auto Refresh: " .. tostring(refreshCountdown) .. "s"
end

local function removeEntry(player)
	local data = entries[player.UserId]
	if data and data.Frame then
		data.Frame:Destroy()
	end
	entries[player.UserId] = nil
	updateCanvas()
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

local function createEntry(player, role, rank)
	local style = getRoleStyle(role, rank)

	local Card = Instance.new("Frame")
	Card.Parent = List
	Card.Name = "U_" .. player.UserId
	Card.Size = UDim2.new(1, -2, 0, 74)
	Card.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
	Card.BorderSizePixel = 0
	Card.LayoutOrder = -rank
	Card.BackgroundTransparency = 1
	Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 14)

	local CardStroke = Instance.new("UIStroke")
	CardStroke.Parent = Card
	CardStroke.Thickness = 1.2
	CardStroke.Color = style.accent
	CardStroke.Transparency = 0.12

	local CardGradient = Instance.new("UIGradient")
	CardGradient.Parent = Card
	CardGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, style.soft),
		ColorSequenceKeypoint.new(0.4, Color3.fromRGB(24, 24, 30)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 24))
	})
	CardGradient.Rotation = 0

	local SideLine = Instance.new("Frame")
	SideLine.Parent = Card
	SideLine.Size = UDim2.new(0, 5, 1, 0)
	SideLine.BackgroundColor3 = style.accent
	SideLine.BorderSizePixel = 0
	Instance.new("UICorner", SideLine).CornerRadius = UDim.new(0, 14)

	local Avatar = Instance.new("ImageLabel")
	Avatar.Parent = Card
	Avatar.Size = UDim2.new(0, 46, 0, 46)
	Avatar.Position = UDim2.new(0, 16, 0.5, -23)
	Avatar.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
	Avatar.Image = getAvatar(player.UserId)
	Avatar.BorderSizePixel = 0
	Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)

	local AvatarStroke = Instance.new("UIStroke")
	AvatarStroke.Parent = Avatar
	AvatarStroke.Thickness = 1
	AvatarStroke.Color = style.accent
	AvatarStroke.Transparency = 0.18

	local Name = Instance.new("TextLabel")
	Name.Parent = Card
	Name.BackgroundTransparency = 1
	Name.Position = UDim2.new(0, 74, 0, 12)
	Name.Size = UDim2.new(1, -154, 0, 20)
	Name.Font = Enum.Font.GothamBold
	Name.Text = player.Name
	Name.TextColor3 = Color3.fromRGB(255,255,255)
	Name.TextSize = 14
	Name.TextXAlignment = Enum.TextXAlignment.Left

	local RoleText = Instance.new("TextLabel")
	RoleText.Parent = Card
	RoleText.BackgroundTransparency = 1
	RoleText.Position = UDim2.new(0, 74, 0, 36)
	RoleText.Size = UDim2.new(1, -154, 0, 16)
	RoleText.Font = Enum.Font.GothamSemibold
	RoleText.Text = "[" .. role .. "] • Rank " .. rank
	RoleText.TextColor3 = style.accent
	RoleText.TextSize = 11
	RoleText.TextXAlignment = Enum.TextXAlignment.Left

	local Badge = Instance.new("Frame")
	Badge.Parent = Card
	Badge.Size = UDim2.new(0, 86, 0, 26)
	Badge.Position = UDim2.new(1, -98, 0.5, -13)
	Badge.BackgroundColor3 = style.soft
	Badge.BorderSizePixel = 0
	Instance.new("UICorner", Badge).CornerRadius = UDim.new(1, 0)

	local BadgeStroke = Instance.new("UIStroke")
	BadgeStroke.Parent = Badge
	BadgeStroke.Thickness = 1
	BadgeStroke.Color = style.accent
	BadgeStroke.Transparency = 0.18

	local BadgeText = Instance.new("TextLabel")
	BadgeText.Parent = Badge
	BadgeText.BackgroundTransparency = 1
	BadgeText.Size = UDim2.new(1, -10, 1, 0)
	BadgeText.Position = UDim2.new(0, 5, 0, 0)
	BadgeText.Font = Enum.Font.GothamBold
	BadgeText.Text = style.text
	BadgeText.TextColor3 = style.accent
	BadgeText.TextSize = 10
	BadgeText.TextXAlignment = Enum.TextXAlignment.Center

	TweenService:Create(Card, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()

	entries[player.UserId] = {
		Frame = Card,
		Name = Name,
		Role = RoleText,
		Avatar = Avatar,
		Badge = BadgeText,
		Stroke = CardStroke,
		SideLine = SideLine,
	}
end

local function addOrUpdateEntry(player, role, rank)
	local style = getRoleStyle(role, rank)
	local data = entries[player.UserId]

	if data and data.Frame then
		data.Frame.LayoutOrder = -rank
		data.Name.Text = player.Name
		data.Role.Text = "[" .. role .. "] • Rank " .. rank
		data.Role.TextColor3 = style.accent
		data.Badge.Text = style.text
		data.Badge.TextColor3 = style.accent
		data.Stroke.Color = style.accent
		data.SideLine.BackgroundColor3 = style.accent
		data.Avatar.Image = getAvatar(player.UserId)
	else
		createEntry(player, role, rank)
	end

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

Minimize.MouseButton1Click:Connect(function()
	minimized = not minimized

	if minimized then
		Minimize.Text = "+"
		ListHolder.Visible = false
		Footer.Visible = false

		TweenService:Create(Main, TweenInfo.new(0.22), {Size = UDim2.new(0, 352, 0, 146)}):Play()
		TweenService:Create(Shadow, TweenInfo.new(0.22), {Size = UDim2.new(0, 360, 0, 153)}):Play()
	else
		Minimize.Text = "–"

		TweenService:Create(Main, TweenInfo.new(0.22), {Size = UDim2.new(0, 352, 0, 468)}):Play()
		TweenService:Create(Shadow, TweenInfo.new(0.22), {Size = UDim2.new(0, 360, 0, 475)}):Play()

		task.delay(0.1, function()
			if Main and Main.Parent then
				ListHolder.Visible = true
				Footer.Visible = true
			end
		end)
	end
end)

Close.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
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
	while ScreenGui.Parent do
		refreshCountdown = REFRESH_EVERY
		setCountdownText()

		while refreshCountdown > 0 and ScreenGui.Parent do
			task.wait(1)
			refreshCountdown -= 1
			setCountdownText()
		end

		if not ScreenGui.Parent then
			break
		end

		for _, player in ipairs(Players:GetPlayers()) do
			checkPlayer(player, false)
		end
	end
end)

safeNotify("HiraCode Scripts", "Elite staff tracker hazır.", 3)
