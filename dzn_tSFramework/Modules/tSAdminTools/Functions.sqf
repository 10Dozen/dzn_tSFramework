#include "data\script_component.hpp"

tSF_fnc_adminTools_handleKey = {
	if (tSF_adminTools_isKeyPressed) exitWith {};
	switch (_this select 1) do {
		// F5
		case 63: {
			tSF_adminTools_isKeyPressed = true;
			[] spawn { sleep 1; tSF_adminTools_isKeyPressed = false; };
			[] spawn tSF_fnc_adminTools_showGSOScreen;
		};
		// F6
		case 64: {
			tSF_adminTools_isKeyPressed = true;
			[] spawn { sleep 1; tSF_adminTools_isKeyPressed = false; };
			[] spawn tSF_fnc_adminTools_RapidArtillery_showZeusSceen;
		};
		// F7
		case 65: {
			tSF_adminTools_isKeyPressed = true;
			// [] spawn { sleep 1; tSF_adminTools_isKeyPressed = false; };
            [{ tSF_adminTools_isKeyPressed = false; }, nil, 1] call CBA_fnc_waitAndExecute;
			[] call tSF_fnc_adminTools_ForceRespawn_showMenu;
		};
		// F8
        case 66: {
        	tSF_adminTools_isKeyPressed = true;
            [{ tSF_adminTools_isKeyPressed = false; }, nil, 1] call CBA_fnc_waitAndExecute;
        	[] call tSF_fnc_adminTools_IM_showMenu;
        };
	};

	false
};

tSF_fnc_adminTools_checkIsAdmin = {
	(serverCommandAvailable "#logout") || !(isMultiplayer) || isServer
};

tSF_fnc_adminTools_checkAndUpdateCurrentAdmin = {
	if (call tSF_fnc_adminTools_checkIsAdmin) then {
		tSF_Admin = player;
		publicVariable "tSF_Admin";
	};
};

tSF_fnc_adminTools_addTopic = {
	tSF_AdminTools_Topic = "tSF_AdminTools";
	player createDiarySubject [tSF_AdminTools_Topic,tSF_AdminTools_TopicName];
};


tSF_fnc_adminTools_handleGSOMenuOverZeusDisplay = {
	if (isNull (findDisplay 312)) then {
		tSF_adminTools_MenuAddedToZeus = false;
	} else {
		if (isNil "tSF_adminTools_MenuAddedToZeus" || {!tSF_adminTools_MenuAddedToZeus}) then {
			(findDisplay 312) displayAddEventHandler ["KeyUp", {call tSF_fnc_adminTools_handleKey}];
			tSF_adminTools_MenuAddedToZeus = true;
		}
	};

	sleep 5;
	[] spawn tSF_fnc_adminTools_handleGSOMenuOverZeusDisplay;
};

tSF_fnc_adminTools_handleGSOMenuOverSpectator = {
	if (isNull (findDisplay 60000)) then {
		tSF_adminTools_MenuAddedToSpectator = false;
	} else {
		if (isNil "tSF_adminTools_MenuAddedToSpectator" || {!tSF_adminTools_MenuAddedToSpectator}) then {
			(findDisplay 60000) displayAddEventHandler ["KeyUp", {call tSF_fnc_adminTools_handleKey}];
			tSF_adminTools_MenuAddedToSpectator = true;
		};
	};

	sleep 5;
	[] spawn tSF_fnc_adminTools_handleGSOMenuOverSpectator;
};

