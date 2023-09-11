return {
	['black_money'] = {
		label = 'Argent sale',
	},

	['burger'] = {
		label = 'Burger',
		weight = 220,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			notification = 'You ate a delicious burger'
		},
	},

	['cola'] = {
		label = 'Coca Cola',
		weight = 350,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ecola_can`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
			usetime = 2500,
			notification = 'You quenched your thirst with cola'
		}
	},

	['parachute'] = {
		label = 'Parachute',
		weight = 8000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		}
	},

	['garbage'] = {
		label = 'Ordures ménagères',
	},

	['paperbag'] = {
		label = 'Sac en papier',
		weight = 1,
		stack = false,
		close = false,
		consume = 0
	},

	['identification'] = {
		label = 'Identification',
	},

	['panties'] = {
		label = 'Knickers',
		weight = 10,
		consume = 0,
		client = {
			status = { thirst = -100000, stress = -25000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_cs_panties_02`, pos = vec3(0.03, 0.0, 0.02), rot = vec3(0.0, -13.5, -1.5) },
			usetime = 2500,
		}
	},

	['lockpick'] = {
		label = 'Lockpick',
		weight = 160,
		consume = 0,
		client = {
			anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer' },
			disable = { move = true, car = true, combat = true },
			usetime = 5000,
			cancel = true
		}
	},

	['phone'] = {
		label = 'Téléphone',
		weight = 190,
		stack = false,
		consume = 0,
		client = {
			add = function(total)
				if total > 0 then
					pcall(function() return exports.npwd:setPhoneDisabled(false) end)
				end
			end,

			remove = function(total)
				if total < 1 then
					pcall(function() return exports.npwd:setPhoneDisabled(true) end)
				end
			end
		}
	},

	['money'] = {
		label = 'Money',
	},

	['mustard'] = {
		label = 'Moutarde',
		weight = 500,
		client = {
			status = { hunger = 25000, thirst = 25000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_food_mustard`, pos = vec3(0.01, 0.0, -0.07), rot = vec3(1.0, 1.0, -1.5) },
			usetime = 2500,
			notification = 'You.. drank mustard'
		}
	},

	['water'] = {
		label = 'Eau',
		weight = 500,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 2500,
			cancel = true,
			notification = 'You drank some refreshing water'
		}
	},

	['radio'] = {
		label = 'Radio',
		weight = 1000,
		stack = false,
		consume = 0,
		allowArmed = true
	},

	['armour'] = {
		label = 'Gilet pare-balles',
		weight = 3000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
            usetime = 3500
		}
	},

	['jewels'] = {
		label = 'bijoux',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['armor'] = {
		label = 'armor',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['black_phone'] = {
		label = 'black phone',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},

	['blowpipe'] = {
		label = 'chalumeaux',
		weight = 2,
		stack = true,
		close = true,
		description = nil
	},

	['blue_phone'] = {
		label = 'blue phone',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},

	['bolcacahuetes'] = {
		label = 'bol de cacahuètes',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['bolchips'] = {
		label = 'bol de chips',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['bolnoixcajou'] = {
		label = 'bol de noix de cajou',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['bolpistache'] = {
		label = 'bol de pistaches',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['bouteillev'] = {
		label = 'bouteille',
		weight = 50,
		stack = true,
		close = true,
		description = nil
	},

	['bread'] = {
		label = 'pain',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['bvin'] = {
		label = 'bouteille de vin',
		weight = 50,
		stack = true,
		close = true,
		description = nil
	},

	['carokit'] = {
		label = 'kit carosserie',
		weight = 3,
		stack = true,
		close = true,
		description = nil
	},

	['carotool'] = {
		label = 'outils carosserie',
		weight = 2,
		stack = true,
		close = true,
		description = nil
	},

	['carte'] = {
		label = 'carte bleu',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['cdr'] = {
		label = 'confiture de raisins',
		weight = 50,
		stack = true,
		close = true,
		description = nil
	},

	['classic_phone'] = {
		label = 'classic phone',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},

	['clip'] = {
		label = 'chargeur',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['coca'] = {
		label = 'feuille de coca',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['coca_seed'] = {
		label = 'graine de coke',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['cocaine'] = {
		label = 'cocaine',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['cocaine_processing_table'] = {
		label = 'table de traitement coke',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['compresse'] = {
		label = 'compresse',
		weight = 2,
		stack = true,
		close = true,
		description = nil
	},

	['drpepper'] = {
		label = 'dr. pepper',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['energy'] = {
		label = 'energy drink',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['fertilizer'] = {
		label = 'fertilisant',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['fish'] = {
		label = 'poisson',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['fishingrod'] = {
		label = 'canne à peche',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['fixkit'] = {
		label = 'kit réparation',
		weight = 3,
		stack = true,
		close = true,
		description = nil
	},

	['fixtool'] = {
		label = 'outils réparation',
		weight = 2,
		stack = true,
		close = true,
		description = nil
	},

	['fuel'] = {
		label = 'essence',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['gazbottle'] = {
		label = 'bouteille de gaz',
		weight = 2,
		stack = true,
		close = true,
		description = nil
	},

	['gold_phone'] = {
		label = 'gold phone',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},

	['golem'] = {
		label = 'golem',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['grand_cru'] = {
		label = 'grand cru',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['grapperaisin'] = {
		label = 'grappe de raisin',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['green_phone'] = {
		label = 'green phone',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},

	['greenlight_phone'] = {
		label = 'green light phone',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},

	['handcuffs'] = {
		label = 'menottes',
		weight = -1,
		stack = true,
		close = true,
		description = nil
	},

	['ice'] = {
		label = 'glaçon',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['icetea'] = {
		label = 'ice tea',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['jager'] = {
		label = 'jägermeister',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['jagerbomb'] = {
		label = 'jägerbomb',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['jagercerbere'] = {
		label = 'jäger cerbère',
		weight = 3,
		stack = true,
		close = true,
		description = nil
	},

	['jeton'] = {
		label = 'jeton(s)',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['jus_raisin'] = {
		label = 'jus de raisin',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['jusfruit'] = {
		label = 'jus de fruits',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['key'] = {
		label = 'clé des menottes',
		weight = -1,
		stack = true,
		close = true,
		description = nil
	},

	['lightsmg_clip'] = {
		label = 'light machine clip',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['limonade'] = {
		label = 'limonade',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['martini'] = {
		label = 'martini blanc',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['menthe'] = {
		label = 'feuille de menthe',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},

	['metreshooter'] = {
		label = 'mètre de shooter',
		weight = 3,
		stack = true,
		close = true,
		description = nil
	},

	['mixapero'] = {
		label = 'mix apéritif',
		weight = 3,
		stack = true,
		close = true,
		description = nil
	},

	['mojito'] = {
		label = 'mojito',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['pates'] = {
		label = 'pâte sablée',
		weight = 50,
		stack = true,
		close = true,
		description = nil
	},

	['phone_module'] = {
		label = 'phone module',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},

	['pink_phone'] = {
		label = 'pink phone',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},

	['pistol_clip'] = {
		label = 'pistol clip',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['powerbank'] = {
		label = 'power bank',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},

	['raisin'] = {
		label = 'raisin',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['red_phone'] = {
		label = 'red phone',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},

	['rhum'] = {
		label = 'rhum',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['rhumcoca'] = {
		label = 'rhum-coca',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['rhumfruit'] = {
		label = 'rhum-jus de fruits',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['rifle_clip'] = {
		label = 'rifle clip',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['saucisson'] = {
		label = 'saucisson',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['shotgun_clip'] = {
		label = 'shotgun clip',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['sim_card'] = {
		label = 'sim card',
		weight = -1,
		stack = true,
		close = true,
		description = nil
	},

	['smg_clip'] = {
		label = 'smg clip',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['sniper_clip'] = {
		label = 'sniper clip',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['soda'] = {
		label = 'soda',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['sucrep'] = {
		label = 'sucre en poudre',
		weight = 50,
		stack = true,
		close = true,
		description = nil
	},

	['tar'] = {
		label = 'tarte aux raisins',
		weight = 50,
		stack = true,
		close = true,
		description = nil
	},

	['teqpaf'] = {
		label = 'teq\'paf',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['tequila'] = {
		label = 'tequila',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['vin'] = {
		label = 'vin',
		weight = 50,
		stack = true,
		close = true,
		description = nil
	},

	['vine'] = {
		label = 'vin',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['vodka'] = {
		label = 'vodka',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['vodkaenergy'] = {
		label = 'vodka-energy',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['vodkafruit'] = {
		label = 'vodka-jus de fruits',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['weapon_clip_extended'] = {
		label = 'extended clip',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['weapon_flashlight'] = {
		label = 'weapon flashlight',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['weapon_luxary_finish'] = {
		label = 'luxury finish',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['weapon_suppressor'] = {
		label = 'suppressor',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['weapon_tint_army'] = {
		label = 'army finish',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['weapon_tint_gold'] = {
		label = 'gold finish',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['weapon_tint_green'] = {
		label = 'green finish',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['weapon_tint_lspd'] = {
		label = 'police finish',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['weapon_tint_orange'] = {
		label = 'orange finish',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['weapon_tint_pink'] = {
		label = 'pink finish',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['weapon_tint_platinum'] = {
		label = 'platinum finish',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['weed_lemonhaze'] = {
		label = 'weed',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['weed_lemonhaze_seed'] = {
		label = 'graine de weed',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['wet_black_phone'] = {
		label = 'wet black phone',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},

	['wet_blue_phone'] = {
		label = 'wet blue phone',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},

	['wet_classic_phone'] = {
		label = 'wet classic phone',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},

	['wet_gold_phone'] = {
		label = 'wet gold phone',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},

	['wet_green_phone'] = {
		label = 'wet green phone',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},

	['wet_greenlight_phone'] = {
		label = 'wet green light phone',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},

	['wet_pink_phone'] = {
		label = 'wet pink phone',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},

	['wet_red_phone'] = {
		label = 'wet red phone',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},

	['wet_white_phone'] = {
		label = 'wet white phone',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},

	['whisky'] = {
		label = 'whisky',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['whiskycoca'] = {
		label = 'whisky-coca',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['white_phone'] = {
		label = 'white phone',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},
}