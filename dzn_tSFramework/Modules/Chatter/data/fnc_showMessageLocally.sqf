#include "script_component.hpp"

/*
    Shows heard speech for player if player is in range.
    Also add 'noise' if player is close to maximum distance.
    _self

    Params:
    _unit - (object) a speaker.
    _message - (string) message to display.
    _name - (string) displayed name of the speaker.
    _maxDistance - (number) maximum distance of the broadcast in meters.

    Return: nothing
*/

__CLIENT_ONLY__

DEBUG_1("(showMessageLocally) Params: %1", _this);
params ["_unit", "_message", "_name", "_maxDistance", "_sayMode"];

private _messagePrefix = "";
private _vehListener = vehicle player;
private _vehSpeaker = vehicle _unit;

switch (_sayMode) do {
    case SAY_MODE__WHISPER: {
        _message = toLower _message;
        _messagePrefix = "*шепчет* ";
    };
    case SAY_MODE__SHOUT: {
        _message = toUpper _message;
        _messagePrefix = "*кричит* ";
    };
};

DEBUG_2("(showMessageLocally) _message=%1, _messagePrefix=%2", _message, _messagePrefix);

// Unit in the same vehicle or have unlimited distance of speech
DEBUG_4("(showMessageLocally) Veh.listener=%1, veh.speaker=%2, same vehicle=%3 max_distance=%4", _vehListener, _vehSpeaker, _vehListener isEqualTo _vehSpeaker, _maxDistance);
if (_vehListener isEqualTo _vehSpeaker) then { _maxDistance = -1; };


DEBUG_1("(showMessageLocally) Max distance: %1", _maxDistance);
if (_maxDistance < 0) exitWith {
    DEBUG_MSG("(showMessageLocally) Inf. distance case - show titles");
    [_name, _messagePrefix + _message] spawn BIS_fnc_showSubtitle;
};

private _distance = player distance _unit;

// Player is too far to hear anything
if (_distance > _maxDistance) exitWith {
    DEBUG_MSG("(showMessageLocally) Out of distance");
};

// Player or unit is in the vehicle - max distance is affected by isolation and engine work
private _vehListenerIsolationCoef = 1;
private _vehSpeakerIsolationCoef = 1;
if (_vehListener != player) then {
    _vehListenerIsolationCoef = _self call [F(getInVehicleIsolationCoef), [player, _vehListener]];
};
if (_vehSpeaker != _unit) then {
    _vehSpeakerIsolationCoef = _self call [F(getInVehicleIsolationCoef), [_unit, _vehSpeaker]];
};

_maxDistance = 3 max (_maxDistance * _vehListenerIsolationCoef * _vehSpeakerIsolationCoef);
DEBUG_1("(showMessageLocally) Max distance = %1", _maxDistance);

// Recheck again, after effects of the vehicle
if (_distance > _maxDistance) exitWith {};

// Player is in the range, but can't hear all
if (_distance > SETTING_2(_self,Direct,NoiseDistanceCoef) * _maxDistance) then {
    DEBUG_1("(showMessageLocally) Distance is too much - adding noise: %1", _distance);
    _message = _self call [F(addNoise), [_message]];
};

[_name, _messagePrefix + _message] spawn BIS_fnc_showSubtitle;
