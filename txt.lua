-- ============================================================
-- ROBLOX BUY ITEM GUI + CONTROL PANEL
-- LocalScript — Place inside StarterPlayerScripts or StarterGui
-- ============================================================

local Players        = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService   = game:GetService("TweenService")
local RunService     = game:GetService("RunService")

local LocalPlayer    = Players.LocalPlayer
local PlayerGui      = LocalPlayer:WaitForChild("PlayerGui")

-- ============================================================
-- STATE
-- ============================================================
local balance        = 66245          -- default balance
local ITEM_COST      = 7499
local selectedPlayer = ""             -- chosen from dropdown
local keybind        = Enum.KeyCode.F -- default keybind
local guiOpen        = false

-- ============================================================
-- HELPER: format number with commas  e.g. 66245 → "66,245"
-- ============================================================
local function formatNumber(n)
	local s = tostring(math.floor(n))
	local result = ""
	local count  = 0
	for i = #s, 1, -1 do
		if count > 0 and count % 3 == 0 then result = "," .. result end
		result = s:sub(i, i) .. result
		count  = count + 1
	end
	return result
end

-- ============================================================
-- BUILD BUY GUI  (ScreenGui  →  MainFrame)
-- ============================================================
local BuyGui       = Instance.new("ScreenGui")
BuyGui.Name        = "BuyItemGui"
BuyGui.ResetOnSpawn = false
BuyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
BuyGui.Enabled     = false   -- starts hidden
BuyGui.Parent      = PlayerGui

-- Dark semi-transparent backdrop
local Backdrop     = Instance.new("Frame")
Backdrop.Name      = "Backdrop"
Backdrop.Size      = UDim2.new(1, 0, 1, 0)
Backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Backdrop.BackgroundTransparency = 0.45
Backdrop.BorderSizePixel = 0
Backdrop.ZIndex    = 1
Backdrop.Parent    = BuyGui

-- Main popup card  (white, rounded)
local MainFrame    = Instance.new("Frame")
MainFrame.Name     = "MainFrame"
MainFrame.Size     = UDim2.new(0, 360, 0, 200)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BorderSizePixel  = 0
MainFrame.ZIndex   = 2
MainFrame.ClipsDescendants = false
MainFrame.Parent   = BuyGui

local MainCorner   = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent  = MainFrame

-- Sweep / shimmer overlay (clips inside card)
local SweepHolder  = Instance.new("Frame")
SweepHolder.Name   = "SweepHolder"
SweepHolder.Size   = UDim2.new(1, 0, 1, 0)
SweepHolder.BackgroundTransparency = 1
SweepHolder.ClipsDescendants = true
SweepHolder.ZIndex = 3
SweepHolder.Parent = MainFrame

local SweepBar     = Instance.new("Frame")
SweepBar.Name      = "SweepBar"
SweepBar.Size      = UDim2.new(0, 80, 1, 0)
SweepBar.Position  = UDim2.new(0, -90, 0, 0)    -- starts off-left
SweepBar.BackgroundColor3 = Color3.fromRGB(200, 220, 255)
SweepBar.BackgroundTransparency = 0.55
SweepBar.BorderSizePixel = 0
SweepBar.ZIndex    = 3
SweepBar.Parent    = SweepHolder

local SweepGrad    = Instance.new("UIGradient")
SweepGrad.Rotation = 0
SweepGrad.Color    = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.new(1,1,1)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 210, 255)),
	ColorSequenceKeypoint.new(1, Color3.new(1,1,1)),
})
SweepGrad.Parent   = SweepBar

-- Title bar row
local TitleRow     = Instance.new("Frame")
TitleRow.Name      = "TitleRow"
TitleRow.Size      = UDim2.new(1, 0, 0, 40)
TitleRow.Position  = UDim2.new(0,0,0,0)
TitleRow.BackgroundTransparency = 1
TitleRow.ZIndex    = 4
TitleRow.Parent    = MainFrame

