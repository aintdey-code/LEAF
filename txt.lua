local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "PurchaseClone"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Dark background overlay
local overlay = Instance.new("Frame")
overlay.Size = UDim2.fromScale(1,1)
overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
overlay.BackgroundTransparency = 0.4
overlay.Parent = gui

-- Main Modal
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(420,220)
main.Position = UDim2.fromScale(0.5,0.5)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = Color3.fromRGB(40,40,40)
main.Parent = overlay

Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-20,0,40)
title.Position = UDim2.new(0,20,0,10)
title.BackgroundTransparency = 1
title.Text = "Buy item"
title.Font = Enum.Font.Gotham
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

-- Balance (Top Right)
local balance = Instance.new("TextLabel")
balance.Size = UDim2.new(0,120,0,40)
balance.Position = UDim2.new(1,-140,0,10)
balance.BackgroundTransparency = 1
balance.Text = "\u{E002} 66,245"
balance.Font = Enum.Font.Gotham
balance.TextSize = 16
balance.TextColor3 = Color3.fromRGB(200,200,200)
balance.TextXAlignment = Enum.TextXAlignment.Right
balance.Parent = main

-- HD Image
local image = Instance.new("ImageLabel")
image.Size = UDim2.fromOffset(60,60)
image.Position = UDim2.new(0,20,0,60)
image.BackgroundTransparency = 1
image.Image = "rbxassetid://76531501501891"
image.Parent = main

-- Item Name
local itemName = Instance.new("TextLabel")
itemName.Size = UDim2.new(1,-100,0,30)
itemName.Position = UDim2.new(0,100,0,65)
itemName.BackgroundTransparency = 1
itemName.Text = "[GIFT] ADMIN PANEL"
itemName.Font = Enum.Font.Gotham
itemName.TextSize = 16
itemName.TextColor3 = Color3.fromRGB(255,255,255)
itemName.TextXAlignment = Enum.TextXAlignment.Left
itemName.Parent = main

-- Price
local price = Instance.new("TextLabel")
price.Size = UDim2.new(1,-100,0,30)
price.Position = UDim2.new(0,100,0,95)
price.BackgroundTransparency = 1
price.Text = "\u{E002} 7,499"
price.Font = Enum.Font.Gotham
price.TextSize = 16
price.TextColor3 = Color3.fromRGB(200,200,200)
price.TextXAlignment = Enum.TextXAlignment.Left
price.Parent = main

-- Buy Button
local buy = Instance.new("TextButton")
buy.Size = UDim2.new(1,-40,0,45)
buy.Position = UDim2.new(0,20,1,-60)
buy.BackgroundColor3 = Color3.fromRGB(88,101,242)
buy.Text = "Buy"
buy.Font = Enum.Font.Gotham
buy.TextSize = 18
buy.TextColor3 = Color3.fromRGB(255,255,255)
buy.Parent = main
Instance.new("UICorner", buy).CornerRadius = UDim.new(0,8)

-- PURCHASE COMPLETED MODAL
local function showSuccess()
	main.Visible = false
	
	local success = main:Clone()
	success.Parent = overlay
	success.Visible = true
	
	title.Text = "Purchase completed"
	itemName.Text = "You have successfully gifted [GIFT] ADMIN PANEL."
	price.Text = ""
	image.Image = ""
	balance.Text = ""
	
	buy.Text = "OK"
	buy.MouseButton1Click:Connect(function()
		gui:Destroy()
	end)
end

buy.MouseButton1Click:Connect(showSuccess)
