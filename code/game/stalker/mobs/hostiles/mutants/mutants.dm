/mob/living/simple_animal/hostile/mutant
	stat_attack = 2
	stat_exclusive = 0
	fearless = 0
	var/gib_targets = 1 //Гибать
	icon = 'icons/stalker/stalker.dmi'
	var/deletable = 1 //Self-deletable dead bodies
	speak_chance = 1.5
	var/kill_exp = 10
	armor_new = list(crush = 0, cut = 0, imp = 0, bullet = 0, burn = 0, bio = 0, rad = 0, psy = 0)
	body_armor = A_SOFT
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)


/mob/living/simple_animal/hostile/mutant/death(gibbed)
	..()
	if(kill_exp)
		for(var/mob/living/carbon/human/H in range(7, src))
			H.give_exp(kill_exp, "[name]_kill", 10)

/mob/living/simple_animal/hostile/mutant/AttackingTarget()
	..()
	if(istype(target, /mob/living))
		var/mob/living/L = target
		if (L.stat == DEAD && gib_targets)
			if(L.timeofdeath + 600 > world.time)
				target = null
				return
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				if(prob(50))
					H.unEquip(H.ears, delay = 0)
				if(prob(50))
					H.unEquip(H.gloves, delay = 0)
				if(prob(50))
					H.unEquip(H.glasses, delay = 0)
				if(prob(50))
					H.unEquip(H.head, delay = 0)
				if(prob(50))
					H.unEquip(H.shoes, delay = 0)
				if(prob(100))
					H.unEquip(H.back, delay = 0)
				H.unEquip(H.back, delay = 0)
				H.unEquip(H.wear_id, delay = 0)
			L.gib()
			visible_message("<span class='danger'>[src] разрывает беднягу на кусочки!</span>")
//			src << "<span class='userdanger'>Ты пожираешь тело и востанавливаешь свое здоровье!</span>"
			src.revive()

/mob/living/simple_animal/hostile/mutant/dog
	name = "dog mutant"
	name_ru = "Мутировшая собака"
	desc_ru = "Мутировавшая слепая дикая собака."
	desc = "This dog became blind because of the radiation, allowing him to develop a more precise sense of smell. Its skin is of a maroon color, and the lack of food shows the bones of its ribcage.His tail is edible and so taking it would be a good idea to make a soup or sell it."
	turns_per_move = 5
	speed = 1
	a_intent = "harm"
	harm_intent_damage = 5
	icon_state = "stalker_dog"
	icon_living = "stalker_dog"
	icon_dead = "stalker_dog_dead"
	attacktext = "bites"
	attacktext_ru = "кусает"
	search_objects = 0
	speak_emote = list("whines", "roars")
	emote_see = list("barks!")
	emote_see_ru = list("лает!")
	faction = list("stalker_mutants1")
	attack_sound = 'sound/stalker/mobs/mutants/attack/dog_attack.ogg'
	idle_sounds = list('sound/stalker/mobs/mutants/idle/bdog_idle_1.ogg',
						'sound/stalker/mobs/mutants/idle/bdog_idle_2.ogg',
						'sound/stalker/mobs/mutants/idle/bdog_idle_3.ogg',
						'sound/stalker/mobs/mutants/idle/bdog_idle_4.ogg')
	death_sound = 'sound/stalker/mobs/mutants/death/dog_death.ogg'
	melee_damage_lower = 10
	melee_damage_upper = 15
	damtype = "cut"
	maxHealth = 25
	fearborder = 10
	healable = 1
	robust_searching = 1
	see_invisible = SEE_INVISIBLE_MINIMUM
	see_in_dark = 4
	deathmessage = "The dog makes a sinister howl!"
	deathmessage_ru = "Мутант издает пронзительный вой."
	del_on_death = 0
	minbodytemp = 0
	maxbodytemp = 1500
	environment_smash = 0
	layer = MOB_LAYER - 0.1
	loot = list(/obj/item/weapon/stalker/loot/dog_tail, /obj/nothing, /obj/nothing)
	random_loot = 1
	attack_type = "bite"
	move_to_delay = 1.2 //Real speed of a mob
	vision_range = 7
	aggro_vision_range = 7

/mob/living/simple_animal/hostile/mutant/dog/AttackingTarget()
	..()
	if(istype(target, /mob/living/carbon))
		var/mob/living/carbon/C = target
		if(C.health > 25)
			var/anydir = pick(GLOB.alldirs)
			target_last_loc = target.loc
			walk_away(src, get_step(src, anydir), 7, move_to_delay)

