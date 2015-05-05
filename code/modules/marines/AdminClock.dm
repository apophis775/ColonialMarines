//This contains EVERYTHING for the clockin/clockout verb. - Apophis775 25APR2015 version
//Should be compatiable with pretty much every byond ever.
//will add 2 verbs to the admin panel, Clock In and Clock Out.


var/clockInLog = null //Variable to track the log file

/proc/clock_in(text) //To see when admins Clock In
	if (config.log_access)
		clockInLog << "\[[time_stamp()]] Clock in: [text]"


/proc/clock_out(text) //To see when admins Clock Out
	if (config.log_access)
		clockInLog << "\[[time_stamp()]] Clock Out: [text]"


/client/proc/Clock_In() // Proc to clock in
	set category = "Admin"
	set name = "Clock In"
	set desc = "Clock In to track your time working"
	clock_in("[key_name(usr)]")
	message_admins("\blue [key_name_admin(usr)] has clocked in", 1)

/client/proc/Clock_Out() // Proc to clock in
	set category = "Admin"
	set name = "Clock Out"
	set desc = "Clock Out to end your time working"
	clock_out("[key_name(usr)]")
	message_admins("\blue [key_name_admin(usr)] has clocked out", 1)


//THESE MUST BE ADDED TO THE MAIN CODE:



//To world.dm in the world/new proc.  Anywhere works, so long as it's below the var/date_time
/*
	clockInLog = file("data/logs/ClockInLog/ [date_string].log") //Part of the AdminClock plugin
*/

//To admin_verbs.dm to whichever level of staff you want to have the ability, so that it appears as a verb:
/*
	/client/proc/Clock_In,
	/client/proc/Clock_Out,
*/






