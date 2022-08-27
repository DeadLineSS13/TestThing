/*
/datum/controller/subsystem/objects/proc/setupGenetics()
	var/list/avnums = new /list(DNA_STRUC_ENZYMES_BLOCKS)
	for(var/i=1, i<=DNA_STRUC_ENZYMES_BLOCKS, i++)
		avnums[i] = i

/datum/controller/subsystem/ticker/proc/setupFactions()
	// Populate the factions list:
	for(var/typepath in typesof(/datum/faction))
		var/datum/faction/F = new typepath()
		if(!F.name)
			qdel(F)
			continue
		else
			factions.Add(F)
			availablefactions.Add(F)

	// Populate the syndicate coalition:
	for(var/datum/faction/syndicate/S in factions)
		syndicate_coalition.Add(S)
*/