/*///////////////////////FAQ по €годам\\\\\\\\\\\\\\\\\\\\\\\\\\\\*\

	Ќа данные момент есть 6 типов €год, каждый из которых имеет свои свойства:

	* расные лечат брут, нанос€т радиационный урон
	*ќранжевые лечат бЄрн, нанос€ тоже радиацию
	*—иние €годы работают ал€ отрезвитель, неплохо справл€ютс€ с опь€нением
	*«еленые вывод€т небольшую дозу радиации
	*Ѕелые €годы добавлены спешиал фор фридом, вызывают галюны, хот€ и довольно слабые.		//Ќужно будет немного глюки переработать
	*„ерные €годы позвол€ют бежать чуть быстрее, однако при смешивании с другими выступают в качестве неплохого усилител€

	ѕри смешивании большинства €год они перенимают эффекты друг друга, дополн€€ или перекрыва€ друг друга
	јх да, при добавлении чего-то нового желательно все, что не относитс€ к смешиванию €год друг с другом, ал€ €годы + вод€ра, писать в
	самом конце кода, а €годы + €годы в начале/середине, располага€ по степени сложности.

*/


/obj/item/weapon/reagent_containers/food/snacks/wild/berries
	name = "strange plant"
	desc = "Some sort strange of berries. You don't think that those edible."
	desc_ru = " акие-то странные €годы. Ќе думаю, что стоит их пробовать."
	icon = 'icons/stalker/berries.dmi'
	w_class = 1
	weight = 0.1

/datum/reagent/wild_food/berries
	name = "berries"
	description = "Just a bunch of berries"
	metabolization_rate = 0.1

/datum/reagent/wild_food/on_mob_life(mob/living/M)
	current_cycle++
	holder.remove_reagent(src.id, metabolization_rate)

//////////////////// –ј—Ќџ≈ я√ќƒџ\\\\\\\\\\\\\\\\\\\\

/obj/item/weapon/reagent_containers/food/snacks/wild/berries/red
	name = "red berries"
	desc = "Some sort of strange red berries. You don't think that those are edible."
	desc_ru = " акие-то странные €годы красного цвета. Ќе думаю, что стоит их пробовать."
	icon_state = "berries_red"
	list_reagents = list("red_berries" = 2)

/datum/reagent/wild_food/berries/red
	name = "Red berries"
	id = "red_berries"

/datum/reagent/wild_food/berries/red/on_mob_life(mob/living/M)
	M.adjustBruteLoss(-0.02, 0)
	M.adjustToxLoss(0.01, 0)
	M.nutrition += 1
	var/mob/living/carbon/human/H = M
	if(H.vessel.get_reagent_amount("blood") < BLOOD_VOLUME_NORMAL)
		H.vessel.add_reagent("blood", 0.2)
	. = 1
	..()


////////////////////ќ–јЌ∆≈¬џ≈ я√ќƒџ\\\\\\\\\\\\\\\\\\\\

/obj/item/weapon/reagent_containers/food/snacks/wild/berries/orange
	name = "orange berries"
	desc = "Some sort of strange orange berries. You don't think that those are edible."
	desc_ru = " акие-то странные €годы оранжевого цвета. Ќе думаю, что стоит их пробовать."
	icon_state = "berries_orange"
	list_reagents = list("orange_berries" = 2)

/datum/reagent/wild_food/berries/orange
	name = "Orange berries"
	id = "orange_berries"

/datum/reagent/wild_food/berries/orange/on_mob_life(mob/living/M)
	M.adjustFireLoss(-0.02, 0)
	M.adjustToxLoss(0.01, 0)
	M.nutrition += 1
	. = 1
	..()


////////////////////—»Ќ»≈ я√ќƒџ\\\\\\\\\\\\\\\\\\\\

/obj/item/weapon/reagent_containers/food/snacks/wild/berries/blue
	name = "blue berries"
	desc = "Some sort of strange blue berries. You don't think that those are edible."
	desc_ru = " акие-то странные €годы синего цвета. Ќе думаю, что стоит их пробовать."
	icon_state = "berries_blue"
	list_reagents = list("blue_berries" = 2)

