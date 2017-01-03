tSF_Briefing_ShowRoster			= 	true;
tSF_Briefing_RosterTimeout		=	-1;

tSF_Briefing_UpdateRosterOnJIP 	=	false;



/*
 * *********************************
 * Description of the module
 * *********************************
 */
tSF_Briefing_Schema = [
	/* Module name */	"Briefing"
	,[
		/* Module Settings */
		[
			/* Setting */		"tSF_Briefing_ShowRoster"
			/* Description */	, "Show Roster"
			/* Type */			, "bool"
		]
		, [
			/* Setting */		"tSF_Briefing_RosterTimeout"
			/* Description */	, "Timeout before roster displayed"
			/* Type */			, "time"
		]
		, [
			/* Setting */		"tSF_Briefing_UpdateRosterOnJIP"
			/* Description */	, "Update roster on JIP"
			/* Type */			, "bool"
		]
	]
];
