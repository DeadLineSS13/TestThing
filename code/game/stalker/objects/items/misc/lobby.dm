/obj/lobby
	name = ""
	icon = 'icons/stalker/lobby/lobby.dmi'
	icon_state = "lobby"
	layer = 20
	plane = 20
	screen_loc = "1,1"
	var/obj/lobby/overlay_image

/obj/lobby/MouseEntered(location,control,params)
	icon_state = "[icon_state]_overlay"

/obj/lobby/MouseExited()
	icon_state = initial(icon_state)

/obj/lobby/ded
	name = "Character Setup"
	icon_state = "ded"
	layer = 22

/obj/lobby/ded/Click()
	if(isnewplayer(usr))
		var/mob/new_player/NP = usr
		NP.client.prefs.ShowChoices(NP)

/obj/lobby/backpack
	name = "Loadout"
	icon_state = "backpack"
	layer = 21

/obj/lobby/backpack/Click()
	if(isnewplayer(usr))
		var/mob/new_player/NP = usr
		NP.client.loadout.show_loadout(NP)

/obj/lobby/forest
	name = "Join Game"
	icon_state = "forest"
	layer = 21

/obj/lobby/forest/Click()
	if(isnewplayer(usr))
		var/mob/new_player/NP = usr
		NP.late_join()

/obj/lobby/moon
	name = ""
	icon_state = "moon"
	layer = 22

/obj/lobby/moon/Click()
	if(isnewplayer(usr))
		var/mob/new_player/NP = usr
		if(NP.client && NP.client.holder)
			if(alert(NP,"Are you sure you wish to observe? You will not be able to play this round!","Player Setup","Yes","No") == "Yes")
				if(!NP.client)	return 1
				var/mob/dead/observer/observer = new()

				NP.spawning = 1

				observer.started_as_observer = 1
				NP.close_spawn_windows()
				var/obj/O = locate("landmark*Observer-Start")
				src << "<span class='notice'>Now teleporting.</span>"
				if (O)
					observer.loc = O.loc
				else
					src << "<span class='notice'>Teleporting failed. You should be able to use ghost verbs to teleport somewhere useful</span>"
				if(NP.client.prefs.be_random_name)
					NP.client.prefs.real_name = random_unique_name(NP.gender)
				if(NP.client.prefs.be_random_body)
					NP.client.prefs.random_character(gender)
				observer.real_name = NP.client.prefs.real_name
				observer.name = observer.real_name
				observer.key = NP.key
				observer.stopLobbySound()
				qdel(NP.mind)

				qdel(NP)
				return 1