/datum/reagent/wild_food/berries/blue
	name = "Blue berries"
	id = "blue_berries"

/datum/reagent/wild_food/berries/blue/on_mob_life(mob/living/M)
	M.dizziness = 0
	M.drowsyness = 0
	M.slurring = 0
	M.confused = 0
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.adjustEnduranceLoss(2)
	. = 1
	..()

////////////////////«≈Ћ≈Ќџ≈ я√ќƒџ\\\\\\\\\\\\\\\\\\\\

/obj/item/weapon/reagent_containers/food/snacks/wild/berries/green
	name = "green berries"
	desc = "Some sort of strange green berries. You don't think that those are edible."
	desc_ru = " акие-то странные €годы зеленого цвета. Ќе думаю, что стоит их пробовать."
	icon_state = "berries_green"
	list_reagents = list("green_berries" = 2)
	light_range = 2
	light_power = 0.7
	light_color = rgb(30,160,0)
	var/in_storage = 0

/obj/item/weapon/reagent_containers/food/snacks/wild/berries/green/New()
	..()
	update_brightness()

/obj/item/weapon/reagent_containers/food/snacks/wild/berries/green/proc/update_brightness()
	if(in_storage)
		light_range = 0
		set_light()
	else
		light_range = initial(light_range)
		set_light()

/datum/reagent/wild_food/berries/green
	name = "Green berries"
	id = "green_berries"

/datum/reagent/wild_fodd/berries/green/on_mob_life(mob/living/M)
	M.adjustToxLoss(-0.03, 0)
	var/mob/living/carbon/human/H = M
	H.vessel.remove_reagent("blood", 0.3)
	. = 1
	..()


////////////////////Ѕ≈Ћџ≈ я√ќƒџ\\\\\\\\\\\\\\\\\\\\

/obj/item/weapon/reagent_containers/food/snacks/wild/berries/white
	name = "white berries"
	desc = "Some sort of strange white berries. You don't think that those are edible."
	desc_ru = " акие-то странные €годы белого цвета. Ќе думаю, что стоит их пробовать."
	icon_state = "berries_white"
	list_reagents = list("white_berries" = 2)

/datum/reagent/wild_food/berries/white
	name = "White berries"
	id = "white_berries"

/datum/reagent/wild_food/berries/white/on_mob_life(mob/living/M)
	M.hallucination += 3
	M.adjustToxLoss(0.02, 0)
	. = 1
	..()


////////////////////„ќ–Ќџ≈ я√ќƒџ\\\\\\\\\\\\\\\\\\\\

/obj/item/weapon/reagent_containers/food/snacks/wild/berries/black
	name = "black berries"
	desc = "Some sort of strange black berries. You don't think that those are edible."
	desc_ru = " акие-то странные €годы черного цвета. Ќе думаю, что стоит их пробовать."
	icon_state = "berries_black"
	list_reagents = list("black_berries" = 2)

/datum/reagent/wild_food/berries/black
	name = "Black berries"
	id = "black_berries"
	metabolization_rate = 2

/datum/reagent/wild_food/berries/black/on_mob_life(mob/living/M)
	M.status_flags |= GOTTAGOFAST
	. = 1
	..()


/obj/item/weapon/reagent_containers/food/snacks/wild/afterattack(obj/target, mob/user , proximity)
	if(target.is_open_container()) //Something like a glass. Player probably wants to transfer TO it.
		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			user << user.client.select_lang("<span class='warning'>®мкость заполнена.</span>","<span class='warning'>[target] is full.</span>")
			return
		user << user.client.select_lang("<span class='notice'>¬ы положили [src] в [target].</span>","<span class='notice'>You put [src] in the [target].</span>")
		reagents.trans_to(target, 100)
		qdel(src)
	..()


////////////////////–≈ј ÷»» я√ќƒ ƒ–”√ — ƒ–”√ќћ\\\\\\\\\\\\\\\\\\\\0

/datum/reagent/wild_food/reactions
	name = "strange substance"
	metabolization_rate = 0.2

/datum/chemical_reaction/wild_food
	name = "strange substance"

