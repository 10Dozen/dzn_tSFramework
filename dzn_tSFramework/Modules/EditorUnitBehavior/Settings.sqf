tSF_EUB_initTimeout	=	20;


/*
 *	Surrender Behavior (ACE dependency)
 *
 *	Unit surrender when player are nearby 
 *		tSF_EUB_surrender_OnHit					- make unit surrender after hit
 *		tSF_EUB_surrender_OnHit_PlayerCloseOnly		- make unit surrender after hit only when players are nearby (3 x tSF_EUB_surrender_PlayerDistance meters)
 *		tSF_EUB_surrender_PlayerDistance			- min distance of nearby players to make unit surrender
 */
 
tSF_EUB_surrender_OnHit 					= true;
tSF_EUB_surrender_OnHit_PlayerCloseOnly			= true;
tSF_EUB_surrender_PlayerDistance				= 10;	// meters





/*
 * *********************************
 * Description of the module
 * *********************************
 */
tSF_EUB_Schema = [
	/* Module name */	"Editor Unit Behavior"
	,[
		/* Module Settings */
		[
			/* Setting */		"tSF_EUB_surrender_OnHit"
			/* Description */	, "Surrender - Make unit Surrender on hit"
			/* Type */			, "bool"
		]
		, 
		[
			/* Setting */		"tSF_EUB_surrender_OnHit_PlayerCloseOnly"
			/* Description */	, "Surrender - Make unit surrender only if player near"
			/* Type */			, "bool"
		]
		, 
		[
			/* Setting */		"tSF_EUB_surrender_PlayerDistance"
			/* Description */	, "Surrender - Min. distance to make unit surrender"
			/* Type */			, "distance"
		]
		, [
			/* Setting */		"tSF_EUB_initTimeout"
			/* Description */	, "Timeout before initialization"
			/* Type */			, "time"
		]
	]
];
