#include "data\script_component.hpp"

tSF_Diag_AddDiagTopic = {
	tSF_Diag_Subject = "tSF_Diagpage";
	if !(player diarySubjectExists tSF_Diag_Subject) then {
		player createDiarySubject [tSF_Diag_Subject, "Diagnostics"];
	};

	private _text = "<font size='14' color='#b7f931'>%1</font>";
	private _texts = [];
	{
		_texts pushBack format [
			"%1 - <font color='#ffffff'>%2</font>"
			, _x # 0
			, _x # 1
		];
	} forEach [
		["tS Framework", tSF_Version]
		, ["dzn_Gear", dzn_gear_version]
		, ["dzn_Dynai", dzn_dynai_version]
		, ["dzn_CommonFunctions", [] call dzn_fnc_getVersion]
	];

	player createDiaryRecord ["tSF_Diagpage", ["Overview", format [_text, _texts joinString "<br />"]]];

	[] call tSF_Diag_Gear_CollectKitData;
	[] call tSF_Diag_Gear_CollectTotalData;
	[] call tSF_Diag_TSF_CollectTotalData;
    [5 * 60, 5] call tSF_Diag_Framework_HandleErrorsData;
	[] spawn tSF_Diag_Dynai_CollectData;
};

tSF_Diag_TSF_CollectTotalData = {
    #define	STR_DATE(X) ([str(X), "0" + str(X)] select (count str(X) == 1))

    private _topicLines = [
        "<font size='14' color='#b7f931'>Scenario name:</font>",
        format ["        %1 (%2)", briefingName, missionName],
        "<font size='14' color='#b7f931'>Date:</font>",
        format ["        %1/%2/%3", STR_DATE(MissionDate select 2), STR_DATE(MissionDate select 1), MissionDate select 0],
        "<font size='14' color='#b7f931'>Modules:</font>"
    ];

    private _moduleTemplate = "<font size='12'>[%1]</font>%2   <font color='%3'>%4</font>";
    private _onOffLabels = ["<font color='#f95631'>OFF</font>", "<font color='#b7f931'>ON</font>"];
    private _fontColors = ["#777777", "#ffffff"];
    private _seps = ["", " "];

    private _enabledModules = [];
    private _disabledModules = [];
    {
        ([_disabledModules, _enabledModules] select _y) pushBack _x;
    } forEach (ECOB(Core) get Q(Settings));

    _enabledModules sort true;
    {
        _topicLines pushBack format [
            _moduleTemplate,
            _onOffLabels # 1, _seps # 1, _fontColors # 1,
            _x
        ];
    } forEach _enabledModules;

    _disabledModules sort true;
    {
        _topicLines pushBack format [
            _moduleTemplate,
            _onOffLabels # 0, _seps # 0, _fontColors # 0,
            _x
        ];
    } forEach _disabledModules;

	player createDiaryRecord ["tSF_Diagpage", ["tSF - Totals", _topicLines joinString "<br />"]];
};

tSF_Diag_Dynai_CollectData = {
	/*
		Dynai:
			Config Zone vs Real zones

			[OK]        Zone1		0
			[NO CONFIG] Zone2		1
			[NO ZONE]   Zone3		2
	*/
	private _dynaiTopic = "<font size='14' color='#b7f931'>Zones</font><br />";

	waitUntil { !isNil "dzn_dynai_zoneProperties" && !isNil "dzn_dynai_core" };

	private _zonesItems = [];

	private _zones = synchronizedObjects dzn_dynai_core;
	private _usedZones = [];
	{
		private _zonename = _x select 0;
		private _zone = objNull;

		if (!isNil (compile _zonename) && { (call compile _zonename) in _zones }) then {
			_usedZones pushBack (call compile _zonename);
			_zonesItems pushBack [_zonename, 0];
		} else {
			_zonesItems pushBack [_zonename, 2];
		};
	} forEach dzn_dynai_zoneProperties;

	private _unusedZones = _zones - _usedZones;
	if !(_unusedZones isEqualTo []) then {
		{ _zonesItems pushBack [str(_x), 1]; } forEach _unusedZones;
	};

	{
		_dynaiTopic = format [
			"%1<br />%2 %3"
			, _dynaiTopic
			, switch (_x select 1) do {
				case 0: { "<font size='12'>[<font color='#b7f931'>OK</font>]</font>                " };
				case 1: { "<font size='12'>[<font color='#f95631'>NO CONFIG</font>]</font>   " };
				case 2: { "<font size='12'>[<font color='#f95631'>NO ZONE</font>]</font>      " };
			}
			, _x select 0
		];
	} forEach _zonesItems;

	player createDiaryRecord ["tSF_Diagpage", ["dzn Dynai - Totals", _dynaiTopic]];
};

tSF_Diag_Gear_CollectTotalData = {
	/*
	 *	Kits vs GAT
	 */
	if (isNil "dzn_gear_gat_table") exitWith {};
	private _gatTopic = "<font size='14' color='#b7f931'>Gear Assignment Table</font><br />";

	private _allKits = [];
	private _allKitsColors = [];

	private _fnc_generateKitColor = {
        private _colorCodes = [4,5,6,7,8,9,"A","B","C","D","E","F"];
		private _color = ["#"];
		for "_i" from 1 to 6 do { _color pushBack selectRandom _colorCodes; };
		_color joinString ""
	};

	{
		private _role = _x select 0;
		private _kit = _x select 1;
		private _exist = !(isNil (compile _kit));
		private _kitColor = "";

		if (_kit in _allKits) then {
			_kitColor = _allKitsColors select (_allKits find _kit);
		} else {
			_kitColor = call _fnc_generateKitColor;
			while { _kitColor in _allKitsColors } do {_kitColor = call _fnc_generateKitColor;};

			_allKits pushBack _kit;
			_allKitsColors pushBack _kitColor;
		};

		_gatTopic = format [
			"%1<br /><font size='12'>[%2]</font> %3 | <font color='%5'>%4</font>"
			, _gatTopic
			, if (_exist) then { "<font color='#b7f931'>OK</font>"} else {"<font color='#f95631'>NO</font>"}
			, _role
			, _kit
			, _kitColor
		];
	} forEach dzn_gear_gat_table;

	player createDiaryRecord ["tSF_Diagpage", ["dzn Gear - Totals", _gatTopic]];
};

