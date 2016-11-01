call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\EditorRadioSettings\Settings.sqf";

if (isServer) then {
	tSF_fnc_ERS_assignRadioByConfig = {
		params["_v", "_configName"];
		private _config = [tSF_ERS_LRRadioConfig, _configName] call dzn_fnc_getValueByKey;
		
		private _side 		= _config select 0;
		private _radioClass	= _config select 1;
		private _range		= _config select 2;
		private _isolated		= if ([typeOf _v, "tf_hasLRRadio"] call TFAR_fnc_getConfigProperty > 0 && !tSF_ERS_OverrideIsolatedConfigValue) then {
			[typeOf _v, "tf_isolatedAmount"] call TFAR_fnc_getConfigProperty
		} else {
			_config select 3;	
		};
		
		_v setVariable ["tf_side", _side, true];
		_v setVariable ["tf_hasRadio", true, true];
		_v setVariable ["tf_isolatedAmount", _isolated, true];
		_v setVariable ["tf_range", _range, true];
		_v setVariable ["TF_RadioType", _radioClass, true];
	};
	
	tSF_fnc_ERS_processLogics = {
		{
			private _logic = _x;
			private _syncUnits = synchronizedObjects _x;
			
			if !(isNil {_logic getVariable "tSF_ERS_Config"}) then {
				private _config = _logic getVariable "tSF_ERS_Config";
				{ [_x, _config] call tSF_fnc_ERS_assignRadioByConfig } forEach _syncUnits;
			};
		} forEach (entities "Logic");	
	};

	waitUntil { time > tSF_ERS_initTimeout };
	call tSF_fnc_ERS_processLogics;
};
