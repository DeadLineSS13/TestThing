
///////////////////////////// ��������� //////////////////////////////////////////

/obj/item/weapon/gun/projectile
	fire_delay = 1
	force = 10
	can_suppress = 0
	can_unsuppress = 0
	spread = 3
	var/image/mag_overlay 			= null
	var/image/mag_overlay_inhands 	= null
	var/image/silencer_overlay 		= null
	var/image/scope_overlay 		= null
	var/image/colored_overlay 		= null
	var/colored 					= null

/obj/item/weapon/gun/projectile/automatic/pistol/pm   // �������
	name_ru = "��"
	name = "PM"
	desc_ru = "����� �������� ���������� ������� �� ��������� ������� � ��������� �����, ��������� '������' ���������� ������ ����� ���. �������, ���������� ��������, ����� ��� �������� ����������."
	desc = "After russian police adopted Yarygin's pistol as a standart handgun, old PMs filled black markets. A simple, small handgun - just for blowing your brains out."
	icon_state = "pm"
	icon_ground = "handgun1_ground"
	w_class = 2
	fire_sound = 'sound/stalker/weapons/pm_shot.ogg'
	mag_type = /obj/item/ammo_box/magazine/stalker/m9x18pm
	gun_type = "smallarm"
	str_need = 8
	accuracy = 2
	weight = 0.75
	drawsound = 'sound/stalker/weapons/draw/pm_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/pm_load.ogg'
	opensound = 'sound/stalker/weapons/unload/pm_open.ogg'

/obj/item/weapon/gun/projectile/automatic/pistol/pm/gold
	name_ru = "�� �������"
	icon_state = "pm_gold"

/obj/item/weapon/gun/projectile/automatic/pistol/pm/slon
	name_ru = "�� Slon"
	icon_state = "pm_slon"

/obj/item/weapon/gun/projectile/automatic/pistol/pm/pigun
	name_ru = "��� ���"
	desc_ru = null
	icon_ground = "pigun_ground"
	icon_state = "pigun_shoot"

/obj/item/weapon/gun/projectile/automatic/pistol/tt   // ��
	name_ru = "��"
	name = "TT"
	desc_ru = "������� ��������� �����, �� �������, �������� �� �� ���, ��� ��� ����� ����� ��������. ����� �����, ���� ��� ����� ����������� ����� � ������� �����."
	desc = "This shitty chinese copy still can put a man down. Would be a miracle if this thing works for more than a month in local dirty badlands."
	icon_state = "tt"
	icon_ground = "handgun1_ground"
	w_class = 2
	fire_sound = 'sound/stalker/weapons/tt33_shot.ogg'
	mag_type = /obj/item/ammo_box/magazine/stalker/tt
	gun_type = "smallarm"
	str_need = 8
	accuracy = 2
	weight = 0.85
	drawsound = 'sound/stalker/weapons/draw/pm_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/pm_load.ogg'
	opensound = 'sound/stalker/weapons/unload/pm_open.ogg'

/obj/item/weapon/gun/projectile/automatic/pistol/colt  // Colt1911A
	name_ru = "����� �1911"
	name = "Colt M1911"
	desc_ru = "���� �� ����� ������ �������� ������������������ ����������, ������� �������� ���������� - ������, � ��������� ���� ����� ��������, ����������� � ���������� ������. �������� �� ��� ��, �������� �� ��� ����?"
	desc = "Old, reliable design. Not very cheap and has very small ammo capacity, but still is quite popular amongst western people."
	icon_state = "cora"
	icon_ground = "handgun1_ground"
	w_class = 2
	fire_sound = 'sound/stalker/weapons/colt1911_shot.ogg'
	mag_type = /obj/item/ammo_box/magazine/stalker/sc45
	gun_type = "smallarm"
	str_need = 10
	accuracy = 2
	reliability_add = 1
	weight = 1.1
	drawsound = 'sound/stalker/weapons/draw/pm_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/pm_load.ogg'
	opensound = 'sound/stalker/weapons/unload/pm_open.ogg'

/obj/item/weapon/gun/projectile/automatic/pistol/m92  // Beretta92FS
	name_ru = "������� M9"
	name = "Beretta M9"
	desc_ru = "�����������, �� ���������� ������������ ������������ ����� � ������ ��������. ��������, ���� ��������� ��������� ������ ����� ����� � ������ ��������������."
	desc = "An effective, ergonomic handgun covered in black plastic. One of the best in it's class."
	icon_state = "m9"
	icon_ground = "handgun2_ground"
	w_class = 2
	fire_sound = 'sound/stalker/weapons/marta_shot.ogg'
	mag_type = /obj/item/ammo_box/magazine/stalker/m9x19marta
	gun_type = "smallarm"
	str_need = 9
	accuracy = 2
	weight = 0.95
	drawsound = 'sound/stalker/weapons/draw/pm_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/pm_load.ogg'
	opensound = 'sound/stalker/weapons/unload/pm_open.ogg'

/obj/item/weapon/gun/projectile/automatic/pistol/fort12  // ���� 12
	name_ru = "����-12"
	name = "Fort-12"
	desc_ru = "�������� ���������� ���������� ��������. �� �������� ���������� ����������� �� ��������, �� ����� ������ ��������. �������� ����� ������������� ���������, ��� � '��������' ��� ��, �� ����������� �������� ����� �� ���������� � ���������� � ����� ������������ �������."
	desc = "An old ukrainian handgun. Neither powerful nor reliable, it's not widespread for obvious reasons. Still has the advantage of the larger magazine capacity compared to PM or TT."
	icon_state = "fort12"
	icon_ground = "handgun2_ground"
	fire_sound = 'sound/stalker/weapons/fort_shot.ogg'
	w_class = 2
	mag_type = /obj/item/ammo_box/magazine/stalker/m9x18fort
	gun_type = "smallarm"
	str_need = 9
	accuracy = 2
	reliability_add = -1
	weight = 0.9
	drawsound = 'sound/stalker/weapons/draw/fort_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/pm_load.ogg'
	opensound = 'sound/stalker/weapons/unload/pm_open.ogg'

