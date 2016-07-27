call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\MissionDefaults\Settings.sqf";

// ********************
// INITIALIZATION
// ********************
enableSaving [false,false];
player addRating 1000000;

if (hasInterface && tSF_MissionDefaults_DisableInputOnStart) then {
	[] spawn {
		waitUntil { time > 0 };
		
		disableUserInput true;
		for "_i" from 0 to tSF_MissionDefaults_DisableInputTimer do {
			hintSilent parseText  format [
				"<t color='#FFE240' font='PuristaLight'>Начало через %1 сек</t>%2"
				, tSF_MissionDefaults_DisableInputTimer - _i
				, "<br /><t color='#AAAAAA' font='PuristaLight' size='0.8'>" + tSF_MissionDefaults_SubtitleText + "</t>"
			];		
			sleep 1;
		};
		
		disableUserInput false;
		hintSilent parseText "<t color='#FFE240' font='PuristaLight'>Удачной Игры!</t>";		
	};

	[] spawn {
		if !(tSF_MissionDefaults_PutEarplugsOn) exitWith {};
		waitUntil {!isNull player};
		player call ace_hearing_fnc_putInEarplugs;
	};

	[] spawn {
    	if !(tSF_MissionDefaults_PutWeaponSafe) exitWith {};
    	waitUntil {!isNull player};
    	player selectWeapon "ACE_Safe";
    };

	/*
	[] spawn {
       	if !(tSF_MissionDefaults_ReplaceFlashbangs) exitWith {};
       	waitUntil {!isNull player};
       	tSF_MissionDefaults_canChangeFlashbangs = false;
       	tSF_MissionDefaults_fnc_waitToCheck = {
       	    tSF_MissionDefaults_canChangeFlashbangs = false;
       	    sleep 30;
       	    tSF_MissionDefaults_canChangeFlashbangs = true;
      	};

      	tSF_MissionDefaults_fnc_changeFlashbangs = {

      	   //	 rhs_mag_mk84
      	   //	 ACE_M84

			//	- Get inventory
			//	- Find rhs_mag_mk84
			//	- count it
			//	- remove all rhs_mag_mk84
			//	- assign back
			//	[player, [missionNamespace, "tSF_MissionDefaults_Inventory"]] call BIS_fnc_saveInventory;
      	};

       	// OnEachFrame - replace item
       	["tSF_MissionDefaults_HandleFlashbangsItems", "onEachFrame", {

       	}] call BIS_fnc_addStackedEventHandler;
	};
	*/
};

