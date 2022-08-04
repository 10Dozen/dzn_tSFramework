#include "script_component.hpp"

/*
    Adds noise to the message, by replacing some symbols with dots.
    Non-public function

    Params:
    _message - (string) message.

    Return:
    _noisedMessage - (string) message with added noise.
*/

params ["_message"];

 private _symbols = _message splitString "";
 private _length = count _symbols - 1;
 if (_length < 5) exitWith { _message };

 private _noiseOffset = random (10 min _length);
 private _noiseStep = random [1, 7, 20];
 if (_noiseStep < _length) then {
     _noiseStep = _length / 2;
 };
 private _noiseLenght = random [2, 4, 6];

 for "_i" from _noiseOffset to _length step (_noiseStep + _noiseLenght) do {
     for "_j" from 0 to _noiseLenght do {
         private _idx = _i + _j;
         if (_idx <= _length) then {
             _symbols set [_idx, "."];
         };
     };
 };

 (_symbols joinString "")
