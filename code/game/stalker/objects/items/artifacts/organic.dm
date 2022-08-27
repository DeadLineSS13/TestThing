
//	Артефакты на органической основе	//

/obj/item/artefact/organic
	light_color = LIGHT_COLOR_BLUEGREEN

/obj/item/artefact/organic/appendix
	name = "Appendix"
	name_ru = "Аппендикс"
	icon_state = "appendix"

	lick_message = "Tastes like raw meat."
	lick_message_ru = "На вкус как сырое мясо."

	effects = list("stamina_coef" = -25, "regen" = 1)

	var/dead = 0
	var/rubbed = 0

/obj/item/artefact/organic/appendix/proc/death()
	if(!dead)
		icon_state = "appendix_dead"
		icon_hands = "appendix_dead"
		effects.Cut()
		owner.recalc_artefact_effects(src)
		initial_effects.Cut()
		dead = 1
		playsound(src, 'sound/stalker/artefacts/appendix_death.ogg', 50, extrarange = -5, time = 35)

/obj/item/artefact/organic/appendix/compress()
	..()
	death()

/obj/item/artefact/organic/appendix/hit()
	..()
	death()

/obj/item/artefact/organic/appendix/cut()
	..()
	death()

/obj/item/artefact/organic/appendix/rub()
	..()
	if(rubbed || dead)
		return
	effects = list("stamina_coef" = 50, "regen" = 3)
	owner.recalc_artefact_effects(src)
	rubbed = 1
	initial_effects = effects.Copy()
	spawn(dice6(2) MINUTES)
		death()



/obj/item/artefact/organic/root
	name = "Root"
	name_ru = "Корень"
	icon_state = "root"

	lick_message = ""
	lick_message_ru = "На вкус как свежий огурец."

	var/compressed = 0

/obj/item/artefact/organic/root/compress()
	..()
	if(!compressed)
		compressed = 1

/obj/item/artefact/organic/root/attack(mob/M, mob/user, def_zone)
	var/eatverb = pick("bite","chew","nibble","gnaw","gobble","chomp")
	user.visible_message("<span class='notice'>[user] takes a [eatverb] from \the [src].</span>", "<span class='notice'>You take a [eatverb] from \the [src].</span>")
	playsound(M.loc,'sound/items/eatfood.ogg', rand(10,50), 1, channel = "regular", time = 10)

	if(compressed)
		effects = list("regen" = 5, "str" = -1, "agi" = -1, "int" = -1)
	else
		effects = list("regen" = 3)
	add_effects(user)
	initial_effects = effects.Copy()
	effects.Cut()
	spawn(dice6(2) MINUTES)
		effects = initial_effects.Copy()
		remove_effects(user)
	qdel(src)



/obj/item/artefact/organic/krot
	name = "Mole"
	name_ru = "Крот"
	icon_state = "krot"

	lick_message = ""
	lick_message_ru = "На вкус как гниль... пфу, тьфе, гадость."

	effects = list("krot" = 1, "str" = 1, "hlt" = 1)

/obj/item/artefact/organic/krot/compress()
	..()
	//TODO: Сделать писк

/obj/item/artefact/organic/krot/cut()
	..()
	var/obj/effect/particle_effect/smoke/S = new(get_turf(src))
	qdel(src)
	S.color = "#a14318"
	S.amount = 5
	S.lifetime = 30
	S.anomaly_reagent = "rustpuddle"
	S.spread_smoke()

/obj/item/artefact/organic/krot/shake()
	..()
	effects = list("krot" = 2, "str" = 2, "hlt" = 2)
	owner.recalc_artefact_effects(src)