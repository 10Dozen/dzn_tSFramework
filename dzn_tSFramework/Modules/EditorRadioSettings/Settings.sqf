tSF_ERS_initTimeout	=	5;


/*
 *	Surrender Behavior (ACE dependency)
 *
 *	Unit surrender when player are nearby 
 *		tSF_EUB_surrender_OnHit					- make unit surrender after hit
 *		tSF_EUB_surrender_OnHit_PlayerCloseOnly		- make unit surrender after hit only when players are nearby (3 x tSF_EUB_surrender_PlayerDistance meters)
 *		tSF_EUB_surrender_PlayerDistance			- min distance of nearby players to make unit surrender
 */
 tSF_ERS_BLUFOR_LRRadioType		= "tf_rt1523g";
 tSF_ERS_BLUFOR_LRRange			= 30000; // meters
 tSF_ERS_BLUFOR_LRIsolated		= 0.5;
 
 
 tSF_ERS_LRRadioConfig = [
 	[west, [
 
 
 ];
 
 
 
dzn_fnc_tfar_setVehicleLR = {
	// [@Vehicle, @Side, @IsolatedAmount, @Range, @RadioType]
	params["_veh", ["_side",west],["_isolated",0.5], ["_range", 30000], ["_type", "tf_rt1523g"]];

	_veh setVariable ["tf_side", _side, true];
	_veh setVariable ["tf_hasRadio", true, true];
	_veh setVariable ["tf_isolatedAmount", _isolated, true];
	_veh setVariable ["tf_range", _range, true];
	_veh setVariable ["TF_RadioType", _type, true];
};
