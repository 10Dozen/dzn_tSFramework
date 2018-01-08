tSF_FARP_VehicleDefaultLoadouts = [];

if (isNil "tSF_FARP") exitWith { diag_log "tSF: No FARP allowed zones were set!" };

private _editorSetComposition = if (isNil "tSF_FARP_Composition") then { "" } else { tSF_FARP_Composition };
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\FARP\FARP Compositions.sqf";
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\FARP\Settings.sqf";
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\FARP\Functions.sqf";
if (_editorSetComposition != "") then { tSF_FARP_Composition = _editorSetComposition; };

if (hasInterface) then {
	"tSF_FARP_showNotAllowedText" addPublicVariableEventHandler {
		if (tSF_FARP_showNotAllowedText) then { [side player, "HQ"] commandChat format [tSF_FARP_STR_NotAllowedText, tSF_FARP_STR_ShortName] };
		tSF_FARP_showNotAllowedText = false;
	};
	"tSF_FARP_showAlreadySet" addPublicVariableEventHandler {
		if (tSF_FARP_showAlreadySet) then { [side player, "HQ"] commandChat format [tSF_FARP_STR_AlreadySet, tSF_FARP_STR_ShortName] };
		tSF_FARP_showAlreadySet = false;
	};
	"tSF_FARP_showSuccessSet" addPublicVariableEventHandler {
		if (tSF_FARP_showSuccessSet) then { [side player, "HQ"] commandChat format [tSF_FARP_STR_SuccessSet, tSF_FARP_STR_ShortName] };
		tSF_FARP_showSuccessSet = false;
	};
	
	[] spawn tSF_fnc_FARP_createFARP_Client;
};

if (isServer) then {
	if (!isNil "tSF_FARP") then {
		tSF_FARP_MarkersLastChecked = [];
		tSF_FARP_Placed = false;
		tSF_FARP_Marker = "";
		
		// Notifications
		tSF_FARP_showAlreadySet = true;
		tSF_FARP_showNotAllowedText = true;
		tSF_FARP_showSuccessSet = true;
		
		tSF_FARP_allowedAreaMarkers = call tSF_fnc_FARP_drawAllowedAreaMarkers;
		
		tSF_FARP_AllowedLocation = synchronizedObjects tSF_FARP;
		
		// Handle markers on briefing
		if !(tSF_FARP_AllowedLocation isEqualTo []) then {
			tSF_FARP_BriefingHelperEH = addMissionEventHandler ["EachFrame", {
				if (count tSF_FARP_MarkersLastChecked == count allMapMarkers) exitWith {};
				private _markersToCheck = allMapMarkers - tSF_FARP_MarkersLastChecked;
				tSF_FARP_MarkersLastChecked = allMapMarkers;
				
				{
					if (toLower(markerText _x) == "farp") then {
						if (tSF_FARP_Placed && markerText tSF_FARP_Marker != "") then {						
							if (tSF_FARP_Marker != _x) then { 
								[side player, "HQ"] commandChat format [tSF_FARP_STR_AlreadySet, tSF_FARP_STR_ShortName];
								publicVariable "tSF_FARP_showAlreadySet";
								deleteMarker _x;
							};
						} else {
							if ([getMarkerPos _x, tSF_FARP_AllowedLocation] call dzn_fnc_isInLocation) then {
								tSF_FARP_Placed = true;
								tSF_FARP_Marker = _x;
								[side player, "HQ"] commandChat format [tSF_FARP_STR_SuccessSet, tSF_FARP_STR_ShortName];
								publicVariable "tSF_FARP_showSuccessSet";
							} else {
								[side player, "HQ"] commandChat format [tSF_FARP_STR_NotAllowedText, tSF_FARP_STR_ShortName];
								publicVariable "tSF_FARP_showNotAllowedText";							
								deleteMarker _x;
							};
						};
					};
				} forEach _markersToCheck;
			}];
		};
		
		[] spawn { 
			waitUntil { time > 1 };
			tSF_FARP_allowedAreaMarkers call tSF_fnc_FARP_removeAllowedAreaMarkers;			
			if (!isNil "tSF_FARP_BriefingHelperEH") then {
				removeMissionEventHandler ["EachFrame", tSF_FARP_BriefingHelperEH];
			};
			
			tSF_FARP_Position = call tSF_fnc_FARP_findAndUpdateMarker;			
			
			[
				tSF_FARP_Position
				, [tSF_FARP_Compositions, tSF_FARP_Composition] call dzn_fnc_getValueByKey
			] spawn tSF_fnc_FARP_createFARP_Server;
			
			publicVariable "tSF_FARP_Position";
		};
	};
	
	"tSF_FARP_MakeOwner" addPublicVariableEventHandler {
		private _owner = _this select 1 select 0;
		private _obj = _this select 1 select 1;
		
		_obj setOwner _owner;
	};
};
