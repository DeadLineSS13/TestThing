SUBSYSTEM_DEF(machines)
	name = "Machines"
	init_order = INIT_ORDER_MACHINES
	flags = SS_KEEP_TIMING

	var/list/processing = list()
	var/list/powernets = list()
	var/list/currentrun = list()



/datum/controller/subsystem/machines/Initialize()
	makepowernets()
//	for(var/L in global_sidormat_list)
//		global_sidormat_list[L] = sortPrice(global_sidormat_list[L])
	fire()
	..()

/datum/controller/subsystem/machines/proc/makepowernets(zlevel)
	for(var/datum/powernet/PN in powernets)
		qdel(PN)
	powernets.Cut()

//	for(var/obj/structure/cable/PC in cable_list)
//		if(!PC.powernet)
//			var/datum/powernet/NewPN = new()
//			NewPN.add_cable(PC)
//			propagate_network(PC,PC.powernet)


/datum/controller/subsystem/machines/stat_entry()
	..("M:[processing.len]|PN:[powernets.len]")


/datum/controller/subsystem/machines/fire(resumed = 0)
	if (!resumed)
		for(var/datum/powernet/Powernet in powernets)
			Powernet.reset() //reset the power state.
		src.currentrun = processing.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	var/seconds = wait * 0.1
	while(currentrun.len)
		var/datum/thing = currentrun[1]
		currentrun.Cut(1, 2)
		if(thing && thing.process(seconds) != PROCESS_KILL)
			if(thing:use_power)
				thing:auto_use_power() //add back the power state
		else
			processing.Remove(thing)
		if (MC_TICK_CHECK)
			return
