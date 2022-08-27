/obj/item/weapon/
	name = "weapon"
	icon = 'icons/obj/weapons.dmi'
	var/weight_alpha = 1

/obj/item/weapon/get_weight(with_alpha = 0)
	var/w_alpha = 1
	if(with_alpha)
		w_alpha = weight_alpha
	return weight * w_alpha


/obj/item/weapon/New()
	..()
	if(!hitsound)
		if(damtype == "fire")
			hitsound = 'sound/items/welder.ogg'
		if(damtype == "brute")
			hitsound = "swing_hit"