//////////////////// расные с оранжевыми\\\\\\\\\\\\\\\\\\\\1

/datum/reagent/wild_food/reactions/red_orange
	id = "red_orange"

/datum/reagent/wild_food/reactions/red_orange/on_mob_life(mob/living/M)
	M.adjustBruteLoss(-0.02, 0)
	M.adjustFireLoss(-0.02, 0)
	M.adjustToxLoss(0.02, 0)
	M.nutrition += 1
	var/mob/living/carbon/human/H = M
	if(H.vessel.get_reagent_amount("blood") < BLOOD_VOLUME_NORMAL)
		H.vessel.add_reagent("blood", 0.1)
	. = 1
	..()

/datum/chemical_reaction/wild_food/red_orange
	id = "red_orange"
	result = list("red_orange" = 2)
	required_reagents = list("red_berries" = 1, "orange_berries" = 1)

//////////////////// расные с зелеными\\\\\\\\\\\\\\\\\\\\2

/datum/reagent/wild_food/reactions/red_green
	id = "red_green"

/datum/reagent/wild_food/reactions/red_green/on_mob_life(mob/living/M)
	M.adjustBruteLoss(-0.02, 0)
	M.nutrition += 1
	var/mob/living/carbon/human/H = M
	if(H.vessel.get_reagent_amount("blood") < BLOOD_VOLUME_NORMAL)
		H.vessel.add_reagent("blood", 0.2)
	. = 1
	..()

/datum/chemical_reaction/wild_food/red_green
	id = "red_green"
	result = list("red_green" = 2)
	required_reagents = list("red_berries" = 1, "green_berries" = 1)

////////////////////ќранжевые с зелеными\\\\\\\\\\\\\\\\\\\\3

/datum/reagent/wild_food/reactions/orange_green
	id = "orange_green"

/datum/reagent/wild_food/reactions/orange_green/on_mob_life(mob/living/M)
	M.adjustFireLoss(-0.02, 0)
	M.nutrition += 1
	. = 1
	..()

/datum/chemical_reaction/wild_food/orange_green
	id = "orange_green"
	result = list("orange_green" = 2)
	required_reagents = list("orange_berries" = 1, "green_berries" = 1)

////////////////////Ѕелые с зелеными\\\\\\\\\\\\\\\\\\\\4

/datum/reagent/wild_food/reactions/white_green
	id = "white_green"

/datum/reagent/wild_food/reactions/white_green/on_mob_life(mob/living/M)
	M.hallucination += 3
	. = 1
	..()

/datum/chemical_reaction/wild_food/white_green
	id = "white_green"
	result = list("white_green" = 2)
	required_reagents = list("white_berries" = 1, "green_berries" = 1)

//////////////////// расные с оранжевыми и с зелеными\\\\\\\\\\\\\\\\\\\\5

/datum/reagent/wild_food/reactions/red_orange_green
	id = "red_orange_green"
	metabolization_rate = 0.4

/datum/reagent/wild_food/reactions/red_orange_green/on_mob_life(mob/living/M)
	M.adjustBruteLoss(-0.02, 0)
	M.adjustFireLoss(-0.02, 0)
	var/mob/living/carbon/human/H = M
	if(H.vessel.get_reagent_amount("blood") < BLOOD_VOLUME_NORMAL)
		H.vessel.add_reagent("blood", 0.2)
	. = 1
	..()

/datum/chemical_reaction/wild_food/red_orange_green
	id = "red_orange_green"
	result = list("red_orange_green" = 2)
	required_reagents = list("red_green" = 1, "orange_green" = 1)

/datum/chemical_reaction/wild_food/red_orange_green2
	id = "red_orange_green2"
	result = list("red_orange_green" = 2)
	required_reagents = list("red_orange" = 1, "green_berries" = 1)

//////////////////// расные с черными\\\\\\\\\\\\\\\\\\\\6

/datum/reagent/wild_food/reactions/red_black
	id = "red_black"
	metabolization_rate = 0.5

