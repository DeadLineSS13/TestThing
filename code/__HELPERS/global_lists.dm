//////////////////////////
/////Initial Building/////
//////////////////////////

/proc/make_datum_references_lists()
	//hair
	init_sprite_accessory_subtypes(/datum/sprite_accessory/hair, GLOB.hair_styles_list, GLOB.hair_styles_male_list, GLOB.hair_styles_female_list)
	GLOB.hair_styles_list				= sortList(GLOB.hair_styles_list)
	GLOB.hair_styles_male_list			= sortList(GLOB.hair_styles_male_list)
	GLOB.hair_styles_female_list			= sortList(GLOB.hair_styles_female_list)
	//facial hair
	init_sprite_accessory_subtypes(/datum/sprite_accessory/facial_hair, GLOB.facial_hair_styles_list, GLOB.facial_hair_styles_male_list, GLOB.facial_hair_styles_female_list)
	GLOB.facial_hair_styles_list 		= sortList(GLOB.facial_hair_styles_list)
	GLOB.facial_hair_styles_male_list	= sortList(GLOB.facial_hair_styles_male_list)
	GLOB.facial_hair_styles_female_list	= sortList(GLOB.facial_hair_styles_female_list)
	//hair color
	init_hair_color_subtypes(/datum/hair_color, GLOB.hair_colors_list)
	GLOB.hair_colors_list				= sortList(GLOB.hair_colors_list)
	init_hair_color_subtypes_normal(/datum/hair_color, GLOB.hair_colors_list_normal)
	GLOB.hair_colors_list_normal				= sortList(GLOB.hair_colors_list_normal)
	init_hair_color_subtypes_donate(/datum/hair_color, GLOB.hair_colors_list_donate)
	GLOB.hair_colors_list_donate				= sortList(GLOB.hair_colors_list_donate)
	//underwear
	init_sprite_accessory_subtypes(/datum/sprite_accessory/underwear, GLOB.underwear_list, GLOB.underwear_m, GLOB.underwear_f)
	GLOB.underwear_list					= sortList(GLOB.underwear_list)
	GLOB.underwear_m						= sortList(GLOB.underwear_m)
	GLOB.underwear_f						= sortList(GLOB.underwear_f)
	//undershirt
	init_sprite_accessory_subtypes(/datum/sprite_accessory/undershirt, GLOB.undershirt_list, GLOB.undershirt_m, GLOB.undershirt_f)
	GLOB.undershirt_list					= sortList(GLOB.undershirt_list)
	GLOB.undershirt_m					= sortList(GLOB.undershirt_m)
	GLOB.undershirt_f					= sortList(GLOB.undershirt_f)
	//socks
	init_sprite_accessory_subtypes(/datum/sprite_accessory/socks, GLOB.socks_list)
	GLOB.socks_list						= sortList(GLOB.socks_list)
	//education
	init_traits_subtypes(/datum/traits/education, GLOB.education_list)
	GLOB.education_list					= sortList(GLOB.education_list)
	//profession
	init_traits_subtypes(/datum/traits/profession, GLOB.profession_list)
	GLOB.profession_list					= sortList(GLOB.profession_list)
	//lifestyle
	init_traits_subtypes(/datum/traits/lifestyle, GLOB.lifestyle_list)
	GLOB.lifestyle_list					= sortList(GLOB.lifestyle_list)
	//trait
	init_traits_subtypes(/datum/traits/trait, GLOB.trait_list)
	GLOB.trait_list					= sortList(GLOB.trait_list)
	//uniform
	init_subtypes(/obj/item/clothing/under/color/switer/stalker, GLOB.available_uniform)
	GLOB.available_uniform			= sortList(GLOB.available_uniform)


//	init_subtypes(/datum/table_recipe, table_recipes)

/* // Uncomment to debug chemical reaction list.
/client/verb/debug_chemical_list()

	for (var/reaction in chemical_reactions_list)
		. += "chemical_reactions_list\[\"[reaction]\"\] = \"[chemical_reactions_list[reaction]]\"\n"
		if(islist(chemical_reactions_list[reaction]))
			var/list/L = chemical_reactions_list[reaction]
			for(var/t in L)
				. += "    has: [t]\n"
	world << .
*/

//creates every subtype of prototype (excluding prototype) and adds it to list L.
//if no list/L is provided, one is created.
/proc/init_subtypes(prototype, list/L)
	if(!istype(L))	L = list()
	for(var/path in subtypesof(prototype))
		L += new path()
	return L

//returns a list of paths to every subtype of prototype (excluding prototype)
//if no list/L is provided, one is created.
/proc/init_paths(prototype, list/L)
	if(!istype(L))
		L = list()
		for(var/path in subtypesof(prototype))
			L+= path
		return L
