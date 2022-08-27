/datum/game_mode/extended
	name = "extended"
	config_tag = "extended"
	required_players = 0
	announce_text = "<B>Sun of Chernobyl rose above the horizon.</B>"
	//reroll_friendly = 1

/datum/game_mode/extended/pre_setup()
	return 1

/datum/game_mode/extended/post_setup()
	..()