core:module('CoreMissionManager')
core:import('CoreTable')

local level = Global.level_data and Global.level_data.level_id or ''
local _add_script_orig = MissionManager._add_script
local dont_run = BLT.Mods:GetModByName("RestorationMod")

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
		-- play the proper heist end lines for stealth, instead of always playing the loud completion lines
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
				table.insert(element.values.on_executed, { delay = 0, id = 100852 })
			elseif element.id == 100022 and element.editor_name == 'alarm' then
				table.insert(element.values.on_executed, { delay = 0, id = 100853 })
			end
		end

		_add_script_orig(self, data)
	end
elseif level == 'firestarter_1' then
	function MissionManager:_add_script(data)
		-- Disable an erroneously placed bag secure zone that can be used with a money bag
		for _, element in pairs(data.elements) do
			if element.id == 101498 and element.editor_name == 'oldLootArea' then
				element.values.enabled = false
			end
		end

		_add_script_orig(self, data)
	end
elseif level == 'flat' then
	function MissionManager:_add_script(data)
		-- Re-enable the C4 alleyway drop on MH-DS
		-- Re-enable a disabled sniper spawn
		for _, element in pairs(data.elements) do
			if element.id == 102261 and element.editor_name == 'pick 1' then
				element.values.on_executed[3] = { delay = 0, id = 100350 }
			elseif element.id == 101599 and element.editor_name == 'sniper_spawn_006' then
				element.values.enabled = true
			end
		end

		_add_script_orig(self, data)
	end
elseif level == 'framing_frame_3' and not dont_run then
	function MissionManager:_add_script(data)
		-- fix for alarm scripts possibly executing twice which allows for pc restarts while power is cut
		-- fix overkill mistakenly executing the "ah, that's the vault guys" dialogue instead of disabling it once you enter the vault
		-- also address a case where if you go loud after the vault is open but before you enter then the dialogue would also play wrongly
		-- fix vantage point enemies not spawning if you had not been on the vantage point in stealth or within 35s of going loud
		for _, element in pairs(data.elements) do
			if element.id == 100318 and element.editor_name == 'police_called' then
				table.insert(element.values.on_executed, { delay = 0, id = 102341 }) -- disable team ai stealth special objectives here instead of just when the vault lasers trip the alarm
				table.insert(element.values.on_executed, { delay = 35, id = 105481 }) -- enable the vantage point areatrigger to initiate the spawn enemy loop
			elseif element.id == 100750 and element.editor_name == '2ndComputerUse' then
				table.insert(element.values.on_executed, { delay = 0, id = 105757 }) -- if vault has been opened, don't play the "ah, that's the vault guys" dialogue
			elseif element.id == 100852  and element.editor_name == 'ALARM' then
				element.values.on_executed[1] = { delay = 0, id = 100318 } -- execute police_called as it can only execute once
				table.remove(element.values.on_executed, 3) -- now redundant, handled by police_called
			elseif element.id == 105480 and element.editor_name == 'trigger_area_030' then
				element.values.width = 2300
				element.values.height = 500 -- extend the areatrigger to cover the whole vantage point
				element.values.on_executed[1] = { delay = 20, id = 105559 } -- start the enemy spawn loop
				element.values.enabled = false -- toggled once it goes loud
			elseif element.id == 105481 and element.editor_name == 'logic_toggle_147' then
				element.values.elements[1] = 105480 -- toggle the vantage point areatrigger to start the spawns once the heist goes loud
			elseif element.id == 105757 and element.editor_name == 'disable_bain_VO_vault' then
				table.remove(element.values.on_executed, 1) -- don't execute the dialogue
				table.insert(element.values.elements, 105221) -- disable it instead
			elseif element.id == 105758 and element.editor_name == 'area_player_stepped_inside_vault' then
				element.values.enabled = false -- since we just disable the dialogue as soon as the vault is open, this is now redundant
			end
		end

		_add_script_orig(self, data)
	end
elseif level == 'watchdogs_2' then
	-- Fix cheat spawns being improperly enabled causing enemies to spawn in while visible
	function MissionManager:_add_script(data)
		for _, element in pairs(data.elements) do
			if (element.id == 101013 or element.id == 101235) and element.editor_name == 'empty' then
				element.values.amount = 'all' -- all players have to be in a position where they could not see the cheat spawns for them to activate
				element.values.width = 7000 -- doesn't extend far enough for both to be out of vision
			elseif element.id == 101220 and element.editor_name == 'enter' then
				element.values.width = 7000 -- doesn't extend far enough for both to be out of vision
			end
		end
		
		_add_script_orig(self, data)
	end
end
