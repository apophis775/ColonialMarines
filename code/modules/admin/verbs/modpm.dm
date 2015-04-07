//allows right clicking mobs to send an admin PM to their client, forwards the selected mob's client to cmd_admin_pm
/client/proc/cmd_mod_pm_context(mob/M as mob in mob_list)
	set category = null
	set name = "Mod PM Mob"

//	if(check_rights(R_ADMIN))
	//	set hidden = 1

	if(!holder)
		src << "<font color='red'>Error: Mod-PM-Context: Only moderators may use this command.</font>"
		return

	if( !ismob(M) || !M.client )	return
	cmd_mod_pm(M.client,null)
	feedback_add_details("admin_verb","MPMM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

//shows a list of clients we could send PMs to, then forwards our choice to cmd_admin_pm
/client/proc/cmd_mod_pm_panel()
	set category = "Admin"
	set name = "Mod PM"

//	if(check_rights(R_ADMIN))
	//	set hidden = 1

	if(!holder)
		src << "<font color='red'>Error: Mod-PM-Panel: Only moderators may use this command.</font>"
		return

	var/list/client/targets[0]
	for(var/client/T)
		if(T.mob)
			if(istype(T.mob, /mob/new_player))
				targets["(New Player) - [T]"] = T
			else if(istype(T.mob, /mob/dead/observer))
				targets["[T.mob.name](Ghost) - [T]"] = T
			else
				targets["[T.mob.real_name](as [T.mob.name]) - [T]"] = T
		else
			targets["(No Mob) - [T]"] = T
	var/list/sorted = sortList(targets)
	var/target = input(src,"To whom shall we send a message?","Mod PM",null) in sorted|null
	if(check_rights(R_ADMIN))
		cmd_admin_pm(targets[target], null)
	else
		cmd_mod_pm(targets[target],null)
	feedback_add_details("admin_verb","MPM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


//takes input from cmd_admin_pm_context, cmd_admin_pm_panel or /client/Topic and sends them a PM.
//Fetching a message if needed. src is the sender and C is the target client
/client/proc/cmd_mod_pm(whom, msg)
	if(check_rights(R_ADMIN,0))
		cmd_admin_pm(whom,msg)
		return

	if(prefs.muted & MUTE_ADMINHELP)
		src << "<font color='red'>Error: Mod-PM: You are unable to use mod PM-s (muted).</font>"
		return

	var/client/C
	if(istext(whom))
		C = directory[whom]
	else if(istype(whom,/client))
		C = whom
	if(!C)
		if(holder)	src << "<font color='red'>Error: Mod-PM: Client not found.</font>"
		else		adminhelp(msg)	//admin we are replying to left. adminhelp instead
		return

	//get message text, limit it's length.and clean/escape html
	if(!msg)
		msg = input(src,"Message:", "Private message to [C.key]") as text|null

		if(!msg)	return
		if(!C)
			if(holder)	src << "<font color='red'>Error: Mod-PM: Client not found.</font>"
			else		adminhelp(msg)	//admin we are replying to has vanished, adminhelp instead
			return

	if (src.handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	//clean the message if it's not sent by a high-rank admin
	if(!check_rights(R_SERVER|R_DEBUG,0))
		msg = sanitize(copytext(msg,1,MAX_MESSAGE_LEN))
		if(!msg)	return

	if(C.holder)
		if(holder)	//both are admins
			C << "<font color='maroon'>Mod PM from-<b>[key_name(src, C, 1)]</b>: [msg]</font>"
			src << "<font color='blue'>Mod PM to-<b>[key_name(C, src, 1)]</b>: [msg]</font>"

		else		//recipient is an admin but sender is not
			C << "<font color='maroon'>Reply PM from-<b>[key_name(src, C, 1)]</b>: [msg]</font>"
			src << "<font color='blue'>PM to-<b>Admins</b>: [msg]</font>"

		//play the recieving admin the adminhelp sound (if they have them enabled)
		if(C.prefs.toggles & SOUND_ADMINHELP)
			C << 'sound/effects/adminhelp.ogg'

	else
		if(holder)	//sender is an admin but recipient is not. Do BIG MAROON TEXT
			C << "<font color='maroon' size='4'><b>-- Moderator private message --</b></font>"
			C << "<font color='maroon'>Mod PM from-<b>[key_name(src, C, 0)]</b>: [msg]</font>"
			C << "<font color='maroon'><i>Click on the moderator's name to reply.</i></font>"
			src << "<font color='blue'>Mod PM to-<b>[key_name(C, src, 1)]</b>: [msg]</font>"

			//always play non-admin recipients the adminhelp sound
			C << 'sound/effects/adminhelp.ogg'

			//AdminPM popup for ApocStation and anybody else who wants to use it. Set it with POPUP_ADMIN_PM in config.txt ~Carn
			if(config.popup_admin_pm)
				spawn()	//so we don't hold the caller proc up
					var/sender = src
					var/sendername = key
					var/reply = input(C, msg,"Mod PM from-[sendername]", "") as text|null		//show message and await a reply
					if(C && reply)
						if(sender)
							C.cmd_admin_pm(sender,reply)										//sender is still about, let's reply to them
						else
							adminhelp(reply)													//sender has left, adminhelp instead
					return

		else		//neither are admins
			src << "<font color='red'>Error: Mod-PM: Non-admin to non-admin PM communication is forbidden.</font>"
			return

	log_admin("PM: [key_name(src)]->[key_name(C)]: [msg]")

	//we don't use message_admins here because the sender/receiver might get it too
	for(var/client/X in admins)
		if(X.key!=key && X.key!=C.key)	//check client/X is an admin and isn't the sender or recipient
			X << "<B><font color='blue'>PM: [key_name(src, X, 0)]-&gt;[key_name(C, X, 0)]:</B> \blue [msg]</font>" //inform X

//temporary "round" memos
/client/proc/shift_memo(msg as message)
	set category = "Admin"
	set name = "Add Shift Transition Memo"
	Shift_Transition_Memo += "	<CENTER><font size=+1>([time2text(world.realtime,"(DDD) DD MMM hh:mm")])<BR></font><B>[usr.ckey]([usr.name]):</B></CENTER><BR> [msg] "
/client/proc/show_shift_memo()
	set category = "Admin"
	set name = "Read Shift Transition Memo"
	usr << browse(Shift_Transition_Memo,"window=Shift_Transition_Memo;size=450x350")