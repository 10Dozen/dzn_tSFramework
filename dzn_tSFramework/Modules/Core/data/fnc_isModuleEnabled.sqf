#include "script_component.hpp"

/*
    Returns true if module exists and enabled,
    false if module exists and disabled (or not exists).

    Module name is case insensitive.

    (_self)

    Params:
        _moduleName (STRING) - name of the modules to check.
    Returns:
        _isEnabled (BOOL) or NIL - state of the module

    _isEnabled = tSF_Core_Component call ["fnc_isModuleEnabled", ["FARP"]]; // true
*/

private _moduleName = _this;

private _isEnabled = false;

{
    if (_moduleName == _x) exitWith {
        _isEnabled = _y;
    };
} forEach (_self get Q(Settings));

_isEnabled
