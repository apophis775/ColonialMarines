//ALIEN PRAETORIAN - UPDATED 30MAY2015 - APOPHIS
/mob/living/carbon/alien/humanoid/praetorian
	name = "alien praetorian"
	caste = "Accurate Praetorian"
	maxHealth = 400
	health = 400
	storedPlasma = 0
	max_plasma = 600 //was 300
	icon_state = "Praetorian Walking"
	plasma_rate = 10
	damagemin = 40
	damagemax = 45
	tacklemin = 4
	tacklemax = 6
	tackle_chance = 70 //Should not be above 100%
	heal_rate = 5
	icon = 'icons/Xeno/2x2_Xenos.dmi'
	var/progress = 0
	var/progressmax = 500
	psychiccost = 16
	//TEMP VARIABLES
	var/SPITCOOLDOWN = 10
	var/usedspit = 0
	//END TEMP VARIABLES

/*
/mob/living/carbon/alien/humanoid/praetorian/Stat()
	..()
	stat(null, "Progress: [progress]/[progressmax]")

/mob/living/carbon/alien/humanoid/praetorian/adjustToxLoss(amount)
	if(stat != DEAD)
		progress = min(progress + 1, progressmax)
	..(amount)
*/


/mob/living/carbon/alien/humanoid/praetorian/New()
	var/datum/reagents/R = new/datum/reagents(100)
	reagents = R
	R.my_atom = src
	if(name == "alien praetorian")
		name = text("alien praetorian ([rand(1, 1000)])")
	real_name = name
	verbs.Add(/mob/living/carbon/alien/humanoid/proc/corrosive_acid_super,
	/mob/living/carbon/alien/humanoid/proc/corrosive_acid,
	/mob/living/carbon/alien/humanoid/proc/neurotoxin,
	/mob/living/carbon/alien/humanoid/proc/super_neurotoxin,
	/mob/living/carbon/alien/humanoid/proc/quickspit)

	verbs -= /mob/living/carbon/alien/verb/ventcrawl
	verbs -= /mob/living/carbon/alien/humanoid/verb/plant
	//var/matrix/M = matrix()
	//M.Scale(1.2,1.3)
	//src.transform = M
	pixel_x = -16
	..()


//Aimable Spit *********************************************************

/mob/living/carbon/alien/humanoid/praetorian/ClickOn(var/atom/A, params)

	var/list/modifiers = params2list(params)
	if(modifiers["shift"])
		spit_neuro(A)

		return
	..()



/mob/living/carbon/alien/humanoid/praetorian/verb/spit_neuro(var/atom/T)

	set name = "Spit Neurotoxin (75)"
	set desc = "Spit Weak Neurotoxin."
	set category = "Alien"
	if(powerc(75))
		if(usedspit <= world.time)
			if(!T)
				var/list/victims = list()
				for(var/mob/living/carbon/human/C in oview(7))
					victims += C
				T = input(src, "Who should we spit Neurotoxin at?") as null|anything in victims

			if(T)
				usedspit = world.time + SPITCOOLDOWN * 15

				src << "We spit at [T]"
				visible_message("\red <B>[src] spits at [T]!</B>")

				var/turf/curloc = src.loc
				var/atom/targloc
				if(!istype(T, /turf/))
					targloc = get_turf(T)
				else
					targloc = T
				if (!targloc || !istype(targloc, /turf) || !curloc)
					return
				if (targloc == curloc)
					return
				var/obj/item/projectile/energy/weak_neurotoxin/A = new /obj/item/projectile/energy/weak_neurotoxin(src.loc)
				A.current = curloc
				A.yo = targloc.y - curloc.y
				A.xo = targloc.x - curloc.x
				adjustToxLoss(-75)
				A.process()

			else
				src << "\blue You cannot spit at nothing!"
		else
			src << "\red You need to wait before spitting!"
	else
		src << "\red You need more plasma."

//END AIMABLE SPIT *****************************************