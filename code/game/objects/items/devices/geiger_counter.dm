#define RAD_LEVEL_NORMAL 0.1
#define RAD_LEVEL_MODERATE 2
#define RAD_LEVEL_HIGH 5
#define RAD_LEVEL_CRITICAL 9

/obj/item/device/geiger_counter //DISCLAIMER: I know nothing about how real-life Geiger counters work. This will not be realistic. ~Xhuis
	name = "geiger counter"
	desc = "A handheld device used for detecting and measuring radiation pulses."
	icon = 'icons/stalker/devices.dmi'
	icon_state = "geiger_off"
	item_state = "multitool"
	w_class = 2
	slot_flags = SLOT_BELT
	materials = list(MAT_METAL = 150, MAT_GLASS = 150)
	var/scanning = 0
	var/radiation_count = 0
	var/emagged = 0

/obj/item/device/geiger_counter/New()
	..()
	SSobj.processing.Add(src)

/obj/item/device/geiger_counter/Destroy()
	SSobj.processing.Remove(src)
	..()

/obj/item/device/geiger_counter/process()
	if(radiation_count)
		radiation_count--
		update_icon()

/obj/item/device/geiger_counter/examine(mob/user)
	..()
	if(!scanning)
		return 1
	user << "<span class='info'>Alt-click it to clear stored radiation levels.</span>"
	if(emagged)
		user << "<span class='warning'>The display seems to be incomprehensible.</span>"
		return 1
	switch(radiation_count)
		if(-INFINITY to RAD_LEVEL_NORMAL)
			user << "<span class='notice'>Ambient radiation level count reports that all is well.</span>"
		if(RAD_LEVEL_NORMAL to RAD_LEVEL_MODERATE)
			user << "<span class='disarm'>Ambient radiation levels slightly above average.</span>"
		if(RAD_LEVEL_MODERATE to RAD_LEVEL_HIGH)
			user << "<span class='warning'>Ambient radiation levels above average.</span>"
		if(RAD_LEVEL_HIGH to RAD_LEVEL_CRITICAL)
			user << "<span class='danger'>Ambient radiation levels highly above average.</span>"
		if(RAD_LEVEL_CRITICAL to INFINITY)
			user << "<span class='boldannounce'>Ambient radiation levels above critical level!</span>"

/obj/item/device/geiger_counter/update_icon()
	if(!scanning)
		icon_state = "geiger_off"
		return 1
	switch(radiation_count)
		if(-INFINITY to RAD_LEVEL_NORMAL)
			icon_state = "geiger_on_1"
		if(RAD_LEVEL_NORMAL to RAD_LEVEL_MODERATE)
			icon_state = "geiger_on_2"
		if(RAD_LEVEL_MODERATE to RAD_LEVEL_HIGH)
			icon_state = "geiger_on_3"
		if(RAD_LEVEL_HIGH to RAD_LEVEL_CRITICAL)
			icon_state = "geiger_on_4"
		if(RAD_LEVEL_CRITICAL to INFINITY)
			icon_state = "geiger_on_5"
	..()

/obj/item/device/geiger_counter/rad_act(amount)
	if(!amount)
		return
	if(!scanning)
		return
	radiation_count = amount
	if(isliving(loc))
		var/mob/living/M = loc
//		var/radiation
		if(amount >= 7)
			M << sound('sound/stalker/anomalies/geiger_3.ogg', channel = SSchannels.get_reserved_channel(32))
//			radiation = "CRITICAL"
		else if(amount >= 3.5)
			M << sound('sound/stalker/anomalies/geiger_2.ogg', channel = SSchannels.get_reserved_channel(32))
//			radiation = "HIGH"
		else
			M << sound('sound/stalker/anomalies/geiger_1.ogg', channel = SSchannels.get_reserved_channel(32))
//			radiation = "MODERATE"

//		M << "<span class='boldannounce'>\icon[src][radiation] PULSE OF RADIATION DETECTED.</span>"

	update_icon()

/obj/item/device/geiger_counter/attack_self(mob/user)
	scanning = !scanning
	update_icon()
	user << "<span class='notice'>\icon[src] You switch [scanning ? "on" : "off"] [src].</span>"

/obj/item/device/geiger_counter/attack(mob/living/M, mob/user)
	if(user.a_intent == "help")
		if(!emagged)
			user.visible_message("<span class='notice'>[user] scans [M] with [src].</span>", "<span class='notice'>You scan [M]'s radiation levels with [src]...</span>")
			if(!M.radiation)
				user << "<span class='notice'>\icon[src] Radiation levels within normal boundaries.</span>"
				return 1
			else
				user << "<span class='boldannounce'>\icon[src] Subject is irradiated. Radiation levels: [M.radiation].</span>"
				return 1
		else
			user.visible_message("<span class='notice'>[user] scans [M] with [src].</span>", "<span class='danger'>You project [src]'s stored radiation into [M]'s body!</span>")
			M.rad_act(radiation_count)
			radiation_count = 0
		return 1
	..()

/obj/item/device/geiger_counter/AltClick(mob/living/user)
	if(!istype(user) || user.incapacitated())
		return ..()
	if(!scanning)
		usr << "<span class='warning'>[src] must be on to reset its radiation level!</span>"
		return 0
	radiation_count = 0
	usr << "<span class='notice'>You flush [src]'s radiation counts, resetting it to normal.</span>"
	update_icon()

#undef RAD_LEVEL_NORMAL
#undef RAD_LEVEL_MODERATE
#undef RAD_LEVEL_HIGH
#undef RAD_LEVEL_CRITICAL