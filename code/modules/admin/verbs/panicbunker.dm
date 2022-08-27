/client/proc/panicbunker()
	set category = "Server"
	set name = "Toggle Panic Bunker"
	if (!CONFIG_GET(flag/sql_enabled))
		usr << "<span class='adminnotice'>The Database is not enabled!</span>"
		return

	CONFIG_SET(flag/panic_bunker, !CONFIG_GET(flag/panic_bunker))

	log_admin("[key_name(usr)] has toggled the Panic Bunker, it is now [(CONFIG_GET(flag/panic_bunker)?"on":"off")]")
	message_admins("[key_name_admin(usr)] has toggled the Panic Bunker, it is now [(CONFIG_GET(flag/panic_bunker)?"enabled":"disabled")].")
	if (CONFIG_GET(flag/panic_bunker) && (!dbcon || !dbcon.IsConnected()))
		message_admins("The Database is not connected! Panic bunker will not work until the connection is reestablished.")
	feedback_add_details("admin_verb","PANIC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

