#include "script_component.hpp"

/*
    Shows received radio message for player if conditions are met (have radio & in range).
    Also add 'noise' if player is close to maximum distance.
    Non-public function
    (_self)

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
     // !isMupliplayer is for testing in SP scenario
    case "LR": { call TFAR_fnc_haveLRRadio || !isMultiplayer };
    case "SW": { call TFAR_fnc_haveSWRadio || !isMultiplayer };
};

DEBUG_1("(showMessageOverRadio) Client have radio: %1", _haveRadio);

// Skip for players that doesn't have SW radio
if !(_haveRadio) exitWith { DEBUG_MSG("(showMessageOverRadio) Exit - No radio.") };

private _title = _callsign;
if (_unit == player) then {
    _title = format ["%1 (Вы)", _title];
};

// Apply distance effects (or skip if caller is the local player or distance unlimited or talkers is virtual one)
if (player != _unit && _maxDistance > 0 && !isNull _unit) then {
    private _distance = player distance _unit;

    // Player is too far to hear anything
    if (_distance > SETTING_2(_self,Radio,StaticsDistanceCoef) * _maxDistance) exitWith { _message = "" };

    // Player is in range to receive only noise
    if (_distance > _maxDistance) exitWith {
        _message = "...*psshhht*......*pshhh*.....*psshhht*....";
        _title = "???";
    };

    // Player is in range, but can't hear all
    if (_distance > SETTING_2(_self,Radio,NoiseDistanceCoef) * _maxDistance) exitWith {
        _message = _self call [F(addNoise), [_message]];
    };
};

DEBUG_1("(showMessageOverRadio) Message after distance effects: %1", _message);

// Empty message - out of distance...
if (_message isEqualTo "") exitWith { DEBUG_MSG("(showMessageOverRadio) Exit - No message.") };


DEBUG_1("(showMessageOverRadio) Invoking: %1", _self get Q(MessageRenderer));
(_self get Q(MessageRenderer)) call [F(show), [_mode, _title, _message]];
// ["Show", [_mode, _title, _message]] call FUNC(MessageRenderer);