local TitleLabel   = Instance.new("TextLabel")
TitleLabel.Name    = "TitleLabel"
TitleLabel.Size    = UDim2.new(1, -70, 1, 0)
TitleLabel.Position= UDim2.new(0, 14, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text    = "Buy item"
TitleLabel.Font    = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.TextColor3 = Color3.fromRGB(30, 30, 30)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex  = 4
TitleLabel.Parent  = TitleRow

-- Robux balance (top-right of title row)
local BalanceLabel = Instance.new("TextLabel")
BalanceLabel.Name  = "BalanceLabel"
BalanceLabel.Size  = UDim2.new(0, 100, 1, 0)
BalanceLabel.Position = UDim2.new(1, -138, 0, 0)
BalanceLabel.BackgroundTransparency = 1
BalanceLabel.Font  = Enum.Font.GothamBold
BalanceLabel.TextSize = 15
BalanceLabel.TextColor3 = Color3.fromRGB(30, 30, 30)
BalanceLabel.TextXAlignment = Enum.TextXAlignment.Right
BalanceLabel.ZIndex = 4
BalanceLabel.Parent = TitleRow

-- Close X button
local CloseBtn     = Instance.new("TextButton")
CloseBtn.Name      = "CloseBtn"
CloseBtn.Size      = UDim2.new(0, 28, 0, 28)
CloseBtn.Position  = UDim2.new(1, -36, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.Text      = "✕"
CloseBtn.Font      = Enum.Font.GothamBold
CloseBtn.TextSize  = 14
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex    = 5
CloseBtn.Parent    = TitleRow

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0,6)
CloseBtnCorner.Parent = CloseBtn

-- Divider
local Divider      = Instance.new("Frame")
Divider.Size       = UDim2.new(1, 0, 0, 1)
Divider.Position   = UDim2.new(0,0,0,40)
Divider.BackgroundColor3 = Color3.fromRGB(220,220,220)
Divider.BorderSizePixel = 0
Divider.ZIndex     = 4
Divider.Parent     = MainFrame

-- Item row
local ItemRow      = Instance.new("Frame")
ItemRow.Name       = "ItemRow"
ItemRow.Size       = UDim2.new(1, 0, 0, 80)
ItemRow.Position   = UDim2.new(0, 0, 0, 41)
ItemRow.BackgroundTransparency = 1
ItemRow.ZIndex     = 4
ItemRow.Parent     = MainFrame

-- Item icon (HD placeholder square with dark bg)
local ItemIcon     = Instance.new("Frame")
ItemIcon.Size      = UDim2.new(0, 56, 0, 56)
ItemIcon.Position  = UDim2.new(0, 14, 0.5, -28)
ItemIcon.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
ItemIcon.BorderSizePixel  = 0
ItemIcon.ZIndex    = 5
ItemIcon.Parent    = ItemRow

local ItemIconCorner = Instance.new("UICorner")
ItemIconCorner.CornerRadius = UDim.new(0, 6)
ItemIconCorner.Parent = ItemIcon

-- HD label on icon
local ItemIconText = Instance.new("TextLabel")
ItemIconText.Size  = UDim2.new(1,0,0,16)
ItemIconText.Position = UDim2.new(0,0,0,4)
ItemIconText.BackgroundTransparency = 1
ItemIconText.Text  = "HD"
ItemIconText.Font  = Enum.Font.GothamBold
ItemIconText.TextSize = 18
ItemIconText.TextColor3 = Color3.fromRGB(255,255,255)
ItemIconText.ZIndex = 6
ItemIconText.Parent = ItemIcon

-- Item name + price
local ItemInfo     = Instance.new("Frame")
ItemInfo.Size      = UDim2.new(1, -84, 1, 0)
ItemInfo.Position  = UDim2.new(0, 80, 0, 0)
ItemInfo.BackgroundTransparency = 1
ItemInfo.ZIndex    = 4
ItemInfo.Parent    = ItemRow

local ItemName     = Instance.new("TextLabel")
ItemName.Size      = UDim2.new(1,0,0,28)
ItemName.Position  = UDim2.new(0,0,0,14)
ItemName.BackgroundTransparency = 1
ItemName.Text      = "[GIFT] ADMIN PANEL"
ItemName.Font      = Enum.Font.GothamBold
ItemName.TextSize  = 15
ItemName.TextColor3 = Color3.fromRGB(30,30,30)
ItemName.TextXAlignment = Enum.TextXAlignment.Left
ItemName.ZIndex    = 5
ItemName.Parent    = ItemInfo

local ItemPrice    = Instance.new("TextLabel")
ItemPrice.Name     = "ItemPrice"
ItemPrice.Size     = UDim2.new(1,0,0,22)
ItemPrice.Position = UDim2.new(0,0,0,42)
ItemPrice.BackgroundTransparency = 1
ItemPrice.Text     = "\u{E002} 7,499"
ItemPrice.Font     = Enum.Font.Gotham
ItemPrice.TextSize = 14
ItemPrice.TextColor3 = Color3.fromRGB(80,80,80)
ItemPrice.TextXAlignment = Enum.TextXAlignment.Left
ItemPrice.ZIndex   = 5
ItemPrice.Parent   = ItemInfo

-- Divider 2
local Divider2     = Instance.new("Frame")
Divider2.Size      = UDim2.new(1, 0, 0, 1)
Divider2.Position  = UDim2.new(0, 0, 0, 121)
Divider2.BackgroundColor3 = Color3.fromRGB(220,220,220)
Divider2.BorderSizePixel = 0
Divider2.ZIndex    = 4
Divider2.Parent    = MainFrame

-- Buy Button
local BuyBtn       = Instance.new("TextButton")
BuyBtn.Name        = "BuyBtn"
BuyBtn.Size        = UDim2.new(1, -28, 0, 44)
BuyBtn.Position    = UDim2.new(0, 14, 0, 130)
BuyBtn.BackgroundColor3 = Color3.fromRGB(100, 140, 220)   -- light blue (pre-sweep = locked)
BuyBtn.Text        = "Buy"
BuyBtn.Font        = Enum.Font.GothamBold
BuyBtn.TextSize    = 16
BuyBtn.TextColor3  = Color3.fromRGB(255,255,255)
BuyBtn.BorderSizePixel = 0
BuyBtn.ZIndex      = 4
BuyBtn.Active      = false     -- locked until sweep completes
BuyBtn.Parent      = MainFrame

local BuyBtnCorner = Instance.new("UICorner")
BuyBtnCorner.CornerRadius = UDim.new(0, 8)
BuyBtnCorner.Parent = BuyBtn

-- ============================================================
-- BUILD SUCCESS POPUP  (inside BuyGui, hidden initially)
-- ============================================================
local SuccessFrame = Instance.new("Frame")
SuccessFrame.Name  = "SuccessFrame"
SuccessFrame.Size  = UDim2.new(0, 360, 0, 170)
SuccessFrame.Position = UDim2.new(0.5, -180, 0.5, -85)
SuccessFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
SuccessFrame.BorderSizePixel  = 0
SuccessFrame.Visible = false
SuccessFrame.ZIndex  = 10
SuccessFrame.Parent  = BuyGui

local SuccessCorner = Instance.new("UICorner")
SuccessCorner.CornerRadius = UDim.new(0,8)
SuccessCorner.Parent = SuccessFrame

-- Success title row
local STitleRow    = Instance.new("Frame")
STitleRow.Size     = UDim2.new(1,0,0,40)
STitleRow.BackgroundTransparency = 1
STitleRow.ZIndex   = 11
STitleRow.Parent   = SuccessFrame

local STitleLabel  = Instance.new("TextLabel")
STitleLabel.Size   = UDim2.new(1,-40,1,0)
STitleLabel.Position = UDim2.new(0,14,0,0)
STitleLabel.BackgroundTransparency = 1
STitleLabel.Text   = "Purchase completed"
STitleLabel.Font   = Enum.Font.GothamBold
STitleLabel.TextSize = 17
STitleLabel.TextColor3 = Color3.fromRGB(30,30,30)
STitleLabel.TextXAlignment = Enum.TextXAlignment.Left
STitleLabel.ZIndex = 11
STitleLabel.Parent = STitleRow

local SCloseBtn    = Instance.new("TextButton")
SCloseBtn.Size     = UDim2.new(0,22,0,22)
SCloseBtn.Position = UDim2.new(1,-32,0.5,-11)
SCloseBtn.BackgroundTransparency = 1
SCloseBtn.Text     = "✕"
SCloseBtn.Font     = Enum.Font.GothamBold
SCloseBtn.TextSize = 14
SCloseBtn.TextColor3 = Color3.fromRGB(120,120,120)
SCloseBtn.BorderSizePixel = 0
SCloseBtn.ZIndex   = 12
SCloseBtn.Parent   = STitleRow

local SDivider     = Instance.new("Frame")
SDivider.Size      = UDim2.new(1,0,0,1)
SDivider.Position  = UDim2.new(0,0,0,40)
SDivider.BackgroundColor3 = Color3.fromRGB(220,220,220)
SDivider.BorderSizePixel = 0
SDivider.ZIndex    = 11
SDivider.Parent    = SuccessFrame

-- Checkmark icon
local CheckIcon    = Instance.new("TextLabel")
CheckIcon.Size     = UDim2.new(0,40,0,40)
CheckIcon.Position = UDim2.new(0.5,-20,0,48)
CheckIcon.BackgroundColor3 = Color3.fromRGB(220,220,220)
CheckIcon.Text     = "✓"
CheckIcon.Font     = Enum.Font.GothamBold
CheckIcon.TextSize = 22
CheckIcon.TextColor3 = Color3.fromRGB(80,80,80)
CheckIcon.BorderSizePixel = 0
CheckIcon.ZIndex   = 11
CheckIcon.Parent   = SuccessFrame
local CheckCorner  = Instance.new("UICorner")
CheckCorner.CornerRadius = UDim.new(1,0)
CheckCorner.Parent = CheckIcon

-- Success message
local SMsg         = Instance.new("TextLabel")
SMsg.Name          = "SMsg"
SMsg.Size          = UDim2.new(1,-28,0,30)
SMsg.Position      = UDim2.new(0,14,0,94)
SMsg.BackgroundTransparency = 1
SMsg.Text          = ""
SMsg.Font          = Enum.Font.Gotham
SMsg.TextSize      = 13
SMsg.TextColor3    = Color3.fromRGB(50,50,50)
SMsg.TextWrapped   = true
SMsg.ZIndex        = 11
SMsg.Parent        = SuccessFrame

-- OK Button (already light blue – no sweep needed)
local OKBtn        = Instance.new("TextButton")
OKBtn.Name         = "OKBtn"
OKBtn.Size         = UDim2.new(1,-28,0,36)
OKBtn.Position     = UDim2.new(0,14,0,124)
OKBtn.BackgroundColor3 = Color3.fromRGB(100,140,220)   -- light blue
OKBtn.Text         = "OK"
OKBtn.Font         = Enum.Font.GothamBold
OKBtn.TextSize     = 15
OKBtn.TextColor3   = Color3.fromRGB(255,255,255)
OKBtn.BorderSizePixel = 0
OKBtn.ZIndex       = 11
OKBtn.Parent       = SuccessFrame
local OKBtnCorner  = Instance.new("UICorner")
OKBtnCorner.CornerRadius = UDim.new(0,8)
OKBtnCorner.Parent = OKBtn

-- ============================================================
-- BUILD CONTROL PANEL  (separate ScreenGui, always visible)
-- ============================================================
local CtrlGui      = Instance.new("ScreenGui")
CtrlGui.Name       = "ControlPanel"
CtrlGui.ResetOnSpawn = false
CtrlGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
CtrlGui.Parent     = PlayerGui

local Panel        = Instance.new("Frame")
Panel.Name         = "Panel"
Panel.Size         = UDim2.new(0, 200, 0, 340)
Panel.Position     = UDim2.new(0, 10, 0.5, -170)
Panel.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Panel.BorderSizePixel  = 0
Panel.ZIndex       = 20
Panel.Parent       = CtrlGui

local PanelCorner  = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0,10)
PanelCorner.Parent = Panel

