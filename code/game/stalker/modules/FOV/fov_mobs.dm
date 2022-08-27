/mob/living/carbon/Move()
	. = ..()
	if(client && src.screens["fov"])
		src.screens["fov"].dir = src.dir
		client.fovProcess()
/mob/living/carbon/forceMove()
	. = ..()
	if(client && src.screens["fov"])
		src.screens["fov"].dir = src.dir
		client.fovProcess()
/mob/living/carbon/face_atom()
	. = ..()
	if(client && src.screens["fov"])
		src.screens["fov"].dir = src.dir
		client.fovProcess()

/mob/living/carbon/eastface()
	..()
	if(client && src.screens["fov"])
		src.screens["fov"].dir = src.dir
		client.fovProcess()
	return 1

/mob/living/carbon/westface()
	..()
	if(client && src.screens["fov"])
		src.screens["fov"].dir = src.dir
		client.fovProcess()
	return 1

/mob/living/carbon/northface()
	..()
	if(client && src.screens["fov"])
		src.screens["fov"].dir = src.dir
		client.fovProcess()
	return 1


/mob/living/carbon/southface()
	..()
	if(client && src.screens["fov"])
		src.screens["fov"].dir = src.dir
		client.fovProcess()
	return 1