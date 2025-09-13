#include "script_component.hpp"

params ["_gearEditMode"];

LOG("Pre-Initialization started");

tSF_Version = TSF_VERSION_NUMBER;
tSF_IComponent = call compileScript [PATH(thisMODULE,IComponent,sqf)];

COB = call compileScript [PATH(thisMODULE,Component,sqf)];

// -- Exit on settings parse error
private _settings = COMPONENT_SETTINGS;
if ((_settings get "#ERRORS") isNotEqualTo []) exitWith {
    ((_settings get "#ERRORS") select 0) params ["","_lineNo","","_errorText"];
    private _src = _settings get "#SOURCE";
    TSF_ERROR_3(TSF_ERR__SETTINGS_PARSE_ERROR,"Модуль не запущен! Ошибка '%1' в строке %2 файла %3",_errorText,_lineNo,_src);
    COMPONENT_SET_STATUS(COMPONENT_STATUS_FAILED);
};
_settings deleteAt "#SOURCE";
_settings deleteAt "#ERRORS";
 
COB call [F(init), [_gearEditMode]];

LOG("Initialized");