-- Panel title
local PanelTitle   = Instance.new("TextLabel")
PanelTitle.Size    = UDim2.new(1,0,0,36)
PanelTitle.Position= UDim2.new(0,0,0,0)
PanelTitle.BackgroundColor3 = Color3.fromRGB(40,40,60)
PanelTitle.Text    = "🎮 Control Panel"
PanelTitle.Font    = Enum.Font.GothamBold
PanelTitle.TextSize = 13
PanelTitle.TextColor3 = Color3.fromRGB(200,200,255)
PanelTitle.BorderSizePixel = 0
PanelTitle.ZIndex  = 21
PanelTitle.Parent  = Panel
local PTCorner     = Instance.new("UICorner")
PTCorner.CornerRadius = UDim.new(0,10)
PTCorner.Parent    = PanelTitle

-- Helper to create labelled TextBox inside panel
local function makeBox(yPos, labelText, defaultText)
	local lbl = Instance.new("TextLabel")
	lbl.Size  = UDim2.new(1,-16,0,18)
	lbl.Position = UDim2.new(0,8,0,yPos)
	lbl.BackgroundTransparency = 1
	lbl.Text  = labelText
	lbl.Font  = Enum.Font.Gotham
	lbl.TextSize = 11
	lbl.TextColor3 = Color3.fromRGB(160,160,180)
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.ZIndex = 21
	lbl.Parent = Panel

	local box = Instance.new("TextBox")
	box.Size  = UDim2.new(1,-16,0,30)
	box.Position = UDim2.new(0,8,0,yPos+19)
	box.BackgroundColor3 = Color3.fromRGB(45,45,65)
	box.Text  = defaultText
	box.Font  = Enum.Font.Gotham
	box.TextSize = 13
	box.TextColor3 = Color3.fromRGB(240,240,255)
	box.PlaceholderColor3 = Color3.fromRGB(100,100,120)
	box.BorderSizePixel = 0
	box.ZIndex = 21
	box.Parent = Panel
	local bc = Instance.new("UICorner")
	bc.CornerRadius = UDim.new(0,6)
	bc.Parent = box
	return box
