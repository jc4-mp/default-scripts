local categories = require("animations")

local open_key = Key.Y
local open = false

-- path of the animation clicked in the list, played with the Play button
local selected = nil

function toggleOpen()
	open = not open
	Input.SetEnabled(not open)
	UI.SetCursorVisible(open)
end

Event.Add("OnKeyUp", function(key)
	if key == open_key and not Chat.IsTyping() then
		toggleOpen()
	end
end)

Event.Add("OnRender", function()
	if open then
		renderMenu()
	end
end)

function renderMenu()
	local player = World.LocalPlayer()
	local current = player and player:AsPlayer():GetAnimation() or ""

	local render_size = Render.GetSize()
	local window_width = math.min(720, math.max(480, render_size.x * 0.4))
	local window_height = math.min(650, math.max(300, render_size.y * 0.7))

	UI.SetNextWindowSize(vec2(window_width, window_height), 0)
	UI.SetNextWindowPos(vec2(render_size.x * 0.5 - window_width / 2, render_size.y * 0.5 - window_height / 2), 0)

	if UI.Begin("Animations", UI.WindowFlags_NoCollapse) then
		local button_width = (UI.GetContentRegionAvail().x - 8) / 2

		if UI.Button("Play", vec2(button_width, 30)) and selected then
			Local.PlayAnimation(selected, true)
		end

		UI.SameLine(0, 8)

		if UI.Button("Stop", vec2(button_width, 30)) then
			Local.StopAnimation()
		end

		UI.TextDisabled("Select an animation and press Play")
		UI.Separator()

		if UI.BeginTabBar("AnimationCategories", 0) then
			for _, category in ipairs(categories) do
				if UI.BeginTabItem(category.category) then
					if UI.BeginChild("AnimationList", vec2(0, UI.GetContentRegionAvail().y), 0, 0) then
						for _, animation in ipairs(category.animations) do
							local label = animation.name .. (animation.path == current and "  (playing)" or "")

							if UI.Selectable(label .. "##" .. animation.path, animation.path == selected) then
								selected = animation.path
							end
						end
					end

					UI.EndChild()
					UI.EndTabItem()
				end
			end

			UI.EndTabBar()
		end
	end

	UI.End()
end