/obj/item/weapon/gun/projectile/automatic/pistol/yarigin  // ������
	name_ru = "��"
	name = "PYa"
	desc_ru = "�����������, ������������ �������� ����������� ������������. �������� �� ���� ������ ������� � ����������� ��� ��� - ������ ������ � �� ����� ��������, �� ���� ������� �������� ��������."
	desc = "A modern, ergonomic russian pistol. In the last decade it became standart issue for many eastern european police and army forces; despite being unreliable, it's cheaper than most western handguns."
	icon_state = "yarigin"
	icon_ground = "handgun2_ground"
	fire_sound = 'sound/stalker/weapons/fort_shot.ogg'
	w_class = 2
	mag_type = /obj/item/ammo_box/magazine/stalker/yarigin
	gun_type = "smallarm"
	str_need = 8
	accuracy = 2
	reliability_add = -1
	weight = 0.95
	drawsound = 'sound/stalker/weapons/draw/fort_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/pm_load.ogg'
	opensound = 'sound/stalker/weapons/unload/pm_open.ogg'

/obj/item/weapon/gun/projectile/automatic/pistol/gyurza  // �����
	name_ru = "�����"
	name = "Gyurza"
	desc_ru = "��������, ������������� � ����� �������� ���� � ����� ������� ���������� �������� � ����������� ��������. ��������� �� ����������� ���������� � �������� �������� ��������� �� 5-7, �� �� ����������� ����� ������� ����������."
	desc = "An ergonomic russian pistol. During the last two decades it became standart issue for many eastern european police and army forces; despite being unreliable, it's much cheaper than western handguns."
	icon_state = "gyurza"
	icon_ground = "handgun2_ground"
	fire_sound = 'sound/stalker/weapons/fiveseven_shot.ogg'
	w_class = 2
	mag_type = /obj/item/ammo_box/magazine/stalker/gyurza
	gun_type = "smallarm"
	reliability_add = -1
	str_need = 8
	accuracy = 2
	weight = 0.9
	drawsound = 'sound/stalker/weapons/draw/pm_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/pm_load.ogg'
	opensound = 'sound/stalker/weapons/unload/pm_open.ogg'

/obj/item/weapon/gun/projectile/automatic/pistol/fn  // FN Five-seveN
	name_ru = "����-�����"
	name = "Five-seveN"
	desc_ru = "����� ������, ������� ��������� � ����������� �������, ������� ��� � ������� ����������� ���-������ ������� ����������."
	desc = "A very light and handy gun, holding it makes you want to burst few holes in someone's cheap armor vest."
	icon_state = "fiveseven"
	icon_ground = "handgun1_ground"
	w_class = 2
	fire_sound = 'sound/stalker/weapons/fiveseven_shot.ogg'
	mag_type = /obj/item/ammo_box/magazine/stalker/fiveseven
	gun_type = "smallarm"
	str_need = 8
	accuracy = 2
	weight = 0.6
	drawsound = 'sound/stalker/weapons/draw/pm_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/pm_load.ogg'
	opensound = 'sound/stalker/weapons/unload/pm_open.ogg'

/obj/item/weapon/gun/projectile/automatic/pistol/glock  // ����
	name_ru = "����"
	name = "Glock"
	desc_ru = "����������� ���� ��������� ������ �� ����� �������� � ����������� ����������, ���� �� ��� ��� ��������� � ������ ����������� ��� � �������� �������, � ����� � ����������� ���. ������, �������, � ����� ������� �� ������."
	desc = "This handgun earned itself a name of one of the most successful designs of last few decades, being reliable, light and accurate. Very favored by police and civilians in western countries."
	icon_state = "glock"
	icon_ground = "handgun2_ground"
	fire_sound = 'sound/stalker/weapons/fort_shot.ogg'
	w_class = 2
	mag_type = /obj/item/ammo_box/magazine/stalker/glock
	gun_type = "smallarm"
	str_need = 8
	accuracy = 2
	force = 10
	can_suppress = 0
	can_unsuppress = 0
	spread = 4
	recoil = 0.25
	reliability_add = 1
	damagelose = 0.2
	weight = 0.625
	drawsound = 'sound/stalker/weapons/draw/fort_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/pm_load.ogg'
	opensound = 'sound/stalker/weapons/unload/pm_open.ogg'

/obj/item/weapon/gun/projectile/automatic/pistol/fort12/unique  // ����12 - ����������� �������
	desc_ru = "����������������� �������� ��������� ����. ��������� ���������."
	unique = 1
	mag_type = /obj/item/ammo_box/magazine/stalker/m9x18fort_u

/obj/item/weapon/gun/projectile/automatic/pistol/pb1s  //��1�
	name_ru = "��"
	name = "PB"
	desc_ru = "� ����� ���� �����"
	icon_state = "pb1s"
	icon_ground = "handgun1_ground"
	w_class = 2
	fire_sound = 'sound/stalker/weapons/pb_shot.ogg'
	mag_type = /obj/item/ammo_box/magazine/stalker/m9x18pm
	gun_type = "smallarm"
	str_need = 8
	accuracy = 2
	force = 10
	suppressed = 1
	can_suppress = 0
	can_unsuppress = 0
	spread = 4
	recoil = 0.25
	damagelose = 0.2
	weight = 0.8
	drawsound = 'sound/stalker/weapons/draw/pm_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/pm_load.ogg'
	opensound = 'sound/stalker/weapons/unload/pm_open.ogg'

/obj/item/weapon/gun/projectile/automatic/pistol/desert  // Desert Eagle
	name_ru = "��������� ����"
	name = "Desert Eagle"
	desc_ru = "����� ������, ����� �������, ����� �����������. ����� �� ������������ ������ ���������� ��������� ����� �����������?"
	desc = "A heavy, powerful handgun. It's impressive shape doesn't actually make it more combat-effective"
	icon_state = "desert"
	icon_ground = "handgun2_ground"
	w_class = 3
	fire_sound = 'sound/stalker/weapons/desert_shot.ogg'
	mag_type = /obj/item/ammo_box/magazine/stalker/desert
	gun_type = "smallarm"
	str_need = 12
	accuracy = 2
	force = 10
	can_suppress = 0
	can_unsuppress = 0
	spread = 4
	recoil = 0.65
	damagelose = 0.15
	weapon_weight = WEAPON_MEDIUM
	weight = 1.8
	drawsound = 'sound/stalker/weapons/draw/usp_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/pm_load.ogg'
	opensound = 'sound/stalker/weapons/unload/pm_open.ogg'

