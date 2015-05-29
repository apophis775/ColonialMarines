//ALIEN DRONE - UPDATED 08FEB2015 - APOPHIS
/mob/living/carbon/alien/humanoid/drone
	name = "alien drone"
	caste = "Drone"
	maxHealth = 170
	health = 170
	icon_state = "Drone Walking"
	storedPlasma = 350
	max_plasma = 750
	damagemin = 12
	damagemax = 16
	heal_rate = 8
	plasma_rate = 13
	tacklemin = 2
	tacklemax = 3 //old max 5
	tackle_chance = 40 //Should not be above 100% old chance 50
	var/hasJelly = 0
	var/jellyProgress = 0
	var/jellyProgressMax = 1000
	psychiccost = 30
	class = 1

	Stat()
		..()
		stat(null, "Jelly Progress: [jellyProgress]/[jellyProgressMax]")
	proc/growJelly()
		spawn while(1)
			if(hasJelly)
				if(jellyProgress < jellyProgressMax)
					jellyProgress = min(jellyProgress + 1, jellyProgressMax)
			sleep(10)
	proc/canEvolve()
		if(!hasJelly)
			return 0
		if(jellyProgress < jellyProgressMax)
			return 0
		return 1

/mob/living/carbon/alien/humanoid/drone/New()
	var/datum/reagents/R = new/datum/reagents(100)
	src.frozen = 1
	spawn (25)
		src.frozen = 0
	reagents = R
	R.my_atom = src
	if(src.name == "alien drone")
		src.name = text("alien drone ([rand(1, 1000)])")
	src.real_name = src.name
	verbs.Add(/mob/living/carbon/alien/humanoid/proc/resin,/mob/living/carbon/alien/humanoid/proc/weak_acid)
	growJelly()
	verbs -= /atom/movable/verb/pull
	/*var/matrix/M = matrix()
	M.Scale(0.9,0.9)
	src.transform = M
	*/
	..()
//Drones use the same base as generic humanoids.
//Drone verbs

/mob/living/carbon/alien/humanoid/drone/verb/evolve() // -- TLE
	set name = "Evolve (500)"
	set desc = "Evolve into a Queen. Only one Queen can exist at a time."
	set category = "Alien"

	if(powerc(500))
		// Queen check
		var/no_queen = 1
		for(var/mob/living/carbon/alien/humanoid/queen/Q in living_mob_list)
			if(!Q.key && Q.brain_op_stage != 4)
				continue
			no_queen = 0

		if(queen_died > 0 && world.timeofday <= queen_died)
			src << "A new queen can evolve in about [round((queen_died - world.timeofday)/600,1)] minutes."
			return

		if(no_queen)
			adjustToxLoss(-500)
			src << "\green You begin to evolve!"
			for(var/mob/O in viewers(src, null))
				O.show_message(text("\green <B>[src] begins to twist and contort!</B>"), 1)
			for(var/mob/living/carbon/alien/A in living_mob_list)
				A << "\red <font size=3><b>A new queen has evolved!</b></font>"
			var/mob/living/carbon/alien/humanoid/queen/new_xeno = new (loc)
			mind.transfer_to(new_xeno)
			del(src)
		else
			src << "<span class='notice'>We already have an alive queen.</span>"
	return



/mob/living/carbon/alien/humanoid/drone/verb/evolve2() // -- TLE
	set name = "Evolve (Jelly)"
	set desc = "Evolve into your next form"
	set category = "Alien"
	if(!hivemind_check(psychiccost))
		src << "\red Your queen's psychic strength is not powerful enough for you to evolve further."
		return
	if(!canEvolve())
		if(hasJelly)
			src << "You are not ready to evolve yet"
		else
			src << "You need a mature royal jelly to evolve"
		return
	if(src.stat != CONSCIOUS)
		src << "You are unable to do that now."
		return
	if(jellyProgress >= jellyProgressMax)
		//green is impossible to read, so i made these blue and changed the formatting slightly
		src << "<B>Hivelord</B> \blue The ULTIMATE hive construction alien.  Capable of building massive hives, that's to it's tremendous Plasma reserve.  However, it is very slow and weak."
		src << "<B>Carrier</B> \blue The latest advance in Alien Evolution.  Capable of holding upto 6 Facehugger, and throwing them a far distance, directly to someones face."
		var/alien_caste = alert(src, "Please choose which alien caste you shall belong to.",,"Hivelord","Carrier")

		var/mob/living/carbon/alien/humanoid/new_xeno
		switch(alien_caste)
			if("Hivelord")
				new_xeno = new /mob/living/carbon/alien/humanoid/hivelord(loc)
			if("Carrier")
				new_xeno = new /mob/living/carbon/alien/humanoid/carrier(loc)
		if(mind)	mind.transfer_to(new_xeno)
		del(src)
		return
	else
		src << "\red You are not ready to evolve."
		return

	del(src)


	return
