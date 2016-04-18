// ********************
// INITIALIZATION
// ********************

if (hasInterface) then {
	[] spawn {
		waitUntil { !isNil "ABM_trainedVeh" };
		ABM_trainedVeh = ABM_trainedVeh
			+ (call compile ("[" + preProcessFile "dzn_tSFramework\Modules\ABMExpand\ABMExpandData.sqf" + "]"));
	};
};
