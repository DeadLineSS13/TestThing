GLOBAL_LIST_EMPTY(clients)							//all clients
GLOBAL_LIST_EMPTY(admins)							//all clients whom are admins
GLOBAL_PROTECT(admins)
GLOBAL_LIST_EMPTY(deadmins)							//all ckeys who have used the de-admin verb.

GLOBAL_LIST_EMPTY(directory)							//all ckeys with associated client
GLOBAL_LIST_EMPTY(stealthminID)						//reference list with IDs that store ckeys, for stealthmins

//Since it didn't really belong in any other category, I'm putting this here
//This is for procs to replace all the goddamn 'in world's that are chilling around the code

GLOBAL_LIST_EMPTY(player_list)				//all mobs **with clients attached**.
GLOBAL_LIST_EMPTY(mob_list)					//all mobs, including clientless
GLOBAL_LIST_EMPTY(mob_directory)			//mob_id -> mob
GLOBAL_LIST_EMPTY(alive_mob_list)			//all alive mobs, including clientless. Excludes /mob/dead/new_player
GLOBAL_LIST_EMPTY(suicided_mob_list)		//contains a list of all mobs that suicided, including their associated ghosts.
GLOBAL_LIST_EMPTY(drones_list)
GLOBAL_LIST_EMPTY(dead_mob_list)			//all dead mobs, including clientless. Excludes /mob/dead/new_player
GLOBAL_LIST_EMPTY(joined_player_list)		//all clients that have joined the game at round-start or as a latejoin.
GLOBAL_LIST_EMPTY(silicon_mobs)				//all silicon mobs
GLOBAL_LIST_EMPTY(living_mob_list)			//all instances of /mob/living and subtypes
GLOBAL_LIST_EMPTY(carbon_list)				//all instances of /mob/living/carbon and subtypes, notably does not contain brains or simple animals
GLOBAL_LIST_EMPTY(ai_list)
GLOBAL_LIST_EMPTY(pai_list)
GLOBAL_LIST_EMPTY(available_ai_shells)
GLOBAL_LIST_INIT(simple_animals, list(list(),list(),list(),list())) // One for each AI_* status define
GLOBAL_LIST_EMPTY(spidermobs)				//all sentient spider mobs
GLOBAL_LIST_EMPTY(bots_list)
GLOBAL_LIST_EMPTY(living_cameras)
GLOBAL_LIST_EMPTY(aiEyes)

GLOBAL_LIST_EMPTY(language_datum_instances)
GLOBAL_LIST_EMPTY(all_languages)

GLOBAL_LIST_EMPTY(sentient_disease_instances)

GLOBAL_LIST_EMPTY(latejoin_ai_cores)

GLOBAL_LIST_EMPTY(mob_config_movespeed_type_lookup)


/proc/update_config_movespeed_type_lookup(update_mobs = TRUE)
	var/list/mob_types = list()
	var/list/entry_value = CONFIG_GET(keyed_list/multiplicative_movespeed)
	for(var/path in entry_value)
		var/value = entry_value[path]
		if(!value)
			continue
		for(var/subpath in typesof(path))
			mob_types[subpath] = value
	GLOB.mob_config_movespeed_type_lookup = mob_types
	if(update_mobs)
		update_mob_config_movespeeds()

/proc/update_mob_config_movespeeds()
	for(var/i in GLOB.mob_list)
		var/mob/M = i
		M.update_config_movespeed()

/mob/proc/update_config_movespeed()
	return
//Надо будет глянуть тгшный файл mob_movespeed.dm и мб перенести к нам
//	add_movespeed_modifier(MOVESPEED_ID_CONFIG_SPEEDMOD, FALSE, 100, override = TRUE, multiplicative_slowdown = get_config_multiplicative_speed())
/*
//ANY ADD/REMOVE DONE IN UPDATE_MOVESPEED MUST HAVE THE UPDATE ARGUMENT SET AS FALSE!
/mob/proc/add_movespeed_modifier(id, update=TRUE, priority=0, flags=NONE, override=FALSE, multiplicative_slowdown=0, movetypes=ALL, blacklisted_movetypes=NONE, conflict=FALSE)
	var/list/temp = list(priority, flags, multiplicative_slowdown, movetypes, blacklisted_movetypes, conflict) //build the modification list
	var/resort = TRUE
	if(LAZYACCESS(movespeed_modification, id))
		var/list/existing_data = movespeed_modification[id]
		if(movespeed_modifier_identical_check(existing_data, temp))
			return FALSE
		if(!override)
			return FALSE
		if(priority == existing_data[MOVESPEED_DATA_INDEX_PRIORITY])
			resort = FALSE // We don't need to re-sort if we're replacing something already there and it's the same priority
	LAZYSET(movespeed_modification, id, temp)
	if(update)
		update_movespeed(resort)
	return TRUE
*/