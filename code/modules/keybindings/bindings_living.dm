/mob/living/key_down(_key, client/user)
	switch(_key)
		if("B")
			if(user.keys_held["Ctrl"])
				lay_down()
				return
			resist()
			return

	return ..()