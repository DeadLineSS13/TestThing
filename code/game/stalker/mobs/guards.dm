GLOBAL_LIST_EMPTY(guards_targets)
GLOBAL_LIST_EMPTY(guards)

/mob/living/carbon/human/guard
	name = "Guard"
	name_ru = "Патрульный"
	stop_automated_movement = 1
	gun_skills = list("smallarm" = 0, "longarm" = 4, "heavy" = 0)
	skills = list("melee" = 10, "medic" = 0)
	agi_const = 14
	agi = 14
	str_const = 12
	str = 12
	int_const = 7
	int = 7
	a_intent = "harm"
	anchored = 1
	var/warned = 0
	var/ammotype = /obj/item/ammo_casing/c545
	var/obj/item/weapon/gun/projectile/gun = /obj/item/weapon/gun/projectile/automatic/ak74

/obj/structure/vallat/satellite
	name = "Сателит"
	name_ru = "Уебан какой-то"
	icon_state = "amogus"
	icon = 'icons/mob/human.dmi'
	phrases = list("ты гурпс вообще читал?","купите мои лутбоксы пожалуйста молю блядь","айм гона КУМ!)) XD","У ТЕБЯ НЕ РП КЛИЧКА >:(((","АХАХАХА ПОРВААААЛСЯ",\
	"я одобряю твою фракцию, только не пизди больше!","дауненок, обоссанец, петух!","ты охуел? щас свинью выдам","что? боевка говно? это формулы, сынок",\
	">ХРЮЮЮ","ЧЕТВЕРТАЯ НЕДЕЛЯ ИЮЛЯ, 2017 ГОД: я сосал меня ебали","ГРОИН НИНУЖОН!!!11")

/obj/structure/vallat
	name = "Валлат"
	name_ru = "Ебаллат"
	icon = 'icons/mob/mob.dmi'
	icon_state = "gibbed-h"
	var/list/phrases = list("чем у меня хуже???","уникальный механ, оригинальные фичи, хордкококор!","так и задумано, иди нахуй!",\
	"Я СДЕЛАЛ ДЛЯ БИЛДА В СОТНИ РАЗ БОЛЬШЕ!!!","прямо как в моей любимой книге 'дезертир тайна черного сталкера 6...'","НЕТ НЕТ НЕЕЕЕТ МОЙ БИИИИИЛД!((((",\
	"мне нужно посоветоваться по этому поводу с айскактусом...","у меня всё работает, может проблема в тебе?","это идет в билд","да я для вас, да вы...эх",\
	"НЕ НРАВИТСЯ? СЪЕБАЛ ОТСЮДА","исправлены фичи, добавлены новые баги", "разработчик, творец, гений, ебла...","такого больше не будет!.. бля")

/obj/structure/vallat/New()
	start_speaking()
	return

/obj/structure/vallat/proc/start_speaking()
	var/P = 10*(rand(10,25))
	while(P)
		sleep(P)
		say(pick(phrases))

/obj/structure/vallat/attackby(obj/item/I, mob/user, params)
	say(pick(phrases))

/obj/structure/vallat/bullet_act(obj/item/projectile/P)
	say(pick(phrases))

/obj/structure/vallat/attack_hand(mob/living/carbon/human/M)
	say(pick(phrases))

/mob/living/carbon/human/guard/Initialize()
	..()
	gun = new gun(src)
	if(!gun.magazine)
		gun.magazine = new gun.mag_type(gun)
		gun.update_icon()
	put_in_r_hand(gun)
	gun.wield(src)
	GLOB.guards.Add(src)

//	EQUIPMENT

	if(prob(75))
		equip_to_slot_or_del(new /obj/item/clothing/under/color/switer/soldier(src),slot_w_uniform, 0)
	else
		equip_to_slot_or_del(new /obj/item/clothing/under/color/switer/soldier_vdv(src),slot_w_uniform, 0)

	equip_to_slot_or_del(new /obj/item/clothing/suit/kazak(src),slot_wear_suit_hard, 0)

	equip_to_slot_or_del(new /obj/item/clothing/gloves/fingerless(src),slot_gloves, 0)

	equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots/warm(src),slot_shoes, 0)

	equip_to_slot_or_del(new /obj/item/clothing/head/kazak(src),slot_head_hard, 0)


/mob/living/carbon/human/guard/Life()
	handle_automated_action()
	spawn(10)
		handle_automated_action()

