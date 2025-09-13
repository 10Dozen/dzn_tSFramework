#include "script_component.hpp"

/*
    Initialize Component Object and it's features.
    Params:
        none
    Returns:
        nothing
*/

if (SETTING(_self,ViewDistance)) then {
    [
        QGVAR(Setting_VD_Presets),
        "EDITBOX",
        ["Пресеты дальности", "Список из чисел определяющих дистанции видимости"],
        [TSF_CBASETTINGS_SECTION, SETTING_CATEGORY],
        "500, 1500, 3000, 10000, 20000",
        0,
        {
            private _presets = parseSimpleArray format ["[%1]", _this];
            COB set [Q(Presets), _presets];
            COB set [Q(CurrentPreset), 1 min (count _presets)];
        }
    ] call CBA_fnc_addSetting;

    [
        QGVAR(Setting_VD_ODRatio),
        "SLIDER",
        [
            "Коэф. дальности объектов", 
            "Объекты отрисовываются на дальность кратную этой настройке (по умолчанию - 75% дистанции видимости)"
        ],
        [TSF_CBASETTINGS_SECTION, SETTING_CATEGORY],
        [0.1, 1, 0.75, 1, true],
        0
    ] call CBA_fnc_addSetting;
};


[
    {
        !isNull findDisplay 52 ||
        getClientState == "BRIEFING SHOWN" ||
        time > 0
    },
    {
        LOG("Client init started");

        forceUnicode 0;
        _this call [F(addTopics)];
        _this call [F(restoreViewDistance)];
        _this call [F(addKeybinds)];
        forceUnicode -1;

        COMPONENT_SET_STATUS(COMPONENT_STATUS_OK);
        LOG("Client initialized");
    }
    , _self
] call CBA_fnc_waitUntilAndExecute;
