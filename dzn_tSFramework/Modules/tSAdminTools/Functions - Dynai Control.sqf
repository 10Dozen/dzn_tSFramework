#include "data\script_component.hpp"

/*
    # See activation condition of the zone
    Note page with zone names and condition of actiavation

    # Able to manually Activate zone
    Execute clickable at note page for each zone that manually activates zones + deactivate + reset

    # Able to evaluate activation condition
    Execute clickable at note page that checks activation condition on server
*/
FUNC(DC_RequestDynaiData) = {
    LOG("Requesting Dynai data from server");
    [clientOwner, "dzn_dynai_zoneProperties"] remoteExec ["publicVariableClient", dzn_dynai_owner];

    [{ !isNil "dzn_dynai_zoneProperties" }, {
        LOG("Dynai Zone Properties required");
    }, [], 5] call CBA_fnc_waitUntilAndExecute;
};

tSF_adminTools_DC_getDynaiData = {
    /*
        Return only zones that exists and configured
        RESULT: Array of zone properties
    */
    private _result = [];
    private _zoneLogics = (synchronizedObjects dzn_dynai_core) apply { str _x };

    {
        private _zoneName = _x # 0;
        if (_zoneName in _zoneLogics) then {
            _result pushBack _x;
        };
    } forEach dzn_dynai_zoneProperties;

    _result
};

tSF_adminTools_DC_addDynaiControlPage = {
    waitUntil { sleep 1; !isNil "dzn_dynai_zoneProperties" && !isNil "dzn_dynai_core" }; // Wait for DynAI to init

    private _topic = "<font color='#12C4FF' size='14'>Зоны DynAI</font>";
    private _zones = [] call tSF_adminTools_DC_getDynaiData;

    /*
        | [    State?    ] [Test Condition]
        | [   Activate   ] [  Deactivate  ] [     Alert    ]
        | [   Show/Hide  ] [     Info     ]
    */
    private _lineFormat = "<font face='EtelkaMonospacePro' size='8'>%1<br /><br /><font size='12'>%2 (%3)</font><br />| [    %4     ] [%5]<br />| [   %6   ] [  %7  ] [     %8    ]<br />| [   %9  ] [     %10     ]</font>";
    private _execLine = "<font color='#A0DB65'><execute expression='""%2"" %3;'>%1</execute></font>";
    {
        _x params ["_name", "_side", "_active", "", "", "", "", "_cond"];

        _topic = format [
            _lineFormat
            , _topic
            , _name
            , toLower _side
            , format [_execLine, "State", _name, "call tSF_adminTools_DC_checkZoneState"]
            , format [_execLine, "Test Condition", _name, "call tSF_adminTools_DC_evaluateZoneCondition"]
            , format [_execLine, "Activate", _name, "spawn tSF_adminTools_DC_activateZone"]
            , format [_execLine, "Deactivate", _name, "spawn tSF_adminTools_DC_deactivateZone"]
            , format [_execLine, "Alert!", _name, "spawn tSF_adminTools_DC_alertZone"]
            , format [_execLine, "Show/Hide", _name, "call tSF_adminTools_DC_showHideZone"]
            , format [_execLine, "Info", _name, "call tSF_adminTools_DC_showZoneInfo"]
        ];
    } forEach _zones;

    player createDiaryRecord [tSF_AdminTools_Topic, ["DynAI Control Panel", _topic]];
};


/*
    Diary functions
*/
tSF_adminTools_DC_checkZoneState = {
    params ["_zonename"];
    [_zonename] remoteExec ["tSF_adminTools_DC_checkZoneStateRemote", dzn_dynai_owner];
};

