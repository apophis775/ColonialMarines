obj/item/weapon/gun/twohanded/energy/gun
	name = "energy gun"
	desc = "A basic energy-based gun with two settings: Stun and kill."
	icon_state = "energystun100"
	item_state = null	//so the human update icon uses the icon_state instead.
	fire_sound = 'sound/weapons/Taser.ogg'

	charge_cost = 100 //How much energy is needed to fire.
	projectile_type = "/obj/item/projectile/energy/electrode"
	origin_tech = "combat=3;magnets=2"
	modifystate = "energystun"

	var/mode = 0 //0 = stun, 1 = kill


obj/item/weapon/gun/twohanded/energy/gun/verb/switch_mode()
	set name = "Switch Mode"
	set category = "Weapon"
//	set src in oview(0)

	switch(mode)
		if(0)
			mode = 1
			charge_cost = 100
			fire_sound = 'sound/weapons/Laser.ogg'
			usr << "\red [src.name] is now set to kill."
			projectile_type = "/obj/item/projectile/beam"
			modifystate = "energykill"
			update_icon()
		if(1)
			mode = 0
			charge_cost = 100
			fire_sound = 'sound/weapons/Taser.ogg'
			usr << "\red [src.name] is now set to stun."
			projectile_type = "/obj/item/projectile/energy/electrode"
			modifystate = "energystun"
			update_icon()