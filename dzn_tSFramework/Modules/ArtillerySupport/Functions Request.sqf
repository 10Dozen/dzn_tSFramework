
tSF_fnc_ArtillerySupport_ShowMenu = {
	// @BatteryCallsign call tSF_fnc_ArtillerySupport_ShowMenu
	private _battery = _this call tSF_fnc_ArtillerySupport_GetBattery;

	if ([_battery, "State", "Waiting"] call tSF_fnc_ArtillerySupport_AssertStatus) then {
		_battery call tSF_fnc_ArtillerySupport_ShowRequestMenu;
	} else {
		if (_battery call tSF_fnc_ArtillerySupport_IsAvailable) then {
			_battery call tSF_fnc_ArtillerySupport_ShowCorrectionMenu;
		} else {
			if ([_battery, "REQUESTER", player] call tSF_fnc_ArtillerySupport_AssertStatus) then {
				_battery call tSF_fnc_ArtillerySupport_ShowAbortMenu;
			} else {
				[_battery, "Artillery is not available", "Mission in progress"] call tSF_fnc_ArtillerySupport_showHint;
			};
		};
	};
};

tSF_fnc_ArtillerySupport_ShowAbortMenu = {
	tSF_ArtillerySupport_LastRequested = _this;

	private _firemission = [_this, "Firemission"] call tSF_fnc_ArtillerySupport_GetStatus; //  [0@_pos, 1@_type, 2@_typeName, 3@_number, 4@_shape, 5@_dir, 6@_size, 7@_delay, 8@_trpName]
	private _pos = _firemission select 0;
	private _trpName = _firemission select 8;
	private _typeName = _firemission select 2;
	private _number = _firemission select 3;
	private _delay = _firemission select 7;

	[
		[0,"HEADER","Firemission Abort"]
		,[1,"LABEL","<t align='right'>Battery:</t>"]
		,[1,"LABEL", (_this select 1)]
		,[2,"LABEL", format [
			"<t align='center'>Firemission: %1, %2 %3, with %4 sec delay</t>"
			, if (_trpName == " ") then { _pos call dzn_fnc_getMapGrid } else { _trpName }
			, _number
			, _typeName
			, _delay
		]]
		, [3, "LABEL", ""]
		, [4, "BUTTON", "CLOSE", { closeDialog 2; }]
		, [4, "LABEL", ""]
		, [4, "BUTTON", "ABORT FIREMISSION", {
			closeDialog 2;
			tSF_ArtillerySupport_LastRequested call tSF_fnc_ArtillerySupport_AbortFiremission;
		}]
	] call dzn_fnc_ShowAdvDialog;
};


