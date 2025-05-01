#include "script_component.hpp"

/*
    Handles briefing phase:
    - Draw FARP markers and related allowed deployment zones
    - Handle FARP placement by user (moving inside the zone, handle deletion)

    (_self) (ServerSide)

    Params:
        0: _marker (STRING) - marker system name

    Returns:
        nothing
*/

#define MARKER_CREATE(PREFIX,NAME) [\
    format ["%1 %2", PREFIX, NAME], \
    getPosASL (_x get Q(Logic)), \
    "mil_box", "ColorOrange", format ["%1 %2", FARP_NAME, NAME], true] call dzn_fnc_createMarkerIcon

params [""];
DEBUG_1("Params: %1", _this);

// -- Marker creation
{
    private _name = _x get Q(Name);
    private _areas = _x get Q(SyncedObjects);

    // -- Position marker
    private _mrkType = ["_USER_DEFINED", "mrk_FARP_"] select (_areas isEqualTo []);
    _x set [
        Q(Marker),
        MARKER_CREATE(_mrkType,_name)
    ];
    private _mrkDefault = MARKER_CREATE("mrk_FARP_defaultPos_",_name);
    _mrkDefault setMarkerAlpha 0.25;

    // -- Allowed areas markers
    private _markers = [];
    {
        (triggerArea _x) params ["_xSize", "_ySize", "_angle", "_isRect"];
        private _mrk = createMarker [
            format ["mrk_FARP_allowedArea_%1_%2", _name, _forEachIndex],
            getPosASL _x
        ];

        _mrk setMarkerShape (["ELLIPSE", "RECTANGLE"] select _isRect);
        _mrk setMarkerSize [_xSize, _ySize];
        _mrk setMarkerDir _angle;

        _mrk setMarkerBrush "SolidBorder";
        _mrk setMarkerColor "ColorOrange";
        _mrk setMarkerAlpha 0.25;

        _markers pushBack _mrk;
    } forEach _areas;
    _x set [Q(AreaMarkers), _markers];

} forEach (_self get Q(FARPs));

// -- Markers handling (moving and deletion)

private _markerDeletedEH = ["deleted", {
    params ["_marker"];
    private _self = COB;
    {
        private _areas = _x get Q(SyncedObjects);
        if (_areas isEqualTo [] || _marker != _x get Q(Marker)) then { continue; };

        // -- Deleted markers is FARP marker - re-create
        private _name = _x get Q(Name);
        _x set [
            Q(Marker),
            MARKER_CREATE("_USER_DEFINED",_name)
        ];
    } forEach (_self get Q(FARPs));
}] call CBA_fnc_addMarkerEventHandler

private _pfh = [{
    params ["_self", "_handle"];

    // -- Moving out of range
    {
        private _areas = _x get Q(SyncedObjects);
        if (_areas isEqualTo []) then { continue; };

        private _mrk = _x get Q(Marker);
        private _curPos = getMarkerPos _mrk;
        private _outOfArea = { !_x } count (_areas apply { _curPos inArea _x }) > 0;
        if (!_outOfArea) then {
            _x set [Q(MarkerLastPosition), _curPos];
            continue;
        };

        _mrk setMarkerPos (_x getOrDefault [
            Q(MarkerLastPosition),
            getPosASL (_x get Q(Logic))
        ]);
    } forEach (_self get Q(FARPs));
}, nil, _self] call CBA_fnc_addPerFrameHandler;

_self set [Q(BriefingHandlerEH), _pfh];
_self set [Q(BriefingMarkerDeletedEH), _markerDeletedEH];
