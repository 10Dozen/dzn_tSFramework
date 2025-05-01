#include "script_component.hpp"

/*
 *	Vehicle Availability
 */
FUNC(checkVehicleAvailable) = {
	params["_veh",["_type", "all"]];
	// "all"  - check both damage, fuel and condition
	// "fuel" - check fuel capacity
	// "state" - check fuel & damage

	if !(alive _veh) exitWith { false };
	private _result = true;
	
	if (["fuel","state","all"] findIf {_x == _type} > -1) then {
		_result = ((fuel _veh) >= GVAR(FuelLimit));
	};
	if (["state","all"] findIf {_x == _type} > -1) then {
		_result = _result && { (canMove _veh) && ((damage _veh) <= GVAR(DamageLimit)) };
	};
	if (["all"] findIf {_x == _type} > -1) then {
		private _cond = _veh getVariable [QGVAR(Condition), { true }];
		_result = _result && _cond;
	};

	_result
};

FUNC(checkVehicleFree) = {
	params["_veh", "_type"];

	if !([_veh, "STATE", "Waiting"] call FUNC(AssertStatus)) exitWith { false };

	switch toLower(_type) do {
		case "rtb": { (_veh distance2d ([_veh, "RTB POINT"] call FUNC(GetStatus)) > 30) };
		case "callin": { !isPlayer (driver _veh) };
		// case "pickup": { true };
		default { true };
	}
};

/*
 *	MENU
 */
FUNC(showHint) = {
	params["_veh","_title","_subtitle",["_subtitleAsScreenText",false]];

	private _callsign = [_veh, "CALLSIGN"] call FUNC(getStatus);
	private _type = (typeof _veh) call dzn_fnc_getVehicleDisplayName;

	private _text = format [
		"<t color='#EDB81A' size='1.5' align='center' font='PuristaBold'>%1</t>
		<br/><t color='#EDB81A' font='PuristaBold'>%2</t>
		<br/><t font='PuristaBold'>%3</t>"
		, _callsign
		, _type
		, _title
	];

	if (!_subtitleAsScreenText) then {
		_text = _text + "<br/><br/>" + _subtitle;
	} else {
		_subtitle = str parseText _subtitle;
		[_subtitle, 1, 2, [0.93,0.72,0.10,1], true] spawn BIS_fnc_WLSmoothText;
	};

	hint parseText _text;
};
FUNC(showMsg) = {
	params ["_veh","_message"];
	[(driver _veh), _message] remoteExec ["sideChat", group player];
};

