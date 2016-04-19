// ********************
// INITIALIZATION
// ********************

CCP_Init = "IN PROGRESS";
if (isNil "tsf_CCP") exitWith { diag_log "No CCP allowed zones were set!" };

call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\CCP\Settings.sqf";
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\CCP\DefaultCompositions.sqf";
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\CCP\Functions.sqf";

if (hasInterface) then {
	"CCP_showNotAllowedText" addPublicVariableEventHandler {
		if (CCP_showNotAllowedText) then { [side player, "HQ"] commandChat dzn_tsf_CCP_STR_NotAllowedText };
		CCP_showNotAllowedText = false;
	};
	"CCP_showAlreadySet" addPublicVariableEventHandler {
		if (CCP_showAlreadySet) then { [side player, "HQ"] commandChat dzn_tsf_CCP_STR_AlreadySet };
		CCP_showAlreadySet = false;
	};
	"CCP_showSuccessSet" addPublicVariableEventHandler {
		if (CCP_showSuccessSet) then { [side player, "HQ"] commandChat dzn_tsc_CCP_STR_SuccessSet };
		CCP_showSuccessSet = false;
	};
};

if (isServer) then {
	if (!isNil "tsf_CCP") then {
		CCP_MarkersLastChecked = [];
		CCP_Placed = false;
		CCP_Marker = "";
		
		// Notifications
		CCP_showAlreadySet = true;
		CCP_showNotAllowedText = true;
		CCP_showSuccessSet = true;
		
		CCP_allowedAreaMarkers = call dzn_fnc_tsf_CCP_drawAllowedAreaMarkers;
		
		CCP_AllowedLocation = [];
		{
			CCP_AllowedLocation pushBack ([_x, true] call dzn_fnc_convertTriggerToLocation);
		} forEach (synchronizedObjects tsf_CCP);
		
		// Handle markers on briefing
		if !(CCP_AllowedLocation isEqualTo []) then {
			["dzn_tsf_CCP_BriefingHelper", "onEachFrame", {
				if (count CCP_MarkersLastChecked == count allMapMarkers) exitWith {};
				private _markersToCheck = allMapMarkers - CCP_MarkersLastChecked;
				CCP_MarkersLastChecked = allMapMarkers;
				
				{
					if (toLower(markerText _x) == "ccp") then {
						if (CCP_Placed && markerText CCP_Marker != "") then {						
							if (CCP_Marker != _x) then { 
								[side player, "HQ"] commandChat dzn_tsf_CCP_STR_AlreadySet;
								publicVariable "CCP_showAlreadySet";
								deleteMarker _x;
							};
						} else {
							if ([getMarkerPos _x, CCP_AllowedLocation] call dzn_fnc_isInLocation) then {
								CCP_Placed = true;
								CCP_Marker = _x;
								[side player, "HQ"] commandChat dzn_tsc_CCP_STR_SuccessSet;
								publicVariable "CCP_showSuccessSet";
							} else {
								[side player, "HQ"] commandChat dzn_tsf_CCP_STR_NotAllowedText;
								publicVariable "CCP_showNotAllowedText";							
								deleteMarker _x;
							};
						};
					};
				} forEach _markersToCheck;
			}] call BIS_fnc_addStackedEventHandler;
		};
		
		[] spawn { 
			waitUntil { time > 1 };
			CCP_allowedAreaMarkers call dzn_fnc_tsf_CCP_removeAllowedAreaMarkers;
			
			["dzn_tsf_CCP_BriefingHelper", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
			dzn_tsf_CCP_Position = call dzn_fnc_tsf_CCP_findMarker;
			publicVariable "dzn_tsf_CCP_Position";
		};
	};
};

[] spawn {
	waitUntil { !isNil "dzn_tsf_CCP_Position" };
	[
		dzn_tsf_CCP_HealTime
		, dzn_tsf_CCP_Radius
		, dzn_tsf_CCP_PreventPlayerDeath
		, dzn_tsf_CCP_Position
		, [dzn_tsf_CCP_Compositions, dzn_tsf_CCP_DefaultComposition] call dzn_fnc_getValueByKey
	] spawn dzn_fnc_tsf_CCP_createCCP
};

CCP_Init = "DONE";
