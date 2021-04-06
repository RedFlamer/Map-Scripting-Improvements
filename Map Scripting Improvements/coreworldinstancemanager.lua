local level = Global.level_data and Global.level_data.level_id or ''
local _get_instance_mission_data_orig = CoreWorldInstanceManager._get_instance_mission_data

if Network:is_client() then
elseif level == 'friend' then
	function CoreWorldInstanceManager:_get_instance_mission_data(path)
		local result = _get_instance_mission_data_orig(self, path)

		if path == 'levels/instances/unique/friend/computer_usb/world/world' then
			for _, element in ipairs(result.default.elements) do
				if element.id == 100015 and element.editor_name == 'USB_is_in' then
					element.values.on_executed[5].delay = 0
					break
				end
			end
		end

		return result
	end
elseif level == 'kenaz' then
	-- https://steamcommunity.com/app/218620/discussions/14/5671690972171731664/
	-- fixed civilians getting stuck at a slot machine and never roaming
	function CoreWorldInstanceManager:_get_instance_mission_data(path)
		local result = _get_instance_mission_data_orig(self, path)

		if path == 'levels/instances/unique/kenaz/slot_machine/world/world' then
			for _, element in ipairs(result.default.elements) do
				if element.id == 100054 and element.editor_name == 'play' then
					element.values.trigger_times = 0
					break
				end
			end
		end

		return result
	end
elseif level == 'nmh' then
	-- https://steamcommunity.com/app/218620/discussions/14/4153959587261788690/
	-- Fixed centrifuges only being usable 9 times
	function CoreWorldInstanceManager:_get_instance_mission_data(path)
		local result = _get_instance_mission_data_orig(self, path)

		if path == 'levels/instances/unique/nmh/nmh_fuge/world/world' then
			for _, element in ipairs(result.default.elements) do
				if element.id == 100015 and element.editor_name == 'interacted_with_centrifuge' then
					element.values.trigger_times = 0
					break
				end
			end
		end

		return result
	end
end