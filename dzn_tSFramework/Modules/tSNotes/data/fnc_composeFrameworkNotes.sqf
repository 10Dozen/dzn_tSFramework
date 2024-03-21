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

private _lines = [];

if (ECOB(Core) call [F(isModuleEnabled), "CCP"]) then {
    _lines pushBack "<font size='15' color='#12C4FF'>CCP</font>";
    _lines pushBack "<font color='#cccccc'>Воспользуйтесь меню действий 'Get Medical Care' на любом из объекте CCP.</font>";
    _lines pushBack "<font color='#cccccc'>Позволяет лечиться игроку, а также лечить других игроков без сознания (опция 'Provide first aid to uncon. patients').</font>";
    _lines pushBack "";
};

if (ECOB(Core) call [F(isModuleEnabled), "FARP"]) then {
    _lines pushBack "<font size='15' color='#12C4FF'>FARP</font>";
    _lines pushBack "<font color='#cccccc'>Воспользуйтесь меню действий 'FARP Menu' на любом из объекте FARPа.</font>";
    _lines pushBack "<font color='#cccccc'>Позволяет обслуживать технику на FARP, а также перевыдать снаряжение игрока.</font>";
    _lines pushBack "";
};

if (ECOB(Core) call [F(isModuleEnabled), "AirborneSupport"]) then {
    _lines pushBack "<font size='15' color='#12C4FF'>Airborne Support</font>";
    _lines pushBack "<font color='#cccccc'>Воспользуйтесь ACE-меню - Radio (Airborne) для вызова воздушного транспорта (доступно при наличии ДВ рации).</font>";
    _lines pushBack "<font color='#cccccc'>Воспользуйтесь ACE-меню на вертолете поддержки, чтобы начать процедуру транспортировки.</font>";
    _lines pushBack "";
};

if (ECOB(Core) call [F(isModuleEnabled), "POM"]) then {
    // TODO: Update name of the page to some static one in POM and here
    _lines pushBack "<font size='15' color='#12C4FF'>Platoon Markers</font>";
    _lines pushBack "<font color='#cccccc'>Для PL доступны легко перемещаемые маркеры союзных и вражеских сил. Зажмите ЛКМ и перетащите маркер подразделения в нужную позицию, согласно полученному LOCSTAT. Удерживая маркер нажмите LCtrl, чтобы изминть подпись, либо Del, чтобы удалить маркер.</font>";
    _lines pushBack "<font color='#cccccc'>Дополнительные макреры можно добавить через запись <font color='#ffb300'><log subject='tSF Operational Markers' record='Record0'>tSF Operational Markers</log></font>.</font>";
    _lines pushBack "";
};

if (ECOB(Core) call [F(isModuleEnabled), "MissionDefaults"]) then {
    if (ECOB(MissionDefaults) get Q(Settings) get Q(Calculator) get Q(enable)) then {
        _lines pushBack "<font size='15' color='#12C4FF'>Калькулятор</font>";
        _lines pushBack "<font color='#cccccc'>Воспользуйтесь чатом и введите '#c 12+2' или '#= 12+2, чтобы вычислить значение.</font>";
        _lines pushBack "";
    };

    if (ECOB(MissionDefaults) get Q(Settings) get Q(PhoneticAlphabet) get Q(enable)) then {
        _lines pushBack "<font size='15' color='#12C4FF'>Автоматические названия маркеров</font>";
        _lines pushBack "<font color='#cccccc'>Введите '$' в имя маркера, чтобы автоматически подобрать имя из фонетического алфавита (например, 'OBJ $' -> 'OBJ Alpha').</font>";
        _lines pushBack "<font color='#cccccc'>Введите '#', '## или '###' в имя маркера, чтобы автоматически подобрать следующий номер (1-, 2- или 3-значное число, например 'TRP ###' -> 'TRP 100', 'TRP 2##' -> 'TRP 200').</font>";
        _lines pushBack "";
    };
};

if (ECOB(Core) call [F(isModuleEnabled), "tSSettings"]) then {
    _lines pushBack "<font size='15' color='#12C4FF'>tS Настройки</font>";
    _lines pushBack "<font color='#cccccc'>Через запись <font color='#ffb300'><log subject='tSF_NotesSettingsPage' record='Record0'>tSF Настройки</log></font> можно настроить дальность видимости.</font>";
    _lines pushBack "";
};

_lines pushBack "<font size='15' color='#12C4FF'>Связь с GSO</font>";
_lines pushBack "<font color='#cccccc'>Кнопка F8 открывает меню для отправки сообщения GSO. Если вы столкнулись с технической проблемой, то вы можете сообщить об этом напрямую.</font>";

[
    "Mission Framework",
    _lines joinString "<br/>"
]
