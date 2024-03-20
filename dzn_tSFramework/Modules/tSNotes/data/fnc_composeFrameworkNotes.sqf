#include "script_component.hpp"

/*
    Composes framework related topics based on actually enabled features
    in the mission.

    (_self)

    Params:
        none.
    Returns:
        Array of topics and content in format [@TopicName, @Content]
*/

private _lines = ["<font color='#12C4FF' size='14'>Доступно:</font>"];
DEBUG_1("(composeFrameworkNotes) Lines: %1", _lines);

if (ECOB(Core) call [F(isModuleEnabled), "CCP"]) then {
    _lines pushBack "- CCP";
    _lines pushBack "<font></font>   Воспользуйтесь меню действий 'Get Medical Care' на любом из объекте CCP.";
    _lines pushBack "<font></font>   Позволяет лечиться игроку, а также лечить других игроков без сознания (опция 'Provide first aid to uncon. patients').";
};

if (ECOB(Core) call [F(isModuleEnabled), "FARP"]) then {
    _lines pushBack "- FARP";
    _lines pushBack "<font></font>   Воспользуйтесь меню действий 'FARP Menu' на любом из объекте FARPа.";
    _lines pushBack "<font></font>   Позволяет обслуживать технику на FARP, а также перевыдать снаряжение игрока.";
};

if (ECOB(Core) call [F(isModuleEnabled), "AirborneSupport"]) then {
    _lines pushBack "- Airborne Support";
    _lines pushBack "<font></font>   Воспользуйтесь ACE-меню - Radio (Airborne) для вызова воздушного транспорта (доступно при наличии ДВ рации).";
    _lines pushBack "<font></font>   Воспользуйтесь ACE-меню на вертолете поддержки, чтобы начать процедуру транспортировки.";
};

if (ECOB(Core) call [F(isModuleEnabled), "POM"]) then {
    _lines pushBack "- Platoon Markers";
};

if (ECOB(Core) call [F(isModuleEnabled), "MissionDefaults"]) then {
    if (ECOB(MissionDefaults) get Q(Settings) get Q(Calculator) get Q(enable)) then {
        _lines pushBack "- Калькулятор";
        _lines pushBack "<font></font>   Воспользуйтесь чатом и введите '#c 12+2' или '#= 12+2, чтобы высчитать значчение.";
    };

    if (ECOB(MissionDefaults) get Q(Settings) get Q(PhoneticAlphabet) get Q(enable)) then {
        _lines pushBack "- Автоматические названия маркеров";
        _lines pushBack "<font></font>   Введите '$' в имя маркера, чтобы автоматически подобрать имя из фонетического алфавита.";
        _lines pushBack "<font></font>   Введите '#', '## или '###' в имя маркера, чтобы автоматически подобрать следующий номер (1-, 2- или 3-значное число).";
    };
};

// TODO: tS Settings
// TODO: Zeus F8

[
    "Mission Framework",
    _lines joinString "<br/>"
]
