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
				, "<br /><t color='#AAAAAA' font='PuristaLight' size='0.8'>Управление отключено, не паникуй</t>"
			];		
			sleep 1;
		};
		
		disableUserInput false;
		hintSilent parseText "<t color='#FFE240' font='PuristaLight'>Удачной Игры!</t>";		
	};
};
