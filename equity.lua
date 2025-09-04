local SHOULD_TWEEN = false;

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Workspace = game:GetService("Workspace")
local EntityService = game:GetService("EntityService")
local PacketService = game:GetService("PacketService")
local LightingService = game:GetService("Lighting")
local ChatService = game:GetService("Chat")
gethui():ClearChildren()
local Fonts = {
	GothamSSm = "https://fonts.gstatic.com/s/roboto/v30/KFOmCnqEu92Fr1Mu4mxP.ttf",
	GothamSSm_Medium = "https://fonts.gstatic.com/s/roboto/v30/KFOmCnqEu92Fr1Mu4mxP.ttf",
	Poppins_SemiBold = "https://fonts.gstatic.com/s/roboto/v30/KFOmCnqEu92Fr1Mu4mxP.ttf",
	Outfit = "https://fonts.gstatic.com/s/roboto/v30/KFOmCnqEu92Fr1Mu4mxP.ttf",
	Outfit_Medium = "https://fonts.gstatic.com/s/roboto/v30/KFOmCnqEu92Fr1Mu4mxP.ttf",
	Outfit_Black = "https://fonts.gstatic.com/s/roboto/v30/KFOmCnqEu92Fr1Mu4mxP.ttf",
	Outfit_Bold = "https://fonts.gstatic.com/s/roboto/v30/KFOmCnqEu92Fr1Mu4mxP.ttf",
	Outfit_SemiBold = "https://fonts.gstatic.com/s/roboto/v30/KFOmCnqEu92Fr1Mu4mxP.ttf",
}
local function Tween(frame, info, props)
	return TweenService:Create(frame, info, props)
end

local function create(type, options, children)
	local object = Instance.new(type)
	for i, v in pairs( options or {}) do
		local old = object[i]
		object[i] = v
	end

	for _, child in pairs(children or {}) do
		child.Parent = object
	end
	return object
end
local function formatTable(tab)
	local tab = tab or {}
	local result = {}
	for i,v in pairs(tab) do
		result[tostring(i):lower()] = v
	end
	return result
end


if connections then
	for i,v in pairs(connections) do
		v:Disconnect()
	end
end
getgenv().connections = {}
function connect(signal, func)
	local result = signal:Connect(func)
	table.insert(connections, result)
	return result;
end


local FluxLib = {} -- this is a oop-like class so dont question selfs

