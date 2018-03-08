/*
 *	F6 Rapid Artillery Zeus Screen
 */
tSF_fnc_adminTools_RapidArtillery_showZeusSceen = {
	if !(call tSF_fnc_adminTools_checkIsAdmin) exitWith {};
	if !(tSF_AdminTools_RapidArtillery_Enabled) exitWith {};

	private _trps = allMapMarkers select { ["TRP", markerText _x, false] call BIS_fnc_inString };
	private _tgtClassObjects = entities [tSF_AdminTools_RapidArtillery_TargetClass, [], false, false];
	
	private _tgtNames 		= [] + (_tgtClassObjects apply { name _x }) + (_trps apply { markerText _x });
	private _tgtPos 		= [] + (_tgtClassObjects apply { getPosATL _x })  + (_trps apply { getMarkerPos _x });
	private _shapes 		= ["CIRCLE", "LINE"];
	private _directions		= [["SOUTH-to-NORTH", 0], ["SW-to-NE", 45], ["WEST-to-EAST", 90], ["SE-to-NW", 315]];
	private _size 		= [["NORMAL / 50m", 50], ["WIDE / 100m", 100], ["EXTRA WIDE / 250m", 250], ["NARROW / 25m", 25]];
	private _gunType 		= tSF_AdminTools_RapidArtillery_ArtillerySettings apply { _x select 0 };
	private _countValues 	= [1,3,6,9];
	private _countTitles 	= _countValues apply { format ["%1 times", _x] };
	private _etaValues 		= [40,50,60,5,10,15,20,30];
	private _etaTitles 		= _etaValues apply { format ["%1 sec", _x] };
	private _delayValues 	= [2,5,10,15,20,30,40,50,60,90,120];
	private _delayTitles 	= _delayValues apply { format ["%1 sec", _x] };

 	/*
 	[ 8-grid            ][                   ][ TRP             V ]
 	[ SHAPE           > ][ DIRECTION       > ][ SIZE            > ]
 	[                                                             ]
 	[ GUN		        ][ ROUND TYPE        ][ TIMES             ]
 	[ ETA               ][                   ][ DELAY             ]
 	[ 															  ]
 	[ CANCEL            ][		             ][ CREATE FIREMISS...]
 	*/

 	[
 		[0, "HEADER", "GSO Zeus Screen - Rapid Artillery Support"]
 		,[1, "INPUT"]
 		,[1, "LABEL", "8-GRID<t align='center'>or</t><t align='right'>TGT</t>"]
 		,[1, "DROPDOWN", _tgtNames, _tgtPos]
 		,[2, "DROPDOWN", _shapes, []]
 		,[2,"LISTBOX", _directions apply { _x select 0 }, _directions apply { _x select 1 }]
		,[2,"LISTBOX", _size apply { _x select 0 }, _size apply { _x select 1 }]

 		, [3, "LABEL", "Gun"]
 		, [3, "LABEL", "Round"]
 		, [3, "LABEL", "Quantity"]
		
		, [4, "DROPDOWN", _gunType, [0,1,2]]
		, [4, "DROPDOWN", tSF_AdminTools_RapidArtillery_AllowedRounds, [0,1,2]]
		, [4, "DROPDOWN", _countTitles, _countValues]
		
		, [5, "DROPDOWN", _etaTitles, _etaValues]
		, [5, "LABEL", "ETA <t align='right'>Delay</t>"]
		, [5, "DROPDOWN", _delayTitles, _delayValues]
		
		, [6, "LABEL", ""]
		, [7, "BUTTON", "CANCEL", { closeDialog 2 }]
		, [7, "LABEL", ""]
		, [7, "BUTTON", "CREATE FIREMISSION", {
			closeDialog 2;
			_this spawn tSF_fnc_adminTools_RapidArtillery_createFiremission;
		}]
	] call dzn_fnc_ShowAdvDialog;
};


tSF_fnc_adminTools_RapidArtillery_createFiremission = {
	params ["_grid", "_tgt", "_shape", "_dir", "_size", "_gun", "_round", "_times", "_eta", "_delay"];

	if (count (_grid select 0) > 0 && count (_grid select 0) < 8) exitWith {
		hint parseText "<t size='1' color='#FFD000' shadow='1'>Rapid Artillery</t><br /><br />Wrong format of 8-grid";
	};

	private _tgtName = "";
	private _tgtPos = [];
	if ((_grid select 0) == "") then {
		_tgtName = _tgt select 1;
		_tgtPos = _tgt select 2 select (_tgt select 0);
	} else {
		_tgtName = "Target";
    	_tgtPos = ((_grid select 0) splitString " " joinString "") call dzn_fnc_getPosOnMapGrid;
	};

	private _gun = _gun select 0;
	private _round = _round select 0;
	private _times = (_times select 2) select (_times select 0);
	private _eta = (_eta select 2) select (_eta select 0);
	private _delay = (_delay select 2) select (_delay select 0);

	tSF_AdminTools_RapidArtillery_FiremissionCount = tSF_AdminTools_RapidArtillery_FiremissionCount + 1;
	private _firemissionNumber = tSF_AdminTools_RapidArtillery_FiremissionCount;

	private _gunName 	= tSF_AdminTools_RapidArtillery_ArtillerySettings select _gun select 0;
	private _typeName	= tSF_AdminTools_RapidArtillery_AllowedRounds select _round;
	private _type		= ((tSF_AdminTools_RapidArtillery_ArtillerySettings select _gun) select 1) select _round;
	
	// Hint
	hint parseText format [
		"<t size='1' color='#FFD000' shadow='1'>Rapid Artillery Firemission #%1:</t>
		<br /><br />%2 at %3
		<br />%4, %5, %6
		<br /><t color='#FFD000'>ETA %7 sec</t> with %8 sec delay between shots"
		, _firemissionNumber
		, _tgtName, _tgtPos call dzn_fnc_getMapGrid
		, _gunName, _typeName, _times
		, _eta, _delay		
	];
	player createDiaryRecord [tSF_AdminTools_Topic, [
		"Rapid Artillery Missions"
		, format [
			"<font color='#12C4FF' size='14'>Firemission #%1</font><br />%2 at %3, %4, %5 %6 times"
			, _firemissionNumber, _tgtName, _tgtPos call dzn_fnc_getMapGrid, _gunName, _typeName, _times
		]
	]];
	
	// Firemission
	sleep (_eta - 1);

	hint parseText format [
		"<t size='1' color='#FFD000' shadow='1'>Rapid Artillery Firemission #%1:</t>
		<br /><br /><t size='1.25'>Splash!</t>"
		, _firemissionNumber
	];
	sleep 1;

	[[_tgtPos, _shape select 1, _dir select 3, _size select 3], _type, 1, _times, 2, _delay] spawn dzn_fnc_StartVirtualFiremission;

	hint parseText format [
		"<t size='1' color='#FFD000' shadow='1'>Rapid Artillery Firemission #%1:</t>
		<br /><br />%2 at %3, %4, %5
		<br />Rounds complete!"
		, _firemissionNumber
		, _tgtName, _tgtPos call dzn_fnc_getMapGrid, _typeName, _times
	];
};