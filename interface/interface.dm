//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/*
/client/verb/wiki()
	set name = "wiki"
	set desc = "Visit the wiki."
	set hidden = 1
	if(config.wikiurl)
		if(alert("This will open the wiki in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.wikiurl)
	else
		src << "<span class='danger'>The wiki URL is not set in the server configuration.</span>"
	return

/client/verb/forum()
	set name = "forum"
	set desc = "Visit the forum."
	set hidden = 1
	if(config.forumurl)
		if(alert("This will open the forum in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.forumurl)
	else
		src << "<span class='danger'>The forum URL is not set in the server configuration.</span>"
	return

/client/verb/rules()
	set name = "Rules"
	set desc = "Show Server Rules."
	set hidden = 1
	if(config.rulesurl)
		if(alert("This will open the rules in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.rulesurl)
	else
		src << "<span class='danger'>The rules URL is not set in the server configuration.</span>"
	return

/client/verb/github()
	set name = "Github"
	set desc = "Visit Github"
	set hidden = 1
	if(CONFIG_GET(string/githuburl))
		if(alert("This will open the Github repository in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(CONFIG_GET(string/githuburl))
	else
		src << "<span class='danger'>The Github URL is not set in the server configuration.</span>"
	return

/client/verb/reportissue()
	set name = "Report issue"
	set desc = "Report an issue"
	set hidden = 1
	if(CONFIG_GET(string/githuburl))
		if(alert("This will open the Github issue reporter in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link("[CONFIG_GET(string/githuburl)]/issues/new")
	else
		src << "<span class='danger'>The Github URL is not set in the server configuration.</span>"
	return
*/
/client/verb/hotkeys_help()
	set name = "hotkeys-help"
	set category = "OOC"

	var/adminhotkeys = {"<font color='purple'>
Admin:
\tF5 = Asay
\tF6 = Player-Panel
\tF7 = Admin-PM
\tF8 = Aghost
</font>"}

	mob.hotkey_help()

	if(holder)
		src << adminhotkeys


/mob/proc/hotkey_help()
	src << browse_rsc('icons/Unsorted/KEY_LAYOUT4.png', "KEY_LAYOUT4.png")
	src << "<img src=\"icons/Unsorted/KEY_LAYOUT4.png\">"
/*
	var/hotkey_mode = {"<font color='purple'>
Hotkey-Mode: (hotkey-mode must be on)
\tTAB = toggle hotkey-mode
\ta = left
\ts = down
\td = right
\tw = up
\tq = drop
\te = equip
\tr = throw
\tc = side panel
\tv = slide a knife in boots
\tm = me
\tt = say
\to = OOC
\tb = resist
\tx = swap-hand
\tz = activate held object (or y)
\t1 = help-intent
\t2 = disarm-intent
\t3 = grab-intent
\t4 = harm-intent
</font>"}

	var/other = {"<font color='purple'>
Any-Mode: (hotkey doesn't need to be on)
\tCtrl+a = left
\tCtrl+s = down
\tCtrl+d = right
\tCtrl+w = up
\tCtrl+q = drop
\tCtrl+e = equip
\tCtrl+r = throw
\tCtrl+b = resist
\tCtrl+O = OOC
\tCtrl+x = swap-hand
\tCtrl+z = activate held object (or Ctrl+y)
\tCtrl+1 = help-intent
\tCtrl+2 = disarm-intent
\tCtrl+3 = grab-intent
\tCtrl+4 = harm-intent
\tDEL = pull
\tINS = cycle-intents-right
\tHOME = drop
\tPGUP = swap-hand
\tPGDN = activate held object
\tEND = throw
</font>"}

	src << hotkey_mode
	src << other
*/
// Needed to circumvent a bug where .winset does not work when used on the window.on-size event in skins.
// Used by /datum/html_interface/nanotrasen (code/modules/html_interface/nanotrasen/nanotrasen.dm)
/client/verb/_swinset(var/x as text)
	set name = ".swinset"
	set hidden = 1
	winset(src, null, x)

/client/verb/toggle_side_panel()
	set name = "toggle-side-panel"
	set hidden = 1

	if(mob)
		var/obj/screen/human/toggle/H = locate() in screen
		if(H)
			H.Click()

/client/verb/toggle_boot_knife()
	set name = "toggle-boots-knife"
	set hidden = 1

	var/mob/living/carbon/human/H = usr
	if(H.shoes)
		H.shoes.Click()

/client/verb/toggle_fixed_eye()
	set name = "toggle-fixed-eye"
	set hidden = 1

	if(mob)
		var/obj/screen/fixeye/F = locate() in screen
		if(F)
			F.Click()

/client/verb/close_look()
	set name = "close-look"
	set hidden = 1

	if(mob)
		mob.close_look()