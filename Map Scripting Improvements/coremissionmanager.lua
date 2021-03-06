core:module("CoreMissionManager")
core:import("CoreTable")

local level = Global.level_data and Global.level_data.level_id or ""

if Network:is_client() then
elseif level == "branchbank" or level == "branchbank_cash" or level == "branchbank_deposit" or level == "branchbank_gold" or level == "branchbank_gold_prof" or level == "branchbank_prof" or level == "firestarter_3" then -- the fuck is this shit
	Hooks:PreHook(MissionManager, "_add_script", "scripting_improvements_add_script", function(self, data)
		-- that's them all right! just seeing them dead makes my blood boil
		-- fixed bain using his dialogue for the john wick civvies when they've been killed
		for _, element in pairs(data.elements) do
			if element.id == 105755 and element.editor_name == "disable_VO" then
				table.insert(element.values.elements, 105700)
			end
		end
	end)
elseif level == "dah" then
	Hooks:PreHook(MissionManager, "_add_script", "scripting_improvements_add_script", function(self, data)
		-- why does a security room spawn disable the chandelier over the fountain?
		for _, element in pairs(data.elements) do
			if element.id == 101659 and element.editor_name == "Disable_Conference_Room" then
				table.remove(element.values.unit_ids, 4)
			end
		end
	end)
