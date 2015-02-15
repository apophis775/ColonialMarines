/mob/living/carbon/alien/humanoid/spitter
	name = "alien spitter"
	caste = "Spitter"
	maxHealth = 270
	health = 270
	storedPlasma = 150
	max_plasma = 450
	icon_state = "Spitter Walking"
	plasma_rate = 30
	var/progress = 0
	var/hasJelly = 1
	var/progressmax = 900
	damagemin = 20
	damagemax = 26
	tacklemin = 3
	tacklemax = 5
	tackle_chance = 60 //Should not be above 100% old was 65
	heal_rate = 3
	psychiccost = 25
	Stat()
		..()
		stat(null, "Jelly Progress: [progress]/[progressmax]")
	proc/growJelly()
		spawn while(1)
			if(hasJelly)
				if(progress < progressmax)
					progress = min(progress + 1, progressmax)
			sleep(10)
	proc/canEvolve()
		if(!hasJelly)
			return 0
		if(progress < progressmax)
			return 0
		return 1


/mob/living/carbon/alien/humanoid/spitter/New()
	var/datum/reagents/R = new/datum/reagents(100)
	src.frozen = 1
	spawn (50)
		src.frozen = 0
	reagents = R
	R.my_atom = src
	if(name == "alien spitter")
		name = text("alien spitter ([rand(1, 1000)])")
	real_name = name
	verbs.Add(/mob/living/carbon/alien/humanoid/proc/weak_neurotoxin,/mob/living/carbon/alien/humanoid/proc/neurotoxin,/mob/living/carbon/alien/humanoid/proc/weak_acid,/mob/living/carbon/alien/humanoid/proc/corrosive_acid)
	verbs -= /mob/living/carbon/alien/humanoid/verb/plant
	//var/matrix/M = matrix()
	//M.Scale(1.15,1.1)
	//src.transform = M
	//pixel_y = 3
	growJelly()
	..()



/mob/living/carbon/alien/humanoid/spitter/verb/evolve() // -- TLE
	set name = "Evolve (Jelly)"
	set desc = "Evolve into a Praetorian"
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
	src << "\blue <b>You are growing into a Praetorian!</b>"

	var/mob/living/carbon/alien/humanoid/new_xeno

	new_xeno = new /mob/living/carbon/alien/humanoid/praetorian(loc)
	src << "\green You begin to evolve!"

	for(var/mob/O in viewers(src, null))
		O.show_message(text("\green <B>[src] begins to twist and contort!</B>"), 1)
	if(mind)	mind.transfer_to(new_xeno)

	del(src)


	return