/mob/living/carbon/human/guard/handle_automated_action()
	if(target && target.faction_s == "Army")
		GLOB.guards_targets.Remove(target)
		target = null
	if(target && warned >= 10)
		if(!GLOB.guards_targets.Find(target))
			target = null
			warned = 0
		else if(target.stat == DEAD)
			GLOB.guards_targets.Remove(target)
			target.give_achievement("I swear, guys, I can kill 'em")
			target = null
			warned = 0
		else if(target in oview(14, src))
			fire(target)
			if(!check_for_weapon(target))
				warned -= 1
			return
		else if(warned)
			warned = 0
			target = null

	for(var/mob/living/L in oview(7, src))
		if(L.faction_s == "Army")
			continue
		if(istype(L, /mob/living/carbon/human/guard))
			continue
		if(L.stat == DEAD)
			continue
		if(GLOB.guards_targets.Find(L))
			target = L
			warned = 20
			fire(target)
			break
		if(ishostile(L))
			target = L
			warned = 20
			fire(target)
			break
		if(ishuman(L))
			if(check_for_weapon(L))
				if(!warned)
					say(pick("Hey, cease that! You know you aren't allowed to carry gun in the camp!", "HEY! No guns in here, you know it! Don't make me shoot you!"),\
					pick("Слышь, не дури, пушку обратно засунь живо!","Бродяга, а ну, пукалку-то свою убери!","Ты чего, совсем контуженный? Нельзя тут оружие в руках носить!"))
					playsound(src, "weapon_drop", 100, 0, 0, 5, channel = SSchannels.get_reserved_channel(35), time = 30)
				warned += 1
				if(warned == 5)
					say(pick("Holster you damn weapon, stalker, or I'll shoot you, god damn it!", "Put your gun back where it was or I'll blow your brains out, for god's sake!"),\
					pick("Не понял, ты оглох или на пулю нарываешься? Мне ж боезапас не жалко!","Да ты крышей поехал, че ли? Убрал немедля, или огонь открою!","Да твою же... не дерзи, я ж всерьез сейчас стрелять буду!"))
					playsound(src, "weapon_drop", 100, 0, 0, 5, channel = SSchannels.get_reserved_channel(35), time = 30)
				if(warned > 9)
					say(pick("Well, that's it!!!", "Oh, you made me do this!!!"),\
					pick("Ну все, кранты тебе, гопота сраная!!!","Ай, пошло-поехало! Сам нарвался!!!","Для сволочей свинца не жалко!!!"))
					GLOB.guards_targets |= L
					target = L
					warned = 20
				break
		if(!target && warned)
			warned -= 1
		if(target)
			target = null

/mob/living/carbon/human/guard/attacked_by(obj/item/I, mob/living/user, def_zone)
	..()
	if(!warned)
		say(pick("Well, that's it!!!", "Oh, you made me do this!!!"),\
			pick("Ну все, кранты тебе, гопота сраная!!!","Ай, пошло-поехало! Сам нарвался!!!","Для сволочей свинца не жалко!!!"))
	GLOB.guards_targets |= user
	target = user
	warned = 20

/mob/living/carbon/human/guard/bullet_act(obj/item/projectile/P)
	..()
	if(istype(P.firer, /mob/living/carbon/human/guard))
		return
	if(!warned)
		say(pick("Well, that's it!!!", "Oh, you made me do this!!!"),\
			pick("Ну все, кранты тебе, гопота сраная!!!","Ай, пошло-поехало! Сам нарвался!!!","Для сволочей свинца не жалко!!!"))
	GLOB.guards_targets |= P.firer
	target =  P.firer
	warned = 20

/mob/living/carbon/human/guard/attack_hand(mob/living/carbon/human/M)
	if(!M)
		return
	if(M.a_intent != "help")
		if(!warned)
			say(pick("Well, that's it!!!", "Oh, you made me do this!!!"),\
			pick("Ну все, кранты тебе, гопота сраная!!!","Ай, пошло-поехало! Сам нарвался!!!","Для сволочей свинца не жалко!!!"))
		GLOB.guards_targets |= M
		target = M
		warned = 20
	..()

/mob/living/carbon/human/guard/show_inv(mob/user)
	if(!warned)
		say(pick("Well, that's it!!!", "Oh, you made me do this!!!"),\
			pick("Ну все, кранты тебе, гопота сраная!!!","Ай, пошло-поехало! Сам нарвался!!!","Для сволочей свинца не жалко!!!"))
	GLOB.guards_targets |= user
	target = user
	warned = 20

/mob/living/carbon/human/guard/hitby()
	return

/mob/living/carbon/human/guard/proc/check_for_weapon(mob/living/carbon/human/H)
	if(istype(H.get_active_held_item(), /obj/item/weapon/gun) || istype(H.get_inactive_held_item(), /obj/item/weapon/gun))
		return TRUE
	return FALSE

/mob/living/carbon/human/guard/proc/fire(atom/targeted_atom)
	if(!get_active_held_item())
		return
	if(ammotype)
		for(var/i = 3, i > 0, i--)
			spawn(i)
//				var/turf/startloc = get_turf(src)
				var/obj/item/ammo_casing/AM = new ammotype
				playsound(src, gun.fire_sound, 100, 1, channel = "regular", time = 10)
				AM.fire(targeted_atom, src, zone_override = ran_zone())
				qdel(AM)
