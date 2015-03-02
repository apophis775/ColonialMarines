
/client/verb/who()
	set name = "Who"
	set category = "OOC"
	
	var/count_observers = 0
	for(var/client/C in clients)
		if(isobserver(C.mob) && !C.holder)		
			count_observers++
	var/count_humans = 0
	var/count_infectedhumans = 0
	for(var/client/C in clients)
		if(ishuman(C.mob) && C.mob.stat != DEAD)
			count_humans++
		if(ishuman(C.mob) && C.mob.stat != DEAD && C.mob.status_flags & XENO_HOST)
			count_infectedhumans++
	var/count_aliens = 0
	for(var/client/C in clients)
		if(isalien(C.mob) && C.mob.stat != DEAD)
			count_aliens++

	var/msg = "<b>Current Players:</b>\n"

	var/list/Lines = list()

	if(holder)
		for(var/client/C in clients)
			var/entry = "\t[C.key]"
			if(C.holder && C.holder.fakekey)
				entry += " <i>(as [C.holder.fakekey])</i>"
			entry += " - Playing as [C.mob.real_name]"
			switch(C.mob.stat)
				if(UNCONSCIOUS)
					entry += " - <font color='darkgray'><b>Unconscious</b></font>"
				if(DEAD)
					if(isobserver(C.mob))
						var/mob/dead/observer/O = C.mob
						if(O.started_as_observer)
							entry += " - <font color='gray'>Observing</font>"
						else
							entry += " - <font color='black'><b>DEAD</b></font>"
					else
						entry += " - <font color='black'><b>DEAD</b></font>"
			if(is_special_character(C.mob))
				entry += " - <b><font color='red'>Antagonist</font></b>"
			entry += " (<A HREF='?_src_=holder;adminmoreinfo=\ref[C.mob]'>?</A>)"
			if(C.mob.status_flags & XENO_HOST)
				entry += " - <b>INFECTED</b>"
			Lines += entry
	else
		for(var/client/C in clients)
			if(C.holder && C.holder.fakekey)
				Lines += C.holder.fakekey
			else
				Lines += C.key

	for(var/line in sortList(Lines))
		msg += "[line]\n"

	if(holder)
		msg += "<b>Total Players: [length(Lines)]</b>"
		msg += "<br><b style=\"color:#777\">Total Non-Admin Observers: [count_observers]</b>"
		msg += "<br><b style=\"color:#688944\">Total Alive Humans: [count_humans] \red(Infected: [count_infectedhumans])</b>"
		msg += "<br><b style=\"color:#6161A1\">Total Alive Aliens: [count_aliens]</b>"
	else
		msg += "<b>Total Players: [length(Lines)]</b>"
	src << msg



//New SEXY Staffwho verb, 01FEB2015 APOPHIS775
/client/verb/staffwho()
	set category = "Admin"
	set name = "StaffWho"
	var/adminwho = ""
	var/modwho = ""
	var/msg = ""
	var/admin_count = 0
	var/mod_count = 0

	if(holder)
		for(var/client/C in admins)
			if(R_ADMIN & C.holder.rights || !(R_MOD & C.holder.rights))
				if(C.holder.fakekey && (!R_ADMIN & holder.rights && !R_MOD & holder.rights))		//Mentors can't see stealthmins
					continue
				adminwho += "\t[C] is a [C.holder.rank]"
				if(C.holder.fakekey)
					adminwho += " <i>(as [C.holder.fakekey])</i>"
				if(isobserver(C.mob))
					adminwho += " - Observing"
				else if(istype(C.mob,/mob/new_player))
					adminwho += " - Lobby"
				else
					adminwho += " - Playing"
				if(C.is_afk())
					adminwho += " (AFK)"
				adminwho += "\n"
				admin_count++
			else if (R_MOD & C.holder.rights)
				modwho += "\t[C] is a [C.holder.rank]"
				if(C.holder.fakekey)
					modwho += " <i>(as [C.holder.fakekey])</i>"
				if(isobserver(C.mob))
					modwho += " - Observing"
				else if(istype(C.mob,/mob/new_player))
					modwho += " - Lobby"
				else
					modwho += " - Playing"
				if(C.is_afk())
					modwho += " (AFK)"
				modwho += "\n"
				mod_count++

	else
		for(var/client/C in admins)
			if(R_ADMIN & C.holder.rights || !R_MOD & C.holder.rights)
				if(!C.holder.fakekey)
					adminwho += "\t[C] is a [C.holder.rank]\n"
					admin_count++
			else if (R_MOD & C.holder.rights)
				modwho += "\t[C] is a [C.holder.rank]\n"
				mod_count++

	src <<"<b>Current Admins ([admin_count]):</b>\n" + adminwho
	msg = ""
	msg = "<b>Current Moderators ([mod_count]):</b>\n" + modwho
	src << msg