#include "script_component.hpp"

/*
    Returns sorted list of respawn locations info.
    
    display name and config entry name of the respawn locations.
    Default location is always on top.
    (_self)

    Params:
        nothing
    Returns:
        array of [_displayName (STRING), _posObj (POS3D/OBJECT), _description (STRING)]
*/

private _respawnLocationsInfo = [];
private _locsConfig = SETTING(_self,Locations);

private _defaultLocationName = _locsConfig get DEFAULT_LOCATION getOrDefault [Q(name), DEFAULT_LOCATION_NAME];
if (_defaultLocationName == "") then { _defaultLocationName = DEFAULT_LOCATION_NAME; };
_respawnLocationsInfo pushBack [
    _defaultLocationName,
    _locsConfig get DEFAULT_LOCATION get Q(positionObject),
    _locsConfig get DEFAULT_LOCATION getOrDefault [Q(description), ""],
    true
];

private _keys = (keys _locsConfig) - [DEFAULT_LOCATION];
_keys sort true;
{
    _respawnLocationsInfo pushBack [
        _locsConfig get _x get Q(name),
        _locsConfig get _x get Q(positionObject),
        _locsConfig get _x getOrDefault [Q(description),""],
        false
    ];
} forEach _keys;

_respawnLocationsInfo