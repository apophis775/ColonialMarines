
/mob/living/carbon/alien/larva/verb/hide()
	set name = "Hide"
	set desc = "Allows to hide beneath tables or certain items. Toggled on or off."
	set category = "Alien"

	if(stat != CONSCIOUS)
		return

	if (layer != TURF_LAYER+0.2)
		layer = TURF_LAYER+0.2
		src << text("\green You are now hiding.")
		for(var/mob/O in oviewers(src, null))
			if ((O.client && !( O.blinded )))
				O << text("<B>[] scurries to the ground!</B>", src)
	else
		layer = MOB_LAYER
		src << text("\green You have stopped hiding.")
		for(var/mob/O in oviewers(src, null))
			if ((O.client && !( O.blinded )))
				O << text("[] slowly peaks up from the ground...", src)

/mob/living/carbon/alien/larva/verb/evolve()
	set name = "Evolve"
	set desc = "Evolve into a fully grown Alien."
	set category = "Alien"
	if(stat != CONSCIOUS)
		return

	if(handcuffed || legcuffed)
		src << "\red You cannot evolve when you are cuffed."

	if(amount_grown >= max_grown)	//TODO ~Carn
		//green is impossible to read, so i made these blue and changed the formatting slightly
		src << "\blue <b>You are growing into a beautiful alien! It is time to choose a caste.</b>"
		src << "\blue There are three to choose from:"
		src << "<B>Runners</B> \blue are fast and agile, able to hunt away from the hive and rapidly move through ventilation shafts as well as pounce of their prey.  The Evolve into Warriors, then Ravagers."
		src << "<B>Sentinels</B> \blue are tasked with protecting the hive and are deadly up close and at a range. They are not as physically imposing nor fast as the warriors.  They Evolve into Spitters, then Praetorians"
		src << "<B>Drones</B> \blue are the working class, offering the largest plasma storage and generation. They evolve into either the Queen, a Hivelord which specializes in building, or a Carrier, which specializes in support"
		var/alien_caste = alert(src, "Please choose which alien caste you shall belong to.",,"Runner","Sentinel","Drone")

		var/mob/living/carbon/alien/humanoid/new_xeno
		switch(alien_caste)
			if("Runner")
				new_xeno = new /mob/living/carbon/alien/humanoid/runner(loc)
			if("Sentinel")
				new_xeno = new /mob/living/carbon/alien/humanoid/sentinel(loc)
			if("Drone")
				new_xeno = new /mob/living/carbon/alien/humanoid/drone(loc)
		if(mind)	mind.transfer_to(new_xeno)
		del(src)
		return
	else
		src << "\red You are not fully grown."
		return
