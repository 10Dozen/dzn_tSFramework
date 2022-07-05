#include "script_component.hpp"

FUNC(processERSLogics) = {
	/*
		Checks mission's GameLogics and execute ERS scripts on
		logics with non empty 'tSF_ERS_Config' variables
		Params: none
		Return: none
	*/
	private _logicsCount = 0;
	private _assignementsSuccessCount = 0;
	{
		private _logic = _x;
		private _logicConfigName = _x getVariable ERS_GAMELOGIC_FLAG;

		if !(isNil "_logicConfigName") then {
			{
				private _result = [_x, _logicConfigName] call FUNC(assignRadioByConfig);
				_assignementsSuccessCount = _assignementsSuccessCount + ([0, 1] select _result);
			} forEach (synchronizedObjects _x);
			_logicsCount = _logicsCount + 1;
		};
	} forEach (entities "Logic");

	[_logicsCount, _assignementsSuccessCount]
};

FUNC(assignRadioByConfig) = {
	/*
		Reads given config and apply long-range radio settings to vehicle.
		Params:
		_veh - (object) vehicle to process
		_configName - (string) config nmae to apply

		Return:
		nothing

		Example:
		[_veh, "BLUFOR"] call tSF_fnc_EditorRadioSettings_assignRadioByConfig
		// applies "BLUFOR" config to vehicle
	*/

	params ["_veh", "_configName"];
	private _config = GVAR(LRRadioConfig) get _configName;

	if (isNil "_config") exitWith {
		TSF_ERROR_1(TSF_ERROR_TYPE__NO_CONFIG, "Failed to find config '%1'", _configName);
		false
	};

	_config params [
		"_side"
		,"_radioClass"
		,"_radioRange"
		,"_isolated"
	];

	if (
		!GVAR(OverrideIsolatedConfigValue)
		&& { [typeOf _veh, "tf_hasLRRadio"] call TFAR_fnc_getConfigProperty > 0 }
	) then {
		_isolated = [typeOf _veh, "tf_isolatedAmount"] call TFAR_fnc_getConfigProperty;
	};

	[_veh, [
		["tf_side", _side, true]
		,["tf_hasRadio", true, true]
		,["TF_RadioType", _radioClass, true]
		,["tf_range", _range, true]
		,["tf_isolatedAmount", _isolated, true]
	], true] call dzn_fnc_setVars;

	true
};
