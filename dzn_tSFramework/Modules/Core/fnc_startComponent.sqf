#include "script_component.hpp"
/*
    Search and starts component by it's name.
    Uses manifest.yaml file in component dir to set up component.

    Exits if machine is not allowed in manifest file without 
    creating component at all.

    Exits and mark component as failed if there are erros on parsing 
    component's settings file.

    # manifest.yaml
    # Start on server 
    Server: true/false (optional, default - false)

    # Start on player 
    Player: true/false (optional, default - false)
    
    # Start on headless - alternative syntax 
    Headless:
        # enable/disable start on target (optional, default - true)
        enabled: true/false
        # component init function 
        init: "fnc_initSever" (optional, default - "fnc_initSever")

    # If true and headless "HC" exists - start only on headless, but not on server 
    PreferHeadless: true/false (optional, default - false)

    # dependencies 
    Depends:
        - ComponentName2
        - ComponentName3

    # List of public functions to initialize from "Public" subdir
    PublicFunctions: (optional, default - [])
        - MyFunction   # will be init as tSF_ComponentName_fnc_MyFunction
        - MyFunction2


*/
#define LOG(MSG) diag_log text format ["[tSF] (%1): LOG: %2", _componentName, MSG];
#define ERR(MSG) diag_log text format ["[%tSF] (%1): ERR: %2", _componentName, MSG];

#define BASIC_PATH Q(dzn_tSFramework\Modules)

params ["_componentName"];
private _manifestFile =  format ["%1\%2\manifest.yaml", BASIC_PATH, _componentName];
if (!fileExists _manifestFile) exitWith {
    LOG("Manifest not found. Module might be deleted.");
};
private _componentSettingsFile = format ["Config\%1.yaml", _componentName];
if (!fileExists _componentSettingsFile) exitWith {
    LOG("Settings file not found.");
};

private _manifest = [_manifestFile] call dzn_fnc_parseSFML;

// -- Manifest settings 
// --
private _serverInit = "fnc_initServer";
private _clientInit = "fnc_initClient";
private _headlessInit = _serverInit;
private _publicFunctions = [];

private _runOnServer = _manifest getOrDefault ["Server", false];
if !(_runOnServer isEqualType false) then {
    _serverInit = _runOnServer getOrDefault ["init", _serverInit];
    _runOnServer = _runOnServer getOrDefault ["enabled", true];
};

private _runOnHeadless = _manifest getOrDefault ["Headless", false];
if !(_runOnHeadless isEqualType false) then {
    _headlessInit = _runOnHeadless getOrDefault ["init", _headlessInit];
    _runOnHeadless = _runOnHeadless getOrDefault ["enabled", true];
};

private _runOnPlayer = _manifest getOrDefault ["Player", false];
if !(_runOnPlayer isEqualType false) then {
    _clientInit = _runOnPlayer getOrDefault ["init", _clientInit];
    _runOnPlayer = _runOnPlayer getOrDefault ["enabled", true];
};

private _preferHeadless = _manifest getOrDefault ["PreferHeadless", false];
private _dependencies = _manifest getOrDefault ["Depends", []];

// -- Filter out unwanted environment
private _isDedicatedServer = isDedicated;
private _isServer = isServer ;
private _isPlayer = hasInterface;
private _isHeadless = !isServer && !hasInterface;

if (_isDedicatedServer && !_runOnServer) exitWith {
    LOG("Exit on server/dedicated");
};
if (_isHeadless && !_runOnHeadless) exitWith {
    LOG("Exit on headless");
};
if (_isPlayer && !_runOnPlayer) exitWith {
    LOG("Exit on player");
};

// В сингле - никогда не выходим 
// В мультиплеере - 
//        Если НЕТ объекта "HC" И мы НЕ сервер          -- выходим
//      Если ЕСТЬ объект "НС" и мы (СЕРВЕР или ИГРОК) -- выходим
private _existsHC = isNil "HC";
if (_preferHeadless && isMultiplayer && (
    (!_existsHC && !_isServer) ||
    (_existsHC && !_isHeadless)
)) exitWith {};


// -- Running component
// --
LOG("Pre-initialization started");

private _skipPreInit = false;
{
    private _isEnabled = _self get Q(Settings) getOrDefault [_x, false]; 
    if (_isEnabled) then { continue; };

    _skipPreInit = true;
    _self call [F(reportError), [
        _componentName,
        "Зависимость отсутствует",
        format ["Модуль не запущен! '%1' не включен в настройках.", _x]
    ]];
} forEach _dependencies;

if (_skipPreInit) exitWith {};

// -- Initialization: Settings
private _componentSettings = [_componentSettingsFile] call dzn_fnc_parseSFML;
if ((_componentSettings get "#ERRORS") isNotEqualTo []) exitWith {
    // -- Fail component 
    ERR("Component initialization skipped => DISABLED");
    
    // -- Throw tSF error 
    ((_componentSettings get "#ERRORS") select 0) params ["","_lineNo","","_errorText"];
    _self call [F(reportError), [
        _componentName,
        TSF_ERR_TYPE__SETTINGS_PARSE_ERROR,
        format [
            "Модуль не запущен! Ошибка '%1' в строке %2 файла %3", _errorText,  _lineNo, 
            _componentSettings get "#SOURCE"
        ]
    ]];
};
_componentSettings deleteAt "#SOURCE";
_componentSettings deleteAt "#ERRORS";

// -- Initialization: Component object
private _cob = createHashMapObject [
    (call compileScript [format ["%1\%2\Component.sqf", BASIC_PATH, _componentName]])
    + 
    [["#base", COMPONENT_IFACE],
    ["#name", _componentName],
    ["#type", format ["tSF_%1_Component", _componentName]],
    ["#str", { format ["tSF_%1_Component", _componentName] }],
    [Q(Settings), _componentSettings]]
];
missionNamespace setVariable [format ["tSF_%1_Component", _componentName], _cob];+
_self call [F(registerComponent), [_componentName, _cob]];


// -- Initialization: Public functions
private ["_funcName", "_funcPath"];
{
    _funcName = format ["tSF_%1_fnc_%2", _componentName, _x];
    _funcPath = format ["%1\%2\Public\fnc_%3.sqf", BASIC_PATH, _componentName, _x];
    missionNamespace setVariable [_funcName, compileScript [_funcPath]];
} forEach _publicFunctions;

// --- Initialization: Component init
if ((_isServer || _isDedicatedServer) && _runOnServer) then {
    LOG("Going to initialize on server");
    _cob call [_serverInit, []];
};

if (_isHeadless && _runOnHeadless) then {
    LOG("Going to initialize on headless");
    _cob call [_headlessInit, []];
};

if (_isPlayer && _runOnPlayer) then {
    LOG("Going to initialize on player");
    _cob call [_clientInit, []];
};
