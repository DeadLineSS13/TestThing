GLOBAL_LIST_EMPTY(idle_anomalies)
GLOBAL_LIST_EMPTY(active_anomalies)

SUBSYSTEM_DEF(anomaly)
	name = "Anomaly"
	init_order = INIT_ORDER_ANOMALY
	wait = 60

/datum/controller/subsystem/anomaly/Initialize(timeofday)
	initialized = TRUE
	fire()
	return ..()

/datum/controller/subsystem/anomaly/fire()
	var/mob/living/carbon/human/H

	for(var/obj/anomaly/A in GLOB.idle_anomalies)
		if(H in range(15, A))
			GLOB.idle_anomalies.Remove(A)
			GLOB.active_anomalies.Add(A)
			SSobj.processing.Add(A)

	for(var/obj/anomaly/A in GLOB.active_anomalies)
		if(!(H in range(15, A)))
			SSobj.processing.Remove(A)
			GLOB.active_anomalies.Remove(A)
			GLOB.idle_anomalies.Add(A)