/obj/item/weapon/gun/projectile/revolver/anaconda
	name_ru = "����� ��������"
	name = "Colt Anaconda"
	desc_ru = "� ����, � ��� �� ������ �������. ��������� �� ����� ���, ��� ������ ����? ������ ������, � ���� �������� � � ��� ������ �� �����. �� ����� � ����, ��� ��� ������� 44-�� �������, ����� ������� ��������� �� �����, � �� ����� ��������� ������ ���� �����. ������ �� ������ ���� ���� ������: ������� �� ���?�. ��, ������ ��, �������?"
	desc = "A heavy, powerful revolver. Did he shoot six times, or only five?"
	icon_ground = "handgun2_ground"
	icon_state = "anaconda"
	w_class = 3
	fire_sound = 'sound/stalker/weapons/desert_shot.ogg'
	fire_delay = 3
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/anaconda
	gun_type = "smallarm"
	str_need = 11
	accuracy = 2
	force = 10
	can_suppress = 0
	can_unsuppress = 0
	spread = 4
	recoil = 1
	reliability_add = 2
	damagelose = 0.1
	weapon_weight = WEAPON_MEDIUM
	weight = 1.8
	drawsound = 'sound/stalker/weapons/draw/usp_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/obrez_load.ogg'
	opensound = 'sound/stalker/weapons/unload/obrez_open.ogg'

/obj/item/weapon/gun/projectile/revolver/rsh
	name_ru = "��-12"
	name = "RSh-12"
	desc_ru = "Oh god oh fuck"
	desc = "Oh god oh fuck"
	icon_ground = "handgun2_ground"
	icon_state = "mateba"
	w_class = 3
	fire_sound = 'sound/stalker/weapons/ash_shot.ogg'
	fire_delay = 3
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rsh
	gun_type = "smallarm"
	str_need = 12
	accuracy = 3
	force = 10
	damage_add = -2
	can_suppress = 0
	can_unsuppress = 0
	spread = 4
	recoil = 1
	reliability_add = 2
	damagelose = 0.1
	weapon_weight = WEAPON_MEDIUM
	weight = 2.2
	drawsound = 'sound/stalker/weapons/draw/usp_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/obrez_load.ogg'
	opensound = 'sound/stalker/weapons/unload/obrez_open.ogg'

/obj/item/weapon/gun/projectile/automatic/pistol/vag  // ���-73 �� �����������
	name_ru = "���-37"
	name = "VAG-37"
	desc_ru = "�� � �������."
	desc = "What a gun."
	icon_state = "vag"
	icon_ground = "handgun2_ground"
	fire_sound = 'sound/stalker/weapons/ppsh_shot.ogg'
	w_class = 2
	mag_type = /obj/item/ammo_box/magazine/stalker/vag
	gun_type = "smallarm"
	str_need = 8
	accuracy = 2
	force = 10
	burst_size = 4
	fire_delay = 1
	can_suppress = 0
	can_unsuppress = 0
	spread = 4
	recoil = 0.25
	reliability_add = 1
	damagelose = 0.2
	weight = 1.2
	drawsound = 'sound/stalker/weapons/draw/usp_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/pm_load.ogg'
	opensound = 'sound/stalker/weapons/unload/pm_open.ogg'



///////////////////////////// ��������, �� //////////////////////////////////////////

/obj/item/weapon/gun/projectile/New()
	..()
	if(!istype(src, /obj/item/weapon/gun/projectile/automatic/pistol))
		mag_overlay = image('icons/stalker/items/weapons/projectile_overlays32x32.dmi', "[initial(icon_state)]-mag", layer = FLOAT_LAYER)

	if(can_suppress)
		silencer_overlay = image('icons/stalker/items/weapons/projectile_overlays48x48.dmi', "[initial(icon_state)]-silencer", layer = FLOAT_LAYER)

	if(can_scope)
		scope_overlay = image('icons/stalker/items/weapons/projectile_overlays32x32.dmi', "[initial(icon_state)]-scope", layer = FLOAT_LAYER)

	if(colored)
		colored_overlay = image('icons/stalker/items/weapons/projectile_overlays32x32.dmi', "[initial(icon_state)]-[colored]", layer = FLOAT_LAYER)
		overlays += colored_overlay

	update_icon()

/obj/item/weapon/gun/attack_hand(mob/user)
	if(!istype(src, user.get_inactive_held_item()) && src.loc == user)
		if(!istype(src, /obj/item/weapon/gun/projectile/automatic/pistol))
			if(flags & IN_PROGRESS)
				return

			flags += IN_PROGRESS
			user.direct_visible_message("<span class='danger'>DOER started to reach [src].</span>", "<span class='notice'>You started to reach [src].</span>",\
									 "<span class='danger'>DOER ����� ��������� [name_ru].</span>", "<span class='notice'>�� ��������� ��������� [name_ru].</span>","danger",user)
			if(!do_mob(usr, src, 5, 1))
				flags &= ~IN_PROGRESS
				return

			flags &= ~IN_PROGRESS
		user.direct_visible_message("<span class='danger'>DOER picked up [src].</span>", "<span class='notice'>You pick up [src].</span>",
							"<span class='danger'>[user] ���� � ���� [name_ru].</span>", "<span class='notice'>�� ������ � ���� [name_ru].</span>","danger",user)
		playsound(src.loc, drawsound, 30, 1, channel = "regular", time = 20)

	..()

/obj/item/weapon/gun/projectile/automatic/pistol/update_icon()
	..()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"]"
	icon_ground = initial(icon_ground)

/obj/item/weapon/gun/projectile/update_icon()
	cut_overlays()

	if(colored)
		add_overlay(colored_overlay)

	if(magazine && mag_overlay)
		add_overlay(mag_overlay)

	if(suppressed && silencer_overlay)
		add_overlay(silencer_overlay)

	if(zoomable && scope_overlay)
		add_overlay(scope_overlay)

	if(unique)
		add_overlay(image('icons/stalker/items/weapons/projectile_overlays32x32.dmi', "unique", layer = FLOAT_LAYER))

	item_state = "[initial(item_state)][magazine ? "" : "-e"][wielded ? "_w" : ""]"	//���� �� ��������� � ��������� �� �����, ����� ���
	icon_ground = "[initial(icon_ground)][magazine ? "" : "-e"]"

	return
