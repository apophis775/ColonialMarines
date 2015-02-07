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
	verbs.Add(/mob/living/carbon/alien/humanoid/proc/corrosive_acid_super,/mob/living/carbon/alien/humanoid/proc/corrosive_acid,/mob/living/carbon/alien/humanoid/proc/neurotoxin,/mob/living/carbon/alien/humanoid/proc/super_neurotoxin)
	verbs -= /mob/living/carbon/alien/verb/ventcrawl
	verbs -= /mob/living/carbon/alien/humanoid/verb/plant
	//var/matrix/M = matrix()
	//M.Scale(1.2,1.3)
	//src.transform = M
	pixel_x = -16
	..()

/mob/living/carbon/alien/humanoid/praetorian


	handle_regular_hud_updates()

		..() //-Yvarov
		var/HP = (health/maxHealth)*100

		if (healths)
			if (stat != 2)
				switch(HP)
					if(80 to INFINITY)
						healths.icon_state = "health0"
					if(60 to 80)
						healths.icon_state = "health1"
					if(40 to 60)
						healths.icon_state = "health2"
					if(20 to 40)
						healths.icon_state = "health3"
					if(0 to 20)
						healths.icon_state = "health4"
					else
						healths.icon_state = "health5"
			else
				healths.icon_state = "health6"