FUNC(ShowRequestMenu) = {
	params["_callsign"];

	if !(player call FUNC(isAuthorizedUser)) exitWith {};
	private _veh = (_callsign call FUNC(getProvider)) select 0;
	if !(_veh call FUNC(checkVehicleAvailable)) exitWith {
		[_veh, "IS NOT AVAILABLE", ""] call FUNC(showHint);
	};

	private _inProgress = (
		!([_veh, "STATE", "Waiting"] call FUNC(assertStatus))
		&& [_veh, "IN PROGRESS"] call FUNC(getStatus)
	);

	private _canRTB = [_veh, "rtb"] call FUNC(checkVehicleFree);
	private _canCallin = [_veh, "callin"] call FUNC(checkVehicleFree);
	private _canPickup = [_veh, "pickup"] call FUNC(checkVehicleFree);

	private _menu = [
		[0, "HEADER", "AIRBORNE SUPPORT"]
		, [1, "LABEL", "<t align='center' color='#c1c1c1'>CALLSIGN | TYPE</t>"]
		, [2, "LABEL", format ["<t align='center' font='PuristaBold'>%1</t>", _callsign] ]
		, [3, "LABEL", format ["<t align='center' color='#c1c1c1'>%1</t>", (typeof _veh) call dzn_fnc_getVehicleDisplayName] ]
		, [4, "LABEL", ""]
	];

	private _i = 5;
	if (_inProgress) then {
		private _landType = ([_veh, "LAND MODE"] call FUNC(getStatus));
		if (_landType != "") then {
			if (_landType == "GET IN") then { _landType = "LAND"; };
			_landType = format ["/ %1 ", _landType];
		};

		_menu pushBack [_i, "HEADER", format [
			"<t font='PuristaBold' align='center'>MISSION IN PROGRESS</t><t align='center'> [ %1 %2]</t>"
			, [_veh, "STATE"] call FUNC(getStatus)
			, _landType
		]];
		_i = _i + 1;
		
		if ([_veh, "STATE", "Pickup"] call FUNC(assertStatus)) then {
			_menu pushBack [_i, "BUTTON", "<t align='center'>LAND ON LZ</t>", {
				closeDialog 2;
				[_args, "LAND"] call FUNC(requestLandMode);
			}, _callsign];
			_i = _i + 1;

			_menu pushBack [_i, "BUTTON", "<t align='center'>HOVER ON LZ</t>", {
				closeDialog 2;
				[_args, "HOVER"] call FUNC(requestLandMode);
			}, _callsign];
			_i = _i + 1;
		};
		
		_menu pushBack [_i, "BUTTON", "<t align='center'>ABORT CURRENT MISSION</t>", {
			closeDialog 2;
			_args call FUNC(RequestAbortMission);
		}, _callsign];
		_i = _i + 1;
	} else {
		_menu pushBack [_i, "HEADER", "<t font='PuristaBold' align='center'>READY FOR MISSION</t>"];
		_i = _i + 1;

		if (GVAR(ReturnToBase) && _canRTB) then {
			_menu pushBack [_i, "BUTTON", "<t align='center'>RETURN TO BASE</t>", {
				closeDialog 2;
				_args call FUNC(requestRTB);
			}, _callsign];
			_i = _i + 1;
		};

		if (GVAR(RequestPickup) && _canPickup) then {
			_menu pushBack [_i, "BUTTON", "<t align='center'>REQUEST PICKUP</t>", {
				closeDialog 2;
				_args call FUNC(requestPickup);
			}, _callsign];
			_i = _i + 1;
		};

		if (GVAR(CallIn) && _canCallin) then {
			_menu pushBack [_i, "BUTTON", "<t align='center'>CALL IN</t>", {
				closeDialog 2;
				_args call FUNC(requestCallIn);
			}, _callsign];
			_i = _i + 1;
		};
	};

	_menu pushBack [_i, "BUTTON", "<t align='center'>CANCEL</t>", { closeDialog 2 }];
	_menu call dzn_fnc_ShowAdvDialog;
};

/*
 *	Requseting
 *
 *	Pick Up
 */