tSF_fnc_ArtillerySupport_ShowRequestMenu = {
	// [ @Logic, @Callsign, @VehicleDisplayName, @Vehicles ]
	/*

	[ 8-grid            ][                   ][ TRP             V ]
	[ SHAPE           > ][ DIRECTION       > ][ SIZE            > ]
	[                                                             ]
	[ ROUND TYPE        ][                   ][ TIMES             ]
	[                   ][                   ][ DELAY             ]

	*/
	tSF_ArtillerySupport_LastRequested = _this;
	private _AvailableFMs = _this call tSF_fnc_ArtillerySupport_GetBatteryMissionsAvailable;

	if !(_AvailableFMs select 4) exitWith {
		[_this, "Artillery is not available", "Out Of Ammo"] call tSF_fnc_ArtillerySupport_showHint;
	};

	private _shapes 		= ["CIRCLE", "LINE"];
	private _directions 		= [["SOUTH-to-NORTH", 0], ["SW-to-NE", 45], ["WEST-to-EAST", 90], ["SE-to-NW", 315]];
	private _size 		= [["NORMAL / 50m", 50], ["WIDE / 100m", 100], ["EXTRA WIDE / 250m", 250], ["NARROW / 25m", 25]];
	private _delay 		= [10,20,30,40,50,60,120,180,240];
	private _trpMarkers 		= allMapMarkers select { ["TRP", markerText _x, false] call BIS_fnc_inString };

	[
		[0,"HEADER","Firemission Request"]
		,[1,"LABEL","<t align='right'>Battery:</t>"]
		,[1,"LABEL", (_this select 1)]
		,[2,"LABEL", format ["<t align='center'>%1<t>", _AvailableFMs select 2]]
		,[3,"HEADER",""]
		,[4,"INPUT"]
		,[4,"LABEL", "<t align='left'>8-Grid</t> <t align='center' color='#999999'>TGT</t> <t align='right'>TRP</t>"]
		,[4,"DROPDOWN",[" "] + _trpMarkers apply { markerText _x },[""] + _trpMarkers]
		,[5,"LISTBOX", _shapes, []]
		,[5,"LISTBOX", _directions apply { _x select 0 }, _directions apply { _x select 1 }]
		,[5,"LISTBOX", _size apply { _x select 0 }, _size apply { _x select 1 }]
		,[6,"LABEL",""]
		,[7,"LISTBOX", _AvailableFMs select 0, _AvailableFMs select 1]
		,[7,"LABEL","<t align='left'>Type</t> <t align='center' color='#999999'>ROUND</t> <t align='right'>Number</t>"]
		,[7,"LISTBOX", ["5","6","7","8","9","10","1","2","3","4"],[]]
		,[8,"LABEL",""]
		,[8,"LABEL","Delay between rounds"]
		,[8,"DROPDOWN", ["Salvo"] + (_delay apply { format ["%1 sec", _x] }), [0] + _delay]
		,[9,"LABEL",""]
		,[10,"BUTTON","CANCEL",{closeDialog 2;}]
		,[10,"LABEL",""]
		,[10,"BUTTON","REQUEST", {
			closeDialog 2;
			[tSF_ArtillerySupport_LastRequested, _this, "Pending Searching Fire"] spawn tSF_fnc_ArtillerySupport_RequestFiremission;
		}]
		,[11,"LABEL",""]
		,[11,"BUTTON","FIRE FOR EFFECT", {
			closeDialog 2;
			[tSF_ArtillerySupport_LastRequested, _this, "Pending Fire For Effect"] spawn tSF_fnc_ArtillerySupport_RequestFiremission;

		}]
		,[11,"LABEL",""]
	] call dzn_fnc_ShowAdvDialog;
};

tSF_fnc_ArtillerySupport_ShowCorrectionMenu = {
	// [ @Logic, @Callsign, @VehicleDisplayName, @Vehicles ]
	tSF_ArtillerySupport_LastRequested = _this;
	private _firemission = [_this, "Firemission"] call tSF_fnc_ArtillerySupport_GetStatus; //  [0@_pos, 1@_type, 2@_typeName, 3@_number, 4@_shape, 5@_dir, 6@_size, 7@_delay, 8@_trpName]
	private _pos = _firemission select 0;
	private _type = _firemission select 1;
	private _typeName = _firemission select 2;
	private _number = _firemission select 3;
	private _spread = _firemission select 4;
	private _trpName = _firemission select 8;

	[
		[0,"HEADER","Adjust Firemission"]
		,[1,"LABEL","<t align='right'>Battery:</t>"]
		,[1,"LABEL", (_this select 1)]
		,[2,"LABEL", format [
			"<t align='center'>Firemission: %1, %2 %3"
			, if (_trpName == " ") then { _pos call dzn_fnc_getMapGrid } else { _trpName }
			, _number
			, _typeName
		]]

		,[3,"HEADER",""]

		,[4,"LABEL","<t align='center'>North</t>"]
		,[5,"LABEL","<t align='center'>West</t>"]
		,[5,"INPUT"]
		,[5,"LABEL","<t align='center'>East</t>"]
		,[6,"INPUT"]
		,[6,"BUTTON","<t align='center'>ADJUST</t>",{
			closeDialog 2;
			[tSF_ArtillerySupport_LastRequested, _this] call tSF_fnc_ArtillerySupport_AdjustFiremission;
		}]
		,[6,"INPUT"]
		,[7,"LABEL",""]
		,[7,"INPUT"]
		,[7,"LABEL",""]
		,[8,"LABEL","<t align='center'>South</t>"]
		,[9,"LABEL",""]

		,[10,"BUTTON","ABORT",{
			closeDialog 2;
			[tSF_ArtillerySupport_LastRequested] call tSF_fnc_ArtillerySupport_CancelFiremission;
		}]
		,[10,"LABEL",""]

		,[10,"BUTTON","FIRE FOR EFFECT",{
			closeDialog 2;
			[tSF_ArtillerySupport_LastRequested] call tSF_fnc_ArtillerySupport_FireForEffect;
		}]
	] call dzn_fnc_ShowAdvDialog;
};