var/sid_generator = 0

/datum/datacore
	var/medical[] = list()
	var/medicalPrintCount = 0
	var/general[] = list()
	var/security[] = list()
	var/securityPrintCount = 0
	var/securityCrimeCounter = 0
	//This list tracks characters spawned in the world and cannot be modified in-game. Currently referenced by respawn_character().
	var/locked[] = list()
	var/stalkers[] = list()

/datum/data
	var/name = "data"

/datum/data/record
	name = "record"
	var/list/fields = list()

/datum/data/crime
	name = "crime"
	var/crimeName = ""
	var/crimeDetails = ""
	var/author = ""
	var/time = ""
	var/dataId = 0

/datum/datacore/proc/createCrimeEntry(cname = "", cdetails = "", author = "", time = "")
	var/datum/data/crime/c = new /datum/data/crime
	c.crimeName = cname
	c.crimeDetails = cdetails
	c.author = author
	c.time = time
	c.dataId = ++securityCrimeCounter
	return c

/datum/datacore/proc/addMinorCrime(id = "", datum/data/crime/crime)
	for(var/datum/data/record/R in security)
		if(R.fields["id"] == id)
			var/list/crimes = R.fields["mi_crim"]
			crimes |= crime
			return

/datum/datacore/proc/removeMinorCrime(id, cDataId)
	for(var/datum/data/record/R in security)
		if(R.fields["id"] == id)
			var/list/crimes = R.fields["mi_crim"]
			for(var/datum/data/crime/crime in crimes)
				if(crime.dataId == text2num(cDataId))
					crimes -= crime
					return

/datum/datacore/proc/removeMajorCrime(id, cDataId)
	for(var/datum/data/record/R in security)
		if(R.fields["id"] == id)
			var/list/crimes = R.fields["ma_crim"]
			for(var/datum/data/crime/crime in crimes)
				if(crime.dataId == text2num(cDataId))
					crimes -= crime
					return

/datum/datacore/proc/addMajorCrime(id = "", datum/data/crime/crime)
	for(var/datum/data/record/R in security)
		if(R.fields["id"] == id)
			var/list/crimes = R.fields["ma_crim"]
			crimes |= crime
			return

/datum/datacore/proc/manifest(nosleep = 0)
	spawn()
		if(!nosleep)
			sleep(40)
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			manifest_inject(H)
		return

/datum/datacore/proc/manifest_modify(name, assignment)
	var/datum/data/record/foundrecord = find_record("name", name, GLOB.data_core.general)
	if(foundrecord)
		foundrecord.fields["rank"] = assignment

