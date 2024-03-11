#include "script_component.hpp"

/*
    Returns next unused Alphabetic code word.
    Scans map markers and collects used words, then suggest unused one.
    If all words from dictionary was used - returns nil.

    (_self)

    Returns:
        _word (STRING) or nil - suggested alphabetic word or NIL if no suggestions left
*/

forceUnicode 1;
private _words = if ((side player) in [west, resistance]) then {
    SETTING_2(_self,PhoneticAlphabet,BLUFOR)
} else {
    SETTING_2(_self,PhoneticAlphabet,OPFOR)
};


DEBUG_1("Words: %1", _words);

private ["_name", "_idx"];
private _usedWords = [];
{
    _name = markerText _x;
    _idx = _words findIf { _x in _name };
    if (_idx == -1) then { continue; };
    _usedWords pushBack (_words # _idx);
} forEach (allMapMarkers);

// Delete used words from list of words and return first left
DEBUG_2("Used words: %1 (%2)", _usedWords, typename _usedWords);
_words = (+_words) - _usedWords;

// If no words left - return wildcard
if (_words isEqualTo []) exitWith { nil };

(_words # 0)
