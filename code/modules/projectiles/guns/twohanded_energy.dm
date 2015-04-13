/obj/item/weapon/gun/twohanded/energy
	icon_state = "energy"
	name = "energy gun"
	desc = "A basic energy-based gun."
	fire_sound = 'sound/weapons/Taser.ogg'

	var/obj/item/weapon/cell/power_supply //What type of power cell this uses
	var/charge_cost = 100 //How much energy is needed to fire.
	var/cell_type = "/obj/item/weapon/cell"
	var/projectile_type = "/obj/item/projectile/beam/practice"
	var/modifystate
	var/wielded = 0
	var/wieldsound = null
	var/unwieldsound = null
	var/force_unwielded = 0
	var/force_wielded = 0

	proc/unwield()
		wielded = 0
		force_unwielded = force
		name = "[initial(name)]"
		update_icon()

	proc/wield()
		wielded = 1
		force_wielded = force
		name = "[initial(name)] (Wielded)"
		update_icon()

	Fire(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, params, reflex = 0)//TODO: go over this
		//Exclude lasertag guns from the CLUMSY check.
		if(clumsy_check)
			if(istype(user, /mob/living))
				var/mob/living/M = user
				if ((CLUMSY in M.mutations) && prob(50))
					M << "<span class='danger'>[src] blows up in your face.</span>"
					M.take_organ_damage(0,20)
					M.drop_item()
					del(src)
					return

		if (!user.IsAdvancedToolUser())
			user << "\red You don't have the dexterity to do this!"
			return
		if(istype(user, /mob/living))
			var/mob/living/M = user
			if (HULK in M.mutations)
				M << "\red Your meaty finger is much too large for the trigger guard!"
				return
		if(ishuman(user))
			if(user.dna && user.dna.mutantrace == "adamantine")
				user << "\red Your metal fingers don't fit in the trigger guard!"
				return

		if(!wielded)
			user << "\red You can not fire this weapon with one hand!"
			return

		add_fingerprint(user)

		var/turf/curloc = get_turf(user)
		var/turf/targloc = get_turf(target)
		if (!istype(targloc) || !istype(curloc))
			return

		if(!special_check(user))
			return

		if (!ready_to_fire())
			if (world.time % 3) //to prevent spam
				user << "<span class='warning'>[src] is not ready to fire again!"
			return

		if(!load_into_chamber()) //CHECK
			return click_empty(user)

		if(!in_chamber)
			return

		in_chamber.firer = user
		in_chamber.def_zone = user.zone_sel.selecting
		if(targloc == curloc)
			user.bullet_act(in_chamber)
			del(in_chamber)
			update_icon()
			return

		if(recoil)
			spawn()
				shake_camera(user, recoil + 1, recoil)

		if(silenced)
			playsound(user, fire_sound, 10, 1)
		else
			playsound(user, fire_sound, 50, 1)
			user.visible_message("<span class='warning'>[user] fires [src][reflex ? " by reflex":""]!</span>", \
			"<span class='warning'>You fire [src][reflex ? "by reflex":""]!</span>", \
			"You hear a [istype(in_chamber, /obj/item/projectile/beam) ? "laser blast" : "gunshot"]!")

		in_chamber.original = target
		in_chamber.loc = get_turf(user)
		in_chamber.starting = get_turf(user)
		in_chamber.shot_from = src
		user.next_move = world.time + 4
		in_chamber.silenced = silenced
		in_chamber.current = curloc
		in_chamber.yo = targloc.y - curloc.y
		in_chamber.xo = targloc.x - curloc.x

		if(params)
			var/list/mouse_control = params2list(params)
			if(mouse_control["icon-x"])
				in_chamber.p_x = text2num(mouse_control["icon-x"])
			if(mouse_control["icon-y"])
				in_chamber.p_y = text2num(mouse_control["icon-y"])

		spawn()
			if(in_chamber)
				in_chamber.process()
		sleep(1)
		in_chamber = null

		update_icon()

		if(user.hand)
			user.update_inv_l_hand()
		else
			user.update_inv_r_hand()


	emp_act(severity)
		power_supply.use(round(power_supply.maxcharge / severity))
		update_icon()
		..()


	New()
		..()
		if(cell_type)
			power_supply = new cell_type(src)
		else
			power_supply = new(src)
		power_supply.give(power_supply.maxcharge)
		return


	load_into_chamber()
		if(in_chamber)	return 1
		if(!power_supply)	return 0
		if(!power_supply.use(charge_cost))	return 0
		if(!projectile_type)	return 0
		in_chamber = new projectile_type(src)
		return 1


	update_icon()
		var/ratio = power_supply.charge / power_supply.maxcharge
		ratio = round(ratio, 0.25) * 100
		if(modifystate)
			icon_state = "[modifystate][ratio]"
		else
			icon_state = "[initial(icon_state)][ratio]"

	attack_self(mob/user as mob)
		if( istype(user,/mob/living/carbon/monkey) )
			user << "<span class='warning'>It's too heavy for you to wield fully.</span>"
			return

		..()
		if(wielded) //Trying to unwield it
			unwield()
			user << "<span class='notice'>You are now carrying the [name] with one hand.</span>"
			if (src.unwieldsound)
				playsound(src.loc, unwieldsound, 50, 1)

			var/obj/item/weapon/twohanded/projectile/offhand/O = user.get_inactive_hand()
			if(O && istype(O))
				O.unwield()
			return

		else //Trying to wield it
			if(user.get_inactive_hand())
				user << "<span class='warning'>You need your other hand to be empty</span>"
				return
			wield()
			user << "<span class='notice'>You grab the [initial(name)] with both hands.</span>"
			if (src.wieldsound)
				playsound(src.loc, wieldsound, 50, 1)

			var/obj/item/weapon/twohanded/projectile/offhand/O = new(user) ////Let's reserve his other hand~
			O.name = "[initial(name)] - offhand"
			O.desc = "Your second grip on the [initial(name)]"
			user.put_in_inactive_hand(O)
			return
