#include "script_component.hpp"

/*
	Handles CCP position selection during briefing.
	Draws default CCP position, draws allowed areas and handles creation of the new markers.
	Should be executed only on clients.

	Params: none
	Returns: none
*/

__CLIENT_ONLY__

private _allowedZones = synchronizedObjects CCP_LOGIC;

// No zones available for CCP set up - skip any handling
if (_allowedZones isEqualTo []) exitWith {};

// Add default CCP position marker and allowed zones to the map
GVAR(DefaultMrk) = [QGVAR(DefaultMrk), getPosATL CCP_LOGIC, MRK_ICON_PREVIEW, MRK_COLOR, format ["(%1)", QUOTE(STR_SHORT_NAME)], true] call dzn_fnc_createMarkerIcon;
GVAR(DefaultMrk) setMarkerAlphaLocal 0.5;
GVAR(AllowedZonesMarkers) = [];
{
	private _trgArea = triggerArea _x;
	private _mrk = createMarkerLocal [format ["%1_%2", QGVAR(Area), _forEachIndex], getPosATL _x];
	_mrk setMarkerShapeLocal (if (_trgArea select 3) then {"RECTANGLE"} else {"ELLIPSE"});
	_mrk setMarkerSizeLocal [_trgArea select 0, _trgArea select 1];
	_mrk setMarkerDirLocal (_trgArea select 2);

	_mrk setMarkerBrushLocal "SolidBorder";
	_mrk setMarkerColorLocal MRK_COLOR;
	_mrk setMarkerAlphaLocal 0.5;

	GVAR(AllowedZonesMarkers) pushBack _mrk;
} forEach _allowedZones;

GVAR(markerDeletedHandler) = addMissionEventHandler ["MarkerDeleted", {
	params ["_marker", "_local"];
	// Ignore non local and non CCP markers
	if (!_local || { markerText _marker != MRK_LABEL }) exitWith {};

	// Ignore if CCP marker was not set previously
	if (isNil {CCP_LOGIC getVariable QGVAR(Marker)}) exitWith {};

	// Ignore if delete marker is not valid CCP marker
	if (_marker isNotEqualTo (CCP_LOGIC getVariable QGVAR(Marker))) exitWith {};

	CCP_LOGIC setVariable [QGVAR(Marker), nil, true];
	CCP_LOGIC setVariable [QGVAR(PreSelectedPosition), nil, true];
}];

GVAR(markerCreatedHandler) = addMissionEventHandler ["MarkerCreated", {
	params ["_marker", "_channelNumber", "_owner", "_local"];

	if (!_local) exitWith {};
	if (markerText _marker != MRK_LABEL) exitWith {};

	_thisArgs params ["_allowedZones"];

	// Check that marker is not set already
	private _alreadySet = !isNil { CCP_LOGIC getVariable QGVAR(Marker) };

	if (_alreadySet) exitWith {
		 SHOW_MESSAGE(STR_ALREADY_SET);
		 [{ deleteMarker _this }, _marker] call CBA_fnc_execNextFrame;
	};

	// Marker is not in the allowed area - report and exit
	private _inAllowedArea = [getMarkerPos _marker, _allowedZones] call dzn_fnc_isInLocation;

	if (!_inAllowedArea) exitWith {
		SHOW_MESSAGE(STR_NOT_ALLOWED);
		[{ deleteMarker _this }, _marker] call CBA_fnc_execNextFrame;
	};

	// Marker is in proper position - update style and save
	SHOW_MESSAGE(STR_SUCCESSFULLY_SET);
	[{ [_this] call FUNC(decorateMarker); }, _marker] call CBA_fnc_execNextFrame;

	CCP_LOGIC setVariable [QGVAR(Marker), _marker, true];
	CCP_LOGIC setVariable [QGVAR(PreSelectedPosition), getMarkerPos _marker, true];
}, [_allowedZones]];
