core:module('CoreMissionManager')
core:import('CoreTable')

local level = Global.level_data and Global.level_data.level_id or ''
local _add_script_orig = MissionManager._add_script

if level == 'dah' then
	function MissionManager:_add_script(data)
		-- Why does a security room spawn disable the chandelier over the fountain?
		for _, element in pairs(data.elements) do
			if element.id == 101659 and element.editor_name == 'Disable_Conference_Room' then
				table.remove(element.values.unit_ids, 4)
			end
		end

		_add_script_orig(self, data)
	end
elseif level == 'election_day_2' then
	function MissionManager:_add_script(data)
		-- stop saying we completed it loud when we completed it stealth bain
		table.insert(data.elements, {
			class = 'ElementEndscreenVariant',
			id = 100852,
			editor_name = 'stealth_endscreen',
			values = {
				execute_on_startup = false,
				rotation = Rotation(0, 0, -0),
				position = Vector3(-300, 3100, 0),
				on_executed = {},
				enabled = true,
				base_delay = 0,
				trigger_times = 0,
				variant = 1
			}
		})	
		table.insert(data.elements, {
			class = 'ElementEndscreenVariant',
			id = 100853,
			editor_name = 'loud_endscreen',
			values = {
				execute_on_startup = false,
				rotation = Rotation(0, 0, -0),
				position = Vector3(-200, 3100, 0),
				on_executed = {},
				enabled = true,
				base_delay = 0,
				trigger_times = 0,
				variant = 2
			}
		})
		
		for _, element in pairs(data.elements) do
			if element.id == 100107 and element.editor_name == 'spawned' then
				table.insert(element.values.on_executed, {
					delay = 0,
					id = 100852
				})
			elseif element.id == 100022 and element.editor_name == 'alarm' then
				table.insert(element.values.on_executed, {
					delay = 0,
					id = 100853
				})
			end
		end

		_add_script_orig(self, data)
	end
elseif level == 'flat' then
	function MissionManager:_add_script(data)
		-- Re-enable the unused C4 alleyway drop on MH-DS
		-- Why was this even unused Overkill...
		for _, element in pairs(data.elements) do
			if element.id == 102261 and element.editor_name == 'pick 1' then
				element.values.on_executed[3] = {
					delay = 0,
					id = 100350
				}
			end
		end

		_add_script_orig(self, data)
	end
elseif level == 'framing_frame_3' then
	function MissionManager:_add_script(data)
		for _, element in pairs(data.elements) do
			if element.id == 100852 then
				-- potentially executing the alarm scripts twice is a MAJOR oversight, instead execute police_called as it can only execute once
				element.values.on_executed[1] = {
					delay = 0,
					id = 100318
				}
				table.remove(element.values.on_executed, 3) -- redundant
			end
		end

		_add_script_orig(self, data)
	end
end