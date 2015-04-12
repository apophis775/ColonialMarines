//ALIEN SENTINEL - UPDATED 07JAN2015 - APOPHIS
/mob/living/carbon/alien/humanoid/sentinel
	name = "alien sentinel"
	caste = "Sentinel"
	maxHealth = 200
	health = 200
	storedPlasma = 75
	max_plasma = 300
	icon_state = "Sentinal Walking"
	plasma_rate = 7
	damagemin = 18
	damagemax = 24
	tacklemin = 2
	tacklemax = 4
	tackle_chance = 50 //Should not be above 100%
	heal_rate = 6
	var/hasJelly = 0
	var/jellyProgress = 0
	var/jellyProgressMax = 750
	psychiccost = 25
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


/mob/living/carbon/alien/humanoid/sentinel/New()
	var/datum/reagents/R = new/datum/reagents(100)
	src.frozen = 1
	spawn (25)
		src.frozen = 0
	reagents = R
	R.my_atom = src
	if(name == "alien sentinel")
		name = text("alien sentinel ([rand(1, 1000)])")
	real_name = name
	verbs.Add(/mob/living/carbon/alien/humanoid/proc/weak_acid,
	/mob/living/carbon/alien/humanoid/proc/weak_neurotoxin,
	/mob/living/carbon/alien/humanoid/proc/quickspit
	)
	verbs -= /mob/living/carbon/alien/humanoid/verb/plant
	growJelly()
	..()


/mob/living/carbon/alien/humanoid/sentinel/verb/evolve2() // -- TLE
	set name = "Evolve (Jelly)"
	set desc = "Evolve into a Spitter"
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
	if(health<maxHealth)
		src << "\red You are too hurt to Evolve."
		return
	src << "\blue <b>You are growing into a Spitter!</b>"

	var/mob/living/carbon/alien/humanoid/new_xeno

	new_xeno = new /mob/living/carbon/alien/humanoid/spitter(loc)
	src << "\green You begin to evolve!"

	for(var/mob/O in viewers(src, null))
		O.show_message(text("\green <B>[src] begins to twist and contort!</B>"), 1)
	if(mind)	mind.transfer_to(new_xeno)

	del(src)


	return
