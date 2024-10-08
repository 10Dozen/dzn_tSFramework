#include "data\script_component.hpp"

waitUntil { DZN_DYNAI_RUNNING && !isNil "dzn_dynai_owner" };

if (clientOwner == dzn_dynai_owner) then {
	// Compile Dynai Remote API on Dnyai owner (e.g. server or headless)
    [] call compileScript ["dzn_tSFramework\Modules\tSAdminTools\data\Functions - Dynai Control Remote.sqf"];
};

if (hasInterface) then {
	call compileScript ["dzn_tSFramework\Modules\tSAdminTools\Settings.sqf"];
	call compileScript ["dzn_tSFramework\Modules\tSAdminTools\Functions.sqf"];
	call compileScript ["dzn_tSFramework\Modules\tSAdminTools\Functions - GSO Menu.sqf"];
	call compileScript ["dzn_tSFramework\Modules\tSAdminTools\Functions - Rapid Artillery Menu.sqf"];
	call compileScript ["dzn_tSFramework\Modules\tSAdminTools\Functions - IM and Respawn Menu.sqf"];
	call compileScript ["dzn_tSFramework\Modules\tSAdminTools\Functions - Dynai Control.sqf"];

	tSF_AdminTools_Rallypoints = createHashMap;
	tSF_AdminTools_TeleportListNeedUpdate = true;
	tSF_AdminTools_GSO_TeleportPositions = [];
	tSF_AdminTools_GSO_TeleportSelections = [];
	tSF_AdminTools_PLR_TeleportPositions = [];
	tSF_AdminTools_PLR_TeleportSelections = [];
	tSF_AdminTools_RapidArtillery_FiremissionCount = 0;

    tSF_AdminTools_Timers = createHashMap;
	[{ [] call tSF_fnc_adminTools_uiUpdateLoop; }, tSF_AdminTools_uiLoop_Timeout] call CBA_fnc_addPerFrameHandler;
	[{ [] call tSF_fnc_adminTools_checkAndUpdateCurrentAdmin; }, 10] call CBA_fnc_addPerFrameHandler;

	[] spawn {
		tSF_adminTools_isKeyPressed = false;
		{
			_x spawn {
				waitUntil {!isNull (findDisplay _this)};
				(findDisplay _this) displayAddEventHandler ["KeyUp",  {call tSF_fnc_adminTools_handleKey}];
			};
		} forEach [
			46,  60492, 12249 /* 46 (game) |  60492 (EGSpectator, A3) | 12249 (ACE Spectator) */
		];

		[] spawn tSF_fnc_adminTools_handleGSOMenuOverZeusDisplay;
		[] spawn tSF_fnc_adminTools_handleGSOMenuOverSpectator;

		waitUntil { 
			sleep 15; 
			call tSF_fnc_adminTools_checkIsAdmin 
		};

		tSF_GATList = [] call tSF_fnc_adminTools_getPersonalGearKits;

		[] call compileScript ["dzn_tSFramework\Modules\tSAdminTools\Functions Diag.sqf"];
		[] call tSF_fnc_adminTools_addTopic;

		if (tSF_AdminTool_EnableMissionEndings) then { [] spawn dzn_fnc_adminTools_addMissionEndsControls; };
		if (tSF_AdminTool_EnableGATTool) then { [] spawn dzn_fnc_adminTools_addGATControls; };

		// -- Timers
		[{ [] call tSF_fnc_adminTools_timers_handleTimers; }, 1] call CBA_fnc_addPerFrameHandler;
        [] call tSF_fnc_adminTools_addTimerControls;
		
		// -- Add mission timer, adjust time according to passed mission time on server (CBA_missionTime value)
  		[
			'Mission', 
			tSF_AdminTools_timers_MissionTimer - CBA_missionTime,
			false 
		] call tSF_fnc_adminTools_timers_addTimer;

		[] spawn tSF_Diag_AddDiagTopic;

		[
			["<t color='#FFD000' align='center'>tSF GSO Tools Activated</t>"], 
			[-20,-5,150,0.032], 
			[0,0,0,.75], 30
		] call dzn_fnc_ShowMessage;

		// Start DynAI Control Panel
		waitUntil { sleep 5; !isNil "dzn_dynai_initialized" && { dzn_dynai_initialized } };
		[] call FUNC(DC_RequestDynaiData);
		[] call tSF_adminTools_DC_addDynaiControlPage;
	};
};

if (isServer) then {
	[
		{
			tSF_adminTools_serverFPS = round(diag_fps);
			publicVariable "tSF_adminTools_serverFPS";
		},
		15
	] call CBA_fnc_addPerFrameHandler;

	// -- Test when in MP editor 
	if (hasInterface) then {
		["CBA_loadingScreenDone", {
			[{
				call compileScript ["dzn_tSFramework\Modules\tSAdminTools\data\Functions - Test.sqf"];
				[] call FUNC(testEntities);
			},[],5] call CBA_fnc_waitAndExecute;
		}] call CBA_fnc_addEventHandler;
	};
};
