tSF_EVC_initTimeout	=	20;

/*
 *	Sync editor placed vehicles with GameLogics and add var with config name: this setVariable ["tSF_EVC", "Ins DSHK Gunner"]
 *	For all synched vehicles -- crew will be spawned.
 *
 *	List of Configs in format
 *		[ 
 *			@ConfigName		- string, e.g. "Ins DSHK Gunner"
 *			, [
 *				@Roles 	- e.g. ["driver", "gunner", "commander","cargo"] or "gunner"
 *				, @Side	- e.g. west, east, resistance, civilian
 *				, @Skill	- e.g. simple skill (number from 0 to 1)
 *				, @Kit	- e.g. dzn_gear kit ("" if not used) *				
 *				, @DynaiBehaviour 	- if TRUE -- assign dzn_Dynai Vehicle Hold behavior
 *			]
 *		]
 *
 *	For example:
 *	[ "Ins DSHK Gunner", [ ["gunner"], EAST, "kit_ins_random", 0.7 ] ]
 */
tSF_EVC_CrewConfig = [	
	[ 
		"NATO MRAP Crew"
		, [ 
			"driver"
			, west			
			, 0.7
			, ""
			, false
		] 
	]
	, [ 
		"Ins BTR Crew"
		, [ 
			["driver","gunner"]
			, east			
			, 0.6
			, "kit_ins_crew"
			, false
		] 
	]
];