function FluxLib.new(settings)
	local settings = formatTable(settings)

	local width  = settings.width  or 600
	local height = settings.height or 370
	
	local title = settings.title or settings.name or "FluxLib"
	local version = settings.verison or "0.0.1"
	local description = settings.description or "Preview"

	local FluxGUI = create("ScreenGui")
	FluxGUI.Parent = gethui()
	FluxGUI.PreventAnyMenuOpen = true
	FluxGUI.FreeCursorWhenEnabled = true

	local states = {}
	local properties = {
		"BackgroundTransparency",
		"TextTransparency",
		"ImageTransparency",
		"ScrollBarImageTransparency"
	}
	local tweening = false
	connect(UserInputService.InputBegan,function(a,b)
		if a.KeyCode == Enum.KeyCode.RightShift and not tweening then -- THIS DOES NOT FUCKING WORK NOW?????
			tweening = true
			pcall(function()
				local enable = not FluxGUI.Enabled
				if(enable) then
					FluxGUI.Enabled = true;
				end
				local time = 0.1		
				for i,v in pairs(FluxGUI:GetDescendants()) do
					states[v] = enable and states[v] or {}; 
					for _,prop in pairs(properties) do
						if v[prop] ~= nil then
							if(not enable) then
								states[v][prop] = v[prop] 
							end
							local propertyValue = enable and states[v][prop] or 1;
							if SHOULD_TWEEN then
								Tween(v,TweenInfo.new(time),{[prop] = propertyValue}):Play()
							else
								v[prop] = propertyValue
							end
						end
					end 
				  
				end
				wait(time)
				if(not enable) then
					FluxGUI.Enabled = false;
				else 
					states = {}
				end
			end)
			tweening = false
		end
	end)
	
	local MainFrame = create("Frame",{
		Parent = FluxGUI,
		Size = UDim2.new(0, width, 0, height),
		CornerRadius = CornerRadius.new(5, 5, 5, 5),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromHex("#0e0e1a"),
		Draggable = true,
		AnchorPoint = Vector2.new(0.5,0.5),
		Position = UDim2.new(0.5,0,0.5,0),
		ClipsDescendants = true,
	})

	local SideBarHolder = create("Frame",{
		Parent = MainFrame,
		Size = UDim2.new(0.325, 0, 0, height),
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(0,0,0),
	})
	local SideBar = create("Frame",{
		Parent = SideBarHolder,
		Size = UDim2.new(1, 5, 1, 0),
		BackgroundColor3 = Color3.fromHex("#13121e"),
		BorderSizePixel = 0,
		CornerRadius = CornerRadius.new(5, 5, 5, 5),
		ClipsDescendants = true
	})
	local SideBarItemsList = create("Frame",{
		Parent = SideBar,
		Size = UDim2.new(1, 5, 1, -60),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0,0,0,60),
	},{
		create("UIListLayout",{
			Padding = UDim.new(0, 5),
			HorizontalAlignment = "Center",
		})
	})

	local TitleLabel = create("TextLabel",{
		Parent = SideBar,
		Text = title,
		Font = Fonts.Outfit_Bold,
        TextColor3 = Color3.fromRGB(255,255,255),
		Position = UDim2.new(0, 10, 0, 8),
        TextXAlignment = "Left",
        TextYAlignment = "Top",
        TextSize = 18,
		BackgroundTransparency = 1,
	})

	local VersionLabel = create("TextLabel",{
		Parent = SideBar,
		Text = version,
		TextSize = 14,
		TextColor3 = Color3.fromHex("#5e1f9e"),
		Position = UDim2.new(0, 115, 0, 5),
		Font = Fonts.Outfit_Bold,
        TextXAlignment = "Left",
        TextYAlignment = "Top",
		BackgroundTransparency = 1
	})

    local DescLabel = create("TextLabel",{
		Parent = SideBar,
		Text = description,
		Font = Fonts.Outfit_Medium,
		Position = UDim2.new(0, 12, 0, 35),
		TextSize = 14,
        TextYAlignment = "Top",
        TextXAlignment = "Left",
		TextColor3 = Color3.fromRGB(225,225,225),
        BackgroundTransparency = 1
	})

	local LocationLabel = create("TextLabel",{
		Parent = SideBar,
		TextSize = 14,
		Position = UDim2.new(0, 12, 0, 31),
		BackgroundTransparency = 1,
        TextTransparency = 1
	})


	
	local ItemsContainer = create("Frame",{
		Parent = MainFrame,
		Position = UDim2.new(1, -125, 0, 15),
		BackgroundColor3 = Color3.fromRGB(255, 255,255),
		Size = UDim2.new(0.775, 0, 0, height - 15),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
	})

	local library = {
		flags = {
			_counter = 0
		},
		tabs = {
			current = nil -- wont be counted
		},
	}

	local Tab, Elements = {}, {}; 
	do
		Tab.__index = Tab
		function Tab.new(name, icon, accent)
			local self = setmetatable({
				name = name,
				icon = icon,
				accent = accent
			}, Tab)

			self:init()

			self._elements = Elements.new(self.container)
			return self
		end
		function Tab:init()
			local sidebar_button = create("TextButton",{
				Parent = SideBarItemsList,
				Size = UDim2.new(1, 0, 0, 50),
				BorderSizePixel = 0,
				BackgroundColor3 = self.accent,
				BackgroundTransparency = 1,
                TextTransparency = 1
			},{
				create("TextLabel",{
					Text = self.name,
					TextSize = 14,
					Font = Fonts.Outfit_SemiBold,
					Position = UDim2.new(0, 35, 0, -2),
                    Size = UDim2.new(1,0,1,0),
                    TextColor3 = Color3.fromRGB(255,255,255),
					BackgroundTransparency = 1,
                    TextXAlignment = "Left"
				}),
				create("ImageLabel",{
					Size = UDim2.new(0, 27, 0, 27),
					Image = self.icon,
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 6, 0, 9),
				})
			})
		
			local tab_container = create("ScrollingFrame",{
				Parent = ItemsContainer,
				Visible = false,
				AutomaticCanvasSize = "Y",
				ScrollBarThickness = 6,
                ClipsDescendants = true,
				ScrollBarImageTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255,255,255),
				Size = UDim2.new(1, 0, 0, height - 15),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Position = UDim2.new(0,-260,0,0),
			},{
				create("UIListLayout",{
					Padding = UDim.new(0, 5),
					--HorizontalAlignment = "Center",
				})
			})

			self.container = tab_container
			self.side_button = sidebar_button

		end
		
		function Tab:Elements()
			return self._elements
		end
		
	end; 
	do
		Elements.__index = Elements
		function Elements.new(container, width, height)
			local self = setmetatable({
				container = container,
				width = width or 370,
				height = height or 80
			}, Elements)
		
			return self
		end
		function Elements:_baseElement(name, description)
			local ItemHolder = create("Frame",{
				Parent = self.container,
				Size = UDim2.new(0, self.width, 0, self.height),
				BackgroundTransparency = 1,
				BorderSizePixel = 1,
				ClipsDescendants = true
			})
			local ItemButton = create("Frame",{
				Parent = ItemHolder,
				Size = UDim2.new(0, self.width, 0, self.height),
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromHex("#12121e"),
				CornerRadius = CornerRadius.new(6, 6, 6, 6),
            },{
				create("Frame",{ -- Circle
					Size = UDim2.new(0, 14, 0, 14),
					Position = UDim2.new(0, 9, 0.5, -14),
					CornerRadius = CornerRadius.new(6, 6, 6, 6),
					BackgroundColor3 = Color3.fromHex("#ddddf0"),
					BorderSizePixel = 0
				}),
				create("TextLabel",{
					Text = name,
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 28, 0.5, -8),
					TextColor3 = Color3.fromHex("#ddddf0"),
					Font = Fonts.Outfit_Medium,
					TextSize = 14,
					BackgroundTransparency = 1,
                    TextXAlignment = "Left"
				}),
				create("TextLabel",{
					Text = description,
					Font = Fonts.Outfit,
					TextSize = 14,
					TextColor3 = Color3.fromHex("#27273b"),
					Position = UDim2.new(0, 9, 0, 6),
					Size = UDim2.new(0, 100, 0, 100),
					BackgroundTransparency = 1,
                    ZIndex = 2,
                    TextXAlignment = "Left"
				})
			})

			return ItemButton
		end

		function Elements:Text(options)
			local options = formatTable(options)
			
			local text = options.text or options.name or "Text"
			local flag = options.flag or tostring(library.flags._counter + 1)

			local textContainer = create("Frame",{
				Parent = self.container,
				Size = UDim2.new(0, self.width, 0, self.height/2+2),
				BackgroundTransparency = 1,
			})

			local component = create("TextLabel",{
				Parent = textContainer,
				Position = UDim2.new(0,0,0.5,-3.5),
				TextColor3 = Color3.fromRGB(190, 190, 190),
				TextSize = 14,
				Text = text,
				Font = Fonts.Outfit_Medium,
                BackgroundTransparency = 1
			})

			local TextClass = {
				Text = text
			}
			function TextClass:Set(text)
				component.Text = text
				self.Text = text
			end

			library:AddFlag(flag, TextClass)

			return TextClass
		end
		function Elements:TextBox(options)
			local options = formatTable(options)
			
			local name = options.name or "Toggle"
			local desc = options.description or "Description"
			local flag = options.flag or tostring(library.flags._counter + 1)

			local text = options.text or "Text"

			local callback = options.callback

			local button = self:_baseElement(name, desc)

			local textbox = create("TextBox",{
				Parent = button,
				Size = UDim2.new(0, 55, 0, 20),
				Position = UDim2.new(1, -5, 0.5, -5),
				CornerRadius = 10,
				TextSize = 14,
				PaddingTop = UDim.new(0,1),
                AnchorPoint = Vector2.new(1,0.5),
				TextWrapped = false,
				TextEditable = true,
				ClearTextOnFocus = false,
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromHex("#2a2a48"),
				TextColor3 = Color3.fromRGB(255, 255, 255),
			})
			local TextBoxClass = {
			}
            connect(textbox.TextChanged,function()
                local xSize = TextService:GetTextSize(textbox.Text, 16, "default", Vector2.new(1924, 1080)).X + 15
                textbox.Size = UDim2.new(0, math.max(xSize, 55), 0, 20)
            end)
			if callback then 
				connect(textbox.TextChanged,callback) 
			end
			textbox.Text = text

			function TextBoxClass:Get()
				return textbox.Text
			end
			function TextBoxClass:Set(text)
				textbox.Text = text
			end

			library:AddFlag(flag, TextBoxClass)
			return TextBoxClass
		end

		function Elements:Toggle(options)
			local options = formatTable(options)
			
			local name = options.name or "Toggle"
			local desc = options.description or "Description"
			local flag = options.flag or tostring(library.flags._counter + 1)

			local callback = options.callback

			local button = self:_baseElement(name, desc)

			local OuterCircle = create("TextButton",{
				Parent = button,
				Size = UDim2.new(0, 30, 0, 14),
				Position = UDim2.new(1, -55, 0.5, -3),
				CornerRadius = CornerRadius.new(6, 6, 6, 6),
				BackgroundColor3 = Color3.fromRGB(224, 224, 224),
				BorderSizePixel = 0,
                TextTransparency = 1,
			})
			local InnerCircle = create("Frame",{
				Parent = OuterCircle,
				Size = UDim2.new(0, 16, 0, 16),
				Position = UDim2.new(0, 0, 0, -1),
				CornerRadius = CornerRadius.new(10, 10, 10, 10),
				BackgroundColor3 = Color3.fromHex("#fefefe"),
				BorderSizePixel = 0,
			})

			local ToggleClass = {
				Enabled = false
			}
			function ToggleClass:Update()
				if self.Enabled then
					Tween(InnerCircle, TweenInfo.new(0.3), {Position = UDim2.new(1, -16, 0, -1)}):Play()
					Tween(InnerCircle, TweenInfo.new(0.3),  {BackgroundColor3 = Color3.fromHex("#5e1f9e")}):Play()
				else
					Tween(InnerCircle, TweenInfo.new(0.3), {Position = UDim2.new(0, 0, 0, -1)}):Play()
					Tween(InnerCircle, TweenInfo.new(0.3),  {BackgroundColor3 = Color3.fromHex("#fefefe")}):Play()
				end
				if callback then
					callback(self.Enabled)
				end
			end
			function ToggleClass:Toggle()
				self.Enabled = not self.Enabled
				self:Update()
			end
			function ToggleClass:Get()
				return self.Enabled
			end
			function ToggleClass:Set(enabled)
				self.Enabled = enabled
				self:Update()
			end
			
            local widthh = self.width;
            local heightt = self.height;
			function ToggleClass:Options()

				-- options are hardcoded cuz sex
				if ToggleClass.optionsclass ~= nil then return ToggleClass.optionsclass end

				local holder
				do 
					local ItemHolder = button.Parent
					holder = create("Frame",{
						Parent = ItemHolder,
						Position = UDim2.new(0, 0, 0, heightt),
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
                        ClipsDescendants = true
					})

					local uilistlayout = create("UIListLayout",{
						Parent = holder,
						Padding = UDim.new(0,5)
					})
					
					local buttonHolder = create("Frame",{
						Parent = button,
						Position = UDim2.new(1,-15,0,0),
						Size = UDim2.new(0,15,1,0),
						CornerRadius = CornerRadius.new(0,0,6,6),
						BackgroundColor3 = Color3.fromRGB(22,22,34),
						BorderSizePixel = 0
					})

					local dot_size = 5
					local dot_padding = 3
					local dots = {}
					
					create("UIListLayout", {
						Padding = UDim.new(0, dot_padding),
						Parent = buttonHolder,
						HorizontalAlignment = "Center",
						VerticalAlignment = "Center"
					})
					for i=1,3 do
						dots[i] = create("Frame",{
							Parent = buttonHolder,
							Size = UDim2.new(0, dot_size, 0, dot_size),
							BackgroundColor3 = Color3.fromRGB(45,45,75),
							BorderSizePixel = 0,
							CornerRadius = 5
						})
					end


					local optionsToggled = false
					local function ToggleOptions()
						optionsToggled = not optionsToggled
						
                        local height = math.max(20,uilistlayout.AbsoluteContentSize.Y)

						local buttonColor = optionsToggled and Color3.fromHex("#5e1f9e") or Color3.fromRGB(22,22,34)
						local dotsColor = optionsToggled and Color3.fromRGB(195,168,222) or Color3.fromRGB(45,45,75)
						local itemSize = optionsToggled and UDim2.new(0, widthh, 0, heightt + height) or UDim2.new(0, widthh, 0, heightt)


						Tween(ItemHolder,   TweenInfo.new(0.5), {Size = itemSize}):Play()
						Tween(buttonHolder, TweenInfo.new(0.3), {BackgroundColor3 = buttonColor}):Play()
						for i=1,3 do
							Tween(dots[i], TweenInfo.new(0.3), {BackgroundColor3 = dotsColor}):Play()
						end
					end
					connect(buttonHolder.MouseButton1Click,ToggleOptions)
				end
				
				local OptionsClass = {}
				function OptionsClass:_baseElement(title)
					return create("Frame",{
						Parent = holder,
						Size = UDim2.new(1,0,0,35),
						CornerRadius = 5,
						BackgroundColor3 = Color3.fromRGB(16,16,28),
						BorderSizePixel = 0
					},{
						create("TextLabel",{
							Text = title,
							Position = UDim2.new(0,5,0,0),
                            Size = UDim2.new(1,0,1,0),
                            TextColor3 = Color3.fromRGB(255,255,255),
                            TextXAlignment = "Left",
							TextSize = 14,
							Font = Fonts.Outfit_Medium,
							BackgroundTransparency = 1
						})
					})
				end
				
				function OptionsClass:Keybind(options)
					local options = formatTable(options)

					local name = options.name or "Keybind"
					local callback = options.Callback or function() ToggleClass:Toggle() end
	
					local listening = false
					local keybind
	
	
					local base = self:_baseElement(name)
	
					local button = create("TextButton",{
						Parent = base,
						Position = UDim2.new(1,-5,0.5,-3.6),
						AnchorPoint = Vector2.new(1,0),
						Size = UDim2.new(0,15,0,15),
						CornerRadius = 5,
						BorderSizePixel = 0,
						BackgroundColor3 = Color3.fromRGB(42,42,72),
						TextColor3 = Color3.fromRGB(255,255,255),
						TextSize = 18.5,
                        PaddingTop = UDim.new(0,1),
                        Text = ""
					})
					local function set(keycode)
						keybind = keycode
						listening = false
						button.Text = keycode and keycode.Name or ""
					end
	
					connect(button.MouseButton1Click, function()
						keybind = nil
						listening = true
						button.Text = "..."
					end)
					local function onInputBegan(inputObject, _gameProcessed)
						if _gameProcessed then return end
						if not inputObject.KeyCode then return end
						if inputObject.KeyCode.Name == "Unknown" then return end
						if listening then
							if inputObject.KeyCode == Enum.KeyCode.Escape or inputObject.KeyCode == Enum.KeyCode.Backspace then
								set(nil)
								return
							end	
						
							set(inputObject.KeyCode)
							--button.Size = UDim2.new(0,5+(12 * #button.Text),0,11)
						elseif inputObject.KeyCode == keybind then
							callback()
						end
					end
					connect(UserInputService.InputBegan, onInputBegan)
					
					local KeybindClass = {}
					function KeybindClass:Set(keycode) -- should be enum.keycode
						set(keycode)
					end

					library:AddFlag(options.flag, KeybindClass)
					return self
				end
				local function createSlider(name, current)
					local base = OptionsClass:_baseElement(name)
	
					local line = create("Frame",{
						Parent = base,
						Position = UDim2.new(1,-15,0.5,-0.5),
						AnchorPoint = Vector2.new(1,0),
						Size = UDim2.new(0,60,0,2),
						BorderSizePixel = 0,
						BorderColor3 = Color3.fromRGB(),
						BackgroundColor3 = Color3.fromRGB(42,42,72)
					})
					local button = create("TextButton",{
						Parent = line,
						Size = UDim2.new(1,0,0,7),
						AnchorPoint = Vector2.new(0,0.5),
						Position = UDim2.new(0,0,0.5,0),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
                        TextTransparency = 1,
					})
					local current_filled = create("Frame",{
						Parent = line,
						Position = UDim2.new(0,0,0.5,0),
						Size = UDim2.new(0.5,0,1,0),
						AnchorPoint = Vector2.new(0,0.5),
						BackgroundColor3 = Color3.fromRGB(72,72,102),
						BorderSizePixel = 0
					})
					local current_value = create("TextLabel",{
						BackgroundTransparency = 1,
						Parent = base,
						Position = UDim2.new(1,-185,0,-35),
                        Size = UDim2.new(0, 100,0,100),
						TextXAlignment = Enum.TextXAlignment.Right,
						TextSize = 14,
                        TextColor3 = Color3.fromRGB(255,255,255),
						Font = Fonts.Outfit_Medium,
						
                        Text = current,
					})

					return line, button, current_filled, current_value
				end
				function OptionsClass:Slider(options)
					local options = formatTable(options)
	
					local name = options.name or "Slider"
					local callback = options.callback
	
					local min = options.min or 0
					local max = options.max or 100
					local current = options.default or options.current or min
					local suffix = options.suffix or ""
	

					local line, button, current_filled, current_value = createSlider(name, current)
					local current_frame = create("Frame",{
						Parent = line,
						Position = UDim2.new(0.5,0,0.5,0),
						AnchorPoint = Vector2.new(0,0.5),
						Size = UDim2.new(0,7,0,7),						
						BorderSizePixel = 0,
						BorderColor3 = Color3.fromRGB(),
						BackgroundColor3 = Color3.fromRGB(72,72,102),
						CornerRadius = 14,
					})

					local sliding = false
					local function rangeToValue(val)
						local value = (max-min) * val + min
						return value
					end
					local function valueToRange(value)
						return (value - min) / (max - min)
					end
					local function set(value)
						current = value
						current_value.Text = string.format("%.2f%s", current, suffix)
	
						current_frame.Position = UDim2.new(valueToRange(value),-1.75,0.5,0)
						current_filled.Size = UDim2.new(valueToRange(value),0,1,0)
						if callback then callback(value) end
					end
					set(current)
					local function update()
						local absolutePosition = line.AbsolutePosition.X
						local absoluteSize = line.AbsoluteSize.X
						local sliderX = (X - absolutePosition)
						local range = math.min(1, math.max(sliderX/absoluteSize, 0))
						set(rangeToValue(range), range)
					end
					connect(button.MouseButton1Down,function()
						sliding = true
						MainFrame.Draggable = false -- crutch but it works
						update()
					end)
					connect(UserInputService.InputChanged, function(inputObject, _gameProcessed)
						if sliding and inputObject.UserInputType == Enum.UserInputType.MouseMovement then
							update()
						end
					end)
					connect(UserInputService.InputEnded,function(inputObject, _gameProcessed)
						if sliding and inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
							sliding = false
							MainFrame.Draggable = true
							update()
						end
					end)

					local SliderClass = {
						_line = line
					}
					function SliderClass:Set(val)
						set(val)
					end
					function SliderClass:Get()
						return current
					end
					library:AddFlag(options.flag, SliderClass)
					return self
				end
				function OptionsClass:SliderRange(options)
					local options = formatTable(options)

					local name = options.name or "Slider"
					local callback = options.callback
	
					local min = options.min or 0
					local max = options.max or 100
					local current = options.default or options.current or min
					local suffix = options.suffix or ""

					local currentSliderMin = options.defaultmin or min
					local currentSliderMax = options.defaultmax or min
	
					local line, button, current_filled, current_value = createSlider(name, current)

					local current_min = create("ImageButton",{
						Parent = line,
						Position = UDim2.new(0,0,0,1),
						AnchorPoint = Vector2.new(0,0.5),
						Size = UDim2.new(0,7,0,7),						
						BorderSizePixel = 0,
						BorderColor3 = Color3.fromRGB(),
						ImageColor3 = Color3.fromRGB(72,72,102),
						BackgroundTransparency = 1,
						Image = "https://upload.wikimedia.org/wikipedia/commons/3/36/Fortnite.png"
					})
					local current_max = create("ImageButton",{
						Parent = line,
						Position = UDim2.new(1,0,0,1),
						AnchorPoint = Vector2.new(0,0.5),
						Size = UDim2.new(0,7,0,7),						
						BorderSizePixel = 0,
						BorderColor3 = Color3.fromRGB(),
						ImageColor3 = Color3.fromRGB(72,72,102),
						BackgroundTransparency = 1,
						Image = "https://upload.wikimedia.org/wikipedia/commons/3/36/Fortnite.png",
						Rotation = 180,
					})

					local slidingMin = false
					local slidingMax = false
					local function rangeToValue(val)
						local value = (max-min) * val + min
						return value
					end
					local function valueToRange(value)
						return (value - min) / (max - min)
					end
					local function set(min,max)
						currentSliderMin = min
						currentSliderMax = max
						local scaledMin = valueToRange(min)
						local scaledMax = valueToRange(max)
						current_filled.Position = UDim2.new(scaledMin,0, 0.5,0)
						current_filled.Size = UDim2.new(scaledMax - scaledMin,0, 1,0)
						
						current_max.Position = UDim2.new(scaledMax,0,0,1)
						current_min.Position = UDim2.new(scaledMin,-3.5,0,1)
						
						current_value.Text = string.format("%d - %d", min, max)
						if callback then callback(min, max) end
					end
					set(currentSliderMin, currentSliderMax)
					local function update()
						local absolutePosition = line.AbsolutePosition.X
						local absoluteSize = line.AbsoluteSize.X
						local sliderX = (Mouse.X - absolutePosition)
						local range = math.min(1,math.max(sliderX/absoluteSize, 0))
					
						local min = currentSliderMin
						local max = currentSliderMax
						if slidingMin then
							min = rangeToValue(range)
						elseif slidingMax then
							max = rangeToValue(range)
						end
						if min > max then
							if slidingMin then
								min = max
							else
								max = min
							end
						end
						
						set(min,max)
					end
					local function start()
						MainFrame.Draggable = false
						update()
					end
					connect(current_min.MouseButton1Down, function()
						slidingMin = true
						start()
					end)				
					connect(current_max.MouseButton1Down, function()
						slidingMax = true
						start()
					end)
	
					connect(UserInputService.InputChanged, function(inputObject, _gameProcessed)
						if (slidingMin or slidingMax) and inputObject.UserInputType == Enum.UserInputType.MouseMovement then
							update()
						end
					end)
					connect(UserInputService.InputEnded, function(inputObject, _gameProcessed)
						if (slidingMin or slidingMax) and inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
							slidingMin = false
							slidingMax = false
							MainFrame.Draggable = true
							update()
						end
					end)

					local RangeClass = {}
					function RangeClass:Get()
						return min, max
					end
					function RangeClass:Set(min, max)
						set(min, max)
					end
					library:AddFlag(options.flag, RangeClass)
					return self
				end	

				function OptionsClass:TextBox(options)
					local options = formatTable(options)

					local name = options.name or "Textbox"
					local callback = options.callback
	
					local text = options.text or ""
					local editable = options.editable
					local placeholder = options.placeholder or ""
	
					local base = self:_baseElement(name)
					
					local box = create("TextBox",{
						Parent = base,
						Position = UDim2.new(1,-2,0.5,0),
						AnchorPoint = Vector2.new(1,0.5),
						Size = UDim2.new(0,80,0,10),
						--TextEditable = editable,
						Text = text,
						PlaceholderText = placeholder,
						CornerRadius = 3,
						TextSize = 14,
						PaddingTop = UDim.new(0,1),
						BorderSizePixel = 0,
						BackgroundColor3 = Color3.fromHex("#2a2a48"),
						TextColor3 = Color3.fromHex("#ffffff"),
					})
					if callback then connect(box.TextChanged, callback) end

					local TextBoxClass = {}
					function TextBoxClass:Get()
						return box.Text
					end
					function TextBoxClass:Set(val)
						box.Text = val
					end

					library:AddFlag(options.flag, TextBoxClass)

					return self
				end
				function OptionsClass:Toggle(options)
					local options = formatTable(options)
			
					local name = options.name or "Toggle"
					local desc = options.description or "Description"

					local callback = options.callback

					local button = self:_baseElement(name, desc)

					local OuterCircle = create("TextButton",{
						Parent = button,
						Size = UDim2.new(0, 30, 0, 14),
						Position = UDim2.new(1, -55, 0.5, -3),
						CornerRadius = CornerRadius.new(6, 6, 6, 6),
						BackgroundColor3 = Color3.fromRGB(224, 224, 224),
						BorderSizePixel = 0,
						TextTransparency = 1,
					})
					local InnerCircle = create("Frame",{
						Parent = OuterCircle,
						Size = UDim2.new(0, 16, 0, 16),
						Position = UDim2.new(0, 0, 0, -1),
						CornerRadius = CornerRadius.new(10, 10, 10, 10),
						BackgroundColor3 = Color3.fromHex("#fefefe"),
						BorderSizePixel = 0,
					})

					local ToggleClass2 = {
						Enabled = false,
					}
					function ToggleClass2:Update()
						if self.Enabled then
							Tween(InnerCircle, TweenInfo.new(0.3), {Position = UDim2.new(1, -16, 0, -1)}):Play()
							Tween(InnerCircle, TweenInfo.new(0.3),  {BackgroundColor3 = Color3.fromHex("#5e1f9e")}):Play()
						else
							Tween(InnerCircle, TweenInfo.new(0.3), {Position = UDim2.new(0, 0, 0, -1)}):Play()
							Tween(InnerCircle, TweenInfo.new(0.3),  {BackgroundColor3 = Color3.fromHex("#fefefe")}):Play()
						end
						if callback then
							callback(self.Enabled)
						end
					end

					function ToggleClass2:Toggle()
						ToggleClass2.Enabled = not ToggleClass2.Enabled
						self:Update()
					end
					function ToggleClass2:Get()
						return self.Enabled
					end
					function ToggleClass2:Set(enabled)
						ToggleClass2.Enabled = enabled
						self:Update()
					end
					connect(OuterCircle.MouseButton1Click, function()
						ToggleClass2:Toggle()
					end)
					if options.default then
						ToggleClass2:Set(options.default)
					end
					

					library:AddFlag(options.flag, ToggleClass2)
					return self
				end

				OptionsClass:Keybind{
					Name = "Keybind"
				}

				ToggleClass.optionsclass = OptionsClass
				return OptionsClass
			end

			connect(OuterCircle.MouseButton1Click, function()
				ToggleClass:Toggle()
			end)
			if options.default then
				ToggleClass:Set(options.default)
			end

			library:AddFlag(flag, ToggleClass)
			return ToggleClass;
		end
	end
	

	function library:AddFlag(flag, class)
		local flag = flag or tostring(library.flags._counter + 1);
		self.flags[flag] = class
		self.flags._counter = self.flags._counter + 1
	end

	function library:SetTitle(title)
		TitleLabel.Text = title
	end
	function library:SetVersion(version)
		VersionLabel.Text = version
	end
	function library:SetDescription(desc)
		DescLabel.Text = desc
	end
	function library:SetLocation(location)
		LocationLabel.Text = location
	end
	function library:SetCurrentTab(tab)
		local previous_tab = library.tabs.current
		if previous_tab ~= nil then
			previous_tab.container.Visible = false
			Tween(previous_tab.side_button, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
		end
		tab.container.Visible = true
		Tween(tab.side_button, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()

		library.tabs.current = tab
	end

	function library:Tab(options)
		local options = formatTable(options)

		local icon = options.icon or options.image or ""
		local name = options.name or "Tab "..(#self.tabs)
		local accent = options.accentcolor or Color3.fromHex("#5e1f9e")

		local tab = Tab.new(name, icon, accent)
		table.insert(library.tabs, tab)

	
		connect(tab.side_button.MouseButton1Click, function()
			if library.tabs.current == tab then return end

			library:SetCurrentTab(tab);
		end)
		
		if library.tabs.current == nil then
			library:SetCurrentTab(tab);
		end

		return tab:Elements()
	end

	function library:Open()
		FluxGUI.Enabled = true;
	end

	library:Open()
	return library
end

local lib = FluxLib.new{
    name = "Bosploit",
    description = "yep this makes you cracked at minecraft"
}

local Tab1 = lib:Tab{
    name = "Ghost",
    icon = "https://upload.wikimedia.org/wikipedia/commons/3/36/Fortnite.png"
}

local Tab2 = lib:Tab{
    name = "Blatant",
    icon = "https://upload.wikimedia.org/wikipedia/commons/3/36/Fortnite.png"
}

local UI = lib:Tab{
    name = "Customization",
    icon = "https://upload.wikimedia.org/wikipedia/commons/3/36/Fortnite.png"
}

local velocityX, VelocityY, VelocityZ = 0,0,0;
local Fullbright, prevBrightness = false, nil
local ReachToggle, ReachRange = false, 4
local VelocityToggle = false
local AutoClicker = false
local aimassist = false
local SumoWalls = false
local Scaffold = false
local Killaura = false
local Eagle = false
local Wtap = false
local counter = 0
local Cps = 5;

UI:Toggle({
	Name ="Transparent UI",
	Description = "This thing is so cool",
	Callback = function(Callback)
		
	end,
})

UI:TextBox({
	Name ="Foreground",
	Description = "Customize the foreground color of the UI.",
	ItemContent = "OH MY GOD",
	Callback = function(Callback)
		
	end
})

Tab2:Toggle({
	Name = "KickSelf",
	Description = "kicks you (works only in servers)",
	Callback = function(Callback)
		game:Shutdown("bye bye!")
	end
})

Tab1:Toggle({
	Name ="Fullbright",
	Description = "Gives you night vision",
	Callback = function(Callback)
		Fullbright = Callback
		if Callback == false and prevBrightness ~= nil then
			LightingService.Brightness = prevBrightness
			prevBrightness = nil
		end
	end
})

Tab1:Toggle({
	Name ="AutoClicker",
	Description = "Automatically clicks",
	Callback = function(Callback)
		AutoClicker = not AutoClicker
	end
}):Options():Slider({
	Name = "Cps",
	Min = 1,
	Max = 30,
	Default = 5,
    Callback = function(val)
        Cps = val
    end
})


Tab1:Toggle({
	Name ="Wtap",
	Description = "Double click on click",
	Callback = function(Callback)
		Wtap = not Wtap
	end
}):Options()

Tab1:Text({
	Name ="Player"
})

Tab1:Toggle({
	Name ="Eagle",
	Description = "Auto place or god bridge basically",
	Callback = function(Callback)
		Eagle = not Eagle
	end
}):Options()

Tab1:Toggle({
	Name ="Reach",
	Description = "Extends reach",
	Callback = function(Callback)
		ReachToggle = not ReachToggle
	end,
}):Options():Slider({
	Name = "Range",
	Min = 1,
	Max = 6,
	Default = 4,
    Callback = function(val)
        ReachRange = val
    end
})

Tab1:Toggle({
	name = "AimAssist",
	Description = "Assists you in aiming",
	Callback = function(Callback)
		aimassist = not aimassist
	end,
}):Options():Toggle({
	Name = "Disable On Death",
	Flag = "aimassist_disable"
}):Toggle({
	Name = "Requires mouse down",
	Flag = "aimassist_mousedown"
}):Slider({
	Name = "Range",
	Flag = "aimassist_range",
	Min = 1,
	Max = 6,
	Default = 4
}):Slider({
	Name = "Assist Angle",
	Flag = "aimassist_angle_attach",
	Min = 1,
	Max = 360,
	Default = 15,
}):Slider({
	Name = "Aim Speed",
	Flag = "aimassist_aim_speed",
	Min = 0.1,
	Max = 2,
	Default = 1
})

Tab1:Toggle({
	name = "Velocity",
	Description = "Low knockback",
	Callback = function(Callback)
		VelocityToggle = not VelocityToggle
	end,
}):Options():Slider({
	Name = "X",
	Min = 0,
	Max = 10,
	Default = 0,
    Callback = function(val)
        velocityX = val
    end
}):Slider({
	Name = "Y",
	Min = 0,
	Max = 10,
	Default = 0,
    Callback = function(val)
        velocityY = val
    end
}):Slider({
	Name = "Z",
	Min = 0,
	Max = 10,
	Default = 0,
    Callback = function(val)
        velocityZ = val
    end
})
local killauraTeamcheck = false;
local killauraCooldown = 200
local killauraCooldownMin = 5
local killauraCooldownMax = 6
--[[
	Mode
	Target mode (priority list)

	Swing range 
	Attack range
	* ^^ Added overall range instead 

	BlockHit -- do not touch
	Max targets -- nuh uh
	GUI Check -- probably impossible atm
--]]

local killaura = Tab2:Toggle({
	Name = "Kill Aura",
	Flag = "killaura",
	Description = "Automatically kills people and shit",
	Callback = function(Callback)
		Killaura = not Killaura
	end,
}):Options()
	:SliderRange({
		Name = "Attacks Per Second",
		Min = 1,
		Max = 25,
		DefaultMin = killauraCooldownMin,
		DefaultMax = killauraCooldownMax,
		Callback = function(min, max)
			killauraCooldownMin = min
			killauraCooldownMax = max
		end
	}):Slider({
		Name = "Range",
		Flag = "killaura_range",
		Min = 1,
		Max = 6,
		Default = 4
	})
	:Slider({
		Name = "Max Angle",
		Flag = "killaura_angle",
		Min = 0,
		Max = 360,
		Default = 360
	})
	:Slider({
		Name = "Attack Angle",
		Flag = "killaura_angle_attach",
		Min = 1,
		Max = 360,
		Default = 15,
	})
	:Toggle({
		Name = "Auto Aim",
		Flag = "killaura_aim",
		Default = true,
	})
	:Slider({
		Name = "Aim Speed",
		Flag = "killaura_aim_speed",
		Min = 0.1,
		Max = 2,
		Default = 1
	})
	:Toggle({
		Name = "Jitter",
		Flag = "killaura_jitter"
	})
	:Slider({
		Name = "Jitter Range",
		Flag = "killaura_jitter_range",
		Min = 0,
		Max = 10,
		Default = 5
	})
	:Toggle({
		Name = "Hit Non-Players",
		Flag = "killaura_nonentities"
	})
	:Toggle({
		Name = "Team Check",
		Callback = function(cal)
			killauraTeamcheck = cal
		end
	}):Toggle({
		Name = "Disable On Death",
		Flag = "killaura_disable"
	}):Toggle({
		Name = "Limit to Items",
		Flag = "killaura_items"
	}):Toggle({
		Name = "Require Mouse Down",
		Flag = "killaura_mousedown"
	})


Tab2:Toggle({
Name ="Scaffold",
	Description = "Automatically places blocks !",
	Callback = function(Callback)
		Scaffold = not Scaffold
	end,
}):Options()

local DEFAULT_TYPE = "iron_ore"
local WALL_HEIGHT = 3
local MIN_GAP_HEIGHT = 3

Tab2:Toggle({
Name ="SumoWalls",
	Description = "Anti fall !!",
	Callback = function(Callback)
		SumoWalls = not SumoWalls
	end,
}):Options():Slider({
	Name = "Min Gap Height",
	Min = 2,
	Max = 10,
	Default = MIN_GAP_HEIGHT,
    Callback = function(val)
        MIN_GAP_HEIGHT = val
    end
}):Slider({
	Name = "Wall Height",
	Min = 1,
	Max = 10,
	Default = WALL_HEIGHT,
    Callback = function(val)
        WALL_HEIGHT = val
    end
}):TextBox({
    Name = "Block Type",
	Placeholder = "Block Type",
	Editable = true,
    Text = DEFAULT_TYPE,
    Callback = function(text)
        DEFAULT_TYPE = text
    end
})



local function GetClosest(distance_limit, teamcheck, hit_entities)
    local localPlayer = LocalPlayer.Character -- when changing worlds the character changes so we have to do this to keep it updated

    local Entities = hit_entities and workspace:GetHittableEntities() or Players:GetPlayers()
    local PlayerEntity = localPlayer.entity

	local closest
	local distance = distance_limit or 5


    for _, Entity in ipairs(Entities) do
		if tostring(Entity.entityObject):sub(1,16) == "EntityArmorStand" then
			goto continue
		end

        if teamcheck and (Entity:GetDisplayName().text:sub(1,10) == localPlayer:GetDisplayName().text:sub(1,10)) then
            goto continue
        end

        local distance2 = localPlayer:GetDistanceToEntity(Entity.entityObject)
		if (Entity:IsAlive()) and (distance > distance2) and (Entity.entityObject ~= PlayerEntity) then
            distance = distance2
            closest = Entity
        end

        ::continue::
    end
	return closest
end

local function WrapAngleTo180(angle)
    return (angle + 180) % 360 - 180
end

local function GetYawChange(yaw, x, z)
    local deltaX = x - LocalPlayer.Character:GetPosition().X
    local deltaZ = z - LocalPlayer.Character:GetPosition().Z
    local yawToEntity = math.deg(math.atan2(deltaZ, deltaX)) - 90
    return WrapAngleTo180(-(yaw - yawToEntity))
end
function GetPitchChange(pitch, posX, posY, posZ)
    local playerPosX = LocalPlayer.Character:GetPosition().X
    local playerPosY = LocalPlayer.Character:GetPosition().Y
    local playerPosZ = LocalPlayer.Character:GetPosition().Z

    local deltaY = posY - 2.2 - playerPosY
    local deltaX = posX - playerPosX
    local deltaZ = posZ - playerPosZ

    deltaY = posY - playerPosY + 0.0625

    local distance = math.sqrt(deltaX * deltaX + deltaZ * deltaZ)

    local pitchToEntity = (-math.deg(math.atan(deltaY / distance)) - 2 + (LocalPlayer.Character:GetDistance(posX, posY, posZ) * 0.2)) + 1
    return -WrapAngleTo180(pitch - pitchToEntity)
end

function GetYawAndPitch(entity)
	local localPlayer = LocalPlayer.Character

    local yaw = localPlayer:GetYaw()
    local pitch = localPlayer:GetPitch()


    local moveYaw = GetYawChange(yaw, entity:GetPosition().X, entity:GetPosition().Z)
    local movePitch = GetPitchChange(pitch, entity:GetPosition().X, entity:GetPosition().Y-0.5, entity:GetPosition().Z)

	return moveYaw, movePitch
end

function doAimassist()
	if not LocalPlayer.Character:IsAlive() then
		if lib.flags["aimassist_disable"].Enabled then
			lib.flags["aimassist"]:Set(false)
		end
		
		return
	end

	if lib.flags["aimassist_mousedown"].Enabled and Mouse.Button1Down == false then
		return
	end

	local closestEntity = GetClosest(lib.flags["aimassist_range"]:Get())
	if closestEntity == nil then return end

	local yaw, pitch = GetYawAndPitch(closestEntity)
	local gcd = 0.2
	local yawGcdFix = 0.05 - (yaw % gcd)
	local pitchGcdFix = 0.05 - (pitch % gcd)

	if math.abs(yaw) > lib.flags["aimassist_angle_attach"]:Get() then return end
	local aimspeed = lib.flags["aimassist_aim_speed"]:Get()
	LocalPlayer.Character:SetYaw(LocalPlayer.Character:GetYaw() + yaw * 0.5 * aimspeed + yawGcdFix)
	LocalPlayer.Character:SetPitch(LocalPlayer.Character:GetPitch() + pitch * 0.5 * aimspeed + pitchGcdFix)
end

function DoKillaura()
	if not LocalPlayer.Character:IsAlive() then
		if lib.flags["killaura_disable"].Enabled then
			lib.flags["killaura"]:Set(false)
		end

		return
	end
	if lib.flags["killaura_mousedown"].Enabled and Mouse.Button1Down == false then
		return
	end
	if lib.flags["killaura_items"].Enabled and LocalPlayer.Character:GetHeldItem() == nil then
		return
	end

    local closestEntity = GetClosest(lib.flags["killaura_range"]:Get(), killauraTeamcheck, lib.flags["killaura_nonentities"].Enabled)
    if closestEntity == nil then
        return
    end

	local yaw, pitch = GetYawAndPitch(closestEntity)
	
	local gcd = 0.2

    local yawGcdFix = 0.05 - (yaw % gcd)
    local pitchGcdFix = 0.05 - (pitch % gcd)

	if math.abs(yaw) > lib.flags["killaura_angle"]:Get() then return end

	if lib.flags["killaura_aim"].Enabled then
		local aimspeed = lib.flags["killaura_aim_speed"]:Get()
		if lib.flags["killaura_jitter"].Enabled then
			local range = lib.flags["killaura_jitter_range"]:Get()
			yaw = WrapAngleTo180(yaw + math.random(-range, range))
			pitch = WrapAngleTo180(pitch + math.random(-range, range))
		end
		
		LocalPlayer.Character:SetYaw(LocalPlayer.Character:GetYaw() + yaw * 0.5 * aimspeed + yawGcdFix)
		LocalPlayer.Character:SetPitch(LocalPlayer.Character:GetPitch() + pitch * 0.5 * aimspeed + pitchGcdFix)
	end
	if math.abs(yaw) <= lib.flags["killaura_angle_attach"]:Get() then 
		Attack(closestEntity) 
	end -- prevents random detections
end

local killaura_skip_switch = false;
local killaura_time = os.clock()
function Attack(entity)
    if (killaura_time < os.clock()) then
        local Character = LocalPlayer.Character

        killaura_time = os.clock() + ( 1 / math.random(killauraCooldownMin, killauraCooldownMax) )
        killaura_skip_switch = true;

        -- WTap logic
        if Wtap then
            Character:SetSprinting(false)
            wait(0.05)
            Character:SetSprinting(true)
        end

        Character:Swing()
        PacketService:SendPacket("C0A", {})
        PacketService:SendPacket("C02", { entity.entityObject, Character.Attack })
        -- LocalPlayer.Character:AttackEntity(entity.entityObject)
    end
end
function DoReach()
	local entity = workspace:Reach(ReachRange)
	if entity then
		Attack(entity)
	end
end
function DoCrit()
	local pos = LocalPlayer.Character.Position
	PacketService:SendPacket("C04", {pos.X, pos.Y + 0.0625,pos.Z, true})
	PacketService:SendPacket("C04", {pos.X, pos.Y, pos.Z, false})
	PacketService:SendPacket("C04", {pos.X, pos.Y + 1.1E-5D,pos.Z, false})
end

function GetOffsets(face, bx, by, bz)
    local offsets = {
		[LocalPlayer.East] = {x = bx + 1, y = by + 1, z = bz + 0.5},
		[LocalPlayer.West] = {x = bx, y = by + 1, z = bz + 0.5},
		[LocalPlayer.South] = {x = bx + 0.5, y = by + 1, z = bz + 1},
		[LocalPlayer.North] = {x = bx + 0.5, y = by + 1, z = bz},
		[LocalPlayer.Up] = {x = bx + 0.5, y = by + 1, z = bz + 0.5},
		[LocalPlayer.Down] = {x = bx + 0.5, y = by, z = bz + 0.5},
    }
    return offsets[face]
end


function DoScaffold()
	Character = LocalPlayer.Character
    local Position =  Character:GetPosition()
	local blockposUnder = Vector3.new(Position.X, Position.Y - 1, Position.Z)
    local blockUnder = Workspace:GetBlock(blockposUnder)
    local nameUnder = Workspace:GetBlockName(blockUnder)
    
    
    if(nameUnder ~= "air") then 
        return
    end

    local ClosestDistance = 8
    local BlockposTarget = nil

    local posX = 0
    local posY = 0
    local posZ = 0

    for x = -3, 3 do
        for y = -3, 3 do
            for z = -3, 3 do
                local blockpos = Vector3.new(Character:GetPosition().X + x, Character:GetPosition().Y + y, Character:GetPosition().Z + z)  
                local block = Workspace:GetBlock(blockpos)
                local name = Workspace:GetBlockName(block)
                
                if(name ~= "air") then 
                    local tempPosX = math.ceil(Character:GetPosition().X + x) - 0.5
                    local tempPosY = math.ceil(Character:GetPosition().Y + y) - 0.5
                    local tempPosZ = math.ceil(Character:GetPosition().Z + z) - 0.5

                    local Distance = Character:GetDistance(tempPosX, tempPosY, tempPosZ)
                    --local Distance = LocalPlayer:getDistanceSqToCenter(blockpos)
                    if(Distance < ClosestDistance) then
                        ClosestDistance = Distance
                        BlockposTarget = blockpos
                        posX = tempPosX
                        posY = tempPosY
                        posZ = tempPosZ
                    end
                end
            end
        end
    end

    if(BlockposTarget == nil) then
        return
    end


    --LocalPlayer:SetPitch(GetPitchChange(0, posX, posY, posZ))
    --LocalPlayer:SetYaw(GetYawChange(0, posX, posZ))
    local Face = Character:GetHorizontalFacing(180 + GetYawChange(0, posX, posZ))

    local DiffrenceY = Character:GetPosition().Y - posY - 1.5

    if(DiffrenceY > 0) then
        Face = LocalPlayer.Up
    end

    --if(DiffrenceY < -1) then -- Downwards scaffold
    --    Face = LocalPlayer.Down
    --end

    local offsets = GetOffsets(Face, math.floor(posX), math.floor(posY), math.floor(posZ))
    local position = Vector3.new(offsets.x, offsets.y, offsets.z)

    Character:Swing()

    Character:PlaceBlock(Character:GetHeldItem(), BlockposTarget:ToBlockPos(), Face, position)
end

local eagle_time = os.clock()
function DoEagle()
	if LocalPlayer.Character:IsBlockBelowAir() 
		and LocalPlayer.Character:GetMoveForward() < 0.1 
		and LocalPlayer.Character:IsOnGround()
		and not LocalPlayer.Character:IsFlying() 
		then
		eagle_time = os.clock()
	end
	if os.clock() - eagle_time <= 0.125 then
		LocalPlayer.Character:SetSneaking(true)
	elseif not LocalPlayer.Character:IsSneakPressed() then
		LocalPlayer.Character:SetSneaking(false)
	end
end

do
	if Block then
		if Block._connection then
			Block._connection:Disconnect()
		end
		for block,_ in pairs(Block._blocks) do pcall(block.destroy,block) end
	end
	getgenv().Block = {}
	Block.__index = Block
	Block._blocks = {}
	function Block.new(position, type)
		local self = setmetatable({
			_position = position,
			_type = type
		}, Block)
		Block._blocks[self] = true
		
		return self
	end

	function getState(state)
		return workspace:GetBlockState(state) or workspace:GetBlockState("air")
	end

	function Block:update()
		local type_state = getState(self._type)
		local position_state = workspace:GetBlockState(self._position)
		
		if position_state ~= type_state then
			self._previous = position_state
			workspace:SetBlock(self._position, type_state)
		end
	end
	function Block:destroy()
		
        if not Block._blocks[self] then return end
		Block._blocks[self] = nil
		if self._previous ~= nil then
			workspace:SetBlock(self._position, self._previous)
		end
	end

	function Block:setPosition(position)
		local old = self._position
		self._position = position
		workspace:SetBlock(old, self._previous)
	end
	function Block:setType(type)
		local old = self._type
		self._type = type
		workspace:SetBlock(self._position, self._type)
		--self:update()
	end

	local running = false
	local connection;
	connection = game:GetService("RunService").Tick:Connect(function()
		if not (Block and Block._blocks) then return connection:Disconnect() end
		if running then return end
		running = true
		for block,_ in pairs(Block._blocks) do
			block:update()
		end
		running = false
	end)
	Block._connection = connection

	function getHeightUntilGround(x,y,z)	
		local height = 0
		while workspace:GetBlockName(Vector3.new(x,y - height,z)) == "air" and height < 100 do
			height = height + 1
		end
		return height
	end

	local currentBlocks = {}
	local doingSumo = false
	function doSumoWalls()
		local Character = LocalPlayer.Character
		if not (Character and Character:IsAlive()) or doingSumo then return end
		
		doingSumo = true
		local s, e = pcall(function()
			
			local newblocks = {}
			
			local position = Character:GetPosition()
			local height = getHeightUntilGround(position.X,position.Y,position.Z)
			for xOffset = -2, 2 do
				for zOffset = -2, 2 do
					if(xOffset == 0 and zOffset == 0)then goto continue end
					local x,y,z = position.X + xOffset, position.Y, position.Z + zOffset

					local isGap = true
					for yOffset = 0, MIN_GAP_HEIGHT do
						if workspace:GetBlockName(Vector3.new(x,y - yOffset,z)) ~= "air" then 
							isGap = false 
							break 
						end
					end

					if isGap then
						local newHeight = getHeightUntilGround(x, y, z)
						if height < newHeight or Character:IsOnGround() then
							for offset = 0, WALL_HEIGHT-1 do
								local pos = Vector3.new(x,y + 1 - offset,z)
								if currentBlocks[pos] then
									currentBlocks[pos]:setType(DEFAULT_TYPE)
									newblocks[pos] = currentBlocks[pos]
								else 
									local block = Block.new(pos, DEFAULT_TYPE)
									newblocks[pos] = block
									currentBlocks[pos] = block
								end
							end
						end
					end
					::continue::
				end
			end
			for i,v in pairs(currentBlocks) do
				if not newblocks[i] then
					v:destroy()
					currentBlocks[i] = nil
				end
			end
			
		end)
		if not s then print("Error:",e) end
		doingSumo = false
	end
end
local counter = 0

function DoVelocity()
    if LocalPlayer.Character:GetHurtTime() == 9 then
        LocalPlayer.Character:SetMotionX(velocityX)
        LocalPlayer.Character:SetMotionY(VelocityY)
        LocalPlayer.Character:SetMotionZ(VelocityZ)
    end
end

function DoAutoClicker()
	Mouse.MouseButton1Click();
end

function DoFullbright()
	if LightingService.Brightness ~= 10 then
		prevBrightness = LightingService.Brightness
		LightingService.Brightness = 10
	end
end

connect(UserInputService.InputBegan, function(key)
	if key.UserInputType == Enum.UserInputType.MouseButton1 then
		if ReachToggle then
			DoReach()
		end
	end
end)

PacketService.PacketSend:Connect(function(packet)
	local id = packet.Packet.ID;
	if killaura_skip_switch then
		if id == "C0A" and not packet:Checkcaller() then
			packet:SetCancel(true)
		elseif id == "C02" then
			killaura_skip_switch = false
		end
	end
end)

connect(game:GetService("RunService").Tick, function()
	if Killaura then
		DoKillaura()
	end
	
	if aimassist then
		doAimassist()
	end

	if VelocityToggle then
		DoVelocity()
	end
	if Scaffold then 
		DoScaffold()
	end

	if Eagle then
		DoEagle()
	end

	if AutoClicker then
		DoAutoClicker()
	end

	if SumoWalls then
		doSumoWalls()
	else
		for i,v in pairs(Block._blocks) do
			v:destroy()
		end
	end
	if Fullbright then
		DoFullbright()
	end
end)