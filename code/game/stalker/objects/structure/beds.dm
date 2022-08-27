/obj/structure/bed/stalker
	icon = 'icons/stalker/structure/decor.dmi'
	flags = NODECONSTRUCT
	layer = 3.1

/obj/structure/bed/stalker/metal
	name = "bed"
	name_ru = "кровать"
	desc = "An ordinary metal bed without a mattress, not too comfortable to sleep."
	desc_ru = "ќбычна€ металлическа€ кровать без матраса, не слишком удобна€ дл€ сна."
	icon_state = "krovat_e"

/obj/structure/bed/stalker/metal/matras
	desc = "An ordinary metal bed with a mattress, comfort during sleep is provided."
	desc_ru = "ќбычна€ металлическа€ кровать с матрасом, комфорт во врем€ сна обеспечен."
	icon_state = "krovat1"

/obj/structure/bed/stalker/metal/matras/Initialize()
	..()
	icon_state = "krovat[rand(1,4)]"

/obj/structure/bed/stalker/matras
	name = "matras"
	name_ru = "матрас"
	desc = "Common spring mattress of average comfort."
	desc_ru = "ќбычный пружинный матрас средней комфортабельности."
	icon_state = "matras1"

/obj/structure/bed/stalker/matras/Initialize()
	..()
	icon_state = "matras[rand(1,2)]"

/obj/structure/bed/stalker/post_buckle_mob(mob/living/M)
	if(M in buckled_mob)
		switch(dir)
			if(1)
				M.pixel_x = 2
				M.pixel_y = -1
			if(2)
				M.pixel_x = 2
				M.pixel_y = 4
	else
		M.pixel_x = initial(M.pixel_x)
		M.pixel_y = initial(M.pixel_y)

/obj/structure/stalker/matras
	name = "matras"
	name_ru = "матрас"
	desc = "Rolled-up matress. With difficulty, but sometimes can replace the pillow."
	desc_ru = "—вернутый матрас. — трудом, но иногда может замен€ть подушку."
	icon_state = "s_matras"
	density = 0
	pixel_x = -11
	layer = 3.1

/obj/structure/stalker/brokenbed
	name = "broken bed"
	name_ru = "сломанна€ кровать"
	desc = "Broken metal bed. You can't sleep on it anymore."
	desc_ru = "—ломанна€ металлическа€ кровать. Ќа ней уже не поспишь."
	icon_state = "krovat_s"

/obj/structure/bed/chair/stalker
	icon = 'icons/stalker/structure/decor.dmi'
	flags = NODECONSTRUCT
	layer = 3.1

/obj/structure/bed/chair/stalker/brevno
	name = "log"
	name_ru = "бревно"
	desc = "The usual log on which you can sit."
	desc_ru = "ќбычное бревно, на котором можно сидеть."
	icon = 'icons/stalker/structure/decor.dmi'
	icon_state = "log1"

/obj/structure/bed/chair/stalker/brevno/log2
	icon_state = "log2"

/obj/structure/bed/chair/stalker/matras
	name = "matras"
	name_ru = "матрас"
	desc = "Common spring mattress of average comfort."
	desc_ru = "ќбычный пружинный матрас средней комфортабельности."
	icon = 'icons/stalker/structure/decor.dmi'
	icon_state = "matras1"

/obj/structure/bed/chair/stalker/matras/Initialize()
	..()
	icon_state = "matras[rand(1,2)]"

/obj/structure/bed/stalker/metal
	name = "bed"
	name_ru = "кровать"
	desc = "An ordinary metal bed without a mattress, not too comfortable to sleep."
	desc_ru = "ќбычна€ металлическа€ кровать без матраса, не слишком удобна€ дл€ сна."
	icon = 'icons/stalker/structure/decor.dmi'
	icon_state = "krovat_e"

/obj/structure/bed/stalker/metal/matras
	desc = "An ordinary metal bed with a mattress, comfort during sleep is provided."
	desc_ru = "ќбычна€ металлическа€ кровать с матрасом, комфорт во врем€ сна обеспечен."
	icon_state = "krovat"

/obj/structure/bed/chair/stalker/divan
	name = "sofa"
	name_ru = "диван"
	desc = "Old worn-out couch. Some places dirty, some places have holes - but you still can sit on it."
	desc_ru = "—тарый изношенный диван. ћестами запачканный, местами дыр€вый - но сидеть на нЄм все же можно."
	icon_state = "divan"

/obj/structure/bed/chair/stalker/divan/divan2
	icon_state = "divan2"