end

local BalanceBox   = makeBox(44,  "Balance",         tostring(balance))
local KeybindBox   = makeBox(104, "Keybind (e.g. F)", "F")

-- Open Shop button
local OpenBtn      = Instance.new("TextButton")
OpenBtn.Name       = "OpenBtn"
OpenBtn.Size       = UDim2.new(1,-16,0,36)
OpenBtn.Position   = UDim2.new(0,8,0,166)
OpenBtn.BackgroundColor3 = Color3.fromRGB(70,120,220)
OpenBtn.Text       = "Open Shop"
OpenBtn.Font       = Enum.Font.GothamBold
OpenBtn.TextSize   = 14
OpenBtn.TextColor3 = Color3.fromRGB(255,255,255)
OpenBtn.BorderSizePixel = 0
OpenBtn.ZIndex     = 21
OpenBtn.Parent     = Panel
local OBCorner     = Instance.new("UICorner")
OBCorner.CornerRadius = UDim.new(0,8)
OBCorner.Parent    = OpenBtn

-- Dropdown label
local DropLabel    = Instance.new("TextLabel")
DropLabel.Size     = UDim2.new(1,-16,0,18)
DropLabel.Position = UDim2.new(0,8,0,214)
DropLabel.BackgroundTransparency = 1
DropLabel.Text     = "Gift to Player"
DropLabel.Font     = Enum.Font.Gotham
DropLabel.TextSize = 11
DropLabel.TextColor3 = Color3.fromRGB(160,160,180)
DropLabel.TextXAlignment = Enum.TextXAlignment.Left
DropLabel.ZIndex   = 21
DropLabel.Parent   = Panel

