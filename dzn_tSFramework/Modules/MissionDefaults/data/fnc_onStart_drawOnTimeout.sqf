#include "script_component.hpp"

/*
    Updates hint with disable on start message and optionally ORBAT info for player's squad.
    Once timed out - show on enable message and deletes PFH.
    (_self)

    Params:
        0: _enableAt (NUMBER) - scheduled time to enable control.
        1: _pfhId (NUMBER) - id of the per frame handler.
    Returns:
        nothing
*/

#define HINT_TITLE "<t color='#FFE240' font='PuristaLight'>Начало через %1 сек</t>"

params ["_enableAt", "_pfhId"];

private _timeLeft = round(_enableAt - CBA_missionTime);
private _settings = _self get Q(Settings) get Q(DisableOnStart);

private _hintMessageLines = [
    format [HINT_TITLE, _timeLeft],
    _settings get Q(onDisableText),
    ""
];

if (_timeLeft <= 0) then {
    // Enable player on time out
    [_pfhId] call CBA_fnc_removePerFrameHandler;
    player enableSimulation true;
    disableUserInput false;

    DEBUG_1("[onStart] Additional message: %1", _settings get Q(onEnableText));
    _hintMessageLines = [
        _settings get Q(onEnableText)
    ];
};

if (_settings getOrDefault [Q(showOrbat), false]) then {
    DEBUG_MSG("[onStart] Showing ORBAT");
    private _orbatInfo = _self call [
        F(onStart_getGroupOrbat),
        [
            player,
            _settings get Q(orbatPrefixSortingOrder)
        ]
    ];
    _hintMessageLines append (_self call [F(onStart_composeOrbatHint), _orbatInfo]);
};


DEBUG_1("[onStart] Hint message: %1", _hintMessageLines);
DEBUG_1("[onStart] Hint message: %1", (_hintMessageLines joinString "<br/>"));

hintSilent parseText (_hintMessageLines joinString "<br/>");