/*
/obj/item/weapon/gun/projectile/automatic/worn_overlays(var/isinhands = TRUE)
	. = list()
	if(!isinhands)
		if(magazine )
			overlays += mag_overlay

		if(suppressed )
			overlays += silencer_overlay
        . += image(icon = 'icons/effects/effects.dmi', icon_state = "[shield_state]")
*/

/obj/item/weapon/gun/projectile/automatic
	burst_penalty = 2
	modifications = list("barrel_automatic" = 0, "frame_automatic" = 0, "grip_automatic" = 0, "compensator_automatic" = 0)

/obj/item/weapon/gun/projectile/automatic/ak74  // AK-74
	name_ru = "��74"
	name = "AK74"
	desc_ru = "������ � ������� �������, �� �������� ���� ��������� ���������� �������. ���� �� ��������� ��� �������� � ����������, ����������� ��� ��������� ������?"
	desc = "An old, bulky assault rifle, slightly smelling of gun oil."
	icon_state = "ak74"
	icon_ground = "ak74_ground"
	item_state = "ak74"
	colored = 0//"normal"
	slot_flags = SLOT_BACK|SLOT_BACK2
	force = 15
	origin_tech = "combat=5;materials=1"
	mag_type = /obj/item/ammo_box/magazine/stalker/m545
	gun_type = "longarm"
	str_need = 9
	accuracy = 4
	fire_sound = 'sound/stalker/weapons/ak74_shot.ogg'
	can_suppress = 0
	can_unsuppress = 0
	burst_size = 3
	fire_delay = 1.25
	reliability_add = 1
	w_class = 5
	recoil = 0.5
	spread = 2
	damagelose = 0.25
	can_scope = 1
	weapon_weight = WEAPON_MEDIUM
	weight = 3.3
	flags =  TWOHANDED
	drawsound = 'sound/stalker/weapons/draw/ak74_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/ak74_load.ogg'
	opensound = 'sound/stalker/weapons/unload/ak74_open.ogg'

/obj/item/weapon/gun/projectile/automatic/ak74/akm  // AK�
	name_ru = "���"
	name = "AKM"
	mag_type = /obj/item/ammo_box/magazine/stalker/akm
	fire_sound = 'sound/stalker/weapons/akm_shot.ogg'
	weight = 3.1

/obj/item/weapon/gun/projectile/automatic/ak74/gold
	name_ru = "��74 Gold"
	icon_state = "ak74_gold"

/obj/item/weapon/gun/projectile/automatic/ak74/voron
	name_ru = "��74 Voron"
	icon_state = "ak74_voron"

/obj/item/weapon/gun/projectile/automatic/ak74/cola
	name_ru = "������� ����-�����������"
	name = "Avtomat Koka-Kolashnikova"
	desc_ru = "����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������"
	desc = "����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������"
	icon_state = "cola"
	icon_ground = "cola_ground"
	item_state = "cola"
	mag_type = /obj/item/ammo_box/magazine/stalker/cola
	fire_sound = 'sound/stalker/weapons/cola_shot.ogg'


/obj/item/weapon/gun/projectile/automatic/aksu74  // ���74�
	name_ru = "���74�"
	name = "AKS74U"
	desc_ru = "������ � ������� �������, �� �������� ���� ��������� ���������� �������. ���� �� ��������� ��� �������� � ����������, ����������� ��� ��������� ������?"
	desc = "An old, shortened assault rifle, slightly smelling of gun oil."
	icon_state = "aksu74"
	icon_ground = "aksu74_ground"
	item_state = "aksu74"
	slot_flags = SLOT_BACK|SLOT_BACK2
	origin_tech = "combat=3;materials=1"
	mag_type = /obj/item/ammo_box/magazine/stalker/m545
	gun_type = "smallarm"
	str_need = 10
	accuracy = 3
	fire_sound = 'sound/stalker/weapons/ak74_shot.ogg'
	damage_add = -3
	burst_size = 4
	fire_delay = 1
	reliability_add = 1
	w_class = 4
	weapon_weight = WEAPON_MEDIUM
	weight = 2.7
	flags =  TWOHANDED
	drawsound = 'sound/stalker/weapons/draw/ak74u_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/ak74_load.ogg'
	opensound = 'sound/stalker/weapons/unload/ak74_open.ogg'

/obj/item/weapon/gun/projectile/automatic/a545
	name_ru = "�-545"
	name = "A-545"
	desc_ru = "�����, �������� �������, ���������� '��������� ���������' � ��������� ���������� �����. ������ ���������."
	desc = "This new russian assault rifle replaced the 74-s as the standart infantry weapon of few eastern european armies, including russian and belorussian ones."
	icon_state = "a545"
	icon_ground = "a545_ground"
	item_state = "a545"
	slot_flags = SLOT_BACK|SLOT_BACK2
	mag_type = /obj/item/ammo_box/magazine/stalker/m545
	gun_type = "longarm"
	str_need = 9
	accuracy = 5
	damage_add = 0
	fire_sound = 'sound/stalker/weapons/ak74_shot.ogg'
	burst_size = 3
	fire_delay = 1.25
	reliability_add = 1
	w_class = 5
	weapon_weight = WEAPON_MEDIUM
	weight = 3.2
	flags =  TWOHANDED
	drawsound = 'sound/stalker/weapons/draw/abakan_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/ak74_load.ogg'
	opensound = 'sound/stalker/weapons/unload/ak74_open.ogg'

/obj/item/weapon/gun/projectile/automatic/ash
	name_ru = "��-12"
	name = "ASh-12"
	desc_ru = "������� ���������, ���������, ������ � � �������� ���������, �������, ������ ����������� �����... ��� ���� ������ ��������� ������ �����."
	desc = "An automatic assault rifle of the special kind, utilising heavy-hitting large-caliber ammo. One of the best weapons available for the Zone."
	icon_state = "ash"
	icon_ground = "ash_ground"
	item_state = "ash"
	slot_flags = SLOT_BACK|SLOT_BACK2
	mag_type = /obj/item/ammo_box/magazine/stalker/ash
	gun_type = "longarm"
	str_need = 11
	accuracy = 4
	damage_add = 0
	fire_sound = 'sound/stalker/weapons/ash_shot.ogg'
	burst_size = 3
	fire_delay = 1.5
	reliability_add = 1
	w_class = 5
	weapon_weight = WEAPON_MEDIUM
	weight = 6
	flags =  TWOHANDED
	drawsound = 'sound/stalker/weapons/draw/abakan_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/ak74_load.ogg'
	opensound = 'sound/stalker/weapons/unload/ak74_open.ogg'

