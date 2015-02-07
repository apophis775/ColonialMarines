#define AIRBORNE 	1
#define BITE		2
#define DEATH		3


/datum/disease/zombie
	name = "Unknown"
	max_stages = 3
	spread = "Unknown"
	cure = "Unknown"
	cure_id = "zombiecure"
	agent = "ZB-Virus"
	affected_species = list("Human")
	permeability_mod = 0.5
	severity = "Unknown"

/datum/disease/zombie/stage_act()
	..()


/datum/zombie_controller
	var/virustype
	var/list/mob/living/carbon/human/zombie/zombies = list()
	proc/initialize()
		virustype = rand(1,3)

	proc/tick()
		spawn while(1)
			var/mob/living/carbon/human/zombie/Z
			for (Z in world.contents)
				if(!zombies.Find(Z))
					zombies.Add(Z)
			sleep(10)



/mob/living/carbon/human/zombie
	name = "unknown"
