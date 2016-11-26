call compile preprocessFileLineNumbers "dzn_tSFramework\Modules\Interactives\Settings.sqf";

#define     APPLY_CLIENT_CODE(X,Y,Z)      if (hasInterface) then {waitUntil {!isNull player && { local player}}; [X, Y, Z] call dzn_fnc_interactives_executeEach; }
#define     APPLY_SEVER_CODE(X,Y,Z)       if (isServer || isDedicated) then { [X, Y, Z] call dzn_fnc_interactives_executeEach; };

dzn_fnc_interactives_persistantLoop = {
	sleep 30;
	_this call dzn_fnc_interactives_executeEach;
};


dzn_fnc_interactives_executeEach = {
	// [@ReferenceList, @Code] call dzn_fnc_interactives_executeEach
	params ["_reference", "_code","_persistant"];

	private _objects = [];
	
	{
		if (typename _x == "STRING") then {
			_objects = _objects + entities _x;
		} else {
			_objects pushBack _x;
		};	
	} forEach _reference;
	
	{
		if !(_x getVariable ["dzn_Interactives_Assigned", false]) then {
			_x spawn _code;
			_x setVariable ["dzn_Interactives_Assigned", true, false];
		};
	} forEach _objects;

	if (_persistant) exitWith {
		[_reference, _code, _persistant] spawn dzn_fnc_interactives_persistantLoop;
	};
};

{
	private _reference = _x select 0;
	private _code = _x select 1;
	private _locality = toLower (_x select 2);
	private _persistant = if (!isNil {_x select 3}) then { _x select 3 } else { false };

	switch (_locality) do {
		case "client": {
			APPLY_CLIENT_CODE(_reference, _code, _persistant);
		};
		case "server": {
			APPLY_SEVER_CODE(_reference, _code, _persistant);
		};
		case "global": {
			APPLY_CLIENT_CODE(_reference, _code, _persistant);
            if (!hasInterface) then {
                APPLY_SEVER_CODE(_reference, _code, _persistant);
            };
		};
	};
} forEach dzn_interactives_objectsAndClasses;