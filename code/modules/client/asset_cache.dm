/*
Asset cache quick users guide:

Make a datum at the bottom of this file with your assets for your thing.
The simple subsystem will most like be of use for most cases.
Then call get_asset_datum() with the type of the datum you created and store the return
Then call .send(client) on that stored return value.

You can set verify to TRUE if you want send() to sleep until the client has the assets.
*/


// Amount of time(ds) MAX to send per asset, if this get exceeded we cancel the sleeping.
// This is doubled for the first asset, then added per asset after
#define ASSET_CACHE_SEND_TIMEOUT 7

//When sending mutiple assets, how many before we give the client a quaint little sending resources message
#define ASSET_CACHE_TELL_CLIENT_AMOUNT 8

//When passively preloading assets, how many to send at once? Too high creates noticable lag where as too low can flood the client's cache with "verify" files
#define ASSET_CACHE_PRELOAD_CONCURRENT 3

/client
	var/list/cache = list() // List of all assets sent to this client by the asset cache.
	var/list/completed_asset_jobs = list() // List of all completed jobs, awaiting acknowledgement.
	var/list/sending = list()
	var/last_asset_job = 0 // Last job done.

//This proc sends the asset to the client, but only if it needs it.
//This proc blocks(sleeps) unless verify is set to false
/proc/send_asset(var/client/client, var/asset_name, var/verify = TRUE)
	if(!istype(client))
		if(ismob(client))
			var/mob/M = client
			if(M.client)
				client = M.client

			else
				return 0

		else
			return 0

	if(client.cache.Find(asset_name) || client.sending.Find(asset_name))
		return 0

