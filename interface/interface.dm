//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/verb/wiki()
	set name = "wiki"
	set desc = "Visit the wiki."
	set hidden = 1
	if( config.wikiurl )
		if(alert("This will open the wiki in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.wikiurl)
	else
		src << "\red The wiki URL is not set in the server configuration."
	return

/client/verb/forum()
	set name = "forum"
	set desc = "Visit the forum."
	set hidden = 1
	if( config.forumurl )
		if(alert("This will open the forum in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.forumurl)
	else
		src << "\red The forum URL is not set in the server configuration."
	return

/client/verb/rbug()
	set name = " rbug"
	set desc = "Report a bug."
	set hidden = 1
	//src << browse(file(RULES_FILE), "window=rules;size=480x320")
	src << link("http://newedenstation.com/showthread.php?tid=555")


#define RULES_FILE "config/rules.html"
/client/verb/rules()
	set name = "Rules"
	set desc = "Show Server Rules."
	set hidden = 1
	//src << browse(file(RULES_FILE), "window=rules;size=480x320")
	src << link("http://newedenstation.com/showthread.php?tid=558&pid=2356#pid2356")
#undef RULES_FILE

/client/verb/donate()
	set name = "Donate"
	set category = "OOC"

	src << "Our server runs entirely off of player donations. If you donate, you can receive cosmetic items for your character. Including armor, helmets, boots, and uniforms. The item will be made custom for you.<br>The minimum amount to donate is $5 to receive your item. Our server currently costs $37.50 a month, and I want to upgrade it to be able to better handle the load of a new server.<br>Here is our donation page:<br>http://newedenstation.com/donate.php<br>If you have any questions regarding donation, you can ahelp and ask.<br><br>Thank you,<br>Jaggerestep"

/client/verb/hotkeys_help()
	set name = "hotkeys-help"
	set category = "OOC"

	var/hotkey_mode = {"<font color='purple'>
Hotkey-Mode: (hotkey-mode must be on)
\tTAB = toggle hotkey-mode
\ta = left
\ts = down
\td = right
\tw = up
\tq = drop
\te = equip
\tr = throw
\tt = say
\tx = swap-hand
\tz = activate held object (or y)
\tf = cycle-intents-left
\tg = cycle-intents-right
\t1 = help-intent
\t2 = disarm-intent
\t3 = grab-intent
\t4 = harm-intent
</font>"}

	var/other = {"<font color='purple'>
Any-Mode: (hotkey doesn't need to be on)
\tCtrl+a = left
\tCtrl+s = down
\tCtrl+d = right
\tCtrl+w = up
\tCtrl+q = drop
\tCtrl+e = equip
\tCtrl+r = throw
\tCtrl+x = swap-hand
\tCtrl+z = activate held object (or Ctrl+y)
\tCtrl+f = cycle-intents-left
\tCtrl+g = cycle-intents-right
\tCtrl+1 = help-intent
\tCtrl+2 = disarm-intent
\tCtrl+3 = grab-intent
\tCtrl+4 = harm-intent
\tDEL = pull
\tINS = cycle-intents-right
\tHOME = drop
\tPGUP = swap-hand
\tPGDN = activate held object
\tEND = throw
</font>"}

	var/admin = {"<font color='purple'>
Admin:
\tF5 = Asay
\tF6 = player-panel-new
\tF7 = game-panel
\tF8 = admin-pm
\tF9 = invisimin
</font>"}

	src << hotkey_mode
	src << other
	if(holder)
		src << admin
