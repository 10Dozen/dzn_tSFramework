
if (hasInterface) then {
	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\tSAdminTools\Settings.sqf";
	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\tSAdminTools\Functions.sqf";
	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\tSAdminTools\Functions Diag.sqf";

	if (tSF_AdminTool_EnableMissionEndings || tSF_AdminTool_EnableGATTool) then {
		[] spawn {
			waitUntil { sleep 15; call dzn_fnc_adminTools_checkIsAdmin };
			call dzn_fnc_adminTools_addTopic;
			
			if (tSF_AdminTool_EnableMissionEndings) then {			
				[] spawn dzn_fnc_adminTools_addMissionEndsControls;
			};
			
			if (tSF_AdminTool_EnableGATTool) then {
				[] spawn dzn_fnc_adminTools_addGATControls;			
			};
			
			[] spawn tSF_Diag_AddDiagTopic;
		};
	};
};