//	log_asset("Sending asset [asset_name] to client [client]")
	client << browse_rsc(SSassets.cache[asset_name], asset_name)
	if(!verify)
		client.cache += asset_name
		return 1

	client.sending |= asset_name
	var/job = ++client.last_asset_job

	client << browse({"
	<script>
		window.location.href="?asset_cache_confirm_arrival=[job]"
	</script>
	"}, "window=asset_cache_browser")

	var/t = 0
	var/timeout_time = (ASSET_CACHE_SEND_TIMEOUT * client.sending.len) + ASSET_CACHE_SEND_TIMEOUT
	while(client && !client.completed_asset_jobs.Find(job) && t < timeout_time) // Reception is handled in Topic()
		stoplag(1) // Lock up the caller until this is received.
		t++

	if(client)
		client.sending -= asset_name
		client.cache |= asset_name
		client.completed_asset_jobs -= job

	return 1

//This proc blocks(sleeps) unless verify is set to false
/proc/send_asset_list(var/client/client, var/list/asset_list, var/verify = TRUE)
	if(!istype(client))
		if(ismob(client))
			var/mob/M = client
			if(M.client)
				client = M.client

			else
				return 0

		else
			return 0

	var/list/unreceived = asset_list - (client.cache + client.sending)
	if(!unreceived || !unreceived.len)
		return 0
	if (unreceived.len >= ASSET_CACHE_TELL_CLIENT_AMOUNT)
		to_chat(client, "Sending Resources...")
	for(var/asset in unreceived)
		if (asset in SSassets.cache)
//			log_asset("Sending asset [asset] to client [client]")
			client << browse_rsc(SSassets.cache[asset], asset)

	if(!verify) // Can't access the asset cache browser, rip.
		client.cache += unreceived
		return 1

	client.sending |= unreceived
	var/job = ++client.last_asset_job

	client << browse({"
	<script>
		window.location.href="?asset_cache_confirm_arrival=[job]"
	</script>
	"}, "window=asset_cache_browser")

	var/t = 0
	var/timeout_time = ASSET_CACHE_SEND_TIMEOUT * client.sending.len
	while(client && !client.completed_asset_jobs.Find(job) && t < timeout_time) // Reception is handled in Topic()
		stoplag(1) // Lock up the caller until this is received.
		t++

	if(client)
		client.sending -= unreceived
		client.cache |= unreceived
		client.completed_asset_jobs -= job

	return 1

//This proc will download the files without clogging up the browse() queue, used for passively sending files on connection start.
//The proc calls procs that sleep for long times.
/proc/getFilesSlow(var/client/client, var/list/files, var/register_asset = TRUE)
	var/concurrent_tracker = 1
	for(var/file in files)
		if (!client)
			break
		if (register_asset)
			register_asset(file, files[file])
		if (concurrent_tracker >= ASSET_CACHE_PRELOAD_CONCURRENT)
			concurrent_tracker = 1
			send_asset(client, file)
		else
			concurrent_tracker++
			send_asset(client, file, verify=FALSE)

		stoplag(0) //queuing calls like this too quickly can cause issues in some client versions

//This proc "registers" an asset, it adds it to the cache for further use, you cannot touch it from this point on or you'll fuck things up.
//if it's an icon or something be careful, you'll have to copy it before further use.
/proc/register_asset(var/asset_name, var/asset)
	SSassets.cache[asset_name] = asset

//Generated names do not include file extention.
//Used mainly for code that deals with assets in a generic way
//The same asset will always lead to the same asset name
/proc/generate_asset_name(var/file)
	return "asset.[md5(fcopy_rsc(file))]"


//These datums are used to populate the asset cache, the proc "register()" does this.

//all of our asset datums, used for referring to these later
GLOBAL_LIST_EMPTY(asset_datums)

//get an assetdatum or make a new one
/proc/get_asset_datum(var/type)
	return GLOB.asset_datums[type] || new type()

/datum/asset
	var/_abstract = /datum/asset

/datum/asset/New()
	GLOB.asset_datums[type] = src
	register()

/datum/asset/proc/register()
	return

/datum/asset/proc/send(client)
	return


//If you don't need anything complicated.
/datum/asset/simple
	_abstract = /datum/asset/simple
	var/assets = list()
	var/verify = FALSE

/datum/asset/simple/register()
	for(var/asset_name in assets)
		register_asset(asset_name, assets[asset_name])

/datum/asset/simple/send(client)
	send_asset_list(client,assets,verify)


// For registering or sending multiple others at once
/datum/asset/group
	_abstract = /datum/asset/group
	var/list/children

/datum/asset/group/register()
	for(var/type in children)
		get_asset_datum(type)

/datum/asset/group/send(client/C)
	for(var/type in children)
		var/datum/asset/A = get_asset_datum(type)
		A.send(C)


// spritesheet implementation - coalesces various icons into a single .png file
// and uses CSS to select icons out of that file - saves on transferring some
// 1400-odd individual PNG files
#define SPR_SIZE 1
#define SPR_IDX 2
#define SPRSZ_COUNT 1
#define SPRSZ_ICON 2
#define SPRSZ_STRIPPED 3

/datum/asset/spritesheet
	_abstract = /datum/asset/spritesheet
	var/name
	var/list/sizes = list()    // "32x32" -> list(10, icon/normal, icon/stripped)
	var/list/sprites = list()  // "foo_bar" -> list("32x32", 5)
	var/verify = FALSE

/datum/asset/spritesheet/register()
	if (!name)
		CRASH("spritesheet [type] cannot register without a name")
	ensure_stripped()

	var/res_name = "spritesheet_[name].css"
	var/fname = "data/spritesheets/[res_name]"
	fdel(fname)
	text2file(generate_css(), fname)
	register_asset(res_name, fcopy_rsc(fname))
	fdel(fname)

	for(var/size_id in sizes)
		var/size = sizes[size_id]
		register_asset("[name]_[size_id].png", size[SPRSZ_STRIPPED])

/datum/asset/spritesheet/send(client/C)
	if (!name)
		return
	var/all = list("spritesheet_[name].css")
	for(var/size_id in sizes)
		all += "[name]_[size_id].png"
	send_asset_list(C, all, verify)

/datum/asset/spritesheet/proc/ensure_stripped(sizes_to_strip = sizes)
	for(var/size_id in sizes_to_strip)
		var/size = sizes[size_id]
		if (size[SPRSZ_STRIPPED])
			continue

		// save flattened version
		var/fname = "data/spritesheets/[name]_[size_id].png"
		fcopy(size[SPRSZ_ICON], fname)
//		var/error = rustg_dmi_strip_metadata(fname)
//		if(length(error))
//			stack_trace("Failed to strip [name]_[size_id].png: [error]")
		size[SPRSZ_STRIPPED] = icon(fname)
		fdel(fname)

/datum/asset/spritesheet/proc/generate_css()
	var/list/out = list()

	for (var/size_id in sizes)
		var/size = sizes[size_id]
		var/icon/tiny = size[SPRSZ_ICON]
		out += ".[name][size_id]{display:inline-block;width:[tiny.Width()]px;height:[tiny.Height()]px;background:url('[name]_[size_id].png') no-repeat;}"

	for (var/sprite_id in sprites)
		var/sprite = sprites[sprite_id]
		var/size_id = sprite[SPR_SIZE]
		var/idx = sprite[SPR_IDX]
		var/size = sizes[size_id]

		var/icon/tiny = size[SPRSZ_ICON]
		var/icon/big = size[SPRSZ_STRIPPED]
		var/per_line = big.Width() / tiny.Width()
		var/x = (idx % per_line) * tiny.Width()
		var/y = round(idx / per_line) * tiny.Height()

		out += ".[name][size_id].[sprite_id]{background-position:-[x]px -[y]px;}"

	return out.Join("\n")

/datum/asset/spritesheet/proc/Insert(sprite_name, icon/I, icon_state="", dir=SOUTH, frame=1, moving=FALSE)
	I = icon(I, icon_state=icon_state, dir=dir, frame=frame, moving=moving)
	if (!I || !length(icon_states(I)))  // that direction or state doesn't exist
		return
	var/size_id = "[I.Width()]x[I.Height()]"
	var/size = sizes[size_id]

	if (sprites[sprite_name])
		CRASH("duplicate sprite \"[sprite_name]\" in sheet [name] ([type])")

	if (size)
		var/position = size[SPRSZ_COUNT]++
		var/icon/sheet = size[SPRSZ_ICON]
		size[SPRSZ_STRIPPED] = null
		sheet.Insert(I, icon_state=sprite_name)
		sprites[sprite_name] = list(size_id, position)
	else
		sizes[size_id] = size = list(1, I, null)
		sprites[sprite_name] = list(size_id, 0)

/datum/asset/spritesheet/proc/InsertAll(prefix, icon/I, list/directions)
	if (length(prefix))
		prefix = "[prefix]-"

	if (!directions)
		directions = list(SOUTH)

	for (var/icon_state_name in icon_states(I))
		for (var/direction in directions)
			var/prefix2 = (directions.len > 1) ? "[dir2text(direction)]-" : ""
			Insert("[prefix][prefix2][icon_state_name]", I, icon_state=icon_state_name, dir=direction)

/datum/asset/spritesheet/proc/css_tag()
	return {"<link rel="stylesheet" href="spritesheet_[name].css" />"}

/datum/asset/spritesheet/proc/icon_tag(sprite_name)
	var/sprite = sprites[sprite_name]
	if (!sprite)
		return null
	var/size_id = sprite[SPR_SIZE]
	return {"<span class="[name][size_id] [sprite_name]"></span>"}

#undef SPR_SIZE
#undef SPR_IDX
#undef SPRSZ_COUNT
#undef SPRSZ_ICON
#undef SPRSZ_STRIPPED


//DEFINITIONS FOR ASSET DATUMS START HERE.


/datum/asset/simple/tgui
	assets = list(
		"tgui.css"	= 'tgui/assets/tgui.css',
		"tgui.js"	= 'tgui/assets/tgui.js'
	)

/datum/asset/simple/pda
	assets = list(
		"pda_atmos.png"			= 'icons/pda_icons/pda_atmos.png',
		"pda_back.png"			= 'icons/pda_icons/pda_back.png',
		"pda_bell.png"			= 'icons/pda_icons/pda_bell.png',
		"pda_blank.png"			= 'icons/pda_icons/pda_blank.png',
		"pda_boom.png"			= 'icons/pda_icons/pda_boom.png',
		"pda_bucket.png"		= 'icons/pda_icons/pda_bucket.png',
		"pda_medbot.png"		= 'icons/pda_icons/pda_medbot.png',
		"pda_floorbot.png"		= 'icons/pda_icons/pda_floorbot.png',
		"pda_crate.png"			= 'icons/pda_icons/pda_crate.png',
		"pda_cuffs.png"			= 'icons/pda_icons/pda_cuffs.png',
		"pda_eject.png"			= 'icons/pda_icons/pda_eject.png',
		"pda_exit.png"			= 'icons/pda_icons/pda_exit.png',
		"pda_flashlight.png"	= 'icons/pda_icons/pda_flashlight.png',
		"pda_honk.png"			= 'icons/pda_icons/pda_honk.png',
		"pda_mail.png"			= 'icons/pda_icons/pda_mail.png',
		"pda_medical.png"		= 'icons/pda_icons/pda_medical.png',
		"pda_menu.png"			= 'icons/pda_icons/pda_menu.png',
		"pda_mule.png"			= 'icons/pda_icons/pda_mule.png',
		"pda_notes.png"			= 'icons/pda_icons/pda_notes.png',
		"pda_power.png"			= 'icons/pda_icons/pda_power.png',
		"pda_rdoor.png"			= 'icons/pda_icons/pda_rdoor.png',
		"pda_reagent.png"		= 'icons/pda_icons/pda_reagent.png',
		"pda_refresh.png"		= 'icons/pda_icons/pda_refresh.png',
		"pda_scanner.png"		= 'icons/pda_icons/pda_scanner.png',
		"pda_signaler.png"		= 'icons/pda_icons/pda_signaler.png',
		"pda_status.png"		= 'icons/pda_icons/pda_status.png'
	)

/datum/asset/simple/paper
	assets = list(
		"large_stamp-clown.png" = 'icons/stamp_icons/large_stamp-clown.png',
		"large_stamp-deny.png" = 'icons/stamp_icons/large_stamp-deny.png',
		"large_stamp-ok.png" = 'icons/stamp_icons/large_stamp-ok.png',
		"large_stamp-hop.png" = 'icons/stamp_icons/large_stamp-hop.png',
		"large_stamp-cmo.png" = 'icons/stamp_icons/large_stamp-cmo.png',
		"large_stamp-ce.png" = 'icons/stamp_icons/large_stamp-ce.png',
		"large_stamp-hos.png" = 'icons/stamp_icons/large_stamp-hos.png',
		"large_stamp-rd.png" = 'icons/stamp_icons/large_stamp-rd.png',
		"large_stamp-cap.png" = 'icons/stamp_icons/large_stamp-cap.png',
		"large_stamp-qm.png" = 'icons/stamp_icons/large_stamp-qm.png',
		"large_stamp-law.png" = 'icons/stamp_icons/large_stamp-law.png'
	)


//Registers HTML Interface assets.
/datum/asset/HTML_interface/register()
	for(var/path in typesof(/datum/html_interface))
		var/datum/html_interface/hi = new path()
		hi.registerResources()
