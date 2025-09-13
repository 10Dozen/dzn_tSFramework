
tSF_EUB_initTimeout	=	20;


/*
 *	Surrender Behavior (ACE dependency)
 *
 *	Unit surrender when player are nearby 
 *		tSF_EUB_surrender_OnHit					- make unit surrender after hit
 *		tSF_EUB_surrender_OnHit_PlayerCloseOnly		- make unit surrender after hit only when players are nearby (3 x tSF_EUB_surrender_PlayerDistance meters)
 *		tSF_EUB_surrender_PlayerDistance			- min distance of nearby players to make unit surrender
 *
 *	To assign by scripts use: 	@Unit remoteExec ["tSF_fnc_EUB_assignCaptiveBehavior", 2];
 */
 
tSF_EUB_surrender_OnHit 					= true;
tSF_EUB_surrender_OnHit_PlayerCloseOnly			= true;
tSF_EUB_surrender_PlayerDistance				= 10;	// meters