tSF_adminTools_DC_checkZoneStateClient = {
    params ["_zonename", "_isActive", "_isAlerted"];

    hint parseText format [
        "<t size='1' color='#FFD000' shadow='1'>[dzn DynAI Control Panel]
        <br />[STATE]</t>
        <br /><br /><t size='1.25'>%1</t>
        <br />%2
        <br />%3"
        , _zonename
        , if (_isActive) then { "<t size='1.25' color='#22FF22'>ACTIVATED</t>" } else { "<t size='1.25'  color='#FF2222'>NOT ACTIVE</t>" }
        , if !(_isAlerted) then { "<t size='1.25' color='#22FF22'>NOT ALERTED</t>" } else { "<t size='1.25'  color='#FF2222'>ALERTED!</t>" }
    ];
};

tSF_adminTools_DC_evaluateZoneCondition = {
    params ["_zonename"];
    [_zonename] remoteExec ["tSF_adminTools_DC_evaluateZoneConditionRemote", dzn_dynai_owner];
};

tSF_adminTools_DC_evaluateZoneConditionClient = {
    params ["_zonename", "_condition", "_result"];

    hint parseText format [
        "<t size='1' color='#FFD000' shadow='1'>[dzn DynAI Control Panel]
        <br />[CONDITION]</t>
        <br /><br /><t size='1.25'>%1</t>
        <br /><t color='#666666'>%2</t>
        <br />
        <br />%3"
        , _zonename
        , _condition
        , if (_result) then { "<t size='1.25' color='#22FF22'>PASSED</t>" } else { "<t size='1.25'  color='#FF2222'>NOT PASSED</t>" }
    ];
};


tSF_adminTools_DC_activateZone = {
    // RE API extension is not required
    params ["_zonename"];

    private _DialogResult = [
        [format ["Do you want to <t color='#33FF33'>activate</t> zone <t color='#FFD000'>%1</t>?", _zonename]]
        , ["Yes"], ["No"]
    ] call dzn_fnc_ShowBasicDialog;
    waitUntil {!dialog};
    if !(_DialogResult) exitWith {};

    private _zone = call compile _zonename;
    _zone call dzn_fnc_dynai_activateZone;

    hint parseText format [
        "<t size='1' color='#FFD000' shadow='1'>[dzn DynAI Control Panel]</t>
        <br /><br /><t size='1.25'>%1 activation...</t>"
        , _zonename
    ];

    waitUntil { sleep 0.25; _zone call dzn_fnc_dynai_isActive };
    _zonename call tSF_adminTools_DC_checkZoneState;
};



tSF_adminTools_DC_deactivateZone = {
    // RE API extension is not required
    params ["_zonename"];

    private _DialogResult = [
        [format ["Do you want to <t color='#FF3333'>de-activate</t> zone <t color='#FFD000'>%1</t>?", _zonename]]
        , ["Yes"], ["No"]
    ] call dzn_fnc_ShowBasicDialog;
    waitUntil {!dialog};
    if !(_DialogResult) exitWith {};

    private _zone = missionNamespace getVariable _zonename;
    [_zone] call dzn_fnc_dynai_deactivateZone;

    hint parseText format [
        "<t size='1' color='#FFD000' shadow='1'>[dzn DynAI Control Panel]</t>
        <br /><br /><t size='1.25'>%1 deactivation...</t>"
        , _zonename
    ];

    waitUntil { sleep 0.25; !(_zone call dzn_fnc_dynai_isActive) };
    _zonename call tSF_adminTools_DC_checkZoneState;
};


tSF_adminTools_DC_alertZone = {
    // RE API extension is not required
    params ["_zonename"];

    private _DialogResult = [
        [format ["Do you want to <t color='#FF3333'>alert</t> zone <t color='#FFD000'>%1</t>?", _zonename]]
        , ["Yes"], ["No"]
    ] call dzn_fnc_ShowBasicDialog;
    waitUntil {!dialog};
    if !(_DialogResult) exitWith {};

    (missionNamespace getVariable _zonename) remoteExec ["dzn_fnc_dynai_alertZone", dzn_dynai_owner];

    hint parseText format [
        "<t size='1' color='#FFD000' shadow='1'>[dzn DynAI Control Panel]</t>
        <br /><br /><t size='1.25'>%1 zone alerted!</t>"
        , _zonename
    ];
};

