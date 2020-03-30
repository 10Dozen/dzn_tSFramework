
/*
 *	Dynai Assets
 */
dzn_fnc_tSF_3DEN_AddDynaiCore = {
	collect3DENHistory {
		dzn_tSF_3DEN_DynaiCore = create3DENEntity ["Logic","Logic",screenToWorld [0.3,0.5]];
		dzn_tSF_3DEN_DynaiCore set3DENAttribute ["Name", "dzn_dynai_core"];

		call dzn_fnc_tSF_3DEN_createDynaiLayer;
		dzn_tSF_3DEN_DynaiCore set3DENLayer dzn_tSF_3DEN_DynaiLayer;

		"tSF Tools - DynAI Core was created" call dzn_fnc_tSF_3DEN_ShowNotif;
	};
};

dzn_fnc_tSF_3DEN_AddDynaiZone = {
	if (isNull dzn_tSF_3DEN_DynaiCore) then { call dzn_fnc_tSF_3DEN_AddDynaiCore; };

	disableSerialization;
	private _name = ["Add Dynai Zone", ["Zone name", []]] call dzn_fnc_3DEN_ShowChooseDialog;
	if (count _name == 0) exitWith { dzn_tSF_3DEN_toolDisplayed = false };

	dzn_tSF_3DEN_Parameter = _name;

	collect3DENHistory {
		private _name = dzn_tSF_3DEN_Parameter;

		private _pos = screenToWorld [0.5,0.5];
		private _dynaiZone = create3DENEntity ["Logic","Logic", _pos];
		private _dynaiArea = create3DENEntity [
			"Trigger"
			,"EmptyDetectorAreaR250"
			, [ (_pos select 0) + 50, _pos select 1, 0 ]
		];

		if (_name select 0 == "") then {
			dzn_tSF_3DEN_DynaiZoneId = dzn_tSF_3DEN_DynaiZoneId + 1;
			_name = format ["Zone%1", dzn_tSF_3DEN_DynaiZoneId];
		} else {
			_name = _name select 0;
		};

		_dynaiZone set3DENAttribute ["Name", _name];

		call dzn_fnc_tSF_3DEN_createDynaiLayer;
		[_name, [_dynaiZone, _dynaiArea]] call dzn_fnc_tSF_3DEN_AddAssetsToDynaiFolder;

		add3DENConnection ["Sync", [dzn_tSF_3DEN_DynaiCore, _dynaiArea], _dynaiZone];

		do3DENAction "ToggleMap";

		(format ["tSF Tools - ""%1"" DynAI Zone was created", _name]) call dzn_fnc_tSF_3DEN_ShowNotif;
	};
};

dzn_fnc_tSF_3DEN_AddDynaiZoneAssets = {
	if (dzn_tSF_3DEN_SelectedLogics isEqualTo []) exitWith { "tSF Tools - Dynai: Assets - No zone selected!" call dzn_fnc_tSF_3DEN_ShowWarn;};
	if (count dzn_tSF_3DEN_SelectedLogics > 1) exitWith { "tSF Tools - Dynai: Assets - Single zone should be selected!" call dzn_fnc_tSF_3DEN_ShowWarn;};

	disableSerialization;
	private _modes = ["Area", "Keypoints", "Vehicle Points", ""];
	private _result = [
		"Add Zone Asset"
		,[
			["Asset", _modes]
		]
	] call dzn_fnc_3DEN_ShowChooseDialog;
	if (_result isEqualTo []) exitWith { dzn_tSF_3DEN_toolDisplayed = false };
	dzn_tSF_3DEN_Parameter = _result select 0;

	collect3DENHistory {
		private _zone = dzn_tSF_3DEN_SelectedLogics select 0;
		private _assets = [];
		private _assetsAttributes = [];
		private _mode = "";

		switch (dzn_tSF_3DEN_Parameter) do {
			/* Area */ case 0: {
				_assets pushBack (create3DENEntity ["Trigger","EmptyDetectorAreaR250", screenToWorld [0.5, 0.5]]);
			};
			/* Keypoints */ case 1: {
				for "_i" from 0 to 2 do {
					_assets pushBack (create3DENEntity ["Logic","LocationArea_F", screenToWorld [0.5 + _i*0.2, 0.5 + _i*0.2]]);
				};
			};
			/* Vehicle Points */ case 2: {
				for "_i" from 0 to 2 do {
					_assets pushBack (create3DENEntity ["Logic","LocationOutpost_F", screenToWorld [0.5 + _i*0.2, 0.5 + _i*0.2]]);
				};
			};
		};

		call dzn_fnc_tSF_3DEN_createDynaiLayer;
		// { _x set3DENLayer dzn_tSF_3DEN_DynaiLayer; } forEach _assets;

		[(_zone get3DENAttribute "Name") select 0, _assets] call dzn_fnc_tSF_3DEN_AddAssetsToDynaiFolder;
		add3DENConnection ["Sync", _assets, _zone];

		(format ["tSF Tools - Dyani: %1 asset was added", _modes select dzn_tSF_3DEN_Parameter]) call dzn_fnc_tSF_3DEN_ShowNotif;
	};
};

dzn_fnc_tSF_3DEN_AddAssetsToDynaiFolder = {
	params["_zoneName", "_assets"];

	call dzn_fnc_tSF_3DEN_RemapDynaiFolders;

	private _subFolderData = dzn_tSF_3DEN_DynaiSubfolders select { _x select 0 == _zoneName };
	private _subFolderID = 0;

	if (_subFolderData isEqualTo []) then {
		_subFolderID = dzn_tSF_3DEN_DynaiLayer add3DENLayer (format["%1 zone", _zoneName]);
		dzn_tSF_3DEN_DynaiSubfolders pushBack [_zoneName, _subFolderID];
	} else {
		_subFolderID = (_subFolderData select 0) select 1;
	};

	{ _x set3DENLayer _subFolderID } forEach _assets;
};

dzn_fnc_tSF_3DEN_RemapDynaiFolders = {
	private _folders = (get3DENLayerEntities dzn_tSF_3DEN_DynaiLayer) select { typename  _x == "SCALAR" };

	{
		private _folderId = _x;
		private _entities = (get3DENLayerEntities _x) select {!isNil { typeOf _x }};
		{
			private _name = (_x get3DENAttribute "name") select 0;
			if (
				typeOf _x == "Logic"
				&& _name != ""
				&& _name != "dzn_dynai_core"
			) then {
				if ( (dzn_tSF_3DEN_DynaiSubfolders select { _x select 0 == _name}) isEqualTo [] ) then {
					dzn_tSF_3DEN_DynaiSubfolders pushBack [_name, _folderId];
				};
			};
		} forEach _entities;
	} forEach _folders;
};


