#include "script_component.hpp"

/*
    Set's default mininal rating to player if current rating is lower.

    (_self)

    Params:
        none
    Returns:
        nothing
*/

private _minRating = SETTING_2(_self,PlayerRating,rating);

if (!SETTING_2(_self,PlayerRating,enable) || rating player >= _minRating) exitWith {};

player addRating _minRating;