tSF_adminTools_DC_showHideZone = {
    params ["_zonename"];
    [_zonename] remoteExec ["tSF_adminTools_DC_showHideZoneRemote", dzn_dynai_owner];
};

tSF_adminTools_DC_showHideZoneClient = {
    params ["_zonename", "_zone", "_props"];

    private _markers = _zone getVariable ["mrk_drawn", []];
    if (_markers isNotEqualTo []) exitWith {
        // Hide zone
        { deleteMarker _x } forEach _markers;
        _zone setVariable ["mrk_drawn", []];

        hint parseText format [
            "<t size='1' color='#FFD000' shadow='1'>[dzn DynAI Control Panel]</t>
            <br /><br />Markers removed for zone %1!"
            , _zonename
        ];
    };

    // Show zone
    private _color = switch ( _props # 1) do {
        case "WEST": { "ColorWEST" };
        case "EAST": { "ColorEAST" };
        case "RESISTANCE": { "ColorGUER" };
        case "CIVILIAN": { "ColorCIV" };
    };

    {
        private _mrk = [
            format ["mrk_area_%1_%2", _zonename, _forEachIndex]
            , _x , true
        ] call BIS_fnc_markerToTrigger;
        _mrk setMarkerBrushLocal "SolidBorder";
        _mrk setMarkerColorLocal _color;
        _markers pushBack _mrk;

        private _mrkTitle = [
            format ["mrk_%1_%2_title", _zonename, _forEachIndex]
            , getPos _x
            , "mil_dot"
            , _color
            , _zonename
            , true
        ] call dzn_fnc_createMarkerIcon;
        _markers pushBack _mrkTitle;
    } forEach (_props # 3);

    _zone setVariable ["mrk_drawn", _markers];
    hint parseText format [
        "<t size='1' color='#FFD000' shadow='1'>[dzn DynAI Control Panel]</t>
        <br /><br />Markers drawn for zone %1!"
        , _zonename
    ];
};


tSF_adminTools_DC_showZoneInfo = {
    params ["_zonename"];
    [_zonename] remoteExec ["tSF_adminTools_DC_showZoneInfoRemote", dzn_dynai_owner];
};

tSF_adminTools_DC_showZoneInfoClient = {
    params ["_zonename", "_side", "_isActive", "_keypoints", "_template", "_behaviour", "_cond", "_grpsWithUnits", "_totalUnitsCount"];

    hint parseText format [
        "<t size='1' color='#FFD000' shadow='1'>[dzn DynAI Control Panel]
        <br />[PROPERTIES]</t>
        <br /><br /><t size='1.25'>%1</t>
        <br />
        <br /><t size='0.75' color='#999999' align='left'>SIDE</t><br /><t align='left'>%2</t>
        <br /><t size='0.75' color='#999999' align='left'>ACTIVE</t><br /><t align='left'>%3</t>
        <br /><t size='0.75' color='#999999' align='left'>KEYPOINTS</t><br /><t align='left'>%4</t>
        <br /><t size='0.75' color='#999999' align='left'>TEMPLATE</t><br /><t align='left'>%5</t>
        <br /><t size='0.75' color='#999999' align='left'>BEHAVIOUR</t><br /><t align='left'>%6</t>
        <br /><t size='0.75' color='#999999' align='left'>CONDITION</t><br /><t align='left'>%7</t>
        <br /><t size='0.75' color='#999999' align='left'># OF GROUPS WITH UNITS</t><br /><t align='left'>%8 (%9 units total)</t>
        "
        , _zonename
        , _side
        , _isActive
        , if (typename _keypoints == "STRING") then { _keypoints } else { count _keypoints }
        , _template
        , _behaviour
        , _cond
        , _grpsWithUnits
        , _totalUnitsCount
    ];
};
