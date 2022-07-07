#include "script_component.hpp"

// Public functions
FUNC(SendMessageOverLRRadio) = {
	/*
		Makes unit to send radio message 'using LR radio'.
		Message will be printed in 'commandChat' only to players with LR radio and within range.
		Has global effect.

		Params:
		_unitIdentity - (object) or (string) unit that sends the radio message OR callsign (requires unit to be registred)
		_message - (string) message to display
		_distance - (number) max distance to broadcast in meters. Optional, default - unlimited.

		Return: nothing

		Example:
		[player, "Get into da choppa!"] call tSF_Chatter_fnc_SendMessageOverLRRadio;
	*/
	params ["_unitIdentity", "_message", ["_distance", nil]];
	[_unitIdentity, _message, "LR", _distance] call FUNC(sendMessageOverRadio);
};

FUNC(SendMessageOverSWRadio) = {
	/*
		Makes unit to send radio message 'using SW radio'.
		Message will be printed in 'sideChat' only to players with LR radio and within range.
		Has global effect.

		Params:
		_unitIdentity - (object) or (string) unit that sends the radio message OR callsign (requires unit to be registred).
		_message - (string) message to display.
		_distance - (number) max distance to broadcast in meters. Optional, default - unlimited.

		Return: nothing

		Example:
		[player, "Get into da choppa!"] call tSF_Chatter_fnc_SendMessageOverSWRadio;
	*/
	params ["_unitIdentity", "_message", ["_distance", nil]];
	[_unitIdentity, _message, "SW", _distance] call FUNC(sendMessageOverRadio);
};

FUNC(sendMessageOverRadio) = {
	/*
		Sends message from unit by LR or SW. Has global effect.

		Params:
		_unitIdentity - (object) or (string) unit that sends the radio message OR callsign (requires unit to be registred).
		_message - (string) message to display.
		_radioType - (string) 'LR' for long-range or 'SW' for short range radio.
		_distance - (number) max distance to broadcast in meters. Optional, default - unlimited.

		Return: nothing

		Example:
		[player, "Get into da choppa!", "SW", 1500] call tSF_Chatter_fnc_sendMessageOverRadio;
		// Sends message over SW radio to all players in 1500 meters.
	*/
	params ["_unitIdentity", "_message", "_radioType", ["_distance", -1]];

	private _unit = objNull;
	private _lrRange = -1;
	private _swRange = -1;
	private _sayLocal = true;

	if (typename _unitIdentity == "STRING") then {
		// User identity is a Callsign
		private _talkerEntity = [_unitIdentity] call FUNC(getRadioTalkerByCallsign); //  [(units _grp) # 0, _lrRange, _swRange]

		if (_talkerEntity isNotEqualTo []) then {
			_unit = _talkerEntity # 0;
			_lrRange = _talkerEntity # 1;
			_swRange = _talkerEntity # 2;
			_sayLocal = !(_unit getVariable [QGVAR(IsDummySpeaker), false]);
		};
	} else {
		// User identity is actual unit
		 _unit = _unitIdentity;
		_lrRange = _maxDistance;
		_swRange = _maxDistance;
	};

	if (isNull _unit) exitWith {};

	private _func = "";
	private _comsRange = -1;
	private _position = getPos _unit;
	switch toUpper _radioType do {
		case "LR": {
			_func = QFUNC(showMessageOverLRRadio);
			_comsRange = _lrRange;
		};
		case "SW": {
			_func = QFUNC(showMessageOverSWRadio);
			_comsRange = _swRange;
		};
	};

	[_unit, _message, _comsRange] remoteExec [_func, 0];

	if (!_sayLocal) exitWith {};
	[_unit, _message, nil, 10] call FUNC(Say);
};

