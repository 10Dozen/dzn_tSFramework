#include "script_component.hpp"

FUNC(isAuthorizedUser) = {
	// Player call tSF_fnc_AirborneSupport_isAuthorizedUser

	[_this, "POM"] call EFUNC(Authorization,checkPlayerAuthorized)
};

/*
 *	Functions
 */
FUNC(addTopic) = {
	player createDiarySubject [GVAR(TopicName),GVAR(TopicName)];

	// Mission Notes
	private _topic = "";
	{
		_topic = format["%1%2", _topic, _x];
	} forEach [
		"<font color='#12C4FF' size='14'>Операционные метки</font>"
		, "<br /><font color='#A0DB65'><execute expression='[""Infantry"", """", east] call " + QFUNC(addPOM) + "'>Добавить - Пехота (Красный)</execute></font>"
		, "<br /><font color='#A0DB65'><execute expression='[""Vehicle"", """", east] call " + QFUNC(addPOM) + "'>Добавить - Техника (Красный)</execute></font>"
		, "<br />---"
		, "<br /><font color='#A0DB65'><execute expression='[""Infantry"", """", west] call " + QFUNC(addPOM) + "'>Добавить - Пехота (Синий)</execute></font>"
		, "<br /><font color='#A0DB65'><execute expression='[""Vehicle"", """", west] call " + QFUNC(addPOM) + "'>Добавить - Техника (Синий)</execute></font>"
		, "<br />---"
		, "<br /><font color='#A0DB65'><execute expression='[""Infantry"", """", resistance] call " + QFUNC(addPOM) + "'>Добавить - Пехота (Зеленый)</execute></font>"
		, "<br /><font color='#A0DB65'><execute expression='[""Vehicle"", """", resistance] call " + QFUNC(addPOM) + "'>Добавить - Техника (Зеленый)</execute></font>"
		, "<br />---"
		, "<br /><font color='#A0DB65'><execute expression='[""Infantry"", ""JTAC"", west] call " + QFUNC(addPOM) + "'>Добавить - JTAC</execute></font>"
	];
	
	player createDiaryRecord [GVAR(TopicName), [SUBTOPIC_NAME, _topic]];	
};

FUNC(getMarkerOnClick) = {
	params["_control","_posX","_posY"];
	
	private _pos = _control ctrlMapScreenToWorld [_posX, _posY];	
	private _thresholdDistnace = 250 * ctrlMapScale (findDisplay 12 displayCtrl 51);		
	private _mrk = GVAR(Markers) select { 
		(getMarkerPos _x) distance2d _pos < _thresholdDistnace
	};
	
	if (_mrk isEqualTo []) exitWith { "" };
	
	(_mrk select 0)
};
	
FUNC(dragMarker) = {
	params ["_control", "_posX", "_posY"];
	private _pos = _control ctrlMapScreenToWorld [_posX, _posY];		
	GVAR(CurrentMrk) setMarkerPosLocal _pos;	
};

FUNC(addPOM) = {
	params["_type", "_text", "_side", ["_protected", false], ["_pos", (findDisplay 12 displayCtrl 51) ctrlMapScreenToWorld [0.5, 0.5]]];

	private _mrk = [
		format ["mrk_pom_%1", GVAR(MarkerLastID)]
		, _pos
		, [GVAR(VehicleMarker),GVAR(InfantryMarker)] select ([_type, "infantry", false] call BIS_fnc_inString)
		, switch (_side) do {
			case west: { "ColorBLUFOR" };
			case east: { "ColorOPFOR" };
			case resistance: { "ColorIndependent" };
		}
		, _text
		, true
	] call dzn_fnc_createMarkerIcon;
	
	GVAR(Markers) pushBack _mrk;
	if (_protected) then { GVAR(ProtectedPOMs) pushBack _mrk; };
	GVAR(MarkerLastID) = GVAR(MarkerLastID) + 1;
};

FUNC(changeName) = {
	if (GVAR(ProtectedPOMs) findIf { _this == _x } > -1) exitWith {};
	
	private _labels = [GVAR(VehicleLabels),GVAR(InfantryLabels)] select (markerType _this == GVAR(InfantryMarker));
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

FUNC(removePOM) = {
	if (GVAR(ProtectedPOMs) findIf { _this == _x } > -1) exitWith {};
	
	deleteMarker GVAR(CurrentMrk); 
	GVAR(Markers) = GVAR(Markers) - [GVAR(CurrentMrk)];	
};

/* Event Handlers */
FUNC(addEventHandlers) = {
	GVAR(MouseMoving) = MAP_CTRL ctrlAddEventHandler ["MouseMoving", {
		if (GVAR(CurrentMrk) == "") exitWith {};
		call FUNC(dragMarker);
		_this
	}];

	GVAR(MouseButtonDown) = MAP_CTRL ctrlAddEventHandler ["MouseButtonDown", {
		GVAR(CurrentMrk) = [_this # 0, _this # 2, _this # 3] call FUNC(getMarkerOnClick);
		_this
	}];

	GVAR(MouseButtonUp) = MAP_CTRL ctrlAddEventHandler ["MouseButtonUp", {
		if (GVAR(CurrentMrk) == "") exitWith {};
		GVAR(CurrentMrk) = "";	
		_this
	}];

	GVAR(KeyUp) = MAP_CTRL ctrlAddEventHandler ["KeyUp", {
		if (GVAR(CurrentMrk) == "") exitWith {};
	
		// CTRL Btn
		if (_this select 3) then { GVAR(CurrentMrk) call FUNC(changeName); };
		
		// DELETE Btn
		if (_this select 1 == 211) then { 
			GVAR(CurrentMrk) call FUNC(removePOM);
			GVAR(CurrentMrk) = "";
		};
		
		_this
	}];
};

FUNC(removeEHs) = {
	MAP_CTRL ctrlRemoveEventHandler ["KeyUp", GVAR(KeyUp)];
	MAP_CTRL ctrlRemoveEventHandler ["MouseButtonUp", GVAR(MouseButtonUp)];
	MAP_CTRL ctrlRemoveEventHandler ["MouseButtonDown", GVAR(MouseButtonDown)];
	MAP_CTRL ctrlRemoveEventHandler ["MouseMoving", GVAR(MouseMoving)];
};