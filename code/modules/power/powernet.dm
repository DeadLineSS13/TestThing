////////////////////////////////////////////
// POWERNET DATUM
// each contiguous network of cables & nodes
/////////////////////////////////////
/datum/powernet
	var/list/cables = list()	// all cables & junctions
	var/list/nodes = list()		// all connected machines

	var/load = 0				// the current load on the powernet, increased by each machine at processing
	var/newavail = 0			// what available power was gathered last tick, then becomes...
	var/avail = 0				//...the current available power in the powernet
	var/viewload = 0			// the load as it appears on the power console (gradually updated)
	var/number = 0				// Unused //TODEL
	var/netexcess = 0			// excess power on the powernet (typically avail-load)///////

/datum/powernet/New()
//	SSmachine.powernets += src

/datum/powernet/Destroy()
	//Go away references, you suck!
	for(var/obj/structure/cable/C in cables)
		cables -= C
		C.powernet = null
	for(var/obj/machinery/power/M in nodes)
		nodes -= M
//		M.powernet = null

//	SSmachine.powernets -= src
	return ..()

/datum/powernet/proc/is_empty()
	return !cables.len && !nodes.len

//remove a cable from the current powernet
//if the powernet is then empty, delete it
//Warning : this proc DON'T check if the cable exists
/datum/powernet/proc/remove_cable(obj/structure/cable/C)
	cables -= C
	C.powernet = null
	if(is_empty())//the powernet is now empty...
		qdel(src)///... delete it

//add a cable to the current powernet
//Warning : this proc DON'T check if the cable exists
/datum/powernet/proc/add_cable(obj/structure/cable/C)
	if(C.powernet)// if C already has a powernet...
		if(C.powernet == src)
			return
		else
			C.powernet.remove_cable(C) //..remove it
	C.powernet = src
	cables +=C

//remove a power machine from the current powernet
//if the powernet is then empty, delete it
//Warning : this proc DON'T check if the machine exists
/datum/powernet/proc/remove_machine(obj/machinery/power/M)
	nodes -=M
//	M.powernet = null
	if(is_empty())//the powernet is now empty...
		qdel(src)///... delete it


//add a power machine to the current powernet
//Warning : this proc DON'T check if the machine exists
/datum/powernet/proc/add_machine(obj/machinery/power/M)
//	if(M.powernet)// if M already has a powernet...
//		if(M.powernet == src)
//			return
//		else
//			M.disconnect_from_network()//..remove it
//	M.powernet = src
	nodes[M] = M

//handles the power changes in the powernet
//called every ticks by the powernet controller
/datum/powernet/proc/reset()

	//see if there's a surplus of power remaining in the powernet and stores unused power in the SMES
	netexcess = avail - load

//	if(netexcess > 100 && nodes && nodes.len)		// if there was excess power last cycle
//		for(var/obj/machinery/power/smes/S in nodes)	// find the SMESes in the network
//			S.restore()				// and restore some of the power that was used

	//updates the viewed load (as seen on power computers)
	viewload = 0.8*viewload + 0.2*load
	viewload = round(viewload)

	//reset the powernet
	load = 0
	avail = newavail
	newavail = 0

/datum/powernet/proc/get_electrocute_damage()
	if(avail >= 1000)
		return Clamp(round(avail/10000), 10, 90) + rand(-5,5)
	else
		return 0