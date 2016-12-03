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
 *				, @VehicleHoldBehaviour 	- (optional) one of the options:
						"hold"		- vehicle will provide overwatch around itself
						, "frontal"		- vehicle will provide overwatch in frontal -45/+45 sector
						, "full frontal"	- vehicle will provide overwatch in frontal -90/+90 sector
 *			]
 *		]
 *
 *	For example:
 *	[ "Ins DSHK Gunner", [ ["gunner"], EAST, "kit_ins_random", 0.7 ] ]
 */
#define	CREW_CONFIG_TABLE		tSF_EVC_CrewConfig = [
#define	CREW_CONFIG_TABLE_END		];

tSF_EVC_OPFOR_CrewSkill		= 0.75;
tSF_EVC_OPFOR_CrewKit		= "";
tSF_EVC_OPFOR_HoldType		= "full frontal";
 
CREW_CONFIG_TABLE
	[ 
		"NATO MRAP Crew"
		, [ 
			"driver"
			, west			
			, 0.7
			, "kit_nato_r"
		] 
	]
	, [ 
		"Ins BTR Crew"
		, [ 
			["driver","gunner"]
			, east			
			, 0.6
			, ""
			, "frontal"
		] 
	]

	/*
		Default presets
	*/
	,["OPFOR VC, GNR, DRV"	,[["commander","driver","gunner"], east, tSF_EVC_OPFOR_CrewSkill, tSF_EVC_OPFOR_CrewKit, tSF_EVC_OPFOR_HoldType]]
	,["OPFOR VC, DRV"		,[["commander","driver"], east, tSF_EVC_OPFOR_CrewSkill, tSF_EVC_OPFOR_CrewKit, tSF_EVC_OPFOR_HoldType]]
	,["OPFOR GNR, DRV"	,[["gunner","driver"], east, tSF_EVC_OPFOR_CrewSkill, tSF_EVC_OPFOR_CrewKit, tSF_EVC_OPFOR_HoldType]]
	,["OPFOR VC, GNR"		,[["commander","gunner"], east, tSF_EVC_OPFOR_CrewSkill, tSF_EVC_OPFOR_CrewKit, tSF_EVC_OPFOR_HoldType]]
	,["OPFOR VC"		,[["commander"], east, tSF_EVC_OPFOR_CrewSkill, tSF_EVC_OPFOR_CrewKit, tSF_EVC_OPFOR_HoldType]]
	,["OPFOR GNR"		,[["gunner"], east, tSF_EVC_OPFOR_CrewSkill, tSF_EVC_OPFOR_CrewKit, tSF_EVC_OPFOR_HoldType]]
	,["OPFOR DRV"		,[["driver"], east, tSF_EVC_OPFOR_CrewSkill, tSF_EVC_OPFOR_CrewKit, tSF_EVC_OPFOR_HoldType]]
	
CREW_CONFIG_TABLE_END

