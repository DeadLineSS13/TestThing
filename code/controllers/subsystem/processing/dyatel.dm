PROCESSING_SUBSYSTEM_DEF(dyatel)
	name = "Dyatel Anomalies"
	priority = FIRE_PRIORITY_OBJ
	flags = SS_NO_INIT
	wait = 10
	var/list/mobs_affected = list()
	var/sound/noise = sound()

/datum/controller/subsystem/processing/dyatel/fire()
	..()

	if(mobs_affected.len)

		if(!noise.channel)
			noise.channel = SSchannels.get_reserved_channel(34)
//		if(!noise.file)
//			noise.file =

		for(var/mob/living/carbon/human/H in mobs_affected)
			mobs_affected[H] += 5
			noise.volume = mobs_affected[H]
			noise.status = SOUND_STREAM | SOUND_UPDATE
			H << noise

		noise.status = SOUND_STREAM