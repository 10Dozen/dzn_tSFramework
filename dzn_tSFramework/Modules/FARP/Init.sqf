FARP_Init = "IN PROGRESS";
if (isNil "tsf_FARP") exitWith { diag_log "tSF: No FARP allowed zones were set!" };

call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\FARP\Settings.sqf";
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\FARP\FARP Compositions.sqf";
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\FARP\Functions.sqf";

if (hasInterface) then {
	"FARP_showNotAllowedText" addPublicVariableEventHandler {
		if (FARP_showNotAllowedText) then { [side player, "HQ"] commandChat tSF_FARP_STR_NotAllowedText };
		FARP_showNotAllowedText = false;
	};
	"FARP_showAlreadySet" addPublicVariableEventHandler {
		if (FARP_showAlreadySet) then { [side player, "HQ"] commandChat tSF_FARP_STR_AlreadySet };
		FARP_showAlreadySet = false;
	};
	"FARP_showSuccessSet" addPublicVariableEventHandler {
		if (FARP_showSuccessSet) then { [side player, "HQ"] commandChat tSF_FARP_STR_SuccessSet };
		FARP_showSuccessSet = false;
	};
	
	[] spawn tSF_fnc_FARP_createFARP_Client;
};

if (isServer) then {
	if (!isNil "tsf_FARP") then {
		FARP_MarkersLastChecked = [];
		FARP_Placed = false;
		FARP_Marker = "";
		
		// Notifications
		FARP_showAlreadySet = true;
		FARP_showNotAllowedText = true;
		FARP_showSuccessSet = true;
		
		FARP_allowedAreaMarkers = call tSF_fnc_FARP_drawAllowedAreaMarkers;
		
		FARP_AllowedLocation = synchronizedObjects tsf_FARP;
		
		// Handle markers on briefing
		if !(FARP_AllowedLocation isEqualTo []) then {
			tSF_FARP_BriefingHelperEH = addMissionEventHandler ["EachFrame", {
				if (count FARP_MarkersLastChecked == count allMapMarkers) exitWith {};
				private _markersToCheck = allMapMarkers - FARP_MarkersLastChecked;
				FARP_MarkersLastChecked = allMapMarkers;
				
				{
					if (toLower(markerText _x) == "ccp") then {
						if (FARP_Placed && markerText FARP_Marker != "") then {						
							if (FARP_Marker != _x) then { 
								[side player, "HQ"] commandChat tSF_FARP_STR_AlreadySet;
								publicVariable "FARP_showAlreadySet";
								deleteMarker _x;
							};
						} else {
							if ([getMarkerPos _x, FARP_AllowedLocation] call dzn_fnc_isInLocation) then {
								FARP_Placed = true;
								FARP_Marker = _x;
								[side player, "HQ"] commandChat tSF_FARP_STR_SuccessSet;
								publicVariable "FARP_showSuccessSet";
							} else {
								[side player, "HQ"] commandChat tSF_FARP_STR_NotAllowedText;
								publicVariable "FARP_showNotAllowedText";							
								deleteMarker _x;
							};
						};
					};
				} forEach _markersToCheck;
			}];
		};
		
		[] spawn { 
			waitUntil { time > 1 };
			FARP_allowedAreaMarkers call tSF_fnc_FARP_removeAllowedAreaMarkers;			
			removeMissionEventHandler ["EachFrame", tSF_FARP_BriefingHelper];
			
			tSF_FARP_Position = call tSF_fnc_FARP_findMarker;			
			
			[
				tSF_FARP_Position
				, [tSF_FARP_Compositions, tSF_FARP_Composition] call dzn_fnc_getValueByKey
			] spawn tSF_fnc_FARP_createFARP_Server;
			
			publicVariable "tSF_FARP_Position";
		};
	};		
};

FARP_Init = "DONE";