/obj/item/weapon/gun/projectile/automatic/m16  // ����
	name = "M16A2"
	name_ru = "M16A2"
	desc_ru = "��������� ��������, ����������� ����������� ����������, �� ���������� ���� ������ ������������� - ������� �� ��� ��� ��������� �� ����������� ������������ ������� ����."
	desc = "A basic american rifle, used to this day by many western forces."
	icon_state = "m16"
	icon_ground = "m16_ground"
	item_state = "m16"
	slot_flags = SLOT_BACK|SLOT_BACK2
	force = 15
	origin_tech = "combat=6"
	mag_type = /obj/item/ammo_box/magazine/stalker/m556x45
	gun_type = "longarm"
	str_need = 8
	accuracy = 5
	fire_sound = 'sound/stalker/weapons/tpc301_shoot.ogg'
	can_suppress = 0
	burst_size = 3
	fire_delay = 1.25
	reliability_add = 1
	w_class = 5
	spread = 2
	recoil = 0.4
	damagelose = 0.2
	can_scope = 1
	weapon_weight = WEAPON_MEDIUM
	weight = 3.4
	flags =  TWOHANDED
	drawsound = 'sound/stalker/weapons/draw/tpc301_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/tpc301_load.ogg'
	opensound = 'sound/stalker/weapons/unload/tpc301_open.ogg'


/obj/item/weapon/gun/projectile/automatic/mp5  // MP5
	name_ru = "��5"
	name = "MP5"
	desc_ru = "������, �� ��������� ������ - ��������, ������ � �����������. ���������� ������ ��� ����������� � �� �������� ������� ����� ������."
	desc = "This old submachine gun is widespread and popular even to this day - it's light and accurate, and uses cheaper handgun ammunition."
	icon_state = "mp5"
	icon_ground = "mp5_ground"
	item_state = "mp5"
	fire_sound = 'sound/stalker/weapons/mp5_shot.ogg'
	mag_type = /obj/item/ammo_box/magazine/stalker/m9x19mp5
	gun_type = "smallarm"
	str_need = 8
	accuracy = 4
	damage_add = 1
	can_suppress = 0
	burst_size = 3
	fire_delay = 1
	slot_flags = SLOT_BELT|SLOT_BACK|SLOT_BACK2
	reliability_add = 1
	w_class = 4
	spread = 3
	recoil = 0.2
	damagelose = 0.4
	can_scope = 1
	weight = 2.5
	flags =  TWOHANDED
	drawsound = 'sound/stalker/weapons/draw/mp5_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/mp5_load.ogg'
	opensound = 'sound/stalker/weapons/unload/mp5_open.ogg'

/obj/item/weapon/gun/projectile/automatic/kiparis  // �������
	name_ru = "�������"
	name = "Kiparis"
	desc_ru = "���������� ��������-������� ����������������� � �������� ��������� �����, �������� ��������� �� �����������. �������, ����������, �� �������������� ������ ��� ���������� �������."
	desc = "An old gun designed for special ops and vehicle crews. Went completely out of army use in the recent years."
	icon_state = "kiparis"
	icon_ground = "kiparis_ground"
	item_state = "kiparis"
	fire_sound = 'sound/stalker/weapons/ppsh_shot.ogg'
	mag_type = /obj/item/ammo_box/magazine/stalker/kiparis
	gun_type = "smallarm"
	str_need = 8
	accuracy = 3
	can_suppress = 0
	burst_size = 3
	fire_delay = 1
	damage_add = 1
	slot_flags = SLOT_BELT
	reliability_add = 1
	w_class = 3
	spread = 3
	recoil = 0.15
	can_scope = 0
	weight = 1.6
	flags =  TWOHANDED
	drawsound = 'sound/stalker/weapons/draw/mp5_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/mp5_load.ogg'
	opensound = 'sound/stalker/weapons/unload/mp5_open.ogg'

/obj/item/weapon/gun/projectile/automatic/veresk  // ������
	name_ru = "������"
	name = "Veresk"
	desc_ru = "�� ����� ������� � ��� � ������ �� �����."
	desc = "This weapon's design makes you dizzy. What a weird SMG."
	icon_state = "veresk"
	icon_ground = "veresk_ground"
	item_state = "veresk"
	fire_sound = 'sound/stalker/weapons/fiveseven_shot.ogg'
	mag_type = /obj/item/ammo_box/magazine/stalker/veresk
	gun_type = "smallarm"
	str_need = 8
	accuracy = 3
	can_suppress = 0
	burst_size = 3
	fire_delay = 1
	slot_flags = SLOT_BELT
	reliability_add = 1
	damage_add = 1
	w_class = 4
	spread = 3
	recoil = 0.15
	can_scope = 0
	weight = 1.4
	flags =  TWOHANDED
	drawsound = 'sound/stalker/weapons/draw/mp5_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/mp5_load.ogg'
	opensound = 'sound/stalker/weapons/unload/mp5_open.ogg'

/obj/item/weapon/gun/projectile/automatic/p90  // �90
	name_ru = "�90"
	name = "P90"
	desc_ru = "������������, ������� � ������ �������� ��������-������� ��� ������ ����������� ���������. ��������� c���������� ������."
	desc = "Accurate, expensive and very successful PDW designed alongside with an unique armor-piercing ammunition. Truly, an example of mastery in weaponsmithing."
	icon_state = "p90"
	icon_ground = "p90_ground"
	item_state = "p90"
	fire_sound = 'sound/stalker/weapons/fiveseven_shot.ogg'
	mag_type = /obj/item/ammo_box/magazine/stalker/p90
	gun_type = "smallarm"
	str_need = 8
	accuracy = 4
	can_suppress = 0
	burst_size = 4
	fire_delay = 0.75
	slot_flags = SLOT_BELT
	reliability_add = 1
	damage_add = 1
	w_class = 4
	spread = 3
	recoil = 0.15
	can_scope = 0
	weight = 2.78
	flags =  TWOHANDED
	drawsound = 'sound/stalker/weapons/draw/mp5_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/mp5_load.ogg'
	opensound = 'sound/stalker/weapons/unload/mp5_open.ogg'

