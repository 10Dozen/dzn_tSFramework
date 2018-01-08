// ********************
// INITIALIZATION
// ********************

if (isNil "tsf_CCP") exitWith { diag_log "No CCP allowed zones were set!" };

private _editorSetComposition = if (isNil "tSF_CCP_Composition") then { "" } else { tSF_CCP_Composition };
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\CCP\Settings.sqf";
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\CCP\CCP Compositions.sqf";
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\CCP\Functions.sqf";
if (_editorSetComposition != "") then { tSF_CCP_Composition = _editorSetComposition; };

if (hasInterface) then {
	"tSF_CCP_showNotAllowedText" addPublicVariableEventHandler {
		if (tSF_CCP_showNotAllowedText) then { [side player, "HQ"] commandChat format [tSF_CCP_STR_NotAllowedText, tSF_CCP_STR_FullName] };
		tSF_CCP_showNotAllowedText = false;
	};
	"tSF_CCP_showAlreadySet" addPublicVariableEventHandler {
		if (tSF_CCP_showAlreadySet) then { [side player, "HQ"] commandChat format [tSF_CCP_STR_AlreadySet, tSF_CCP_STR_FullName] };
		tSF_CCP_showAlreadySet = false;
	};
	"tSF_CCP_showSuccessSet" addPublicVariableEventHandler {
		if (tSF_CCP_showSuccessSet) then { [side player, "HQ"] commandChat format [tSF_CCP_STR_SuccessSet, tSF_CCP_STR_FullName] };
		tSF_CCP_showSuccessSet = false;
	};
	
	[] spawn tSF_fnc_CCP_createCCP_Client;
};

if (isServer) then {
	if (!isNil "tsf_CCP") then {
		tSF_tSF_CCP_MarkersLastChecked = [];
		tSF_CCP_Placed = false;
		tSF_CCP_Marker = "";
		
		// Notifications
		tSF_CCP_showAlreadySet = true;
		tSF_CCP_showNotAllowedText = true;
		tSF_CCP_showSuccessSet = true;
		
		tSF_CCP_allowedAreaMarkers = call tSF_fnc_CCP_drawAllowedAreaMarkers;
		
		tSF_CCP_AllowedLocation = synchronizedObjects tsf_CCP;		
		
		// Handle markers on briefing
		if !(tSF_CCP_AllowedLocation isEqualTo []) then {
			tSF_CCP_BriefingHelperEH = addMissionEventHandler ["EachFrame", {
				if (count tSF_tSF_CCP_MarkersLastChecked == count allMapMarkers) exitWith {};
				private _markersToCheck = allMapMarkers - tSF_tSF_CCP_MarkersLastChecked;
				tSF_tSF_CCP_MarkersLastChecked = allMapMarkers;
				
				{
					if (toLower(markerText _x) == "ccp") then {
						if (tSF_CCP_Placed && markerText tSF_CCP_Marker != "") then {						
							if (tSF_CCP_Marker != _x) then { 
								[side player, "HQ"] commandChat format [tSF_CCP_STR_SuccessSet, tSF_CCP_STR_FullName];
								publicVariable "tSF_CCP_showAlreadySet";
								deleteMarker _x;
							};
						} else {
							if ([getMarkerPos _x, tSF_CCP_AllowedLocation] call dzn_fnc_isInLocation) then {
								tSF_CCP_Placed = true;
								tSF_CCP_Marker = _x;
								[side player, "HQ"] commandChat format [tSF_CCP_STR_SuccessSet, tSF_CCP_STR_FullName];
								publicVariable "tSF_CCP_showSuccessSet";
							} else {
								[side player, "HQ"] commandChat format [tSF_CCP_STR_NotAllowedText, tSF_CCP_STR_FullName];
								publicVariable "tSF_CCP_showNotAllowedText";							
								deleteMarker _x;
							};
						};
					};
				} forEach _markersToCheck;
			}];
		};
		
		[] spawn { 
			waitUntil { time > 1 };
			tSF_CCP_allowedAreaMarkers call tSF_fnc_CCP_removeAllowedAreaMarkers;
			if (!isNil "tSF_CCP_BriefingHelperEH") then {
				removeMissionEventHandler ["EachFrame", tSF_CCP_BriefingHelperEH];
			};
			
			tSF_CCP_Position = call tSF_fnc_CCP_findAndUpdateMarker;
			
			[
				tSF_CCP_Position
				, [tSF_CCP_Compositions, tSF_CCP_Composition] call dzn_fnc_getValueByKey
			] spawn tSF_fnc_CCP_createCCP_Server;
			
			publicVariable "tSF_CCP_Position";
		};
	};		
};