tSF_Diag_Gear_CollectKitData = {
	/*
	 *	Kit content
	 */
	if (isNil "dzn_gear_gat_table") exitWith {};
	private _kitTopic = "<font size='16' color='#b7f931'>Kits</font><br />";
	private _fnc_CheckForItem = {
		params ["_arr","_val"];
		private _result = false;
		{if (typename _x == "ARRAY") then { if (_val in _x) exitWith { _result = true }; };} forEach _arr;

		_result
	};

	private _kits = [];

	{
		if !( (_x select 1) in _kits ) then {

		_kits pushBack (_x select 1);

		private _role = _x select 0;
		private _exist = !(isNil (compile (_x select 1)));

		if (_exist) then {
			private _kitname = _x select 1;
			private _kit = call compile _kitname;
			private _kitArray = ((_kit select 5 select 1) + (_kit select 6  select 1) + (_kit select 7  select 1));


			private _hasMaptools = [_kitArray, "ACE_MapTools"] call _fnc_CheckForItem;
			private _hasIfak = ([_kitArray, "ACE_tourniquet"] call _fnc_CheckForItem)
				&& (
					[_kitArray, "ACE_fieldDressing"] call _fnc_CheckForItem
					|| [_kitArray, "ACE_packingBandage"] call _fnc_CheckForItem
					|| [_kitArray, "ACE_elasticBandage"] call _fnc_CheckForItem
					|| [_kitArray, "ACE_quikclot"] call _fnc_CheckForItem
				);
			private _hasBinocular = [_kitArray, "Binocular"] call _fnc_CheckForItem || [_kitArray, "ACE_Vector"] call _fnc_CheckForItem;

			_kitTopic = format [
				"%1<br /><font color='#b7f931'>%2</font><br />   Has IFAK -- %3<br />   Has Maptools -- <font color='#5b9aff'>%4</font><br />   Has Binocular/Vector -- <font color='#5b9aff'>%5</font>"
				, _kitTopic
				, _x select 1
				, if (_hasIfak) then { "<font color='#b7f931'>Yes</font>" } else { "<font color='#f95631'>No</font>" }
				, if (_hasMaptools) then { "Yes" } else { "No" }
				, if (_hasBinocular) then { "Yes" } else { "No" }

			];
		};

		};
	} forEach dzn_gear_gat_table;

	player createDiaryRecord ["tSF_Diagpage", ["dzn Gear - Kits", _kitTopic]];
};

tSF_Diag_Framework_HandleErrorsData = {
    params ["_updateUntilTime", "_updateTimeout"];

    private _pfh = [{
        if (time > _this # 0) then {
            [_this # 1] call CBA_fnc_removePerFrameHandler;
        };

        [] call tSF_Diag_Framework_UpdateErrorReport;
    }, _updateTimeout, time + _updateUntilTime] call CBA_fnc_addPerFrameHandler;
};

#define GET_COLOR_ON_ERROR_COUNT(COUNT) \
    [ \
        linearConversion [0, 10, COUNT, 1, 0.85, false], \
        linearConversion [0, 10, COUNT, 0.85, 0.5, false], \
        0 \
    ] call BIS_fnc_colorRGBtoHTML

tSF_Diag_Framework_UpdateErrorReport = {
    /* DIAGNOSTICS - ! ERRORS ! - ComponentName (2)
                                  timestamp Some message
                                  timestamp Some message

                                  ComponentName2 (1)
                                  timestamp Some message
    */

    private _errorsData = ECOB(Core) get Q(ReportedErrors);
    private _keys = keys _errorsData;
    _keys sort true;

    private _lines = [];
    private _totalErrors = 0;
    {
        private _errors = _errorsData get _x;
        private _count = count _errors;
        _totalErrors = _totalErrors + _count;

        _lines pushBack format [
            "<font color='%1'>%2 (%3)</font>",
            GET_COLOR_ON_ERROR_COUNT(_count),
            _x,
            _count
        ];

        {
            _lines pushBack _x;
        } forEach _errors;
        _lines pushBack "";
    } forEach _keys;

    if (_totalErrors == 0) then {
        _lines insert [0, ["<font color='#d7eb71'>Ошибок не обнаружено</font>"]];
    } else {
         _lines insert [
            0,[format [
                "<font color='%1'>Всего ошибок: %2</font><br/>---",
                GET_COLOR_ON_ERROR_COUNT(_totalErrors),
                _totalErrors
            ]]
        ];
    };

    if (!isNil "tSF_Diag_Framework_ErrorTopicRecord") then {
        player removeDiaryRecord ["tSF_Diagpage", tSF_Diag_Framework_ErrorTopicRecord];
    };
    tSF_Diag_Framework_ErrorTopicRecord = player createDiaryRecord [
        "tSF_Diagpage", ["! ОШИБКИ !", _lines joinString "<br />"]
    ];
};
