/mob/living/carbon/alien/verb/ventcrawl() // -- TLE
	set name = "Crawl through vent"
	set desc = "Enter an air vent and crawl through the pipe system."
	set category = "Alien"

	src << "\red To vent crawl, Alt + Click the vent."


/mob/living/carbon/alien/verb/toggle_darkness()
   set name = "Toggle Nightvision"
   set category = "Alien"
   if (src.nightvision == 1)
      src.nightvision = 2
   else
      src.nightvision = 1

/mob/living/carbon/alien/verb/unweld_vent(O as obj|turf in oview(1))
	set name = "Corrode vent (120)"
	set category = "Alien"

	if(powerc(120))
		var/obj/machinery/atmospherics/unary/vent_pump/V
		V = O
		if(O in oview(1))
			if(istype(O, /obj/machinery/atmospherics/unary/vent_pump))
				adjustToxLoss(-120)
				V.welded = 0
				V.update_icon()
				V.visible_message( \
				"\red [src] spits acid at \ [V].", \
				"\blue You corrode \ [V] with your acid.", \
				"You hear a loud hissing sound.")

/mob/living/carbon/alien/verb/hive_status()
	set name = "Hive Status"
	set desc = "Check the status of your current hive."
	set category = "Alien"

	var/dat = "<html><head><title>Hive Status</title></head><body><h1><B>Hive Status</B></h1>"
	
	if(ticker.mode.aliens.len > 0)
		dat += "<table cellspacing=5><tr><td><b>Name</b></td><td><b>Location</b></td></tr>"
		for(var/mob/living/L in mob_list)
			var/turf/pos = get_turf(L)
			if(L.mind && L.mind.assigned_role)
				if(L.mind.assigned_role == "Alien")
					var/mob/M = L.mind.current
					var/area/player_area = get_area(L)
					if((M) && (pos) && (pos.z == 1 || pos.z == 6))
						dat += "<tr><td>[M.real_name][M.client ? "" : " <i>(mindless)</i>"][M.stat == 2 ? " <b><font color=red>(DEAD)</font></b>" : ""]</td>"
						dat += "<td>[player_area.name] ([pos.x], [pos.y])</td></tr>"
		dat += "</table>"
	dat += "</body></html>"
	usr << browse(dat, "window=roundstatus;size=600x400")
	return
