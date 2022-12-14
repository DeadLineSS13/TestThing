GLOBAL_DATUM_INIT(data_core, /datum/datacore, new)
//var/global/defer_powernet_rebuild = 0		// true if net rebuild will be called manually after an event
//Noble idea, but doing this made GC fail. The gains from waiting on deffering are lost by using del()

var/CELLRATE = 0.002  // multiplier for watts per tick <> cell storage (eg: .002 means if there is a load of 1000 watts, 20 units will be taken from a cell per second)
var/CHARGELEVEL = 0.001 // Cap for how fast cells charge, as a percentage-per-tick (.001 means cellcharge is capped to 1% per second)

GLOBAL_LIST_EMPTY(powernets)

// this is not strictly unused although the whole modules datum thing is unused
// To remove this you need to remove that
var/datum/moduletypes/mods = new()

var/map_name = "Unknown"	//The name of the map that is loaded. Assigned in world/New()