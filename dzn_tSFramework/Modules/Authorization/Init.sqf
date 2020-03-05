call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\Authorization\Settings.sqf";
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\Authorization\Functions.sqf";


tSF_Authorization_CommonPermissions = [false, false, false];
tSF_Authorization_List apply { 
	if (toLower (_x # 0) == "any") then {
		tSF_Authorization_CommonPermissions = _x # 1;
	};

	[toLower (_x # 0), _x # 1]
};

tSF_Authorization_Initialized = true;