
if (hasInterface) then {
	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\tSAdminTools\Settings.sqf";
	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\tSAdminTools\Functions.sqf";
	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\tSAdminTools\Functions - GSO Menu.sqf";
	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\tSAdminTools\Functions - Rapid Artillery Menu.sqf";
	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\tSAdminTools\Functions - IM and Respawn Menu.sqf";
	tSF_AdminTools_Rallypoints = [];
	tSF_AdminTools_TeleportListNeedUpdate = true;
	tSF_AdminTools_GSO_TeleportPositions = [];
	tSF_AdminTools_GSO_TeleportSelections = [];
	tSF_AdminTools_PLR_TeleportPositions = [];
	tSF_AdminTools_PLR_TeleportSelections = [];
	tSF_AdminTools_RapidArtillery_FiremissionCount = 0;
	
	[] spawn {
		while { true } do {
			call tSF_fnc_adminTools_checkAndUpdateCurrentAdmin;
			sleep 10;
		};	
	};

	[] spawn {
		tSF_adminTools_isKeyPressed = false;
		{
			_x spawn {
				waitUntil {!isNull (findDisplay _this)};
				(findDisplay _this) displayAddEventHandler ["KeyUp",  {call tSF_fnc_adminTools_handleKey}];
			};
		} forEach [
			46, 12249 /* 46 (game) | 12249 (ACE Spectator) */
		];
		
		[] spawn tSF_fnc_adminTools_handleGSOMenuOverZeusDisplay;
		[] spawn tSF_fnc_adminTools_handleGSOMenuOverSpectator;
		
		waitUntil { sleep 15; call tSF_fnc_adminTools_checkIsAdmin };
		
		tSF_GATList = (allVariables missionNamespace)  select {  
			["kit_", _x, false] call BIS_fnc_inString 
			&& !(["lkit_", _x, false] call BIS_fnc_inString)
			&& !(["cba_xeh", _x, false] call BIS_fnc_inString)
		};
		tSF_GATList pushBack "";
		
		call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\tSAdminTools\Functions Diag.sqf";
		call tSF_fnc_adminTools_addTopic;
		
		if (tSF_AdminTool_EnableMissionEndings) then { [] spawn dzn_fnc_adminTools_addMissionEndsControls; };			
		if (tSF_AdminTool_EnableGATTool) then { [] spawn dzn_fnc_adminTools_addGATControls; };
		[] spawn tSF_Diag_AddDiagTopic;
		
		[["<t color='#FFD000' align='center'>tSF GSO Tools Activated</t>"], [-20,-5,150,0.032], [0,0,0,.75], 30] call dzn_fnc_ShowMessage;
	};
};

if (isServer) then {
	tSF_fnc_adminTools_getFps = {
		sleep 15;		
		tSF_adminTools_serverFPS = round(diag_fps);
		publicVariable "tSF_adminTools_serverFPS";		
		[] spawn tSF_fnc_adminTools_getFps;
	};
	
	[] spawn tSF_fnc_adminTools_getFps;
};
