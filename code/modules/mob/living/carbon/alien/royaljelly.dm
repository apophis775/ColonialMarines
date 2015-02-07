/obj/royaljelly
	name = "royal jelly"
	desc = "A sack with a green liquid inside"
	icon = 'icons/mob/alien.dmi'
	icon_state = "jelly"
	var/growth = 0
	var/maxgrowth = 100
	var/health = 100
	var/ready = 0
	var/plasmapool = 0

/*
/obj/royaljelly/attack_hand(user as mob)
	if(growth == maxgrowth)
		var/mob/living/carbon/alien/humanoid/sentinel/sent = user
		if(sent && istype(sent, /mob/living/carbon/alien/humanoid/sentinel))
			sent.evolve2()
			del(src)
			return
		var/mob/living/carbon/alien/humanoid/drone/drone = user
		if(drone && istype(drone, /mob/living/carbon/alien/humanoid/drone))
			drone.evolve2()
			del(src)
			return
		var/mob/living/carbon/alien/humanoid/hunter/hunt = user
		if(hunt && istype(hunt, /mob/living/carbon/alien/humanoid/hunter))
			hunt.evolve2()
			del(src)
			return

		user << "This is not for you!"
	else
		user << "\blue It is not ready"
*/

/obj/royaljelly/attack_hand(user as mob)
	var/mob/living/carbon/alien/humanoid/sentinel/sent = user
	if(sent && !sent.hasJelly)
		sent.hasJelly = 1
		sent.visible_message("[sent] drinks the royal jelly.")
		del(src)
		return
	/*var/mob/living/carbon/alien/humanoid/hunter/hunt = user
	if(hunt && !hunt.hasJelly)
		hunt.hasJelly = 1
		hunt.visible_message("[hunt] drinks the royal jelly.")
		del(src)
		return*/
	var/mob/living/carbon/alien/humanoid/runner/runner = user
	if (runner && !runner.hasJelly)
		runner.hasJelly = 1
		runner.visible_message("[runner] drinks the royal jelly")
		del(src)
		return
	var/mob/living/carbon/alien/humanoid/drone/drone = user
	if(drone && !drone.hasJelly)
		drone.hasJelly = 1
		drone.visible_message("[drone] drinks the royal jelly.")
		del(src)
		return
	user << "\blue You already feel the effects of the royal jelly flowing through your veins."

/obj/royaljelly/attack_paw(user as mob) //can be picked up by aliens
	if(isalien(user))
		attack_hand(user)
		return
	else
		..()
		return



/obj/royaljelly/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage
	if(health <= 0)
		del(src)
	return
/*
/obj/royaljelly/proc/cause_grow()
	if(growth < 100)
		growth += 1
		desc = initial(desc)
		desc += "\n It's [growth]% done"
		var/matrix/M = src.transform
		M.Scale(1.05, 1.05)
		src.transform = M
	else
		ready = 1
		desc = initial(desc)
		desc += "\n It's ready to be used"

/obj/royaljelly/proc/grow()
	spawn while(1)
		cause_grow()
		sleep(240)
*/
/obj/royaljelly/New()
	//grow()
	var/matrix/M = matrix()
	M.Scale(1,1)
	src.transform = M

	..()