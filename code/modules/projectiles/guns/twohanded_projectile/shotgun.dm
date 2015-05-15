/obj/item/weapon/gun/twohanded/projectile/shotgun/pump
	name = "shotgun"
	desc = "Useful for sweeping alleys."
	icon_state = "shotgun"
	item_state = "shotgun"
	max_shells = 4
	w_class = 4.0
	force = 10
	flags =  FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BACK
	caliber = "shotgun"
	origin_tech = "combat=4;materials=2"
	ammo_type = "/obj/item/ammo_casing/shotgun/beanbag"
	var/pumped = 0
	var/obj/item/ammo_casing/current_shell = null
	recoil = 4

	isHandgun()
		return 0

	afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)
		..()
		if(in_chamber) //To stop spamming before pump
			in_chamber = null
		sleep(5)
		playsound(loc, 'sound/weapons/shotgun_pump.ogg', 60, 1, -1)
		if(current_shell)
			current_shell.loc = get_turf(src)
			current_shell = null
			if(in_chamber)
				in_chamber = null
		if(!loaded.len) return 0 //empty
		var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
		loaded -= AC //Remove casing from loaded list.
		current_shell = AC
		if(AC.BB)
			AC.spent = 1
			in_chamber = AC.BB //Load projectile into chamber.
		update_icon()	//I.E. fix the desc
		return

/obj/item/weapon/gun/twohanded/projectile/shotgun/pump/load_into_chamber()  //copy over the standard version, chambers itself after attacks
	return 0

/obj/item/weapon/gun/twohanded/projectile/shotgun/pump/combat
	name = "combat shotgun"
	icon_state = "cshotgun"
	max_shells = 8
	origin_tech = "combat=5;materials=2"
	ammo_type = "/obj/item/ammo_casing/shotgun"


/obj/item/weapon/gun/twohanded/projectile/shotgun/pump/riot
	name = "riot shotgun"
	icon_state = "cshotgun"
	max_shells = 8
	origin_tech = "combat=5;materials=2"
	ammo_type = "/obj/item/ammo_casing/shotgun/beanbag"


//PUMP SHOTGUN FLASHLIGHT CODE
// Moved to guns/projectile.dm

///obj/item/weapon/gun/twohanded/projectile/shotgun/pump/verb/toggle_light()
//	set name = "Toggle Flashlight"
//	set category = "Weapon"
//
//	if(haslight && !islighton) //Turns the light on
//		usr << "\blue You turn the flashlight on."
//		usr.SetLuminosity(gun_light)
//		islighton = 1
//	else if(haslight && islighton) //Turns the light off
//		usr << "\blue You turn the flashlight off."
//		usr.SetLuminosity(0)
//		islighton = 0
//	else if(!haslight) //Points out how stupid you are
//		usr << "\red You foolishly look at where the flashlight would be, if it was attached..."
//
///obj/item/weapon/gun/twohanded/projectile/shotgun/pump/riot/pickup(mob/user)//Transfers the lum to the user when picked up
//	if(islighton)
//		SetLuminosity(0)
//		usr.SetLuminosity(gun_light)
//
///obj/item/weapon/gun/twohanded/projectile/shotgun/pump/riot/dropped(mob/user)//Transfers the Lum back to the gun when dropped
//	if(islighton)
//		SetLuminosity(gun_light)
//		usr.SetLuminosity(0)