-- Dropdown selected display
local DropSelected = Instance.new("TextButton")
DropSelected.Name  = "DropSelected"
DropSelected.Size  = UDim2.new(1,-16,0,30)
DropSelected.Position = UDim2.new(0,8,0,233)
DropSelected.BackgroundColor3 = Color3.fromRGB(45,45,65)
DropSelected.Text  = "— Select Player —"
DropSelected.Font  = Enum.Font.Gotham
DropSelected.TextSize = 12
DropSelected.TextColor3 = Color3.fromRGB(200,200,220)
DropSelected.BorderSizePixel = 0
DropSelected.ZIndex = 22
DropSelected.Parent = Panel
local DSCorner     = Instance.new("UICorner")
DSCorner.CornerRadius = UDim.new(0,6)
DSCorner.Parent    = DropSelected

-- Dropdown list container (hidden until clicked)
local DropList     = Instance.new("Frame")
DropList.Name      = "DropList"
DropList.Size      = UDim2.new(1,-16,0,0)
DropList.Position  = UDim2.new(0,8,0,264)
DropList.BackgroundColor3 = Color3.fromRGB(50,50,75)
DropList.BorderSizePixel  = 0
DropList.ClipsDescendants = true
DropList.Visible   = false
DropList.ZIndex    = 30
DropList.Parent    = Panel
local DLCorner     = Instance.new("UICorner")
DLCorner.CornerRadius = UDim.new(0,6)
DLCorner.Parent    = DropList