/datum/datacore/proc/get_manifest(monochrome, OOC)
	var/list/heads = list()
	var/list/sec = list()
	var/list/eng = list()
	var/list/med = list()
	var/list/sci = list()
	var/list/sup = list()
	var/list/civ = list()
	var/list/bot = list()
	var/list/misc = list()
	var/dat = {"
	<head><style>
		.manifest {border-collapse:collapse;}
		.manifest td, th {border:1px solid [monochrome?"black":"#DEF; background-color:white; color:black"]; padding:.25em}
		.manifest th {height: 2em; [monochrome?"border-top-width: 3px":"background-color: #48C; color:white"]}
		.manifest tr.head th { [monochrome?"border-top-width: 1px":"background-color: #488;"] }
		.manifest td:first-child {text-align:right}
		.manifest tr.alt td {[monochrome?"border-top-width: 2px":"background-color: #DEF"]}
	</style></head>
	<table class="manifest" width='350px'>
	<tr class='head'><th>Name</th><th>Rank</th></tr>
	"}
	var/even = 0
	// sort mobs
	for(var/datum/data/record/t in GLOB.data_core.general)
		var/name = t.fields["name"]
		var/rank = t.fields["rank"]
		var/department = 0
		if(rank in command_positions)
			heads[name] = rank
			department = 1
		if(rank in security_positions)
			sec[name] = rank
			department = 1
		if(rank in engineering_positions)
			eng[name] = rank
			department = 1
		if(rank in medical_positions)
			med[name] = rank
			department = 1
		if(rank in science_positions)
			sci[name] = rank
			department = 1
		if(rank in supply_positions)
			sup[name] = rank
			department = 1
		if(rank in civilian_positions)
			civ[name] = rank
			department = 1
		if(rank in nonhuman_positions)
			bot[name] = rank
			department = 1
		if(!department && !(name in heads))
			misc[name] = rank
	if(heads.len > 0)
		dat += "<tr><th colspan=3>Heads</th></tr>"
		for(var/name in heads)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[heads[name]]</td></tr>"
			even = !even
	if(sec.len > 0)
		dat += "<tr><th colspan=3>Security</th></tr>"
		for(var/name in sec)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[sec[name]]</td></tr>"
			even = !even
	if(eng.len > 0)
		dat += "<tr><th colspan=3>Engineering</th></tr>"
		for(var/name in eng)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[eng[name]]</td></tr>"
			even = !even
	if(med.len > 0)
		dat += "<tr><th colspan=3>Medical</th></tr>"
		for(var/name in med)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[med[name]]</td></tr>"
			even = !even
	if(sci.len > 0)
		dat += "<tr><th colspan=3>Science</th></tr>"
		for(var/name in sci)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[sci[name]]</td></tr>"
			even = !even
	if(sup.len > 0)
		dat += "<tr><th colspan=3>Supply</th></tr>"
		for(var/name in sup)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[sup[name]]</td></tr>"
			even = !even
	if(civ.len > 0)
		dat += "<tr><th colspan=3>Civilian</th></tr>"
		for(var/name in civ)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[civ[name]]</td></tr>"
			even = !even
	// in case somebody is insane and added them to the manifest, why not
	if(bot.len > 0)
		dat += "<tr><th colspan=3>Silicon</th></tr>"
		for(var/name in bot)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[bot[name]]</td></tr>"
			even = !even
	// misc guys
	if(misc.len > 0)
		dat += "<tr><th colspan=3>Miscellaneous</th></tr>"
		for(var/name in misc)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[misc[name]]</td></tr>"
			even = !even

	dat += "</table>"
	dat = replacetext(dat, "\n", "")
	dat = replacetext(dat, "\t", "")
	return dat


var/record_id_num = 1001
/datum/datacore/proc/manifest_inject(mob/living/carbon/human/H, pass)
	if(H.mind && (H.mind.assigned_role != H.mind.special_role))
		var/assignment
		if(H.mind.assigned_role)
			assignment = H.mind.assigned_role
		else if(H.job)
			assignment = H.job
		else
			assignment = "Unassigned"

		var/id = H.sid//num2hex(record_id_num++,6)
		sid_generator++
		H.sid = sid_generator
		var/sid = sid_generator
		var/image = get_id_photo(H)
		var/obj/item/weapon/photo/photo_front = new()
		var/obj/item/weapon/photo/photo_side = new()

		var/obj/item/weapon/photo/photo_west = new()
		var/obj/item/weapon/photo/photo_east = new()
		var/obj/item/weapon/photo/photo_back = new()

		photo_front.photocreate(null, icon(image, dir = SOUTH))
		photo_side.photocreate(null, icon(image, dir = WEST))
		photo_west.photocreate(null, icon(image, dir = WEST))
		photo_east.photocreate(null, icon(image, dir = EAST))
		photo_back.photocreate(null, icon(image, dir = NORTH))

		//These records should ~really~ be merged or something
		//General Record
		var/datum/data/record/G = new()
		G.fields["id"]			= id
		G.fields["name"]		= H.real_name
		G.fields["rank"]		= assignment
		G.fields["age"]			= H.age
//		if(config.mutant_races)
//			G.fields["species"]	= H.dna.species.name
		G.fields["fingerprint"]	= md5(H.dna.uni_identity)
		G.fields["p_stat"]		= "Active"
		G.fields["m_stat"]		= "Stable"
		G.fields["sex"]			= H.gender
		G.fields["photo_front"]	= photo_front
		G.fields["photo_side"]	= photo_side
		general += G

		//Medical Record
		var/datum/data/record/M = new()
		M.fields["id"]			= id
		M.fields["name"]		= H.real_name
		M.fields["blood_type"]	= H.dna.blood_type
		M.fields["b_dna"]		= H.dna.unique_enzymes
		M.fields["mi_dis"]		= "None"
		M.fields["mi_dis_d"]	= "No minor disabilities have been declared."
		M.fields["ma_dis"]		= "None"
		M.fields["ma_dis_d"]	= "No major disabilities have been diagnosed."
		M.fields["alg"]			= "None"
		M.fields["alg_d"]		= "No allergies have been detected in this patient."
		M.fields["cdi"]			= "None"
		M.fields["cdi_d"]		= "No diseases have been diagnosed at the moment."
		M.fields["notes"]		= "No notes."
		medical += M

		//Security Record
		var/datum/data/record/S = new()
		S.fields["id"]			= id
		S.fields["name"]		= H.real_name
		S.fields["criminal"]	= "None"
		S.fields["mi_crim"]		= list()
		S.fields["ma_crim"]		= list()
		S.fields["notes"]		= "No notes."
		security += S

		//Locked Record
		var/datum/data/record/L = new()
		L.fields["id"]			= md5("[H.real_name][H.mind.assigned_role]")	//surely this should just be id, like the others?
		L.fields["name"]		= H.real_name
		L.fields["rank"] 		= H.mind.assigned_role
		L.fields["age"]			= H.age
		L.fields["sex"]			= H.gender
		L.fields["blood_type"]	= H.dna.blood_type
		L.fields["b_dna"]		= H.dna.unique_enzymes
		L.fields["enzymes"]		= H.dna.struc_enzymes
		L.fields["identity"]	= H.dna.uni_identity
		L.fields["species"]		= H.dna.species.type
		L.fields["features"]	= H.dna.features
		L.fields["image"]		= image
		locked += L


		//?????????? ????????
		var/datum/data/record/sk = new()

		sk.fields["reputation"]		= 1000
		sk.fields["photo_front"]	= photo_front
		sk.fields["photo_west"]		= photo_west
		sk.fields["photo_east"]		= photo_east
		sk.fields["photo_back"]		= photo_back
		sk.fields["pass"]			= pass
		sk.fields["lastlogin"]		= world.time
		sk.fields["sid"]			= sid
		sk.fields["name"]			= H.real_name
		sk.fields["rank"]			= H.mind.assigned_role
		sk.fields["rating"] = 0
		sk.fields["degree"] = 0

		var/datum/job/J = null
		if(H.mind.assigned_role)
			J = SSjob.GetJob(H.mind.assigned_role)

		if(J)
			if(J.real_rank == "Lieutenant")
				sk.fields["rating"] = 1000
				sk.fields["degree"] = 1
			sk.fields["faction_s"]	= J.faction_s
		else
			sk.fields["faction_s"]	= "Loners"

		if(sk.fields["faction_s"] == "Bandits")
			sk.fields["money"]			= 2000
		else
			sk.fields["money"]			= 5000

		stalkers += sk
	return



/datum/proc/get_id_photo(mob/living/carbon/human/H)
	var/datum/job/J = SSjob.GetJob(H.mind.assigned_role)
	var/datum/preferences/P = H.client.prefs
	if(!J)
		return get_flat_human_icon(null, /datum/outfit/stalker, P)
	else
		return get_flat_human_icon(null,J.outfit,P)