/mob/living/simple_animal/hostile/mutant/spider
	name = "Nastiness"
	name_ru = "Гадость"
	desc_ru = "Выглядит мерзко."
	turns_per_move = 5
	speed = 1
	a_intent = "harm"
	harm_intent_damage = 5
	icon = 'icons/stalker/npc/spider.dmi'
	icon_state = "spider"
	icon_living = "spider"
	icon_dead = "spider_dead"
	attacktext = "uses an outgrowth to strike"
	attacktext_ru = "пронзает отростками"
	search_objects = 0
	//speak_emote = list("whines", "roars")
	emote_see = list("stares enigmatically.")
	emote_see_ru = list("загадочно смотрит.",
						"бессмысленно смотрит.")
	faction = list("necromutants")
	attack_sound = list('sound/stalker/mobs/mutants/attack/spider_attack_1.ogg',
						'sound/stalker/mobs/mutants/attack/spider_attack_2.ogg')
	idle_sounds = list('sound/stalker/mobs/mutants/idle/spider_idle_1.ogg',
						'sound/stalker/mobs/mutants/idle/spider_idle_2.ogg',
						'sound/stalker/mobs/mutants/idle/spider_idle_3.ogg')
	death_sound = 'sound/stalker/mobs/mutants/death/spider_death.ogg'
	damtype = "imp"
	dmgvalue = "straight"
	dice_number = 1
	add_damage = 0
	str = 10
	maxHealth = 40
	fearborder = 0
	armor_new = list(crush = 2, cut = 2, imp = 2, bullet = 2, burn = 5, bio = 5, rad = 0, psy = 0)
	healable = 1
	robust_searching = 1
	see_invisible = SEE_INVISIBLE_MINIMUM
	see_in_dark = 4
	deathmessage = "Creature dies, bleeding with malodorous ichor."
	deathmessage_ru = "Существо издыхает в жутких судорогах, истекая дурнопахнущей сукровицей."
	del_on_death = 0
	minbodytemp = 0
	maxbodytemp = 1500
	environment_smash = 0
	layer = MOB_LAYER - 0.1
//	loot = list(/obj/item/weapon/stalker/loot/dog_tail, /obj/nothing, /obj/nothing)
	random_loot = 1
	attack_type = "claw"
	move_to_delay = 4 //Real speed of a mob
	vision_range = 9
	aggro_vision_range = 6

/mob/living/simple_animal/hostile/mutant/spider/New()
	..()
	add_overlay(image('icons/stalker/npc/spider.dmi', "spider_tent", layer = MOB_LAYER - 0.2))

/mob/living/simple_animal/hostile/mutant/spider/death()
	..()
	cut_overlays()

/mob/living/simple_animal/hostile/mutant/mistake
	name = "Nastiness"
	name_ru = "Гадость"
	desc_ru = "Выглядит мерзко."
	turns_per_move = 5
	speed = 1
	a_intent = "harm"
	icon = 'icons/stalker/npc/mistake.dmi'
	icon_state = "mistake"
	icon_living = "mistake"
	icon_dead = "mistake_dead"
	attacktext = "strikes fiercely"
	attacktext_ru = "бьет наотмашь"
	search_objects = 0
//	speak_emote = list("whines", "roars")
	emote_see = list("roars.")
	emote_see_ru = list("злобно рычит.",
						"разъяренно рычит.")
	faction = list("clones")
	attack_sound = 'sound/stalker/mobs/mutants/attack/mistake_attack.ogg'
	idle_sounds = list('sound/stalker/mobs/mutants/idle/mistake_idle_1.ogg',
						'sound/stalker/mobs/mutants/idle/mistake_idle_2.ogg')
	death_sound = 'sound/stalker/mobs/mutants/death/mistake_death.ogg'
	damtype = "crush"
	dmgvalue = "straight"
	dice_number = 2
	add_damage = 2
	str = 16
	maxHealth = 48
	fearborder = 0
	healable = 1
	robust_searching = 1
	see_invisible = SEE_INVISIBLE_MINIMUM
	see_in_dark = 4
	deathmessage = "Creature whines and collapses, pink flesh quickly losing any humanoid shape it had."
	deathmessage_ru = "Существо заваливается на спину. Розоватая плоть быстро теряет всякое человеческое подобие."
	minbodytemp = 0
	maxbodytemp = 1500
	environment_smash = 0
	layer = MOB_LAYER - 0.1
//	loot = list(/obj/item/weapon/stalker/loot/dog_tail, /obj/nothing, /obj/nothing)
	random_loot = 1
	attack_type = "claw"
	move_to_delay = 6 //Real speed of a mob
	vision_range = 6
	aggro_vision_range = 6

/mob/living/simple_animal/hostile/mutant/mistake/death()
	..()
	if(prob(10))
		new /obj/item/artefact/organic/appendix(get_turf(src))
