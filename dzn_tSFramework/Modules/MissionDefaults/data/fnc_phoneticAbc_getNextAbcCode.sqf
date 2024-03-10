#include "script_component.hpp"

/*
    Returns next unused Alphabetic code word.

    // scan map markers
    // check for each alphabetic use
    // mark map of alphabetic usage
    // pick next unused one

    (_self)

    Returns:
        _word (STRING) - suggested alphabetic word or NIL if no suggestions left
*/

private _sidePlayer = side player;
private _words = +(_self get Q(Settings) get Q(PhoneticAlphabet) get (
    ["OPFOR", "BLUFOR"] select (_sidePlayer in [west, resistance])
));

private ["_name", "_usedWrodIdx"];
private _usedWords = [];
{
    _name = markerText _x;
    _usedWrodIdx = _words findIf { _x in _name };
    if (_usedWrodIdx == -1) then { continue; };
    _usedWords pushBack (_words # _usedWrodIdx);
} forEach (allMapMarkers);

DEBUG_MSG("Used Abc Words:");
{ DEBUG_MSG(_x); } forEach _usedWords;


// Delete used words from list of words and return first left
_words = _words - _usedWords;

DEBUG_MSG("Suggested Abc Words:");
{ DEBUG_MSG(_x); } forEach _words;

// If no words left - return wildcard
if (_words isEqualTo []) exitWith { nil };

(_words # 0)