/obj/item/weapon/gun/projectile/automatic/bizon  // �����
	name_ru = "�����"
	name = "Bizon"
	desc_ru = "��������� ������ ��� ���������� ����������� ������. ������������ ������������ �������� - �������� �������� � ������� �������� �������� ��� ������ �������������, �� ����������� ������ ��������� ������ �������."
	desc = "One hell of a weird gun, utilising a low-power handgun cartridge. Only benefits of it's design are enormous ammo counter and a very impressive rate of fire, but piercing capabilities are somewhat unimpressive."
	icon_state = "bizon"
	icon_ground = "bizon_ground"
	item_state = "bizon"
	fire_sound = 'sound/stalker/weapons/ppsh_shot.ogg'
	mag_type = /obj/item/ammo_box/magazine/stalker/bizon
	gun_type = "smallarm"
	str_need = 8
	accuracy = 3
	can_suppress = 0
	burst_size = 4
	fire_delay = 1
	damage_add = 1
	slot_flags = SLOT_BELT
	reliability_add = 1
	w_class = 4
	spread = 3
	recoil = 0.15
	can_scope = 0
	weight = 2.3
	flags =  TWOHANDED
	drawsound = 'sound/stalker/weapons/draw/mp5_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/mp5_load.ogg'
	opensound = 'sound/stalker/weapons/unload/mp5_open.ogg'

/obj/item/weapon/gun/projectile/automatic/ppsh  // ���
	name_ru = "���"
	name = "PPSh"
	desc_ru = "�������, ������������� ����� � ������� ���������. ����� ������� �� ��� ������ ���������?"
	desc = "This ancient gun deserves a place in someone's private collection. How in the hell did you even find it?"
	icon_state = "ppsh"
	icon_ground = "ppsh_ground"
	item_state = "ppsh"
	fire_sound = 'sound/stalker/weapons/ppsh_shot.ogg'
	mag_type = /obj/item/ammo_box/magazine/stalker/ppsh
	gun_type = "longarm"
	str_need = 9
	accuracy = 3
	can_suppress = 0
	damage_add = 1
	burst_size = 5
	fire_delay = 0.75
	slot_flags = SLOT_BACK|SLOT_BACK2
	w_class = 5
	spread = 3
	recoil = 0.25
	damagelose = 0.5
	can_scope = 0
	weapon_weight = WEAPON_MEDIUM
	weight = 3.6
	flags =  TWOHANDED
	drawsound = 'sound/stalker/weapons/draw/mp5_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/mp5_load.ogg'
	opensound = 'sound/stalker/weapons/unload/mp5_open.ogg'

/obj/item/weapon/gun/projectile/automatic/ppsh/donbass
	name_ru = "��� ����� ��������"
	desc_ru = null
	icon_state = "pps_donbashero"
	item_state = "pps_donbashero"

/obj/item/weapon/gun/projectile/automatic/fnf2000  // fnf2000
	name_ru = "FN-F2000"
	desc_ru = "��-�2000 � ��-������ ��������� ������. ����������� ��������� ������������� ����������� � ������� �������������� �������������� ������� �������� ������ ������� ���� �������������. ��� ������������� ��������������� ���� ����� ����� ������ ������������� ����������. ������ � ��37 �������� ����� �� ������ ������ �������� � ����."
	desc = "This futuristic-looking weapon with a bullpup layout is actually a mass produced modular system, comprising a rifle grenade complex with a computerized fire control system and a 40-mm grenade launcher. Despite its bulky appearance, the weapon is highly ergonomic, easy to use and benefits from good technical characteristics. This one lacks a built-in computerised scope, yet itself is very precise and powerful."
	icon_state = "fnf2000"
	item_state = "fnf2000"
	slot_flags = SLOT_BACK
	force = 15
	origin_tech = "combat=6"
	mag_type = /obj/item/ammo_box/magazine/stalker/m556x45
	gun_type = "longarm"
	str_need = 10
	accuracy = 4
	fire_sound = 'sound/stalker/weapons/fnf2000_shoot.ogg'
	can_suppress = 0
	burst_size = 3
	fire_delay = 1
	w_class = 4
	spread = 2
	recoil = 0.35
	damagelose = 0.15
	can_scope = 0
	weapon_weight = WEAPON_MEDIUM
	weight = 4.8
	flags =  TWOHANDED
	drawsound = 'sound/stalker/weapons/draw/fnf2000_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/fnf2000_load.ogg'
	opensound = 'sound/stalker/weapons/unload/fnf2000_open.ogg'

/obj/item/weapon/gun/projectile/automatic/fnf2000s  // fnf2000
	name_ru = "FN-F2000-OTBS"
	desc_ru = "��-�2000 � ��-������ ��������� ������. ����������� ��������� ������������� ����������� � ������� �������������� �������������� ������� �������� ������ ������� ���� �������������. ��� ������������� ��������������� ���� ����� ����� ������ ������������� ����������. ������ � ��37 �������� ����� �� ������ ������ �������� � ����. � ������ ������ �������������� ������� ��� �������� � ���� ��� ������������."
	desc = "This futuristic-looking weapon with a bullpup layout is actually a mass produced modular system, comprising a rifle grenade complex with a computerized fire control system and a 40-mm grenade launcher. Despite its bulky appearance, the weapon is highly ergonomic, easy to use and benefits from good technical characteristics."
	icon_state = "fnf2000s"
	item_state = "fnf2000s"
	slot_flags = SLOT_BACK
	force = 15
	origin_tech = "combat=6"
	mag_type = /obj/item/ammo_box/magazine/stalker/m556x45
	gun_type = "longarm"
	str_need = 10
	accuracy = 6
	fire_sound = 'sound/stalker/weapons/fnf2000_shoot.ogg'
	can_suppress = 0
	burst_size = 3
	fire_delay = 1
	zoomable = 1
	zoom_amt = 12
	w_class = 4
	spread = 1
	recoil = 0.35
	damagelose = 0.15
	can_scope = 0
	weapon_weight = WEAPON_MEDIUM
	weight = 4.8
	flags =  TWOHANDED
	drawsound = 'sound/stalker/weapons/draw/fnf2000_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/fnf2000_load.ogg'
	opensound = 'sound/stalker/weapons/unload/fnf2000_open.ogg'