FUNC(Say) = {
	/*
		Makes unit to say given message, that will be displayed as subtitle for nearby players.
		Has global effect.

		Params:
		_unit - (object) a speaker.
		_message - (string) message to display.
		_name - (string) displayed name in the subtitle. Optional, by default - name returned by 'name' command.
		_distance - (number) max distance for speech to be 'heard' by players, in meters. Optional, default - 30 meters.

		Return: nothing

		Example:
		[player, "Get into da choppa!", "Dutch"] call tSF_Chatter_fnc_Say;
		// Will show 'Get into da choppa' message from 'Dutch' for all players within 30 meters from player.
	*/

	params ["_unit", "_message", ["_name", name (_this # 0)], ["_distance", 20]];

	[_unit, _message, _name, _distance] remoteExec [QFUNC(showMessageLocally), 0];
};
FUNC(Shout) = {
	/*
		Same as tSF_Chatter_fnc_Say, but for larger distance (75 meters)
	*/
	params ["_unit", "_message","_name"];
	[_unit, _message, _name, 75] call FUNC(Say);
};
FUNC(Whisper) = {
	/*
		Same as tSF_Chatter_fnc_Say, but for shorter distance (5 meters)
	*/
	params ["_unit", "_message","_name"];
	[_unit, _message, _name, 5] call FUNC(Say);
};


// Non-public functions
// Transmission functions
FUNC(showMessageOverLRRadio) = {
	/*
		Shows received LR radio message. Wrapper for FUNC(showMessageOverRadio).
	*/
	params ["_unit", "_message", "_maxDistance"];
	[_unit, _message, "LR", _maxDistance] call FUNC(showMessageOverRadio)
};

FUNC(showMessageOverSWRadio) = {
	/*
		Shows received SW radio message. Wrapper for FUNC(showMessageOverRadio).
	*/
	params ["_unit", "_message", "_maxDistance"];
	[_unit, _message, "SW", _maxDistance] call FUNC(showMessageOverRadio)
};

FUNC(showMessageOverRadio) = {
	/*
		Shows received radio message for player if conditions are met (have radio & in range).
		Also add 'noise' if player is close to maximum distance.
		Non-public function

		Params:
		_unit - (object) a speaker.
		_message - (string) message to display.
		_mode - (string) 'LR' for long range and 'SW' for short range radio.
		_maxDistance - (number) maximum distance of the broadcast in meters.

		Return: nothing
	*/

	if !(hasInterface) exitWith {};
	params ["_unit", "_message", "_mode", "_maxDistance"];

	_mode = toUpper _mode;
	private _haveRadio = switch _mode do {
		case "LR": { call TFAR_fnc_haveLRRadio };
		case "SW": { call TFAR_fnc_haveSWRadio };
	};

	// Skip for players that doesn't have SW radio
	if !(_haveRadio) exitWith {};

	if (_maxDistance > 0) then {
		private _distance = player distance _unit;

		// Player is too far to hear anything
		if (_distance > GVAR(DistanceRadioStaticsCoef) * _maxDistance) exitWith { _message = "" };

		// Player is in range to receive only noise
		if (_distance > _maxDistance) exitWith {
			_message = "...*psshhht*......*pshhh*.....*psshhht*....";
		};

		// Player is in range, but can't hear all
		if (_distance > GVAR(DistanceRadioNoiseCoef) * _maxDistance) exitWith {
			_message = [_message] call FUNC(addNoise);
		};
	};

	switch _mode do {
		case "LR": { _unit commandChat _message };
		case "SW": { _unit sideChat _message };
	};
};

FUNC(showMessageLocally) = {
	/*
		Shows heard speech for player if player is in range.
		Also add 'noise' if player is close to maximum distance.
		Non-public function

		Params:
		_unit - (object) a speaker.
		_message - (string) message to display.
		_name - (string) displayed name of the speaker.
		_maxDistance - (number) maximum distance of the broadcast in meters.

		Return: nothing
	*/
	if !(hasInterface) exitWith {};
	params ["_unit", "_message", "_name", "_maxDistance"];
	private _distance = player distance _unit;

	// Player is too far to hear anything
	if (_distance > _maxDistance) exitWith {};

	private _veh = vehicle player;
	if (_veh != player) then {
		private _vehicleIsolationCoef = _veh getVariable QGVAR(isolatedCoef);
		if (isNil "_vehicleIsolationCoef") then {
			_vehicleIsolationCoef = 1 - ([typeOf _veh, "tf_isolatedAmount", 0.3] call TFAR_fnc_getConfigProperty);
			_veh setVariable [QGVAR(isolatedCoef), _vehicleIsolationCoef];
		};
		_vehicleIsolationCoef = [_vehicleIsolationCoef, 1] select (isTurnedOut player);

		private _heavyEngineCoef = [1, 0.3] select (_veh isKindOf "Tank" || _veh isKindOf "Plane" || _veh isKindOf "Helicopter");
		private _engineCoef = [1, 0.7 * _heavyEngineCoef] select (isEngineOn _veh);

		_maxDistance = 3 max (_maxDistance *_vehicleIsolationCoef * _engineCoef);
	};

	// Recheck again, after effects of the vehicle
	if (_distance > _maxDistance) exitWith {};

	// Player is in max range, but can't hear all
	if (_distance > GVAR(DistanceVocalNoiseCoef) * _maxDistance) then {
		_message = [_message] call FUNC(addNoise);
	};

	[_name, _message] spawn BIS_fnc_showSubtitle;
};

FUNC(addNoise) = {
	/*
		Adds noise to the message, by replacing some symbols with dots.
		Non-public function

		Params:
		_message - (string) message.

		Return:
		_noisedMessage - (string) message with added noise.
	*/

	params ["_message"];

	 private _symbols = _message splitString "";
	 private _length = count _symbols - 1;
	 if (_length < 5) exitWith { _message };

	 private _noiseOffset = random (10 min _length);
	 private _noiseStep = random [1, 7, 20];
	 if (_noiseStep < _length) then {
		 _noiseStep = _length / 2;
	 };
	 private _noiseLenght = random [2, 4, 6];

	 for "_i" from _noiseOffset to _length step (_noiseStep + _noiseLenght) do {
		 for "_j" from 0 to _noiseLenght do {
			 private _idx = _i + _j;
			 if (_idx <= _length) then {
				 _symbols set [_idx, "."];
			 };
		 };
	 };

	 (_symbols joinString "")
};

// Utils
FUNC(prepareTalkers) = {
	/*
		Reads Radio Talkers table and creates talkers
		Params: none
		Return: none
	*/

	{
		_x params ["_side", "_callsign", ["_unit", objNull], ["_range", [-1,-1]]];

		if (isNull _unit) then {
			[_side, _callsign] call FUNC(createVirtualRadioTalker);
		} else {
			if (_unit isKindOf "Logic") then {
				// GameLogic as Virtual talker
				[_side, _callsign, getPos _unit, _range] call FUNC(createVirtualRadioTalker);
			} else {
				// Unit-talker
				[_unit, _callsign, _range] call FUNC(registerUnitAsRadioTalker);
			};
		};
	} forEach GVAR(TalkersTable);

	publicVariable QGVAR(RadioTalkers);
};

FUNC(createVirtualRadioTalker) = {
	/*
		Creates and registers some 'virtual' radio talker group with dummy unit and given callsign.

		Params:
		_side - (side) side of the talker group (should be same as players to see messages).
		_callsign - (string) callsign of the talker (will be displayed in message).
		_position - (Pos3D array) position of the talker. Optional.
		_range - (array) max broadcast range of LR and SW radios. Optional, default [-1, -1] means unlimited.

		Return: none

		Example:
		// "PAPA BEAR" talker with unlimited broadcast range
		[west, "PAPA BEAR"] call tSF_Chatter_fnc_createVirtualRadioTalker;

		// "The Spy" talker with weak short-range radio, that can be heard only in 1.5 km near the given position
		[west, "The Spy", [1244, 2330, 0], [0, 1500]] call tSF_Chatter_fnc_createVirtualRadioTalker
	*/
	// Creates dummy radio talker
	params ["_side", "_callsign", "_position", ["_range", [-1,-1]]];

	private _grp = [_side, if (isNil "_position") then { nil } else { _position }] call FUNC(createDummy);
	_grp setGroupIdGlobal [_callsign];

	GVAR(RadioTalkers) set [_callsign, [_grp, _range # 0, _range # 1]];
};

FUNC(registerUnitAsRadioTalker) = {
	/*
		Registres existing unit as radio talker by given callsign.
		Also changes group callsign to given.

		Params:
		_unit - (object) unit (should be some soldier, not a vehicle/object).
		_callsign - (string) callsign of the talker (will be displayed in message).
		_range - (array) max broadcast range of LR and SW radios. Optional, default [-1, -1] means unlimited.

		Return: none

		Example:
		// Unit hq_commander with 'PAPA BEAR' callsign and broadcast range 30km for LR and 5km for SW
		[hq_commander, "PAPA BEAR", [30000, 5000]] call tSF_Chatter_fnc_registerUnitAsRadioTalker;
	*/
	params ["_unit", "_callsign", ["_range", [-1,-1]]];

	private _grp = group _unit;
	_grp setGroupIdGlobal [_callsign];

	GVAR(RadioTalkers) set [_callsign, [_grp, _range # 0, _range # 1]];
};

FUNC(getRadioTalkerByCallsign) = {
	/*
		Returns registered talker entity by given callsign. Or empty array if not found.

		Params:
		_callsign - (string) callsign of the talker.

		Return:
		_talkerEntity - (array) array of talker data: 0: unit (object), 1: range of LR comms (number), 2L range of SW radio comms (number).

		Example:
		_talkerEntity = ["PAPA BEAR"] call tSF_Chatter_fnc_getRadioTalkerByCallsign; // Return: [hq_commander, 30000, 5000]
	*/
	params ["_callsign"];
	private _talkerEntity = GVAR(RadioTalkers) get _callsign;
	if (isNil "_talkerEntity") exitWith {
		TSF_ERROR_1(TSF_ERROR_TYPE__MISSING_ENTITY, "Failed to find '%1' radio talker! Please, create one before use!", _callsign);
		[]
	};

	_talkerEntity params ["_grp", "_lrRange", "_swRange"];

	private _unit = (units _grp) # 0;
	if (!alive _unit) exitWith {
		[]
	};

	[_unit, _lrRange, _swRange]
};

FUNC(createDummy) = {
	/*
		Creates a new group of given side with one dummy unit.
		Params:
		_side - (side) side of the group.
		_position - (PosAGL array) position of the unit. Optional, default [-1000, -1000, 0]

		Return:
		_grp - (group) created group.
	*/
	params ["_side", ["_position", [-1000, -1000, 0]]];

	private _grp = createGroup _side;
	private _class = switch (_side) do {
		case west: { "B_soldier_F" };
		case east: { "O_soldier_F" };
		case resistance: { "I_soldier_F" };
		case civilian: { "C_man_1" };
	};
	private _unit = _grp createUnit [_class , _position, [], 0, "NONE"];
	_unit disableAI "ALL";
	hideObjectGlobal _unit;
	_unit enableSimulation false;

	_unit setVariable [QGVAR(IsDummySpeaker), true, true];

	// Disable Dynai caching for unit
	_unit setVariable ["dzn_dynai_cacheable", true, true];
	// Disable IWB loop for unit
	_unit setVariable ["IWB_Disable", true, true];

	_grp
};
