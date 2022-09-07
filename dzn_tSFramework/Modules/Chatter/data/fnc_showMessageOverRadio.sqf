#include "script_component.hpp"

/*
    Shows received radio message for player if conditions are met (have radio & in range).
    Also add 'noise' if player is close to maximum distance.
    Non-public function

    Params:
    _unit - (object) a speaker.
    _callsign - (string) unit's callsign.
    _message - (string) message to display.
    _mode - (string) 'LR' for long range and 'SW' for short range radio.
    _maxDistance - (number) maximum distance of the broadcast in meters.

    Return: nothing
*/

__CLIENT_ONLY__

DEBUG_1("(showMessageOverRadio) Params: %1", _this);

params ["_unit", "_callsign", "_message", "_mode", "_maxDistance"];

_mode = toUpper _mode;
private _haveRadio = switch _mode do {
    case "LR": { call TFAR_fnc_haveLRRadio };
    case "SW": { call TFAR_fnc_haveSWRadio };
};

// Skip for players that doesn't have SW radio
if !(_haveRadio) exitWith {};

private _title = _callsign;
if (_unit == player) then {
    _title = format ["%1 (You)", _title];
};

// Apply distance effects (or skip if caller is the local player or distance unlimited or talkers is virtual one)
if (player != _unit && _maxDistance > 0 && !isNull _unit) then {
    private _distance = player distance _unit;

    // Player is too far to hear anything
    if (_distance > (GET_ "Radio", "StaticsDistanceCoef" _SETTING) * _maxDistance) exitWith { _message = "" };

    // Player is in range to receive only noise
    if (_distance > _maxDistance) exitWith {
        _message = "...*psshhht*......*pshhh*.....*psshhht*....";
        _title = "???";
    };

    // Player is in range, but can't hear all
    if (_distance > (GET_ "Radio", "NoiseDistanceCoef" _SETTING) * _maxDistance) exitWith {
        _message = [_message] call FUNC(addNoise);
    };
};

// Empty message - out of distance...
if (_message isEqualTo "") exitWith {};

["Show", [_mode, _title, _message]] call FUNC(MessageRenderer);
