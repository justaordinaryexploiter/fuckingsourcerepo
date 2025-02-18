-- [By RedDominus]
-- [Owned by The Scripts]
-- [Coded by RedDominus & The Scripts]
-- Services
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- Create the ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = CoreGui
ScreenGui.Name = "ScriptExecutorUI"

-- Create the main Frame
local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0.4, 0, 0.4, 0)
Frame.Position = UDim2.new(0.3, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.fromRGB(50, 50, 50)
Frame.Active = true -- Enables interaction

-- Create a title bar for dragging
local TitleBar = Instance.new("Frame")
TitleBar.Parent = Frame
TitleBar.Size = UDim2.new(1, 0, 0.1, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local TitleText = Instance.new("TextLabel")
TitleText.Parent = TitleBar
TitleText.Size = UDim2.new(1, 0, 1, 0)
TitleText.Text = "Script Executor"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.BackgroundTransparency = 1
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 18

-- Draggable Functionality (PC & Mobile)
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Create the TextBox for Lua scripts
local scriptTextBox = Instance.new("TextBox")
scriptTextBox.Parent = Frame
scriptTextBox.Size = UDim2.new(1, -10, 0.65, -10)
scriptTextBox.Position = UDim2.new(0, 5, 0.12, 5)
scriptTextBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
scriptTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
scriptTextBox.Font = Enum.Font.SourceSans
scriptTextBox.TextSize = 16
scriptTextBox.ClearTextOnFocus = false
scriptTextBox.Text = "" -- Placeholder text for the TextBox
scriptTextBox.MultiLine = true

-- Create the Execute Button
local executeButton = Instance.new("TextButton")
executeButton.Parent = Frame
executeButton.Size = UDim2.new(0.3, 0, 0.2, 0)
executeButton.Position = UDim2.new(0, 5, 0.8, 5)
executeButton.Text = "Execute"
executeButton.Font = Enum.Font.GothamBold
executeButton.TextSize = 18
executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
executeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Create the Clear Button
local clearButton = Instance.new("TextButton")
clearButton.Parent = Frame
clearButton.Size = UDim2.new(0.3, 0, 0.2, 0)
clearButton.Position = UDim2.new(0.35, 5, 0.8, 5)
clearButton.Text = "Clear"
clearButton.Font = Enum.Font.GothamBold
clearButton.TextSize = 18
clearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
clearButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Create the Paste Button
local pasteButton = Instance.new("TextButton")
pasteButton.Parent = Frame
pasteButton.Size = UDim2.new(0.3, 0, 0.2, 0)
pasteButton.Position = UDim2.new(0.7, -5, 0.8, 5)
pasteButton.Text = "Paste"
pasteButton.Font = Enum.Font.GothamBold
pasteButton.TextSize = 18
pasteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
pasteButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Function to Execute the Script
local function executeScript()
    local scriptContent = scriptTextBox.Text
    local success, errorMessage = pcall(function()
        loadstring(scriptContent)() -- Executes the script
    end)

    if not success then
        -- If there's an error, show it in the TextBox
        scriptTextBox.Text = "Error: " .. errorMessage
    end
end

-- Button functions
executeButton.MouseButton1Click:Connect(executeScript) -- Execute script
clearButton.MouseButton1Click:Connect(function()
    scriptTextBox.Text = "" -- Clear the TextBox
end)
pasteButton.MouseButton1Click:Connect(function()
    scriptTextBox.Text = getclipboard() -- Paste the clipboard content into the TextBox
end)
