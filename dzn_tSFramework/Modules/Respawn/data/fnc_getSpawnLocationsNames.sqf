#include "script_component.hpp"

/*
    Returns sorted list of display name and config entry name of the respawn locations. 
    Default location is always on top.
    (_self)

    Params:
        nothing
    Returns:
        array of [@LocationDisplayName(string), @LocationConfigName(string), @LocationDescription(stirng)]
*/

private _respawnLocationsInfo = [];
private _locsConfig = SETTING(_self,Locations);

private _defaultLocationName = _locsConfig get DEFAULT_LOCATION getOrDefault [Q(name), DEFAULT_LOCATION_NAME];
if (_defaultLocationName == "") then { _defaultLocationName = DEFAULT_LOCATION_NAME; };
_respawnLocationsInfo pushBack [
    _defaultLocationName, 
    DEFAULT_LOCATION, 
    _locsConfig get DEFAULT_LOCATION getOrDefault [Q(description), ""]
];

private _keys = (keys _locsConfig) - [DEFAULT_LOCATION];
_keys sort true;
{
    _respawnLocationsInfo pushBack [
        _locsConfig get _x get Q(name),
        _x,
        _locsConfig get _x getOrDefault [Q(description),""]
    ];
} forEach _keys;

_respawnLocationsInfo