
if (hasInterface) then {
	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\tSAdminTools\Settings.sqf";
	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\tSAdminTools\Functions.sqf";
	tSF_AdminTools_Rallypoints = [];
	tSF_AdminTools_TeleportListNeedUpdate = true;
	tSF_AdminTools_GSO_TeleportPositions = [];
	tSF_AdminTools_GSO_TeleportSelections = [];
	tSF_AdminTools_PLR_TeleportPositions = [];
	tSF_AdminTools_PLR_TeleportSelections = [];
	tSF_AdminTools_RapidArtillery_FiremissionCount = 0;

	if (tSF_AdminTool_EnableMissionEndings || tSF_AdminTool_EnableGATTool) then {
		[] spawn {
			waitUntil { sleep 15; call dzn_fnc_adminTools_checkIsAdmin };
			tSF_GATList = (allVariables missionNamespace)  select {  
				["kit_", _x, false] call BIS_fnc_inString 
				&& !(["lkit_", _x, false] call BIS_fnc_inString)
				&& !(["cba_xeh", _x, false] call BIS_fnc_inString)
			};
			tSF_GATList pushBack "";
			
			call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\tSAdminTools\Functions Diag.sqf";
			call dzn_fnc_adminTools_addTopic;
			
			if (tSF_AdminTool_EnableMissionEndings) then { [] spawn dzn_fnc_adminTools_addMissionEndsControls; };			
			if (tSF_AdminTool_EnableGATTool) then { [] spawn dzn_fnc_adminTools_addGATControls; };
			[] spawn tSF_Diag_AddDiagTopic;
			
			tSF_adminTools_isKeyPressed = false;
			{
				_x spawn {
					waitUntil {!isNull (findDisplay _this)};
					(findDisplay _this) displayAddEventHandler ["KeyUp",  {call tSF_fnc_adminTools_handleKey}];
				};
			} forEach [
				46, 60492, 12249 /* 46 (game) | 60492 (spectator arma) | 12249 (ACE Spectator) */
			];			
			[] spawn tSF_fnc_adminTools_handleGSOMenuOverZeusDisplay;
		};
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