FUNC(pathDrawer) = {
	params ["_mode", "_payload"];
	switch (toUpper _mode) do {
		case "ADD": {
			if (isNil QGVAR(OnMapPath)) then {
				GVAR(OnMapPath) = [_payload];
			} else {
				GVAR(OnMapPath) pushBack _payload;
			};
			if (isNil QGVAR(PathDrawerEH)) then { ["START"] call FUNC(pathDrawer); };
		};
		case "ICON": {
			GVAR(OnMapIcon) = switch (toUpper _payload) do {
				case "INGRESS": { ["\A3\ui_f\data\map\markers\military\marker_CA.paa", [1,0.2,0.2,1], "Ingress"] };
				case "EGRESS": { ["\A3\ui_f\data\map\markers\military\marker_CA.paa", [1,0.2,0.2,1], "Engress"] };
				case "PICKUP": { ["\A3\ui_f\data\map\markers\military\pickup_CA.paa", [1,0.5,0.5,1], "Pick up"] };
			};
		};
		case "START": {
			GVAR(PathDrawerEH) = (findDisplay 12 displayCtrl 51) ctrlAddEventHandler [
				"Draw",
				{
					private _mousePos = ((_this # 0) ctrlMapScreenToWorld getMousePosition);
					private _nodes = +GVAR(OnMapPath);
					_nodes pushBack _mousePos;

					for "_i" from 0 to (count _nodes)-2 do {
						(_this # 0) drawLine [_nodes # _i, _nodes # (_i + 1), [0,0,1,1]];
					};

					if (!isNil QGVAR(OnMapIcon)) then {
						(_this # 0) drawIcon [
							GVAR(OnMapIcon) # 0,
							GVAR(OnMapIcon) # 1,
							_mousePos, 32, 32, 0,
							GVAR(OnMapIcon) # 2,
							true
						];
					};
				}
			];
		};
		case "STOP": {
			(findDisplay 12 displayCtrl 51) ctrlRemoveEventHandler ["Draw", GVAR(PathDrawerEH)];
			GVAR(PathDrawerEH) = nil;
			GVAR(OnMapPath) = nil;
			GVAR(OnMapIcon) = nil;
		};
	};
};

FUNC(requestPickup) = {
	private _veh = (_this call FUNC(getProvider)) select 0;
	if (!visibleMap) then { openMap [true,false]; };

	[
		_veh
		, "Requesting Pickup"
		, "(Step 1 of 2) Select INGRESS waypoint!"
		, true
	] call FUNC(showHint);

	["ADD", getPos _veh] call FUNC(pathDrawer);
	["ICON", "INGRESS"] call FUNC(pathDrawer);

	[QGVAR(clickForPickupEH), "onMapSingleClick", {
		[QGVAR(clickForPickupEH), "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;

		params ["_id","_pos","_alt","_shifr", "_veh"];
		GVAR(Ingress_Mrk) = ["tSF_Ingress", _pos, "mil_marker", "ColorCIV", "Ingress", true] call dzn_fnc_createMarkerIcon;
		["ADD", _pos] call FUNC(pathDrawer);
		["ICON", "PICKUP"] call FUNC(pathDrawer);

		if (!visibleMap) then { openMap [true,false]; };
		[_veh, "Requesting Pickup", "(Step 2 of 2) Select LZ!", true] call FUNC(showHint);

		[QGVAR(clickForPickupLZEH), "onMapSingleClick", {
			params ["_id","_pos","_alt","_shifr","_veh","_ingressPos"];
			if (_pos call dzn_fnc_isInWater) exitWith { hint "Landing Zone should not be in water!"; };

			private _nearSafePos = [_pos, 0, 20, 10] call BIS_fnc_findSafePos;
			if (_pos distance2d _nearSafePos > 20) exitWith { hint "Position is not available for landing!"; };
			openMap [false,false];

			[_veh, [
				["STATE", "Pickup"]
				, ["SIDE", side player]
				, ["LANDING POINT", _pos]
				, ["INGRESS POINT", _ingressPos]
				, ["IN PROGRESS", true]
				, ["LAND MODE", "GET IN"]
			]] call FUNC(setStatus);

			[_veh, "Pickup Requested", "Approaching to AO!"] call FUNC(showHint);
			if (!isNull driver _veh) then {
				[_veh, "10-4, moving to AO!"] call FUNC(showMsg);
			};

			deleteMarker GVAR(Ingress_Mrk);

			["STOP"] call FUNC(pathDrawer);
			[QGVAR(clickForPickupLZEH), "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
		}, [_veh,_pos]] call BIS_fnc_addStackedEventHandler;
	}, [_veh]] call BIS_fnc_addStackedEventHandler;
};

FUNC(requestLandMode) = {
	params ["_callsign","_mode"];
	private _veh = (_callsign call FUNC(getProvider)) # 0;

	private _msg = switch (toUpper _mode) do {
		case "LAND": { "Landing on LZ, confirmed!" };
		case "HOVER": { "Roger-dodger, no landing, hovering over LZ!" };
	};

	[_veh, "LAND MODE", _mode] call FUNC(setStatus);
	[_veh, _msg] call FUNC(showMsg);
};

FUNC(requestRTB) = {
	private _veh =(_this call FUNC(getProvider)) select 0;
	if (!visibleMap) then { openMap [true,false]; };

	["ADD", getPos _veh] call FUNC(pathDrawer);
	["ICON", "EGRESS"] call FUNC(pathDrawer);
	[
		_veh
		, "Returning to base"
		, "Select EGRESS waypoint!"
		, true
	] call FUNC(showHint);

	[QGVAR(clickForRTBEH), "onMapSingleClick", {
		[QGVAR(clickForRTBEH), "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
		["STOP"] call FUNC(pathDrawer);
		openMap [false, false];

		private _veh =_this select 4;
		_veh engineOn true;
		[_veh, [
			["EGRESS POINT", _pos]
			, ["SIDE", side player]
			, ["STATE", "RTB"]
			, ["IN PROGRESS", true]
			, ["LAND MODE", "LAND"]
		]] call FUNC(setStatus);

		[
			_veh
			, "Returning to base"
			, "Leaving AO!"
		] call FUNC(showHint);

		[_veh, "Leaving in 5 seconds and returning to base!"] call FUNC(showMsg);
	}, [_veh]] call BIS_fnc_addStackedEventHandler;
};

FUNC(requestCallIn) = {
	private _veh = (_this call FUNC(getProvider)) select 0;
	
	// Helicopter in air - instant switch
	if (isEngineOn _veh && getPosATL _veh # 2 > 10) exitWith {
		[
			_veh
			, "Approaching AO"
			, "Assuming direct control..."
		] call FUNC(showHint);
	
		[_veh, [
			["SIDE", side player]
			, ["STATE", "Call In Instant"]
			, ["IN PROGRESS", true]
			, ["LAND MODE", ""]
		]] call FUNC(setStatus);

		[player, _veh] call FUNC(AssignToCallInHelicopter);
	};

	if (!visibleMap) then { openMap [true,false]; };
	"SHOW" call FUNC(displayRestrictedAreaMarker);
	["ADD", getPos _veh] call FUNC(pathDrawer);
	["ICON", "INGRESS"] call FUNC(pathDrawer);

	[
		_veh
		, "Approaching AO"
		, "Select INGRESS waypoint!"
		, true
	] call FUNC(showHint);

	[QGVAR(clickForCallInEH), "onMapSingleClick", {
		[QGVAR(clickForCallInEH), "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
		openMap [false, false];
		"HIDE" call FUNC(displayRestrictedAreaMarker);
		["STOP"] call FUNC(pathDrawer);

		private _ingress = _pos;
		private _veh = _this select 4;

		[
			_veh
			, "Approaching AO"
			, "Assuming direct control in 15 seconds..."
		] call FUNC(showHint);
		[_veh, "Approaching to AO!"] call FUNC(showMsg);

		_veh engineOn true;
		[_veh, [
			["INGRESS POINT", _ingress]
			, ["SIDE", side player]
			, ["STATE", "Call In"]
			, ["IN PROGRESS", true]
		]] call FUNC(setStatus);

		[player, _veh] call FUNC(AssignToCallInHelicopter);
	}, [_veh]] call BIS_fnc_addStackedEventHandler;
};

FUNC(requestAbortMission) = {
	params ["_callsign"];
	private _veh = (_callsign call FUNC(getProvider)) select 0;

	if ([_veh, "STATE", "Call In"] call FUNC(assertStatus)) exitWith {
		[
			_veh
			, "Not possible to abort Call In mission"
			, "Wait for mission end"
		] call FUNC(showHint);
	};

	[_veh, "STATE", "Aborted"] call FUNC(setStatus);
	[_veh, "Mission Aborted", "Waiting for orders!"] call FUNC(showHint);
	[_veh, "Mission aborted. Waiting for orders!"] call FUNC(showMsg);

	[{ [_this, "STATE", "Waiting"] call FUNC(assertStatus) }, {
		_this call FUNC(ShowRequestMenu)
	}, _callsign] call CBA_fnc_waitUntilAndExecute;
};

/*
 *	Other functions (client side)
 */

FUNC(showInfo) = {
	if (!isNil QGVAR(InfoShown)) exitWith {};
	GVAR(InfoShown) = true;

	GVAR(showInfoIconColor) = (getArray(configfile >> "CfgMarkerColors" >> ("color" + str(side player)) >> "color")) apply {
		call compile _x
	};
	_iconDrawerEH= (findDisplay 12 displayCtrl 51) ctrlAddEventHandler [
		"Draw",
		{
			{
				(_this # 0) drawIcon [
					MRK_ICON_AIR,
					GVAR(showInfoIconColor),
					getPosATL (_x # 0),
					MRK_ICON_SIZE, MRK_ICON_SIZE, 0,
					format [
						"%1 [%2]"
						, [_x # 0, "NAME"] call FUNC(getStatus)
						, [_x # 0, "STATE"] call FUNC(getStatus)
					],
					true
				];
			} forEach GVAR(Vehicles);
		}
	];

	private _iconDrawer3DEHs = [];
	{
		_iconDrawer3DEHs pushBack ([
			_x # 0
			, [format ["%1", [_x # 0, "NAME"] call FUNC(getStatus)], [0.93,0.72,0.10,1], 1]
			, "under"
			, { player distance2d _this < 100 }
		] call dzn_fnc_addDraw3d);
	} forEach GVAR(Vehicles);

	[{
		(findDisplay 12 displayCtrl 51) ctrlRemoveEventHandler ["Draw", (_this # 0)];
		{ _x call dzn_fnc_RemoveDraw3d } forEach (_this # 1);
		GVAR(InfoShown) = nil;
	},[_iconDrawerEH, _iconDrawer3DEHs],10] call CBA_fnc_waitAndExecute;
};

FUNC(displayRestrictedAreaMarker) = {
	if (toLower(_this) == "show") then {
		createMarkerLocal [QGVAR(CloseAreaMrk), getPosASL player];
		QGVAR(CloseAreaMrk) setMarkerShapeLocal "ELLIPSE";
		QGVAR(CloseAreaMrk) setMarkerSizeLocal [GVAR(CallIn_MinDistance),GVAR(CallIn_MinDistance)];
		QGVAR(CloseAreaMrk) setMarkerColorLocal "ColorRed";
		QGVAR(CloseAreaMrk) setMarkerAlphaLocal 0.5;
	} else {
		deleteMarkerLocal QGVAR(CloseAreaMrk);
	};
};

FUNC(showTeleportMenu) = {
	GVAR(TeleportMenu) = [
		["Re-deploy",false]
		, ["Deploy to Squad",[2],"",-5,[["expression", "[player,'squad'] spawn " + QFUNC(doTeleport)]],"1","1"]
		, ["Deploy to Base",[3],"",-5,[["expression", "[player,'base'] spawn " + QFUNC(doTeleport)]],"1","1"]
	];
	showCommandingMenu format ["#USER:%1", QGVAR(TeleportMenu)];
};

FUNC(doTeleport) = {
	params["_unit","_dest"];

	private _pos = if ("base" == toLower(_dest)) then {
		selectRandom GVAR(ReturnPoints)
	} else {
		getPosATL ( selectRandom (units (group _unit)) )
	};
	_pos = [(_pos # 0) + 10, (_pos # 1) - 10,0];

	0 cutText ["", "WHITE OUT", 0.1];
	_unit allowDamage false;
	sleep 1;
	moveOut _unit;
	_unit setPosATL _pos;
	sleep 1;
	_unit allowDamage true;

	0 cutText ["", "WHITE IN", 1];
	GVAR(TeleportMenu) = [];
};
