#include "script_component.hpp"

/*
    Shows ORBAT hint outside of on game start hint (e.g. by keybind).
    (_self)
    Params:
        none
    Returns:
        nothing
*/

private _settings = _self get Q(Settings) get Q(DisableOnStart);
if !(_settings getOrDefault [Q(showOrbat), false]) exitWith {};

private _hintMessageLines = [];
private _orbatInfo = ECOB(Core) call [F(getGroupORBAT), [player, false]];

hintSilent parseText ((_self call [F(onStart_composeOrbatHint), _orbatInfo]) joinString "<br/>");
