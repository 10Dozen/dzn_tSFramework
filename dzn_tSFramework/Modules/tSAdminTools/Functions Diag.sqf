#include "script_component.hpp"

#define DIAG_PAGE "tSF_Diagpage"

#define COLOR_HEX_OK "#b7f931"
#define COLOR_HEX_FAIL "#f95631"

// For debug
if (isNil "TFAR_fnc_isRadio") then {
    TFAR_fnc_isRadio = { false };
};

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

    [] call CBA_fnc_addEventHandler;

    [] call tSF_Diag_TSF_UpdateTSFRecord;
    [TSF_EVENT_COMPONENT_STATE_CHANGED, { [] call tSF_Diag_TSF_UpdateTSFRecord; }] call CBA_fnc_addEventHandler;

    [] call tSF_Diag_Gear_CollectKitData;
    [] call tSF_Diag_Gear_CollectTotalData;
    [5 * 60, 5] call tSF_Diag_Framework_HandleErrorsData;
    [] spawn tSF_Diag_Dynai_CollectData;
};

tSF_Diag_TSF_UpdateTSFRecord = {
    #define	STR_DATE(X) ([str(X), "0" + str(X)] select (count str(X) == 1))
    private _topicLines = [
        "<font size='14' color='#b7f931'>Scenario name:</font>",
        format ["        %1 (%2)", briefingName, missionName],
        "<font size='14' color='#b7f931'>Date:</font>",
        format ["        %1/%2/%3", STR_DATE(MissionDate select 2), STR_DATE(MissionDate select 1), MissionDate select 0],
        "<font size='14' color='#b7f931'>Modules:</font>"
    ];

    private _moduleLineTemplate = "<font size='12'>[<font color='%4'>%1</font>]</font>%2   <font color='%5'>%3</font>";
    private _fontColors = createHashMapFromArray [
        [COMPONENT_STATUS_STARTING, "#ff8800"],
        [COMPONENT_STATUS_OK, COLOR_HEX_OK],
        [COMPONENT_STATUS_FAILED, COLOR_HEX_FAIL],
        ["OFF", "#777777"],
        ["PRE_INIT", "#77cc77"]
    ];
    private _fontTextColors = ["#777777", "#ffffff"];
    private _seps = ["", " "];

    private _enabledModules = [];
    private _disabledModules = [];
    {
        ([_disabledModules, _enabledModules] select _y) pushBack _x;
    } forEach (ECOB(Core) get Q(Settings));

    _enabledModules sort true;
    {
        private _component = TSF_COMPONENT(_x);
        private _status = "ON";
        if (!isNil "_component") then {
            _status = _component getOrDefault [COMPONENT_STATUS_VARNAME, "PRE_INIT"];
        };
        _topicLines pushBack format [
            _moduleLineTemplate,
            _status,
            _seps # 1,
            _x,
            _fontColors get _status,
            _fontTextColors # 1
        ];
    } forEach _enabledModules;

    _disabledModules sort true;
    {
        private _status = "OFF";
        _topicLines pushBack format [
            _moduleLineTemplate,
            _status,
            _seps # 0,
            _x,
            _fontColors get _status,
            _fontTextColors # 0
        ];
    } forEach _disabledModules;

    if (!isNil "tSF_Diag_Framework_OverviewRecord") then {
        player removeDiaryRecord [DIAG_PAGE, tSF_Diag_Framework_OverviewRecord];
    };
    tSF_Diag_Framework_OverviewRecord = player createDiaryRecord [
        DIAG_PAGE, ["tSF - Totals", _topicLines joinString "<br />"]
    ];
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
        private _zone = missionNamespace getVariable [_zonename, objNull];

        if (!isNull _zone && { _zone in _zones }) then {
            _usedZones pushBack _zone;
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

    private _lines = [
        "<font size='16' color='#b7f931'>Gear Assignment Table</font>",
        "Проверка существования китов указанных в GAT.",
        ""
    ];

    {
        _x params ["_roleName", "_kitName"];
        private _gear = missionNamespace getVariable _kitName;
        if (isNil "_gear") then {
            ECOB(Core) call [TSF_ERROR_METHOD, [
                "dzn_Gear - Gear Assignment Table",
                format ["%1 - %2", TSF_ERROR_TYPE__MISSING_KIT, _roleName],
                format [
                    "Запись GAT для роли <font color='%3'>%1</font> ссылается на несуществующий набор <font color='%4'>%2</font>",
                    _roleName,
                    _kitName,
                    COLOR_HEX_AQUA,
                    COLOR_HEX_LIME
                ]
            ]];

            // -- Gear map
            _lines pushBack format ["[<font color='%2'>%1</font>] - %3 (%4)",
                "Не найден",
                COLOR_HEX_FAIL,
                _roleName,
                _kitName
            ];

            continue;
        };

        if (_gear isEqualType []) then {
            // -- Random kit - ["kitname", "kitnmae"]
            {
                private _gearInRandomKit = missionNamespace getVariable _x;
                _lines pushBack format ["[<font color='%2'>%1</font>] - %3 (random, %4)",
                    ["OK", "Не найден"] select (isNil "_gearInRandomKit"),
                    [COLOR_HEX_OK, COLOR_HEX_FAIL] select (isNil "_gearInRandomKit"),
                    _roleName,
                    _x
                ];
            } forEach _gear;
        } else {
            _lines pushBack format ["[<font color='%2'>%1</font>] - %3 (%4)",
                ["OK", "Не найден"] select (isNil "_gear"),
                [COLOR_HEX_OK, COLOR_HEX_FAIL] select (isNil "_gear"),
                _roleName,
                _kitName
            ];
        };
    } forEach dzn_gear_gat_table_plain;

    player createDiaryRecord ["tSF_Diagpage", ["dzn Gear - GAT", _lines joinString "<br/>"]];
};

tSF_Diag_Gear_CollectKitData = {
    /*
     *	Kit content
     *  Check for medical items, maptools, binoculars. Alerts for leader roles without maptools and bino
     */
    if (isNil "dzn_gear_gat_table") exitWith {};

    private _handle = {
        params ["_name", "_kitname"];

        private _gearMap = missionNamespace getVariable _kitname;
        if (isNil "_gearMap") exitWith {
            format ["<font color='%1'>    (не существует)</font>", COLOR_HEX_FAIL]
        };

        // Check for medical items
        private _allItems = [];
        {
            if ((_x # 0) isEqualType "") then {
                _allItems pushBack (_x # 0);
            } else {
                _allItems append (_x # 0);
            };
        } forEach ((_gearMap get "UniformItems") + (_gearMap get "VestItems") + (_gearMap get "BackpackItems"));

        private _hasMedicalItems = (
            "FirstAidKit" in _allItems
            || "ACE_fieldDressing" in _allItems
            || "ACE_packingBandage" in _allItems
            || "ACE_elasticBandage" in _allItems
            || "ACE_quikclot" in _allItems
        );
        private _hasMaptools = "ACE_MapTools" in _allItems;
        private _hasBinocular = (_gearMap get "AssignedItems") findIf {
            ((_x call BIS_fnc_itemType) # 1) in ["Binocular", "LaserDesignator"]
        } > -1;
        private _hasSRRadio = (_gearMap get "AssignedItems") findIf {
            _x == 'ItemRadio' || _x call TFAR_fnc_isRadio
        } > -1;
        private _hasLRRadio = (getNumber (configFile >> "CfgVehicles" >> (_gearMap get "Backpack") >> "tf_hasLRradio") > 0);

        // Raise error
        private _errorsMessages = [
            format [
                "(GAT) Набор <font color='%3'>%1</font> для роли <font color='%4'>%2</font>:",
                _kitname, _name,
                 COLOR_HEX_LIME,
                 COLOR_HEX_AQUA
            ]
        ];
        if (!_hasMedicalItems) then {
            _errorsMessages pushBack "- не имеет [Медицины]";
        };

        private _isLeader = "leader" in (_gearMap getOrDefault ["Tags", []]);
        private _isPlatoonNetOperator = "PL_NET" in (_gearMap getOrDefault ["Tags", []]);
        if (_isLeader && !_hasMaptools) then {
            _errorsMessages pushBack "- отмечен тегом [leader], но не имеет [Инструментов карты]";
        };
        if (_isLeader && !_hasBinocular) then {
            _errorsMessages pushBack "- отмечен тегом [leader], но не имеет [Бинокля]";
        };
        if (_isLeader && !_hasSRRadio) then {
            _errorsMessages pushBack "- отмечен тегом [leader], но не имеет [КВ рации]";
        };
        if (_isPlatoonNetOperator && !_hasLRRadio) then {
            _errorsMessages pushBack "- отмечен тегом [PLNET], но не имеет [ДВ рации]";
        };

        if (count _errorsMessages > 1) then {
            ECOB(Core) call [TSF_ERROR_METHOD, [
                "dzn_Gear",
                format ["%1 - %2", TSF_ERROR_TYPE__MISSING_ITEM, _kitname],
                _errorsMessages joinString "<br/>"
            ]];
        };

        #define FMT_OK_ITEM(TITLE) format ["<font color='%2'>        %1</font>", TITLE, COLOR_HEX_OK]
        #define FMT_MISSING_ITEM(TITLE) format ["<font color='%2'>        %1</font>", TITLE, COLOR_HEX_FAIL]
        [
            [FMT_MISSING_ITEM("Без медицины!"), FMT_OK_ITEM("+ Медицина")] select _hasMedicalItems,
            ["", "    *назначается лидерской роли"] select _isLeader,
            [
                ["", FMT_MISSING_ITEM("Без инструментов карты!")] select _isLeader,
                FMT_OK_ITEM("Map tools")
            ] select (_hasMaptools),
            [
                ["", FMT_MISSING_ITEM("Без бинокля!")] select _isLeader,
                FMT_OK_ITEM("Бинокль")
            ] select _hasBinocular,
            [
                ["", FMT_MISSING_ITEM("Без КВ рации!")] select _isLeader,
                FMT_OK_ITEM("КВ рация")
            ] select _hasSRRadio,
            ["", "    *назначается роли оператора ДВ (PLNET)"] select _isPlatoonNetOperator,
            [
                ["", FMT_MISSING_ITEM("Без ДВ рации!")] select _isPlatoonNetOperator,
                FMT_OK_ITEM("ДВ рация")
            ] select _hasLRRadio
        ] select { _x isNotEqualTo "" } joinString "<br/>"
    };


    private _lines = [
        "<font size='16' color='#b7f931'>Kits</font>",
        "Проверка состава набора снаряжения.",
        ""
    ];
    {
        _x params ["_rolename", "_kitname"];
        private _gearMap = missionNamespace getVariable [_kitname, ""];

        if (_gearMap isEqualType []) then {
            // -- Random kit
            {
                _lines pushBack format ["%1 <font color='#aaaaaa'>| (random) | for role: %2</font>", _x, _rolename];
                _lines pushBack ([_rolename, _x] call _handle);
            } forEach _gearMap;
        } else {
            _lines pushBack format ["%1 <font color='#aaaaaa'>| %2</font>", _kitname, _rolename];
            _lines pushBack ([_rolename, _kitname] call _handle);
        };

        _lines pushBack "";
    } forEach dzn_gear_gat_table_plain;

    player createDiaryRecord ["tSF_Diagpage", ["dzn Gear - Kits", _lines joinString "<br/>"]];
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
