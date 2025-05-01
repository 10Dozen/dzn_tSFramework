#include "script_component.hpp"

/*
    Assigns radio to given vehicle, based on given radio config. If some config
    values are missing - settings from Defaults section will be used instead.

    (_self)

    Params:
        _vehicle (OBJECT) - vehicle to assign radio to.
        _radioConfig (HASHMAP) - radio config to use.
    Returns:
        none

    _self call ["fnc_assignRadio", [myCar, _config]];
*/

params["_veh", "_config"];

#define Value(NAME) (_config get Q(NAME))
#define ValueOrDefault(NAME) (_config getOrDefault [Q(NAME), SETTING_2(_self,Defaults,NAME)])

private _side = Value(side);
private _radioClass = Value(class);
private _range = ValueOrDefault(range);
private _isolation = ValueOrDefault(isolation);
private _overrideIsolation = ValueOrDefault(overrideIsolation);

private _isolatedConfigValue = [typeOf _veh, "tf_isolatedAmount"] call TFAR_fnc_getVehicleConfigProperty;
if (_isolatedConfigValue > 0 && !_overrideIsolation) then {
    _isolation = _isolatedConfigValue;
};

_veh setVariable ["tf_side", _side, true];
_veh setVariable ["tf_hasRadio", true, true];
_veh setVariable ["tf_isolatedAmount", _isolation, true];
_veh setVariable ["tf_range", _range, true];
_veh setVariable ["TF_RadioType", _radioClass, true];