/datum/reagent/wild_food/reactions/red_black/on_mob_life(mob/living/M)
	M.adjustBruteLoss(-0.1, 0)
	M.adjustToxLoss(0.1, 0)
	M.nutrition += 5
	var/mob/living/carbon/human/H = M
	if(H.vessel.get_reagent_amount("blood") < BLOOD_VOLUME_NORMAL)
		H.vessel.add_reagent("blood", 0.1)
	. = 1
	..()

/datum/chemical_reaction/wild_food/red_black
	id = "red_black"
	result = list("red_black" = 2)
	required_reagents = list("red_berries" = 1, "black_berries" = 1)

////////////////////ќранжевые с черными\\\\\\\\\\\\\\\\\\\\7

/datum/reagent/wild_food/reactions/orange_black
	id = "orange_black"
	metabolization_rate = 0.5

/datum/reagent/wild_food/reactions/orange_black/on_mob_life(mob/living/M)
	M.adjustFireLoss(-0.1, 0)
	M.adjustToxLoss(0.1, 0)
	M.nutrition += 5
	. = 1
	..()

/datum/chemical_reaction/wild_food/orange_black
	id = "orange_black"
	result = list("orange_black" = 2)
	required_reagents = list("orange_berries" = 1, "black_berries" = 1)

////////////////////«еленые с черными\\\\\\\\\\\\\\\\\\\\8

/datum/reagent/wild_food/reactions/green_black
	id = "green_black"
	metabolization_rate = 0.5

/datum/reagent/wild_food/reactions/green_black/on_mob_life(mob/living/M)
	M.adjustToxLoss(-0.125, 0)
	. = 1
	..()

/datum/chemical_reaction/wild_food/green_black
	id = "green_black"
	result = list("green_black" = 2)
	required_reagents = list("green_berries" = 1, "black_berries" = 1)

////////////////////Ѕелые с черными\\\\\\\\\\\\\\\\\\\\9

/datum/reagent/wild_food/reactions/white_black
	id = "white_black"
	metabolization_rate = 0.5

/datum/reagent/wild_food/reactions/white_black/on_mob_life(mob/living/M)
	M.hallucination += 30
	M.adjustToxLoss(0.1, 0)
	. = 1
	..()

/datum/chemical_reaction/wild_food/white_black
	id = "white_black"
	result = list("white_black" = 2)
	required_reagents = list("white_berries" = 1, "black_berries" = 1)

////////////////////—иние с черными\\\\\\\\\\\\\\\\\\\\10

/datum/reagent/wild_food/berries/blue_black
	id = "blue_black"

/datum/reagent/wild_food/berries/blue_black/on_mob_life(mob/living/M)		//—обсно то же, что и синие, лишь чуть усиленные, нужны в дальшейних рецептах
	M.dizziness = 0
	M.drowsyness = 0
	M.slurring = 0
	M.confused = 0
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.adjustEnduranceLoss(10)
	. = 1
	..()

/datum/chemical_reaction/wild_food/blue_black
	id = "blue_black"
	result = list("blue_black" = 2)
	required_reagents = list("blue_berries" = 1, "black_berries" = 1)

////////////////////Ѕелые с черными с зелеными\\\\\\\\\\\\\\\\\\\\11

/datum/reagent/wild_food/reactions/white_black_green
	id = "white_black_green"
	metabolization_rate = 0.5

/datum/reagent/wild_food/reactions/white_black_green/on_mob_life(mob/living/M)
	M.hallucination += 30
	. = 1
	..()

/datum/chemical_reaction/wild_food/white_black_green
	id = "white_black_green"
	result = list("white_black_green" = 2)
	required_reagents = list("white_black" = 1, "green_berries" = 1)


/datum/chemical_reaction/wild_food/white_black_green2
	id = "white_black_green2"
	result = list("white_black_green" = 2)
	required_reagents = list("white_green" = 1, "black_berries" = 1)

/datum/chemical_reaction/wild_food/white_black_green3
	id = "white_black_green3"
	result = list("white_black_green" = 2)
	required_reagents = list("green_black" = 1, "white_berries" = 1)

//////////////////// расные с оранжевыми и с зелеными и еще и с черным\\\\\\\\\\\\\\\\\\\\12

