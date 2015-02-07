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
				V.welded = 0
				V.update_icon()
				V.visible_message( \
				"\red [src] spits acid at \ [V].", \
				"\blue You corrode \ [V] with your acid.", \
				"You hear a loud hissing sound.")
