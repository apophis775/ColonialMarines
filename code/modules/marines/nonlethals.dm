/obj/item/weapon/melee/stunprod
	name = "electrified prodder"
	desc = "A specialised prod designed for incapacitating xenomorphic lifeforms with."
	icon_state = "stunbaton"
	item_state = "baton"
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_BELT
	force = 12
	throwforce = 7
	w_class = 3
	var/charges = 12
	var/status = 0
	var/mob/foundmob = "" //Used in throwing proc.

	origin_tech = "combat=2"

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is putting the live [src.name] in \his mouth! It looks like \he's trying to commit suicide.</b>"
		return (FIRELOSS)

/obj/item/weapon/melee/stunprod/update_icon()
	if(status)
		icon_state = "stunbaton_active"
	else
		icon_state = "stunbaton"

/obj/item/weapon/melee/stunprod/attack_self(mob/user as mob)
	if(status && (CLUMSY in user.mutations) && prob(50))
		user << "\red You grab the [src] on the wrong side."
		user.Weaken(30)
		charges--
		if(charges < 1)
			status = 0
			update_icon()
		return
	if(charges > 0)
		status = !status
		user << "<span class='notice'>\The [src] is now [status ? "on" : "off"].</span>"
		playsound(src.loc, "sparks", 75, 1, -1)
		update_icon()
	else
		status = 0
		user << "<span class='warning'>\The [src] is out of charge.</span>"
	add_fingerprint(user)

/obj/item/weapon/melee/stunprod/attack(mob/M as mob, mob/user as mob)
	if(status && (CLUMSY in user.mutations) && prob(50))
		user << "<span class='danger'>You accidentally hit yourself with the [src]!</span>"
		user.Weaken(30)
		charges--
		if(charges < 1)
			status = 0
			update_icon()
		return

	var/mob/living/carbon/alien/H = M
	if(isrobot(M))
		..()
		return

	if(user.a_intent == "hurt")
		return
	else if(!status)
		H.visible_message("<span class='warning'>[M] has been poked with [src] whilst it's turned off by [user].</span>")
		return

	if(status)
		H.weakened = 6
		user.lastattacked = M
		H.lastattacker = user
		charges -= 2
		H.visible_message("<span class='danger'>[M] has been prodded with the [src] by [user]!</span>")

		user.attack_log += "\[[time_stamp()]\]<font color='red'> Stunned [H.name] ([H.ckey]) with [src.name]</font>"
		H.attack_log += "\[[time_stamp()]\]<font color='orange'> Stunned by [user.name] ([user.ckey]) with [src.name]</font>"
		log_attack("[user.name] ([user.ckey]) stunned [H.name] ([H.ckey]) with [src.name]")

		playsound(src.loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)
		if(charges < 1)
			status = 0
			update_icon()

	add_fingerprint(user)


/obj/item/weapon/melee/stunprod/emp_act(severity)
	switch(severity)
		if(1)
			charges = 0
		if(2)
			charges = max(0, charges - 5)
	if(charges < 1)
		status = 0
		update_icon()


//-----NEW PRODDER CODE-----\\