/datum/reagent/wild_food/reactions/red_orange_green_black
	id = "red_orange_green_black"
	metabolization_rate = 1

/datum/reagent/wild_food/reactions/red_orange_green_black/on_mob_life(mob/living/M)
	M.adjustBruteLoss(-2, 0)
	M.adjustFireLoss(-2, 0)
	var/mob/living/carbon/human/H = M
	if(H.vessel.get_reagent_amount("blood") < BLOOD_VOLUME_NORMAL)
		H.vessel.add_reagent("blood", 0.5)
	. = 1
	..()

/datum/chemical_reaction/wild_food/red_orange_green_black
	id = "red_orange_green_black"
	result = list("red_orange_green_black" = 1)
	required_reagents = list("red_orange_green" = 1, "black_berries" = 1)

/datum/chemical_reaction/wild_food/red_orange_green_black2
	id = "red_orange_green_black2"
	result = list("red_orange_green_black" = 3)
	required_reagents = list("red_black" = 1, "orange_black" = 1, "green_black" = 1)

/datum/chemical_reaction/wild_food/red_orange_green_black3
	id = "red_orange_green_black3"
	result = list("red_orange_green_black" = 1)
	required_reagents = list("red_orange" = 1, "green_black" = 1)

////////////////////„ерные с вод€рой\\\\\\\\\\\\\\\\\\\\13

/datum/reagent/consumable/ethanol/boosted_vodka
	name = "Vodka"
	id = "boosted_vodka"
	boozepwr = 45

/datum/reagent/consumable/ethanol/boosted_vodka/on_mob_life(mob/living/M)
	M.adjustToxLoss(-0.21, 0)
	..()
	. = 1

/datum/chemical_reaction/wild_food/boosted_vodka
	id = "boosted_vodka"
	result = list("boosted_vodka" = 5)
	required_reagents = list("green_black" = 2, "vodka" = 5)

////////////////////—амогонка из €год\\\\\\\\\\\\\\\\\\\\14

/datum/reagent/consumable/ethanol/berries_moonshine
	name = "Moonshine"
	id = "berries_moonshine"
	boozepwr = 70

/datum/reagent/consumable/ethanol/berries_moonshine/on_mob_life(mob/living/M)
	M.nutrition += 1
	M.adjustToxLoss(-0.05, 0)
	..()
	. = 1

/datum/chemical_reaction/wild_food/berries_moonshine
	id = "berries_moonshine"
	result = list("berries_moonshine" = 10)
	required_reagents = list("water" = 10, "white_black_green" = 1)

////////////////////—амогонка из €год, меньша€ доза алкогол€\\\\\\\\\\\\\\\\\\\\15

/datum/reagent/consumable/ethanol/berries_moonshine_less
	name = "Moonshine"
	id = "berries_moonshine_less"
	boozepwr = 20

/datum/reagent/consumable/ethanol/berries_moonshine_less/on_mob_life(mob/living/M)
	M.nutrition += 1
	M.adjustToxLoss(-0.05, 0)
	..()
	. = 1

/datum/chemical_reaction/wild_food/berries_moonshine_less
	id = "berries_moonshine_less"
	result = list("berries_moonshine_less" = 10)
	required_reagents = list("berries_moonshine" = 10, "blue_black" = 1)

////////////////////яд из вод€ры и €год\\\\\\\\\\\\\\\\\\\\16

/datum/reagent/wild_food/berries/vodka_poison
	id = "vodka_poison"
	metabolization_rate = 1

/datum/reagent/wild_food/berries/vodka_poison/on_mob_life(mob/living/M)
	M.adjustToxLoss(5, 0)
	..()
	. = 1

/datum/chemical_reaction/wild_food/vodka_posion
	id = "vodka_poison"
	result = list("vodka" = 15, "vodka_posion" = 5)
	required_reagents = list("vodka" = 20, "white_berries" = 2)

/datum/chemical_reaction/wild_food/vodka_posion_n					//”бираем €д добавлением усиленных синих €год
	id = "vodka_poison_n"
	result = list("vodka" = 30)
	required_reagents = list("vodka_poison" = 30, "blue_black" = 1)
