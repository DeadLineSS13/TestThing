
/client
		//////////////////////
		//BLACK MAGIC THINGS//
		//////////////////////
	parent_type = /datum
		////////////////
		//ADMIN THINGS//
		////////////////
	var/datum/admins/holder = null
	var/buildmode		= 0
	var/AI_Interact		= 0

	var/jobbancache = null //Used to cache this client's jobbans to save on DB queries
	var/last_message	= "" //Contains the last message sent by this client - used to protect against copy-paste spamming.
	var/last_message_count = 0 //contins a number of how many times a message identical to last_message was sent.

		/////////
		//OTHER//
		/////////
	var/datum/preferences/prefs = null
	var/datum/loadout/loadout = null
	var/move_delay			= 1
	var/moving				= null
	var/adminobs			= null
	var/area				= null

		///////////////
		//SOUND STUFF//
		///////////////
	var/ambience_playing= null
	var/played			= 0
	var/l_played		= 0

		////////////
		//SECURITY//
		////////////
	// comment out the line below when debugging locally to enable the options & messages menu
	control_freak = 1

		////////////////////////////////////
		//things that require the database//
		////////////////////////////////////
	var/player_age = "Requires database"	//So admins know why it isn't working - Used to determine how old the account is - in days.
	var/related_accounts_ip = "Requires database"	//So admins know why it isn't working - Used to determine what other accounts previously logged in from this ip
	var/related_accounts_cid = "Requires database"	//So admins know why it isn't working - Used to determine what other accounts previously logged in from this computer id


	var/global/obj/screen/click_catcher/void

	// Used by html_interface module.
	var/hi_last_pos


	//datum that controls the displaying and hiding of tooltips
	var/datum/tooltip/tooltips

	mouse_pointer_icon = 'icons/stalker/cursors.dmi'
	show_popup_menus = 0

//	preload_rsc = "https://rocld.com/n952x"
//	preload_rsc = "https://uc2d9fcdf3bdce160b782476896b.dl.dropboxusercontent.com/cd/0/get/Ab0a7WM_RstJTgwUNu4oAWqW9Bd8MLmbje4wHt9339xQSx6an-z1jTubVIrtYysXmy9_9hFSEE3m4Syi2X-rFiPirMpt5mDZXddbELCbNtdwBg/file#"
	preload_rsc = "https://s179vla.storage.yandex.net/rdisk/e7c365fa40aa53c9d4917ef9c50e1e6d0debc4f256b4e961fd52225653862eaa/5dd0120f/N9OlBfiPa-e8BElmAtIui5vlVKE2bce5GmQQSRqrc2o8oDmkmF6SczrIPoHrOvendX386vR1H6upayTAHjWTdQ==?uid=0&filename=roadside_picnic_rsc.zip&disposition=attachment&hash=66mChJ9UxJca9AocrflgoqDSBBTd2IODeAs9bt1XNx9ZPvkJJOo23UXLT%2B0lUQVhq/J6bpmRyOJonT3VoXnDag%3D%3D&limit=0&content_type=application%2Fzip&owner_uid=287721019&fsize=231453647&hid=abff612940f997f77b38b9e7a21b057c&media_type=compressed&tknv=v2&rtoken=iJBpbklSKr5p&force_default=no&ycrid=na-1207a358dc8ef2108627156ef2ae9d84-downloader2f&ts=59778278d61c0&s=89bbbd82772de29dded2c002f2f1301f49333675ba2cdcecbe8a7e35570d9b27&pb=U2FsdGVkX1_HNaqPX6KxA5YiJO_TQgaWcFFOl0tCr1gSnERf2BFaIHsEhJJynA3P9g40cgVeh_X-acGcAsPm7Cq5ukxAqVaaA6lRb02A97c"

	var/connection_time //world.time they connected
	var/connection_realtime //world.realtime they connected
	var/connection_timeofday //world.timeofday they connected

	var/inprefs = FALSE
	var/list/topiclimiter
	var/list/clicklimiter

	var/datum/chatOutput/chatOutput
