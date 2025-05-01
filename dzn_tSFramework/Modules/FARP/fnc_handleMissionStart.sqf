#include "script_component.hpp"

/*
    Handles after briefing phase:
    - Removes EHs and unused markers
    - Creates compositions and assign actions

    (_self) (ServerSide)

    Params:
        none

    Returns:
        nothing
*/

params [""];
DEBUG_1("Params: %1", _this);

// -- Remove EHs
[_self get Q(BriefingHandlerEH)] call CBA_fnc_removePerFrameHandler;
["deleted", _self get Q(BriefingMarkerDeletedEH)] call CBA_fnc_removeMarkerEventHandler;

// -- Create compositions and stuff
private _farpLogics = [];
{
    // -- Remove markers
    (_x get Q(AreaMarkers)) apply { deleteMarker _x; };
    _x deleteAt Q(MarkerLastPosition);
    _x deleteAt Q(AreaMarkers);

    // -- Remove allowed areas
    (_x get Q(SyncedObjects)) apply { deleteVehicle _x; };

    // -- Create compositions on marker position
    private _pos = getMarkerPos (_x get Q(Marker));
    _pos = [_pos, 0, 70, 20, 0, 0, 0, [], [_pos, _pos]] call BIS_fnc_findSafePos;

    // Get composition by id/name, update with classes via `format ["Classname", "A", "B", "C"]`
    private _composition = _self get Q(Compositions) get (_x get Q(Composition));
    private _replacementClasses = _x get Q(Classes);
    _composition = _composition apply { format ([_x # 0] + _replacementClasses) };

    private _objects = [[_pos, 0], _composition] call dzn_fnc_setComposition;
    _objects apply {
        _x lock true;
        clearItemCargoGlobal _x;
        clearMagazineCargoGlobal _x;
        clearWeaponCargoGlobal _x;
        clearBackpackCargoGlobal _x;
    };
    _x set [Q(SyncedObjects), _objects];

    private _logic = _x get Q(Logic);
    _logic setPosASL _pos;
    _logic synchronizeObjectsAdd _objects;

    // -- Resources
    private _defaults = _self get Q(Defaults) get Q(Resources);
    private _resources = (_self get Q(Configs) get (_x get Q(Config))) getOrDefault [Q(Resources), _defaults];
    _logic setVariable [GAMELOGIC_RESOURCES, [
        _resources getOrDefault [Q(Repair), _defaults get Q(Repair)],
        _resources getOrDefault [Q(Refuel), _defaults get Q(Refuel)],
        _resources getOrDefault [Q(Rearm), _defaults get Q(Rearm)],
        _resources getOrDefault [Q(Gear), _defaults get Q(Gear)]
    ], true];

    _farpLogics pushBack _logic;
} forEach (_self get Q(FARPs));

    // -- Init actions for players
[Q(COMPONENT), F(initClient), [_farpLogics], 0] call dzn_fnc_RCE;
