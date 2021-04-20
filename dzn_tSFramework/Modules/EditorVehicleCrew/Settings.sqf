#include "data\script_component.hpp"

/* Dependency: No
 */

// Delay before initializations
GVAR(initTimeout)     = 1;
GVAR(initCondition)   = { true };

// Default settings
GVAR(OPFOR_Side)      = east; // west, east, resistance, civilian
GVAR(OPFOR_CrewSkill) = 0.75;
GVAR(OPFOR_CrewKit)   = "";
GVAR(OPFOR_HoldType)  = "full frontal";


#define	CREW_CONFIG_TABLE GVAR(CrewConfig) = [
#define	CREW_CONFIG_TABLE_END ];
#define OPFOR_CREW_CONFIG_DEFAULT GVAR(OPFOR_Side),GVAR(OPFOR_CrewSkill),GVAR(OPFOR_CrewKit),GVAR(OPFOR_HoldType)

/*
 *	Sync editor placed vehicles with GameLogics and add var with config name: this setVariable ["tSF_EVC", "Ins DSHK Gunner"]
 *	For all synched vehicles -- crew will be spawned.
 *
 *	List of Configs in format
 *		[
 *			@ConfigName		- string, e.g. "Ins DSHK Gunner"
 *			, [
 *				@Roles 		- e.g. ["driver", "gunner", "commander","cargo"] or "gunner"
 *				, @Side		- e.g. west, east, resistance, civilian
 *				, @Skill	- e.g. simple skill (number from 0 to 1)
 *				, @Kit		- (optional) e.g. dzn_gear kit ("" if not used)
 *				, @VehicleHoldBehaviour - (optional) one of the options:
 *						"hold"			- vehicle will provide overwatch around itself
 *						"frontal"		- vehicle will provide overwatch in frontal -45/+45 sector
 *						"full frontal"	- vehicle will provide overwatch in frontal -90/+90 sector
 *				, @CrewmanClass - (optional) classname for crewman class
 *			]
 *		]
 */
CREW_CONFIG_TABLE
	/*
		Default presets
	*/
	["OPFOR VC, GNR, DRV"	,[["commander","driver","gunner"], OPFOR_CREW_CONFIG_DEFAULT]]
	,["OPFOR VC, DRV"		,[["commander","driver"], OPFOR_CREW_CONFIG_DEFAULT]]
	,["OPFOR GNR, DRV"		,[["gunner","driver"], OPFOR_CREW_CONFIG_DEFAULT]]
	,["OPFOR VC, GNR"		,[["commander","gunner"], OPFOR_CREW_CONFIG_DEFAULT]]
	,["OPFOR VC"			,[["commander"], OPFOR_CREW_CONFIG_DEFAULT]]
	,["OPFOR GNR"			,[["gunner"], OPFOR_CREW_CONFIG_DEFAULT]]
	,["OPFOR DRV"			,[["driver"], OPFOR_CREW_CONFIG_DEFAULT]]

	/*
	Example of custom config:
	[
		"NATO MRAP Crew" // Config Name
		, [
			"driver"			// Roles
			, west				// Side
			, 0.7				// Skill
			, "_kit_nato_r"		// dzn_gear kit name
			, "frontal"			// dzn_dynai behavior
			, "B_Soldier_F"		// Crew classname
		]
	]
	*/
CREW_CONFIG_TABLE_END
