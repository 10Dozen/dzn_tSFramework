#include "script_component.hpp"

/*
    Updates hint with disable on start message and optionally ORBAT info for player's squad.
    // _self
*/

#define DisableOnStart_Settings (_self get Q(Settings) get Q(DisableOnStart))
#define HINT_TITLE "<t color='#FFE240' font='PuristaLight'>Начало через %1 сек</t>"

params ["_enableAt", "_pfhId"];

private _timeLeft = round(_enableAt - CBA_missionTime);

private _hintMessageLines = [
    format [HINT_TITLE, _timeLeft],
    DisableOnStart_Settings get Q(text)
];

if (_timeLeft < 0) then {
    // Enable player on time out
    [_pfhId] call CBA_fnc_removePerFrameHandler;
    player enableSimulation true;
    disableUserInput false;
    _hintMessageLines pushBack (DisableOnStart_Settings get Q(onEnableText));
};

if (DisableOnStart_Settings getOrDefault [Q(showOrbat), false]) then {
    private _orbatInfo = _self call [
        F(onStart_getGroupOrbat),
        [
            player,
            DisableOnStart_Settings get Q(orbatPrefixSortingOrder)
        ]
    ];
    _hintMessageLines append (_self call [F(onStart_composeOrbatHint), _orbatInfo]);
};

hintSilent parseText (_hintMessageLines joinString "<br/>");
