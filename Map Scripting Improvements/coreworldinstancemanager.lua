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
end