call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\POM\Settings.sqf";

// ********************
// INITIALIZATION
// ********************

if !(hasInterface) exitWith {};
if (isMultiplayer &&  !(roleDescription player in tSF_POM_AuthorizedUsers)) exitWith {};

waitUntil { time > 5 };

tSF_POM_CurrentMrk = "";
tSF_POM_Markers = [];
tSF_POM_ProtectedPOMs = [];
tSF_POM_MarkerLastID = 0;

/*
 *	Functions
 */
tSF_fnc_POM_GetMarkerOnClick = {
	params["_control","_posX","_posY"];
	
	private _pos = _control ctrlMapScreenToWorld [_posX, _posY];	
	private _thresholdDistnace = 250 * ctrlMapScale (findDisplay 12 displayCtrl 51);		
	private _mrk = tSF_POM_Markers select { 
		(getMarkerPos _x) distance2d _pos < _thresholdDistnace
	};
	
	if (_mrk isEqualTo []) exitWith { "" };
	
	(_mrk select 0)
};
	
tSF_fnc_POM_DragMarker = {
	params ["_control", "_posX", "_posY"];
	private _pos = _control ctrlMapScreenToWorld [_posX, _posY];		
	tSF_POM_CurrentMrk setMarkerPosLocal _pos;	
};

tSF_fnc_POM_AddTopic = {
	player createDiarySubject [tSF_POM_TopicName,tSF_POM_TopicName];

	// Mission Notes
	private _topic = "";
	{
		_topic = format["%1%2", _topic, _x];
	} forEach [
		"<font color='#12C4FF' size='14'>Операционные метки</font>"
		, "<br /><font color='#A0DB65'><execute expression='[""Infantry"", """", east] call tSF_fnc_POM_AddPOM'>Добавить - Пехота (Красный)</execute></font>"
		, "<br /><font color='#A0DB65'><execute expression='[""Vehicle"", """", east] call tSF_fnc_POM_AddPOM'>Добавить - Техника (Красный)</execute></font>"
		, "<br />---"
		, "<br /><font color='#A0DB65'><execute expression='[""Infantry"", """", west] call tSF_fnc_POM_AddPOM'>Добавить - Пехота (Синий)</execute></font>"
		, "<br /><font color='#A0DB65'><execute expression='[""Vehicle"", """", west] call tSF_fnc_POM_AddPOM'>Добавить - Техника (Синий)</execute></font>"
		, "<br />---"
		, "<br /><font color='#A0DB65'><execute expression='[""Infantry"", """", resistance] call tSF_fnc_POM_AddPOM'>Добавить - Пехота (Зеленый)</execute></font>"
		, "<br /><font color='#A0DB65'><execute expression='[""Vehicle"", """", resistance] call tSF_fnc_POM_AddPOM'>Добавить - Техника (Зеленый)</execute></font>"
	];
	
	player createDiaryRecord [tSF_POM_TopicName, ["Add Operational Marker", _topic]];	
};

tSF_fnc_POM_AddPOM = {
	params["_type", "_text", "_side", ["_protected", false]];
	
	private _mrk = [
		format ["mrk_pom_%1", tSF_POM_MarkerLastID]
		, [500, 200 + 100*tSF_POM_MarkerLastID, 0]
		, if ( [_type, "infantry", false] call BIS_fnc_inString ) then { 
			tSF_POM_InfantryMarker
		} else {
			tSF_POM_VehicleMarker
		}
		, switch (_side) do {
			case west: { 			"ColorBLUFOR" };
			case east: { 			"ColorOPFOR" };
			case resistance: { 		"ColorIndependent" };
		}
		, _text
		, true
	] call dzn_fnc_createMarkerIcon;
	
	tSF_POM_Markers pushBack _mrk;
	if (_protected) then { tSF_POM_ProtectedPOMs pushBack _mrk; };
	tSF_POM_MarkerLastID = tSF_POM_MarkerLastID + 1;
};

tSF_fnc_POM_ChangeName = {
	if (_this in tSF_POM_ProtectedPOMs) exitWith {};
	
	private _labels = if (markerType _this == tSF_POM_InfantryMarker) then { tSF_POM_InfantryLabels } else { tSF_POM_VehicleLabels };
	private _curentLabelID = _labels find (markerText _this);
	private _label = "";
	
	if (_curentLabelID > -1) then {	
		if (_curentLabelID + 1 < (count _labels)) then {
			_label = _labels select (_curentLabelID + 1);
		} else {
			_label = _labels select 0;
		};
	} else {
		_label = _labels select 0;
	};
	
	_this setMarkerTextLocal _label;
};

tSF_fnc_POM_RemovePOM = {
	if (_this in tSF_POM_ProtectedPOMs) exitWith {};
	
	deleteMarker tSF_POM_CurrentMrk; 
	tSF_POM_Markers = tSF_POM_Markers - [tSF_POM_CurrentMrk];	
};


/*
 *	Generate Operational Markerks
 */
 
if (tSF_POM_GenerateMarkersFromGroups) then {
	{	
		private _grpPOM = ["Infantry", groupId (group _x), side _x, true];
		
		if !(_grpPOM in tSF_POM_OperationalMarkers) then {
			tSF_POM_OperationalMarkers pushBack _grpPOM;
		};	
	} forEach (call BIS_fnc_listPlayers);
};

{
	_x call tSF_fnc_POM_AddPOM; // _x = [ "Infantry", "Razor 1'1", east]
} forEach tSF_POM_OperationalMarkers;


/*
 *	Run handlers
 */
 
call tSF_fnc_POM_AddTopic;

tSF_POM_MouseButtonDown_EH = (findDisplay 12 displayCtrl 51) ctrlAddEventHandler ["MouseButtonDown", {		
	tSF_POM_CurrentMrk = [_this select 0, _this select 2, _this select 3] call tSF_fnc_POM_GetMarkerOnClick;
	_this	
}];

tSF_POM_MouseMoving = (findDisplay 12 displayCtrl 51) ctrlAddEventHandler ["MouseMoving", {
	if (tSF_POM_CurrentMrk == "") exitWith {};
	call tSF_fnc_POM_DragMarker;		
	_this	
}];

tSF_POM_MouseButtonUp_EH = (findDisplay 12 displayCtrl 51) ctrlAddEventHandler ["MouseButtonUp", {
	if (tSF_POM_CurrentMrk == "") exitWith {};
	tSF_POM_CurrentMrk = "";	
	_this	
}];

tSF_POM_KeyUp_EH = (findDisplay 12 displayCtrl 51) ctrlAddEventHandler ["KeyUp", {
	if (tSF_POM_CurrentMrk == "") exitWith {};
	
	// Control Btn
	if (_this select 3) then { tSF_POM_CurrentMrk call tSF_fnc_POM_ChangeName; };
	
	// DELETE Btn
	if (_this select 1 == 211) then { 
		tSF_POM_CurrentMrk call tSF_fnc_POM_RemovePOM;
		tSF_POM_CurrentMrk = "";
	};
	
	_this
}];



waitUntil { sleep 10; !alive player };
{
	(findDisplay 12 displayCtrl 51) ctrlRemoveEventHandler _x;
} forEach [
	["MouseButtonDown", tSF_POM_MouseButtonDown_EH]
	,["MouseMoving", tSF_POM_MouseMoving]
	,["MouseButtonUp", tSF_POM_MouseButtonUp_EH]
	,["KeyUp", tSF_POM_KeyUp_EH]
];
