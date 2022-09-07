#include "script_component.hpp"

/*
    Shows heard speech for player if player is in range.
    Also add 'noise' if player is close to maximum distance.
    Non-public function

    Params:
    _unit - (object) a speaker.
    _message - (string) message to display.
    _name - (string) displayed name of the speaker.
    _maxDistance - (number) maximum distance of the broadcast in meters.

    Return: nothing
*/

__CLIENT_ONLY__

params ["_unit", "_message", "_name", "_maxDistance"];

private _vehListener = vehicle player;
private _vehSpeaker = vehicle _unit;

// Unit in the same vehicle or have unlimited distance of speech
if (_vehListener == _vehSpeaker) then { _maxDistance = -1; };
if (_maxDistance < 0) exitWith {
    [_name, _message] spawn BIS_fnc_showSubtitle;
};

private _distance = player distance _unit;

// Player is too far to hear anything
if (_distance > _maxDistance) exitWith {};

// Player or unit is in the vehicle - max distance is affected by isolation and engine work
private _vehListenerIsolationCoef = 1;
private _vehSpeakerIsolationCoef = 1;
if (_vehListener != player) then {
    _vehListenerIsolationCoef = [player, _vehListener] call FUNC(getInVehicleIsolationCoef);
};
if (_vehSpeaker != _unit) then {
    _vehSpeakerIsolationCoef = [_unit, _vehSpeaker] call FUNC(getInVehicleIsolationCoef);
};

_maxDistance = 3 max (_maxDistance * _vehListenerIsolationCoef * _vehSpeakerIsolationCoef);

// Recheck again, after effects of the vehicle
if (_distance > _maxDistance) exitWith {};

// Player is in the range, but can't hear all
if (_distance > (GET_ "Direct", "NoiseDistanceCoef" _SETTING) * _maxDistance) then {
    _message = [_message] call FUNC(addNoise);
};

[_name, _message] spawn BIS_fnc_showSubtitle;
