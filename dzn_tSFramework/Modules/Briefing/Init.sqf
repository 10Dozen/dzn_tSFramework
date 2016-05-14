// ********************
// INITIALIZATION
// ********************

waitUntil { !isNull findDisplay 52 || getClientState == "BRIEFING SHOWN" || time > 0 };
[] execVM "dzn_tSFramework\Modules\Briefing\tSF_Briefing.sqf";
