
//	Артефакты электрические по своей природе	//

/obj/item/artefact/electro
	light_color = COLOUR_LTEMP_SKY_CLEAR

/obj/item/artefact/electro/mozaika
	name = "Mosaik"
	name_ru = "Мозаика"
	icon_state = "mozaika"

	lick_message = "Tastes like an old glass bottle."
	lick_message_ru = "На вкус как пыльное бутылочное стекло."

	effects = list("burn_armor" = 2, "agi" = -1)



/obj/item/artefact/electro/zapzap
	name = "Zapzap"
	name_ru = "Запзап"
	icon_state = "zapzap"

	lick_message = ""
	lick_message_ru = "А-А-АЙ! МОЙ ЯЗЫК! С-сука, током бьет..."

	effects = list("zapzap" = 1, "hlt" = -2, "str" = 1, "agi" = 1, "stamina_coef" = -25)

/obj/item/artefact/electro/zapzap/lick()
	usr.direct_visible_message("<span class='notice'>DOER licked TARGET</span", message_ru = "<span class='notice'>DOER лизнул TARGET</span>", span_class = "notice", doer = usr, target = src)
	usr << sanitize_russian(usr.client.select_lang("<i><span class='warning'>[lick_message_ru]</span></i>", "<i><span class='warning'>[lick_message]</span></i>"))
	for(var/mob/living/carbon/human/H in view(7, usr))
		H.give_exp(3, "[name]_lick", 1)
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		var/obj/item/organ/limb/head = H.get_organ("head")
		head.take_damage(0, 0, 1)
		playsound(src, pick('sound/stalker/artefacts/electra_hit.ogg','sound/stalker/artefacts/electra_hit1.ogg'), 100, extrarange = -5, time = 10)

/obj/item/artefact/electro/zapzap/hit(mob/user, str_bonus = 0)
	..()
	if(user.rolld(dice6(3), user.str-6+str_bonus))
		user.dust()
		var/turf/stalker/T = get_turf(src)
		spawn(3 SECONDS)
			new /obj/anomaly/natural/tesla_ball(T)
		qdel(src)



/obj/item/artefact/electro/kirpich
	name = "Brick"
	name_ru = "Кирпич"
	icon_state = "kirpich"

	lick_message = ""
	lick_message_ru = "А-А-АЙ! МОЙ ЯЗЫК! С-сука, током бьет..."

	effects = list("kirpich" = 2)

/obj/item/artefact/electro/kirpich/lick()
	usr.direct_visible_message("<span class='notice'>DOER licked TARGET</span", message_ru = "<span class='notice'>DOER лизнул TARGET</span>", span_class = "notice", doer = usr, target = src)
	usr << sanitize_russian(usr.client.select_lang("<i><span class='warning'>[lick_message_ru]</span></i>", "<i><span class='warning'>[lick_message]</span></i>"))
	for(var/mob/living/carbon/human/H in view(7, usr))
		H.give_exp(3, "[name]_lick", 1)
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		var/obj/item/organ/limb/head = H.get_organ("head")
		head.take_damage(0, 0, 1)
		playsound(src, pick('sound/stalker/artefacts/electra_hit.ogg','sound/stalker/artefacts/electra_hit1.ogg'), 100, extrarange = -5, time = 10)

/obj/item/artefact/electro/kirpich/shake()
	..()
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		var/obj/item/organ/limb/L = pick(H.organs)
		H << sanitize_russian("<span class='warning'>[H.client.select_lang(\
								pick("Проклятье... все тело зудит.", "Ни секунды покоя из-за этого зуда...", "Ар-ргх. Лишь бы этот чертов зуд прекратился!"),\
								pick("Damn, my whole body itches...", "Ugh, not a single moment without this itch.", "Ar-rgh. I just want this fucking itch to stop!"))]</span>")
		L.take_damage(0, 0, 1)
		playsound(src, pick('sound/stalker/artefacts/electra_hit.ogg','sound/stalker/artefacts/electra_hit1.ogg'), 100, extrarange = -5, time = 10)

/obj/item/artefact/electro/zapzap/hit(mob/user, str_bonus = 0)
	..()
	if(user.rolld(dice6(3), user.str-6+str_bonus))
		qdel(src)