local DropLayout   = Instance.new("UIListLayout")
DropLayout.SortOrder = Enum.SortOrder.LayoutOrder
DropLayout.Padding  = UDim.new(0,2)
DropLayout.Parent  = DropList

-- ============================================================
-- FUNCTIONS
-- ============================================================

-- Update BalanceLabel in Buy GUI
local function refreshBalance()
	BalanceLabel.Text = "\u{E002} " .. formatNumber(balance)
end

-- Deduct cost from balance; returns true if successful
local function deductBalance()
	if balance < ITEM_COST then return false end
	balance = balance - ITEM_COST
	refreshBalance()
	BalanceBox.Text = tostring(balance)
	return true
end

-- Play sweep animation, call callback when done
local function playSweep(callback)
	-- Reset position
	SweepBar.Position = UDim2.new(0, -90, 0, 0)
	BuyBtn.Active     = false
	BuyBtn.BackgroundColor3 = Color3.fromRGB(100, 140, 220)

	local tween = TweenService:Create(
		SweepBar,
		TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
		{ Position = UDim2.new(1, 10, 0, 0) }
	)
	tween:Play()
	tween.Completed:Connect(function()
		-- Unlock Buy button
		BuyBtn.Active = true
		BuyBtn.BackgroundColor3 = Color3.fromRGB(60, 110, 210)  -- slightly darker = ready
		if callback then callback() end
	end)
end

-- Open the Buy GUI
local function openGui()
	if guiOpen then return end
	guiOpen = true
	refreshBalance()
	SuccessFrame.Visible = false
	MainFrame.Visible    = true
	BuyGui.Enabled       = true
	playSweep(nil)
end

-- Close everything
local function closeGui()
	guiOpen = false
	BuyGui.Enabled = false
	MainFrame.Visible    = false
	SuccessFrame.Visible = false
end

-- Show success popup
local function showSuccess()
	local target = (selectedPlayer ~= "") and selectedPlayer or "Unknown"
	SMsg.Text    = "You have successfully gifted [GIFT] ADMIN PANEL to " .. target .. "."
	MainFrame.Visible    = false
	SuccessFrame.Visible = true
