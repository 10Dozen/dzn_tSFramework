call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\InteractivesACE\Settings.sqf";

tSF_IACE_addAction = {
	params ["_type","_name","_id","_node","_code","_cond"];
	
	private _action = [
		_id
		,_name
		, ""
		,_code
		,_cond	
	] call ace_interact_menu_fnc_createAction;
	
	private _path = [];
	private _actionType = 0;
	private _classes = [] ;
	
	if (typename _type == "STRING" && {toLower _type == "self"} ) then {
		_path = ["ACE_SelfActions"];	
		_classes = [typeof player];
		_actionType = 1;
	};
	
	if (typename _type == "ARRAY") then {
		_path = ["ACE_MainActions"];	
		_classes = _type;
		_actionType = 0;
	};	
	
	if (_node != "") then {
		_path pushBack _node;	
	};
	
	{
		call compile format [
			"[_x, _actionType, _path, _action] call %1;"
			, if (typename _x == "STRING") then {
				"ace_interact_menu_fnc_addActionToClass"
			} else {
				"ace_interact_menu_fnc_addActionToObject"
			}
		];
	} forEach _classes;
};

{
	_x call tSF_IACE_addAction;
} forEach tSF_IACE_Actions;