/*
	Mission Endings
*/
dzn_fnc_adminTools_addMissionEndsControls = {
	waitUntil { sleep 5; time > 5 && !isNil QEGVAR(MissionConditions,Endings) };

	// Mission Notes
    private _topicLines = [
        "<font color='#12C4FF' size='14'>Завершение миссии</font>",
        "<font color='#A0DB65'><execute expression='""end1"" spawn tSF_fnc_adminTools_callEndings;'>Generic WIN</execute></font>",
        "<font color='#A0DB65'><execute expression='""loser"" spawn tSF_fnc_adminTools_callEndings;'>Generic LOSE</execute></font>",
        "----"
    ];

    {
        _x params ["_name", "_desc"];
        _topicLines pushBack format [
            "<font color='#A0DB65'><execute expression='""%1"" spawn tSF_fnc_adminTools_callEndings;'>%1</execute></font> %2",
            _name,
            if (_desc isEqualTo "") then { "" } else { format ["(%1)", _desc] }
        ];
    } forEach EGVAR(MissionConditions,Endings);

	player createDiaryRecord [
        tSF_AdminTools_Topic,
        ["Mission End", _topicLines joinString "<br/>"]
    ];
};

tSF_End = {
	if !(call tSF_fnc_adminTools_checkIsAdmin) exitWith { hint "You are not an admin!"; };

	[] spawn {
		sleep 5;
        private _ends = EGVAR(MissionConditions,Endings);
		private _endsOptions = _ends apply {
            format ["%1 (%2)", _x select 0, _x select 1]
        };

		private _result = ["End Mission",[["Ending", _endsOptions]]] call dzn_fnc_ShowChooseDialog;

		if (_result isEqualTo []) exitWith {};
		( (_ends # (_result # 0)) # 0 ) spawn tSF_fnc_adminTools_callEndings;
	};
};

tSF_fnc_adminTools_callEndings = {
	params["_ending"];
	if !(call tSF_fnc_adminTools_checkIsAdmin) exitWith { hint "You are not an admin!"; };

	private _Result = false;
	if !(isNil "dzn_fnc_ShowBasicDialog") then {
		_Result = [
			[format ["Do you want to finish the mission with ending <t color='#A0DB65'>""%1""</t>?", _ending]]
			, ["End", [1, .37, .17, .5]]
			, ["Cancel"]
		] call dzn_fnc_ShowBasicDialog;
	} else {
		_Result = true;
	};

	if !(_Result) exitWith {};
    [_ending, true, 2] remoteExec ["BIS_fnc_endMission", 0, true];
};


/*
    GAT Tool
*/

dzn_fnc_adminTools_addGATControls = {
	waitUntil {sleep 10; time > 10 && !isNil "dzn_gear_initDone" && !isNil "dzn_gear_gat_table" && !isNil "dzn_fnc_ShowChooseDialog"};
	player createDiaryRecord [tSF_AdminTools_Topic, [
		"GAT Tool"
		, format [
			"<font color='#12C4FF' size='14'>Gear Assignment Table Tool</font><br />%1"
			, "<font color='#A0DB65'><execute expression='[] spawn dzn_fnc_adminTools_showGATTool;'>Open GAT Tool</execute></font>"
		]
	]];
};

dzn_fnc_adminTools_showGATTool = {
	private _PlayerList = call BIS_fnc_listPlayers;
	private _PlayerNamesList = [];
	{ _PlayerNamesList pushBack (name _x); } forEach _PlayerList;

	tSF_GATList = (allVariables missionNamespace) select {  ["kit_", _x, false] call BIS_fnc_inString &&  !(["lkit_", _x, false] call BIS_fnc_inString) };
	tSF_GATList pushBack "";

	private _Result = [];
	_Result = [
		"GAT Tool"
		,[
			["Player", _PlayerNamesList]
			, ["GAT Kit", tSF_GATList]
			, ["or Kitname", []]
		]
	] call dzn_fnc_ShowChooseDialog;

	if (count _Result == 0) exitWith {};

	private _player = _PlayerList select (_Result select 0);
	private _kitname = if ( typename (_Result select 2) != "STRING") then {
		tSF_GATList select (_Result select 1);
	} else {
		_Result select 2;
	};

	if (isNil {call compile _kitname}) exitWith {
		hint parseText format [
			"<t size='1' color='#FFD000' shadow='1'>GAT Tools:</t>
			<br />There is no kit named '%1'"
			, _kitname
		];
	};

	[_player, _kitname] remoteExec ["dzn_fnc_gear_assignKit", _player];
	hint parseText format [
		"<t size='1' color='#FFD000' shadow='1'>GAT Tools:</t>
		<br /> Kit '%1' was assigned to %2"
		, _kitname
		, _PlayerNamesList select (_Result select 0)
	];
};

/*
    Timers
*/

tSF_fnc_adminTools_addTimerControls = {
    // Mission Notes
    private _topic = [
         "<font color='#12C4FF' size='14'>Таймеры</font>",
         "<br />",
         "<br />[<font color='#A0DB65'><execute expression='[] call tSF_fnc_adminTools_timers_showInfo;'>Показать</execute></font>]  |  ",
         "[<font color='#A0DB65'><execute expression='[] call tSF_fnc_adminTools_timers_showMenu;'>Добавить новый</execute></font>]  |  ",
         "[<font color='#A0DB65'><execute expression='[] call tSF_fnc_adminTools_timers_showEditMenu;'>Редактировать</execute></font>] ",
         "<br />---",
         "<br />1 час 30 мин: ",
            "[<font color='#A0DB65'><execute expression='[""Mission"", 5400] spawn tSF_fnc_adminTools_timers_addTimer;'>Вкл</execute></font>] ",
            "[<font color='#A0DB65'><execute expression='[""Mission""] spawn tSF_fnc_adminTools_timers_unsetTimer;'>Откл</execute></font>]",
         "<br />30 мин        ",
            "[<font color='#A0DB65'><execute expression='[""30 Min"", 1800] spawn tSF_fnc_adminTools_timers_addTimer;'>Вкл</execute></font>] ",
            "[<font color='#A0DB65'><execute expression='[""30 Min""] spawn tSF_fnc_adminTools_timers_unsetTimer;'>Откл</execute></font>]",
        "<br />15 мин        ",
            "[<font color='#A0DB65'><execute expression='[""15 Min"", 900] spawn tSF_fnc_adminTools_timers_addTimer;'>Вкл</execute></font>] ",
            "[<font color='#A0DB65'><execute expression='[""15 Min""] spawn tSF_fnc_adminTools_timers_unsetTimer;'>Откл</execute></font>]",
        "<br />5 мин          ",
            "[<font color='#A0DB65'><execute expression='[""5 Min"", 300] spawn tSF_fnc_adminTools_timers_addTimer;'>Вкл</execute></font>] ",
            "[<font color='#A0DB65'><execute expression='[""5 Min""] spawn tSF_fnc_adminTools_timers_unsetTimer;'>Откл</execute></font>]",
        "<br />1 мин          ",
            "[<font color='#A0DB65'><execute expression='[""1 Min"", 60] spawn tSF_fnc_adminTools_timers_addTimer;'>Вкл</execute></font>] ",
            "[<font color='#A0DB65'><execute expression='[""1 Min""] spawn tSF_fnc_adminTools_timers_unsetTimer;'>Откл</execute></font>]"
    ];
    player createDiaryRecord [tSF_AdminTools_Topic, ["Таймеры", _topic joinString ""]];

    ['Mission', 5400, false] call tSF_fnc_adminTools_timers_addTimer;
};

#define ADMIN_TIMER_HINT_TITLE "<t size='1.1' color='#FFD000' shadow='1'>Admin Timer</t>"
#define ADMIN_TIMER_HINT_HEADER "<t color='#999999' align='left'>Таймер:</t><t color='#aaaaaa' align='right'>ETA:</t>"
#define ADMIN_TIMER_HINT_LINE "<t align='left'>%1</t><t align='right'>%2</t>"
#define PRETTY_TIME(TIME_SECONDS) ("+" + ([TIME_SECONDS, "HH:MM:SS"] call BIS_fnc_secondsToString))

tSF_fnc_adminTools_timers_addTimer = {
    params ["_name", "_newTime", ["_needConfirm", true], ["_showInfo", true]];

    private _newTimePretty = PRETTY_TIME(_newTime);
    private _existingTimer = tSF_AdminTools_Timers get _name;
    private _confirmed = true;

    if (_needConfirm && !isNil "_existingTimer" && {!(_existingTimer # 1)}) then {
        _confirmed = [
            [format [
                "Таймер <t color='#FFD700'>%1</t> существует. Осталось %2. Новый %3.",
                _name,
                PRETTY_TIME((_existingTimer # 0) - CBA_missionTime),
                _newTimePretty
           ]],
           ["Изменить", [0.427, 0.721, 0.2, 1]],
           ["Отмена"]
        ] call dzn_fnc_ShowBasicDialog;
    };

    if (!_confirmed) exitWith {};

    tSF_AdminTools_Timers set [_name, [
        CBA_missionTime + _newTime,
        false
    ]];

    if (!_showInfo) exitWith {};
    hint parseText ([
        ADMIN_TIMER_HINT_TITLE,
        "Добавлен таймер!",
        "",
        ADMIN_TIMER_HINT_HEADER,
        format [ADMIN_TIMER_HINT_LINE, _name, PRETTY_TIME(_newTime)]
    ] joinString "<br />");
};


tSF_fnc_adminTools_timers_unsetTimer = {
    params ["_name", ["_showInfo", true]];

    private _timer = tSF_AdminTools_Timers get _name;
    if (isNil "_timer") exitWith {};

    tSF_AdminTools_Timers deleteAt _name;

    if (!_showInfo) exitWith {};
    hint parseText ([
        ADMIN_TIMER_HINT_TITLE,
        format ["Таймер '%1' удален!", _name]
    ] joinString "<br />");
};

tSF_fnc_adminTools_timers_showMenu = {
    params [["_name", ""]];

    private _fnc_onSliderChanged = {
        params ["_eventData", "_cob"];
        _eventData params ["", "_curValue"];
        (_cob call ["GetByTag", "timeLbl"]) ctrlSetStructuredText parseText PRETTY_TIME(_curValue);
    };

    private _fnc_addTimer = {
        params ["_cob", "_isUpdating"];
        (_cob call ["GetValues"]) params ["_name", "_newTime"];
        _cob call ["Close"];
        [_name, (_newTime # 0), !_isUpdating] spawn tSF_fnc_adminTools_timers_addTimer;
    };

    private _isUpdating = _name isNotEqualTo "";
    private _defaultTime = 5 * 60;
    private _timer = tSF_AdminTools_Timers get _name;
    if (!isNil "_timer") then {
        _timer params ["_expiredAt", "_isExpired"];
        // Show time left as default selection
        _defaultTime = [
            _expiredAt - CBA_missionTime,
            0
        ] select _isExpired;
    };

    [
        ["HEADER", ["Добавть таймер", "Обновить таймер"] select _isUpdating],
        ["LABEL", "Название"],
        ["INPUT", ["Unnamed", _name] select _isUpdating],
        ["br"],
        ["LABEL", "Время"],
        ["LABEL", PRETTY_TIME(_defaultTime), [["tag", "timeLbl"], ["w", 0.15]]],
        ["SLIDER", [0, 5400, 1], _defaultTime, [["tag", "timeSlider"], ["w", 0.35]], [["SliderPosChanged", _fnc_onSliderChanged]]],
        ["br"],
        ["label"],["label"],["BUTTON", ["Добавить", "Обновить"] select _isUpdating, _fnc_addTimer, _isUpdating]
    ] call dzn_fnc_ShowAdvDialog2;
};

tSF_fnc_adminTools_timers_showEditMenu = {
    if (keys tSF_AdminTools_Timers isEqualTo []) exitWith {
        hint "Таймеры не установлены!";
    };

    private _fnc_onEdit = {
        params ["_cob", "_timerName"];
        _cob call ["Close"];
        [{ _this call tSF_fnc_adminTools_timers_showMenu; }, [_timerName]] call CBA_fnc_execNextFrame;
    };

    private _fnc_onUnset = {
        params ["_cob", "_timerName"];
        hint str _this;
        [_timerName] call tSF_fnc_adminTools_timers_unsetTimer;

        _cob call ["Close"];
        if ((keys tSF_AdminTools_Timers) isEqualTo []) exitWith {};
        [{
            [] call tSF_fnc_adminTools_timers_showEditMenu;
        }] call CBA_fnc_execNextFrame;
    };

    private _fnc_onCbaEvent = {
        if (!dialog) exitWith {};
        _thisArgs params ["_cob"];

        private _ctrls = _cob call ["GetControls", [["timeLbl"]]];

        private ["_ctrl", "_timeText"];
        {
            _y params ["_expiresAt", "_isExpired"];
            _ctrl = _ctrls # _forEachIndex;
            _timeText = [PRETTY_TIME(_expiresAt - CBA_missionTime), "(истек)"] select _isExpired;
            _ctrl ctrlSetStructuredText parseText _timeText;
        } forEach tSF_AdminTools_Timers;
    };

    private _nodes = [
        ["HEADER", "Редактировать таймер"],
        ["OnCBAEvent", "tSF_AdminTools_Timers_OnTimeUpdated", _fnc_onCbaEvent]
    ];

    {
        _y params ["_expiresAt", "_isExpired"];
        _nodes pushBack ["BR"];
        _nodes pushBack ["LABEL", _x];
        _nodes pushBack ["LABEL", [PRETTY_TIME(_expiresAt - CBA_missionTime), "(истек)"] select _isExpired, [["tag", "timeLbl"]]];
        _nodes pushBack ["BUTTON", "Изменить", _fnc_onEdit, _x];
        _nodes pushBack ["ICON_BUTTON", "\a3\3DEN\Data\Displays\Display3DEN\search_end_ca.paa", _fnc_onUnset, _x, [["x", 0.97]]];
    } forEach tSF_AdminTools_Timers;

    _nodes call dzn_fnc_ShowAdvDialog2;
};

tSF_fnc_adminTools_timers_showInfo = {
    private _msg = [
        ADMIN_TIMER_HINT_TITLE,
        "",
        ADMIN_TIMER_HINT_HEADER
    ];

    {
        _y params ["_expiredAt", "_isExpired"];
        _msg pushBack format [
            ADMIN_TIMER_HINT_LINE,
            _x,
            [
                PRETTY_TIME(_expiredAt - CBA_missionTime),
                "<t color='#00b7ff'>(истек)</t>"
            ] select _isExpired
        ];
    } forEach tSF_AdminTools_Timers;

    hint parseText (_msg joinString "<br/>");
};

tSF_fnc_adminTools_timers_handleTimers = {
    private _timeNow = CBA_missionTime;
    private _expiredTimers = [];
    {
        _y params ["_expiredAt", "_isExpired"];

        if (_isExpired) then { continue; };
        if (_timeNow < _expiredAt) then { continue; };

        _y set [1, true]; // set expired flag
        _expiredTimers pushBack _x;
    } forEach tSF_AdminTools_Timers;

    ["tSF_AdminTools_Timers_OnTimeUpdated", 1] call CBA_fnc_localEvent;

    if (_expiredTimers isEqualTo []) exitWith {};

    private _msg = [
        ADMIN_TIMER_HINT_TITLE,
        "---"
    ];

    {
        _msg pushBack format [ADMIN_TIMER_HINT_LINE, _x, "ИСТЕК!"];
    } forEach _expiredTimers;

    hint parseText (_msg joinString "<br />");

    private _playSound = { playSoundUI ["a3\sounds_f\air\heli_attack_02\alarm.wss", 2, 1]; };
    for "_i" from 0 to 5 do {
        [_playSound, nil, _i] call CBA_fnc_waitAndExecute;
    };
};
