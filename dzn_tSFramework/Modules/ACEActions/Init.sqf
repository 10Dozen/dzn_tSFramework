call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\ACEActions\Settings.sqf";


tSF_fnc_ACEActions_addAction = {
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
	
	if (_node != "") then { _path pushBack _node; };
	
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

tSF_fnc_ACEActions_processActionList = {
	private _list = [];
	
	{if (_x select 3 == "") then {_list pushBack _x;};} forEach _this;
	private _orderedList = _list + (_this - _list);
	
	{_x call tSF_fnc_ACEActions_addAction;} forEach _orderedList;
};

if (hasInterface) then {
	waitUntil {time > tSF_ACEActions_Timeout};
	
	tSF_ACEActions_Actions call tSF_fnc_ACEActions_processActionList;
};