/obj/item/weapon/gun/projectile/automatic/l6_saw/pkm
	name_ru = "���"
	name = "PKM"
	desc_ru = "���� �� ����� ������� �������������� �����, ����� ������ ����� ������� ������� � ����. �������� �������� - �������� ��� � ������ �������� ��� �������� � ���."
	desc = "This machine gun is one of the most powerful weapons available in Zone. Main disadvantages are extremely large weight and powerful recoil."
	icon_state = "PKMclosed200"
	icon_ground = "PKMclosed200_ground"
	item_state = "l6closedmag"
	w_class = 7
	slot_flags = null
	origin_tech = "combat=5;materials=1;syndicate=2"
	mag_type = /obj/item/ammo_box/magazine/stalker/pkm
	gun_type = "longarm"
	str_need = 11
	accuracy = 5
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'sound/stalker/weapons/pkm_shot.ogg'
	reliability_add = 1
	can_suppress = 0
	can_scope = 0
	burst_size = 4
	fire_delay = 1
	spread = 3
	recoil = 1
	damagelose = 0.25
	weight = 9
	flags =  TWOHANDED

/obj/item/weapon/gun/projectile/automatic/l6_saw/pkm/update_icon()
	icon_state = "PKM[cover_open ? "open" : "closed"][magazine ? Ceiling(get_ammo(0)/200)*200 : "-empty"]"
	item_state = "l6[cover_open ? "open" : "closed"][magazine ? "mag" : "nomag"]"
	icon_ground = "PKM[cover_open ? "open_ground" : "closed_ground"][magazine ? Ceiling(get_ammo(0)/200)*200 : "-empty"]"

/obj/item/weapon/gun/projectile/automatic/l6_saw/pkm/shottie
   name_ru = "PTV M-777"
   desc_ru = "������ ������ ���������. ������ ��� ������."
   mag_type = /obj/item/ammo_box/magazine/stalker/pkm/shottie

///////////////////////////// ����������� �������� //////////////////////////////////////////
/obj/item/weapon/gun/projectile/automatic/val  // ���
	name_ru = "���"
	name = "Val"
	desc_ru = "����� � �����������."
	icon_state = "val"
	icon_ground = "val_ground"
	item_state = "val"
	fire_sound = 'sound/stalker/weapons/vintorez_shot.ogg'
	mag_type = /obj/item/ammo_box/magazine/stalker/sp9x39val
	gun_type = "longarm"
	str_need = 8
	accuracy = 4
	suppressed = 1
	can_suppress = 0
	can_unsuppress = 0
	slot_flags = SLOT_BACK|SLOT_BACK2
	reliability_add = 1
	force = 15
	origin_tech = "combat=5;materials=1"
	burst_size = 3
	fire_delay = 1.25
	w_class = 5
	spread = 2
	recoil = 0.3
	damagelose = 0.1
	can_scope = 1
	weapon_weight = WEAPON_MEDIUM
	weight = 2.5
	flags =  TWOHANDED
	drawsound = 'sound/stalker/weapons/draw/val_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/val_load.ogg'
	opensound = 'sound/stalker/weapons/unload/val_open.ogg'

/obj/item/weapon/gun/projectile/automatic/vintorez  // ��� ��������
	name_ru = "��������"
	name = "Vintorez"
	desc = "Quiet and effective."
	desc_ru = "����� � �����������."
	icon_state = "vintorez"
	icon_ground = "vintorez_ground"
	item_state = "vintorez"
	fire_sound = 'sound/stalker/weapons/vintorez_shot.ogg'
	mag_type = /obj/item/ammo_box/magazine/stalker/sp9x39vint
	gun_type = "longarm"
	str_need = 8
	accuracy = 7
	suppressed = 1
	can_suppress = 0
	can_unsuppress = 0
	zoomable = 1
	zoom_amt = 7
	burst_size = 3
	fire_delay = 1.25
	slot_flags = SLOT_BACK|SLOT_BACK2
	reliability_add = 1
	force = 15
	origin_tech = "combat=5;materials=1"
	w_class = 5
	spread = 1
	recoil = 0.3
	damagelose = 0
	can_scope = 0
	weapon_weight = WEAPON_MEDIUM
	weight = 3.2
	flags =  TWOHANDED
	drawsound = 'sound/stalker/weapons/draw/val_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/val_load.ogg'
	opensound = 'sound/stalker/weapons/unload/val_open.ogg'

/obj/item/weapon/gun/projectile/automatic/groza  // ��-14 �����
	name_ru = "�����"
	name = "Groza"
	desc = "Quiet and effective. And also has an underbarrel grenade launcher."
	desc_ru = "����� � �����������. ������������� ������������ ������������."
	icon_state = "groza"
	item_state = "groza"
	fire_sound = 'sound/stalker/weapons/groza_shot.ogg'
	mag_type = /obj/item/ammo_box/magazine/stalker/sp9x39groza
	gun_type = "longarm"
	suppressed = 1
	str_need = 9
	accuracy = 4
	can_suppress = 0
	slot_flags = SLOT_BACK|SLOT_BACK2
	reliability_add = 1
	fire_delay = 1.25
	force = 15
	origin_tech = "combat=5;materials=1"
	burst_size = 3
	w_class = 4
	spread = 2
	recoil = 0.4
	damagelose = 0.35
	can_scope = 1
	weapon_weight = WEAPON_MEDIUM
	weight = 4
	flags =  TWOHANDED
	drawsound = 'sound/stalker/weapons/draw/groza_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/groza_load.ogg'
	opensound = 'sound/stalker/weapons/unload/groza_open.ogg'

/obj/item/weapon/gun/projectile/automatic/fal  // ���
	name_ru = "�� ���"
	name = "FN Fal"
	desc = "An old automatic rifle, utilising very powerful cartridge, making each shot much more deadlier but also significantly decreasing burst accuracy and magazine capacity."
	desc_ru = "������ �������������� ��������, ������������ ������ ����������, �������� ������ ������� ������������, �� ����� ����������� ������ �������� �������� ��������� � ��������������� ��������."
	icon_state = "fal"
	icon_ground = "fal_ground"
	item_state = "fal"
	fire_sound = 'sound/stalker/weapons/akm_shot.ogg'
	mag_type = /obj/item/ammo_box/magazine/stalker/fal
	gun_type = "longarm"
	str_need = 11
	accuracy = 5
	can_suppress = 0
	can_unsuppress = 0
	slot_flags = SLOT_BACK|SLOT_BACK2
	reliability_add = 1
	origin_tech = "combat=5;materials=1"
	burst_size = 3
	fire_delay = 1.5
	w_class = 5
	spread = 4
	weapon_weight = WEAPON_MEDIUM
	weight = 4.45
	flags =  TWOHANDED
	drawsound = 'sound/stalker/weapons/draw/val_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/val_load.ogg'
	opensound = 'sound/stalker/weapons/unload/val_open.ogg'