/*
/obj/item/weapon/melee/stunprod
	name = "electrified prodder"
	desc = "A specialised prod designed for incapacitating xenomorphic lifeforms with."
	icon_state = "stunbaton"
	item_state = "baton"
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_BELT
	force = 12
	throwforce = 7
	w_class = 3
	var/charges = 12
	var/status = 0
	var/mob/foundmob = "" //Used in throwing proc.

	origin_tech = "combat=2"

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is putting the live [src.name] in \his mouth! It looks like \he's trying to commit suicide.</b>"
		return (FIRELOSS)

/obj/item/weapon/melee/stunprod/update_icon()
	if(status)
		icon_state = "stunbaton_active"
	else
		icon_state = "stunbaton"

/obj/item/weapon/melee/stunprod/attack_self(mob/user as mob)
	if(status && (CLUMSY in user.mutations) && prob(50))
		user << "\red You grab the [src] on the wrong side."
		user.Weaken(30)
		charges--
		if(charges < 1)
			status = 0
			update_icon()
		return
	if(charges > 0)
		status = !status
		user << "<span class='notice'>\The [src] is now [status ? "on" : "off"].</span>"
		playsound(src.loc, "sparks", 75, 1, -1)
		update_icon()
	else
		status = 0
		user << "<span class='warning'>\The [src] is out of charge.</span>"
	add_fingerprint(user)

/obj/item/weapon/melee/stunprod/attack(mob/M as mob, mob/user as mob)
	if(status && (CLUMSY in user.mutations) && prob(50))
		user << "<span class='danger'>You accidentally hit yourself with the [src]!</span>"
		user.Weaken(30)
		charges--
		if(charges < 1)
			status = 0
			update_icon()
		return

	var/mob/living/carbon/H = M
	if(isrobot(M))
		..()
		return

	if(user.a_intent == "hurt")
		return
	else if(!status)
		H.visible_message("<span class='warning'>[M] has been poked with [src] whilst it's turned off by [user].</span>")
		return

	if(status)
		charges -= 2
		playsound(src.loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)
		user.lastattacked = M
		H.lastattacker = user
		add_fingerprint(user)
		if(charges < 1)
			status = 0
			update_icon()
		if(isalien(H))
			var/mob/living/carbon/alien/T = M
			switch(T.class)
				if(0) //Tier 0
					H.weakened = rand(8,12)
					H.visible_message("<span class='danger'>[M] has been prodded with the [src] by [user]!</span>")
					//--Logs
					user.attack_log += "\[[time_stamp()]\]<font color='red'> Stunned [H.name] ([H.ckey]) with [src.name]</font>"
					H.attack_log += "\[[time_stamp()]\]<font color='orange'> Stunned by [user.name] ([user.ckey]) with [src.name]</font>"
					log_attack("[user.name] ([user.ckey]) stunned [H.name] ([H.ckey]) with [src.name]")

				if(1) //Tier I
					H.weakened = rand(6,7)
					H.visible_message("<span class='danger'>[M] has been prodded with the [src] by [user]!</span>")
					//--Logs
					user.attack_log += "\[[time_stamp()]\]<font color='red'> Stunned [H.name] ([H.ckey]) with [src.name]</font>"
					H.attack_log += "\[[time_stamp()]\]<font color='orange'> Stunned by [user.name] ([user.ckey]) with [src.name]</font>"
					log_attack("[user.name] ([user.ckey]) stunned [H.name] ([H.ckey]) with [src.name]")

				if(2) //Tier II
					if(prob(60))
						H.weakened = rand(4,5)
						H.visible_message("<span class='danger'>[M] has been prodded with the [src] by [user]!</span>")
						//--Logs
						user.attack_log += "\[[time_stamp()]\]<font color='red'> Stunned [H.name] ([H.ckey]) with [src.name]</font>"
						H.attack_log += "\[[time_stamp()]\]<font color='orange'> Stunned by [user.name] ([user.ckey]) with [src.name]</font>"
						log_attack("[user.name] ([user.ckey]) stunned [H.name] ([H.ckey]) with [src.name]")
					else
						H.visible_message("<span class='danger'>[M] has been prodded with the [src] by [user], but it is still standing!</span>")

				if(3) //Tier III
					if(prob(20))
						H.weakened = rand(2,3)
						H.visible_message("<span class='danger'>[M] has been prodded with the [src] by [user]!</span>")
						//--Logs
						user.attack_log += "\[[time_stamp()]\]<font color='red'> Stunned [H.name] ([H.ckey]) with [src.name]</font>"
						H.attack_log += "\[[time_stamp()]\]<font color='orange'> Stunned by [user.name] ([user.ckey]) with [src.name]</font>"
						log_attack("[user.name] ([user.ckey]) stunned [H.name] ([H.ckey]) with [src.name]")
					else
						H.visible_message("<span class='danger'>[M] has been prodded with the [src] by [user], but it is still standing!</span>")
		else
			//For other mobs
			H.visible_message("<span class='danger'>[M] has been prodded with the [src] by [user]!</span>")
			H.Weaken(rand(8,9))
			user.attack_log += "\[[time_stamp()]\]<font color='red'> Stunned [H.name] ([H.ckey]) with [src.name]</font>"
			H.attack_log += "\[[time_stamp()]\]<font color='orange'> Stunned by [user.name] ([user.ckey]) with [src.name]</font>"
			log_attack("[user.name] ([user.ckey]) stunned [H.name] ([H.ckey]) with [src.name]")

/obj/item/weapon/melee/stunprod/emp_act(severity)
	switch(severity)
		if(1)
			charges = 0
		if(2)
			charges = max(0, charges - 5)
	if(charges < 1)
		status = 0
		update_icon()
*/