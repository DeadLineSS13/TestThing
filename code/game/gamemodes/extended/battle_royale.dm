/datum/game_mode/battle_royale
	name = "Battle Royale"
	config_tag = "battle_royale"
	required_players = 0
	announce_text = "<b>Fortnite was a mistake.</b>"

/datum/game_mode/battle_royale/pre_setup()
	SSbr_zone.ON = 1
	SStext.ON = 0
	return 1

/datum/game_mode/battle_royale/post_setup()
	SSbr_zone.Initialize()
	..()