/obj/item/weapon/gun/projectile/automatic/sks  // ���
	name_ru = "���"
	name = "SKS"
	desc_ru = "���� �������� ���� ����������."
	desc = "Time to take down some boars."
	icon_state = "sks"
	icon_ground = "sks_ground"
	item_state = "sks"
	fire_sound = 'sound/stalker/weapons/akm_shot.ogg'
	mag_type = /obj/item/ammo_box/magazine/internal/boltaction/sks
	gun_type = "longarm"
	str_need = 9
	accuracy = 4
	can_suppress = 0
	can_unsuppress = 0
	fire_delay = 5
	durability = 200
	slot_flags = SLOT_BACK|SLOT_BACK2
	burst_size = 0
	origin_tech = "combat=5;materials=1"
	w_class = 5
	spread = 2
	weapon_weight = WEAPON_MEDIUM
	weight = 3.75
	flags =  TWOHANDED
	drawsound = 'sound/stalker/weapons/draw/ak74_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/bolt_load.ogg'
	opensound = 'sound/stalker/weapons/unload/val_open.ogg'

/obj/item/weapon/gun/projectile/automatic/sks/New()
	..()
	if(!magazine)
		magazine = new mag_type(src)

/obj/item/weapon/gun/projectile/automatic/sks/MouseDrop(atom/over_object)
	var/mob/M = usr
	if(M.restrained() || M.stat || !Adjacent(M))
		return
	if(!istype(over_object, /obj/screen/inventory/hand))
		return

	if(!M.is_holding(src))
		return

	var/obj/item/ammo_casing/AC = chambered //Find chambered round
	if(chambered)
		if(jam)
			if(flags & IN_PROGRESS)
				return

			while(jam)
				var/dice = M.int + M.gun_skills[gun_type] - 4
				flags += IN_PROGRESS
				if(!do_mob(M, src, 10, 1))
					flags &= ~IN_PROGRESS
					return
				flags &= ~IN_PROGRESS
				if(M.rolld(dice6(3), dice))
					jam = 0
					usr << usr.client.select_lang("<span class='notice'>������ ����� � �����.</span>", "<span class='notice'>Weapon is working again.</span>")

		AC.loc = get_turf(src)
		AC.SpinAnimation(10, 1)
		weight -= AC.weight
		chambered = null
		usr << usr.client.select_lang( "<span class='notice'>�� �������������� ������ [name_ru], ���������� ���������.</span>", "<span class='notice'>You pull the bolt of [src], clearing the chamber.</span>")
		playsound(M, opensound, 50, 1, channel = "regular", time = 20)

	else
		usr << usr.client.select_lang("<span class='notice'>��� ��� ����. ������ ��������� ���������.</span>", "<span class='notice'>How interesting. Weapon is completely unloaded.</span>")
	update_icon()

/obj/item/weapon/gun/projectile/automatic/sks/attack_self(mob/living/user)
	if(chambered)//We have a shell in the chamber
		chambered.loc = get_turf(src)//Eject casing
		chambered.SpinAnimation(5, 1)
		if (!chambered.BB)
			addtimer(CALLBACK(chambered, /obj/item/ammo_casing/proc/delete_projectile), rand(CLEANABLE_CLEAN_DELAY*0.75, CLEANABLE_CLEAN_DELAY*1.25))
		chambered = null

	if(!magazine.ammo_count())
		return 0
	var/obj/item/ammo_casing/AC = magazine.get_round() //load next casing.
	chambered = AC
	playsound(user, opensound, 50, 1, channel = "regular", time = 20)

/obj/item/weapon/gun/projectile/automatic/sks/attackby(obj/item/A, mob/user, params)
	if(!user.is_holding(src))
		return

	var/num_loaded = 0
	if(istype(A, /obj/item/ammo_box/stalker/sks))
		var/obj/item/ammo_box/stalker/sks/S = A

		for(var/obj/item/ammo_casing/AM in S)
			if(magazine.give_round(AM, 0))
				user.unEquip(AM, 0, 0)
				AM.loc = src
				S.stored_ammo -= AM
				num_loaded++
				if(!chambered)
					chamber_round()

	else
		num_loaded = magazine.attackby(A, user, params, 1)

	if(num_loaded)
		if(jam)
			jam = 0
		playsound(user, loadsound, 50, 1, channel = "regular", time = 10)
		var/word = "��������"
		switch(num_loaded)
			if(1)
				word = "������"
			if(2 to 4)
				word = "�������"
		user << user.client.select_lang("<span class='notice'>�� ��������� [num_loaded] [word] � [name_ru].</span>","<span class='notice'>You load [num_loaded] ammo casings in the [src].</span>")
		if(A)
			A.update_icon()
		update_icon()
		user.changeNext_move(CLICK_CD_MELEE)

/obj/item/weapon/gun/projectile/automatic/svd  // ���
	name_ru = "���"
	name = "SVD"
	desc_ru = "���� �������� ���� �������."
	desc = "Time to take down some terrorists."
	icon_state = "svd"
	icon_ground = "vintorez_ground"
	item_state = "vintorez"
	fire_sound = 'sound/stalker/weapons/sniper_shot.ogg'
	mag_type = /obj/item/ammo_box/magazine/stalker/svd
	gun_type = "longarm"
	str_need = 10
	accuracy = 7
	can_suppress = 0
	can_unsuppress = 0
	zoomable = 1
	zoom_amt = 7
	fire_delay = 5
	slot_flags = SLOT_BACK|SLOT_BACK2
	burst_size = 0
	origin_tech = "combat=5;materials=1"
	w_class = 5
	spread = 1
	weapon_weight = WEAPON_MEDIUM
	weight = 4.5
	flags =  TWOHANDED
	drawsound = 'sound/stalker/weapons/draw/val_draw.ogg'
	loadsound = 'sound/stalker/weapons/load/val_load.ogg'
	opensound = 'sound/stalker/weapons/unload/val_open.ogg'