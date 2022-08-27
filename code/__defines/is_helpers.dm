// simple is_type and similar inline helpers

#define islist(L) (istype(L,/list))

#define in_range(source, user) (get_dist(source, user) <= 1)

#define ismovableatom(A) (istype(A, /atom/movable))

#define isatom(A) (isloc(A))

#define isweakref(D) (istype(D, /datum/weakref))

#define isitem(A) (istype(A, /obj/item))

// MOB HELPERS

#define ishuman(A) (istype(A, /mob/living/carbon/human))

#define isanimal(A) (istype(A, /mob/living/simple_animal))

#define ishostile(A) (istype(A, /mob/living/simple_animal/hostile))

#define iscarbon(A) (istype(A, /mob/living/carbon))

#define isliving(A) (istype(A, /mob/living))

#define isobserver(A) (istype(A, /mob/dead/observer))

#define isnewplayer(A) (istype(A, /mob/new_player))

#define islimb(A) (istype(A, /obj/item/organ/limb))

// STALKER

#define isvodka(I) (istype(I, /obj/item/weapon/reagent_containers/food/drinks/vodka))

#define isaffected(I) (istype(I, /obj/item/weapon/stalker/bolt) || istype(I, /obj/item/ammo_casing))