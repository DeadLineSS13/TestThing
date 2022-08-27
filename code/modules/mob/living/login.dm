/mob/living/Login()
	..()
	//Mind updates
	sync_mind()
//	mind.show_memory(src, 0)

	//Round specific stuff
//	if(ticker && ticker.mode)
//		switch(ticker.mode.name)
//			if("sandbox")
//				CanBuild()

	update_damage_hud()

	update_interface()
	return .