end

-- Populate dropdown with current players
local function refreshDropdown()
	-- Clear old entries
	for _, child in ipairs(DropList:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end

	local allPlayers = Players:GetPlayers()
	local totalH = #allPlayers * 28 + (#allPlayers - 1) * 2
	DropList.Size = UDim2.new(1,-16, 0, math.min(totalH, 120))

	for i, plr in ipairs(allPlayers) do
		local btn = Instance.new("TextButton")
		btn.Size  = UDim2.new(1,0,0,28)
		btn.BackgroundTransparency = 1
		btn.Text  = plr.Name
		btn.Font  = Enum.Font.Gotham
		btn.TextSize = 12
		btn.TextColor3 = Color3.fromRGB(230,230,255)
		btn.LayoutOrder = i
		btn.ZIndex = 31
		btn.Parent = DropList

		btn.MouseButton1Click:Connect(function()
			selectedPlayer = plr.Name
			DropSelected.Text = plr.Name
			DropList.Visible  = false
		end)
	end
end

-- Toggle dropdown visibility
local function toggleDropdown()
	if DropList.Visible then
		DropList.Visible = false
	else
		refreshDropdown()
		DropList.Visible = true
	end
end

-- Parse keybind from text
local function parseKeybind(text)
	local upper = text:upper():gsub("%s","")
	-- Try to find Enum.KeyCode[upper]
	local ok, kc = pcall(function() return Enum.KeyCode[upper] end)
	if ok and kc then
		keybind = kc
	end
end

-- ============================================================
-- CONNECTIONS
-- ============================================================

-- Open shop button
OpenBtn.MouseButton1Click:Connect(function()
	openGui()
end)

-- Close X in Buy popup
CloseBtn.MouseButton1Click:Connect(function()
	closeGui()
end)

-- Buy button
BuyBtn.MouseButton1Click:Connect(function()
	if not BuyBtn.Active then return end
	if balance < ITEM_COST then
		-- Flash red to indicate insufficient balance
		BuyBtn.BackgroundColor3 = Color3.fromRGB(200,60,60)
		task.delay(0.6, function()
			BuyBtn.BackgroundColor3 = Color3.fromRGB(60,110,210)
		end)
		return
	end
	BuyBtn.BackgroundColor3 = Color3.fromRGB(30,60,140)  -- dark blue on click
	deductBalance()
	task.delay(0.15, function()
		showSuccess()
	end)
end)

-- OK button in success popup
OKBtn.MouseButton1Click:Connect(function()
	OKBtn.BackgroundColor3 = Color3.fromRGB(30,60,140)   -- dark blue on click
	task.delay(0.15, function()
		closeGui()
	end)
end)

-- Success popup X
SCloseBtn.MouseButton1Click:Connect(function()
	closeGui()
end)

-- Balance box: update balance live
BalanceBox.FocusLost:Connect(function()
	local val = tonumber(BalanceBox.Text)
	if val and val >= 0 then
		balance = math.floor(val)
		refreshBalance()
	else
		BalanceBox.Text = tostring(balance)
	end
end)

-- Keybind box
KeybindBox.FocusLost:Connect(function()
	parseKeybind(KeybindBox.Text)
end)

-- Dropdown toggle
DropSelected.MouseButton1Click:Connect(function()
	toggleDropdown()
end)

-- Keybind input listener
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == keybind then
		if guiOpen then
			closeGui()
		else
			openGui()
		end
	end
end)

-- Auto-update dropdown when players join/leave
Players.PlayerAdded:Connect(function()
	if DropList.Visible then refreshDropdown() end
end)
Players.PlayerRemoving:Connect(function(plr)
	if selectedPlayer == plr.Name then
		selectedPlayer = ""
		DropSelected.Text = "— Select Player —"
	end
	if DropList.Visible then refreshDropdown() end
end)

-- Initial balance display
refreshBalance()

-- ============================================================
-- END OF SCRIPT
-- ============================================================
