#include "script_component.hpp"

/*
    Select next/prev view distance preset
    (_self)

    Params:
        0: _direction (NUMBER) - cycling direction - next (1) or prev (-1)
    Returns:
        nothing
*/

params ["_dir"];

private _currentPreset = (_self get Q(CurrentPreset)) + _dir;
private _presets = _self get Q(Presets);
private _maxIdx = (count _presets) - 1;

_currentPreset = [
    _maxIdx min _currentPreset,
    0 max _currentPreset
] select (_dir < 0);

_self set [Q(CurrentPreset), _currentPreset];

private _tgtVD = _presets select _currentPreset;
private _tgtOVD = _tgtVD * GVAR(Setting_VD_ODRatio);

_self call [F(setViewDistance), [_tgtVD, _tgtOVD]];