elseif level == "election_day_2" then
	Hooks:PreHook(MissionManager, "_add_script", "scripting_improvements_add_script", function(self, data)
		-- play the proper heist end lines for stealth, instead of always playing the loud completion lines
		table.insert(data.elements, {
			class = "ElementEndscreenVariant",
			id = 100852,
			editor_name = "stealth_endscreen",
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
			class = "ElementEndscreenVariant",
			id = 100853,
			editor_name = "loud_endscreen",
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
			if element.id == 100107 and element.editor_name == "spawned" then
				table.insert(element.values.on_executed, {delay = 0, id = 100852})
			elseif element.id == 100022 and element.editor_name == "alarm" then
				table.insert(element.values.on_executed, {delay = 0, id = 100853})
			end
		end
	end)
elseif level == "escape_park" or level == "escape_park_day" then
	Hooks:PreHook(MissionManager, "_add_script", "scripting_improvements_add_script", function(self, data)
		-- fixed some sniping swats not spawning
		for _, element in pairs(data.elements) do
			if element.id == 102486 and element.editor_name == "escape_2_link" or element.id == 102457 and element.editor_name == "escape_3_link" then
				table.insert(element.values.on_executed, {delay = 0, id = 100677})
			end
		end
	end)
elseif level == "firestarter_1" then
	Hooks:PreHook(MissionManager, "_add_script", "scripting_improvements_add_script", function(self, data)
		-- disable an erroneously placed bag secure zone that can be used with a money bag
		-- if only 11 weapon bags spawned now only 11 are required for the all bags xp
		-- make the money bag not required for the securing all bags xp, i'm pretty sure the money is just meant to be a "bonus" bag
		-- make the money bag not count towards heist completion/lord of war achievement
		-- make money bags not blow up when thrown in the gas tank
		-- enable reinforce points on two of the hangars, requires Streamlined Heisting for cops to actually reinforce
		for _, element in pairs(data.elements) do
			if element.id == 101498 and element.editor_name == "oldLootArea" then
				element.values.enabled = false -- no longer can you chuck a money bag in the air and secure it
			elseif element.id == 103622 and element.editor_name == "11" then
				element.values.on_executed[1] = {delay = 0, id = 103628} -- if 11 bags have spawned then give the all loot xp when 11 have been secured.
			elseif element.id == 101016 and element.editor_name == "trigger_area_013" then
				table.remove(element.values.on_executed, 5) -- only check if you have secured all bags and to give the all bags xp on a weapon bag
				table.remove(element.values.on_executed, 4) -- make money not count towards the stealing weapons objective
				table.remove(element.values.on_executed, 3) -- and make money not trigger any dialogue/achievements, now it's solely a bonus bag
			elseif element.id == 101037 and element.editor_name == "SecureLoot" then
				table.insert(element.values.on_executed, {delay = 0, id = 102402}) -- now only weapons will count towards heist completion/achievements
				table.insert(element.values.on_executed, {delay = 0, id = 103638}) -- this seems to be what Overkill had intended to do
				table.insert(element.values.on_executed, {delay = 0, id = 103637}) -- was that the last bag? if so then award the xp
			elseif element.id == 103162 and element.editor_name == "trigger_area_017" then
				table.insert(element.values.on_executed, {delay = 0, id = 101359}) -- enable reinforce points inside/outside the hangar
			elseif element.id == 103211 and element.editor_name == "trigger_area_018" then
				table.insert(element.values.on_executed, {delay = 0, id = 101360}) -- enable reinforce points inside/outside the hangar
			elseif element.id == 104465 and element.editor_name == "func_carry_005" or element.id == 104467 and element.editor_name == "func_carry_006" or element.id == 104468 and element.editor_name == "func_carry_007" or element.id == 104469 and element.editor_name == "func_carry_008" then
				table.remove(element.values.on_executed, 1)
			end
		end
	end)
elseif level == "firestarter_2" then
	Hooks:PreHook(MissionManager, "_add_script", "scripting_improvements_add_script", function(self, data)
		-- fixed van not allowing you to secure the goat without having picked up any other loot
		for _, element in pairs(data.elements) do			
			if element.id == 102673 and element.editor_name == "pickedUpLoot" then
				table.insert(element.values.sequence_list, {sequence = "load", guis_id = 14, unit_id = 100693})
			end
		end
	end)
elseif level == "flat" then
	Hooks:PreHook(MissionManager, "_add_script", "scripting_improvements_add_script", function(self, data)
		-- re-enable the C4 alleyway drop on MH-DS
		-- re-enable a disabled sniper spawn
		for _, element in pairs(data.elements) do
			if element.id == 102261 and element.editor_name == "pick 1" then
				table.insert(element.values.on_executed, {delay = 0, id = 100350}) -- c4 has a 33% chance to drop in the alley
			elseif element.id == 101599 and element.editor_name == "sniper_spawn_006" or element.id == 101521 and element.editor_name == "SO Sniper" then
				element.values.enabled = true -- enable a sniper spawn and his special objective
			end
		end
	end)
elseif level == "framing_frame_3" then
	Hooks:PreHook(MissionManager, "_add_script", "scripting_improvements_add_script", function(self, data)
		-- fix for alarm scripts possibly executing twice which allows for pc restarts while power is cut
		-- fix overkill mistakenly executing the "ah, that's the vault guys" dialogue instead of disabling it once you enter the vault
		-- also address a case where if you go loud after the vault is open but before you enter then the dialogue would also play wrongly
		-- fix vantage point enemies not spawning if you had not been on the vantage point in stealth or within 35s of going loud
		-- fixed wine not activating bag secure zipline
		-- fixed wine not giving it's bag value if secured by zipline
		-- fixed a toggle not being hooked up, i"m not sure exactly if it causes any issues, but it's fixed
		for _, element in pairs(data.elements) do
			if element.id == 100318 and element.editor_name == "police_called" then
				table.insert(element.values.on_executed, {delay = 0, id = 102341}) -- disable team ai stealth special objectives here instead of just when the vault lasers trip the alarm
				table.insert(element.values.on_executed, {delay = 35, id = 105481}) -- enable the vantage point areatrigger to initiate the spawn enemy loop
			elseif element.id == 100750 and element.editor_name == "2ndComputerUse" then
				table.insert(element.values.on_executed, {delay = 0, id = 105757}) -- if vault has been opened, don't play the "ah, that's the vault guys" dialogue
			elseif element.id == 100852  and element.editor_name == "ALARM" then
				element.values.on_executed[1] = {delay = 0, id = 100318} -- execute police_called as it can only execute once
				table.remove(element.values.on_executed, 3) -- now redundant, handled by police_called
			elseif element.id == 102047 and element.editor_name == "hide_all_vault_units003" then
				table.insert(element.values.on_executed, {delay = 0, id = 104885}) -- not hooked up as it should be
			elseif element.id == 105224 and element.editor_name == "func_carry_010" then
				element.values.operation = "secure" -- fixed wine not giving it's bag value if secured by zipline
			elseif element.id == 105480 and element.editor_name == "trigger_area_030" then
				element.values.width = 2300
				element.values.height = 500 -- extend the areatrigger to cover the whole vantage point
				element.values.on_executed[1] = {delay = 20, id = 105559} -- start the enemy spawn loop
				element.values.enabled = false -- toggled once it goes loud
			elseif element.id == 105481 and element.editor_name == "logic_toggle_147" then
				element.values.elements[1] = 105480 -- toggle the vantage point areatrigger to start the spawns once the heist goes loud
			elseif element.id == 105757 and element.editor_name == "disable_bain_VO_vault" then
				table.remove(element.values.on_executed, 1) -- don't execute the dialogue
				table.insert(element.values.elements, 105221) -- disable it instead
			elseif element.id == 105758 and element.editor_name == "area_player_stepped_inside_vault" then
				element.values.enabled = false -- since we just disable the dialogue as soon as the vault is open, this is now redundant
			elseif element.id == 105900 and element.editor_name == "logic_counter_012" then
				element.values.counter_target = 1 -- fixed wine not activating bag secure zipline
				element.values.on_executed[1] = {delay = 0, id = 104569} -- show the bag secure waypoint
			end
		end
	end)
elseif level == "nmh" then
	-- fixed the dozer event so it can actually occur on overkill+
	Hooks:PreHook(MissionManager, "_add_script", "scripting_improvements_add_script", function(self, data)
		for _, element in pairs(data.elements) do
			if element.id == 104124 and element.editor_name == "logic_chance_operator_004" then
				element.values.chance = 50 -- 50% chance for a dozer and shield to enter the elevator through the flames once it has reached the top instead of 0%
			end
		end
	end)
elseif level == "pal" then
	Hooks:PreHook(MissionManager, "_add_script", "scripting_improvements_add_script", function(self, data)
		-- fixed Bain saying to find Mitchell when masked up or when the door has been crowbarred
		for _, element in pairs(data.elements) do
			if element.id == 102410 and element.editor_name == "all_masked" or element.id == 100551 and element.editor_name == "basement_door_crowbared" then
				table.insert(element.values.on_executed, {id = 100096, delay = 0})
			end
		end
	end)
elseif level == "run" then
	Hooks:PreHook(MissionManager, "_add_script", "scripting_improvements_add_script", function(self, data)
		-- make a few enemy spawns use their proper swat van exit animation
		-- fix helicopter deploying smoke but not spawning any enemies
		for _, element in pairs(data.elements) do
			if element.id == 100624 and element.editor_name == "ai_spawn_enemy_004" or element.id == 103472 and element.editor_name == "ai_spawn_enemy_130" then
				element.values.spawn_action = "e_sp_armored_truck_1st"
			elseif element.id == 100708 and element.editor_name == "ai_spawn_enemy_006" then
				element.values.spawn_action = "e_sp_armored_truck_2nd"
			elseif element.id == 102212 and element.editor_name == "ai_enemy_group_039" then
				table.insert(element.values.elements, 102232) -- make the helicopter actually spawn some coppers
				table.insert(element.values.elements, 102261)
				table.insert(element.values.elements, 102273)
				table.insert(element.values.elements, 102279)
			end
		end
	end)
elseif level == "vit" then
	-- fix a guard randomly dying on the surface
	Hooks:PreHook(MissionManager, "_add_script", "scripting_improvements_add_script", function(self, data)
		for _, element in pairs(data.elements) do
			if element.id == 104080 and element.editor_name == "func_disable_unit_058" then
				table.insert(element.values.unit_ids, 101268)
			end
		end
	end)
elseif level == "watchdogs_2" then
	-- fix cheat spawns being improperly enabled causing enemies to spawn in while being directly visible
	Hooks:PreHook(MissionManager, "_add_script", "scripting_improvements_add_script", function(self, data)
		for _, element in pairs(data.elements) do
			if (element.id == 101013 or element.id == 101235) and element.editor_name == "empty" then
				element.values.amount = "all" -- all players have to be in a position where they could not see the cheat spawns for them to activate
				element.values.width = 7000 -- doesn"t extend far enough for both to be out of vision
			elseif element.id == 101220 and element.editor_name == "enter" then
				element.values.width = 7000 -- doesn"t extend far enough for both to be out of vision
			end
		end
	end)
end