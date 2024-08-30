#include "script_component.hpp"


/*
    Opens Crew menu for given vehicle.
    [ Title                             X ]
    [ Slotname 1              [ + ] [ ++ ]]
    [ Slotname 2                     [ - ]]
    [                                     ]
    [                          [ Close   ]]

    (_self)

    Params:
        _vehicle (OBJECT) - vehicle to check against
    Returns:
        none

    _self call ["fnc_openCrewMenu", [_vehicle]];
*/

// TBD: Move button functions into separeate files

params ["_vehicle"];

private _configName = _vehicle getVariable GAMELOGIC_FLAG;
if (isNil "_configName") exitWith {
    TSF_ERROR_1(TSF_ERROR_TYPE__NO_CONFIG, "(AddCrew) У машины %1 не задан конфиг опций экипажа", _vehicle);
    objNull
};
if !(_configName in SETTING(_self,Configs)) exitWith {
    TSF_ERROR_2(TSF_ERROR_TYPE__NO_CONFIG, "(AddCrew) Конфиг опций экипажа %1 для машины %2 не найден в настройках модуля", _configName, _vehicle);
    objNull
};

private _cfg = SETTING(_self,Configs) get _configName;

private _slotsControls = [];
private _seats = _cfg get Q(crew);
private _isLeader = leader player isEqualTo player;
private _isVehicleCommander = effectiveCommander _vehicle isEqualTo player;

{
    private _seatCfg = _x;
    private _seat = _x get Q(seat);
    private _seatName = _x getOrDefault [Q(name), _seat];
    private _seatCurrentUnit = _self call [F(getUnitOnSeat), [_vehicle, _seat]];
    private _leadByPlayer = (leader group _seatCurrentUnit) isEqualTo player;
    private _isInPlayerLeadGroup = isPlayer leader group _seatCurrentUnit;

    // Format name -- white if seat is empty, gray if occupied by player, light green if occupied by AI
    _slotsControls pushBack [
        "LABEL",
        format [
            "<t color='%1'>%2%3</t>",
            [
                [COLOR_HEX_LIGHT_GREEN, COLOR_HEX_DARK_GRAY] select (isPlayer _seatCurrentUnit),
                COLOR_HEX_WHITE
            ] select (isNull _seatCurrentUnit),
            _seatName,
            [
                [
                    [" (без лидера)", " (другой игрок)"] select _isInPlayerLeadGroup,
                    " (Вы)"
                ] select _leadByPlayer,
                ""
            ] select (isNull _seatCurrentUnit)
        ]
    ];

    // Added Add or Remove actions
    if (isNull _seatCurrentUnit) then {
        _slotsControls append [
            [
                "BUTTON",
                "<t align='center'>+</t>",
                COB get F(onMenuButtonAdd),
                [_self, _vehicle, _seatCfg, false],
                [
                    ["w", 0.25],
                    [
                        "tooltip",
                        format [
                            "%1Добавить AI-юнита на место в экипаже",
                            [
                                "Вы не являетесь командиром техники и не сможете управлять юнитом!\n",
                                ""
                            ] select _isVehicleCommander
                        ]
                    ],
                    [
                        "bg", 
                        [COLOR_RGBA_LIGHT_RED, COLOR_RGBA_LIGHT_GREEN] select _isVehicleCommander
                    ], 
                    ["color", COLOR_RGBA_BLACK]
                ]
            ],
            [
                "BUTTON",
                "<t align='center'>++</t>",
                COB get F(onMenuButtonAdd),
                [_self, _vehicle, _seatCfg, true],
                [
                    ["w", 0.25],
                    [
                        "tooltip",
                        format [
                            "%1%2Добавить AI-юнита на место в экипаже и присоединить к группе.",
                            [
                                "Вы не являетесь командиром техники и не сможете управлять юнитом!\n",
                                ""
                            ] select _isVehicleCommander,
                            [
                                "Вы не являетесь лидером отряда и не сможете управлять юнитом!\n",
                                ""
                            ] select _isLeader

                        ]
                    ],
                    [
                        "bg", 
                        [COLOR_RGBA_LIGHT_RED, COLOR_RGBA_LIGHT_GREEN] select (_isVehicleCommander && _isLeader)
                    ], 
                    ["color", COLOR_RGBA_BLACK]
                ]
            ],
            ["BR"]
        ];
        continue;
    };

    _slotsControls append [
        [
            "BUTTON",
            "<t align='center'>—</t>",
            _self get F(onMenuButtonRemove),
            [_self, _vehicle, _seatCfg, false],
            [
                ["w", 0.25],
                [
                    "tooltip",
                    ["Удалить AI-юнита на выбранном месте.", "Слот занят игроком"] select (isPlayer _seatCurrentUnit)
                ],
                ["enabled", !(isPlayer _seatCurrentUnit)]
            ]
        ],
        [
            "BUTTON",
            "<t align='center'>-+</t>",
            _self get F(onMenuButtonRemove),
            [_self, _vehicle, _seatCfg, true, _isInPlayerLeadGroup],
            [
                ["w", 0.25],
                [
                    "tooltip",
                    [
                        [
                            "Пересоздать AI-юнита на выбранном месте.",
                            "Вы должны быть командиром машины и лидером отряда (в зависимости от настроек с которыми был создан бот),",
                            "чтобы управлять созданным юнитом."
                        ] joinString "\n", 
                        "Слот занят игроком"
                    ] select (isPlayer _seatCurrentUnit)
                ],
                ["enabled", !(isPlayer _seatCurrentUnit)],
                ["color", COLOR_RGBA_BLACK],
                [
                    "bg",
                    [
                        [COLOR_RGBA_LIGHT_RED, COLOR_RGBA_LIGHT_GREEN] select _isVehicleCommander,
                        [COLOR_RGBA_LIGHT_RED, COLOR_RGBA_LIGHT_GREEN] select (_isVehicleCommander && _isLeader)
                    ] select _isInPlayerLeadGroup
                ]
            ]
        ],
        ["BR"]
    ];
} forEach _seats;


private _menu = [
    ["HEADER", "Управление экипажем"],
    ["LABEL","Добавляйте или удаляйте AI-экипаж:"],
    [
        "CHECKBOX", 
        "Командир", 
        _isVehicleCommander, 
        [
            ["w",0.25],
            ["enabled", false],
            [
                "tooltip", 
                [
                    "Вы не командир машины!",
                    "Вы командир машины."
                ] select _isVehicleCommander
            ],
            [
                "color", 
                [
                    COLOR_RGBA_LIGHT_RED,
                    COLOR_RGBA_LIGHT_GREEN
                ] select _isVehicleCommander
            ]
        ]
    ],
    [
        "CHECKBOX", 
        "Лидер отряда", 
        _isLeader, 
        [
            ["w",0.25],
            ["enabled", false],
            [
                "tooltip", 
                [
                    "Вы не командир отряда!",
                    "Вы командир отряда."
                ] select _isLeader
            ],
            [
                "color", 
                [
                    COLOR_RGBA_LIGHT_RED,
                    COLOR_RGBA_LIGHT_GREEN
                ] select _isLeader
            ]
        ]
    ],
    ["BR"]
];
_menu append _slotsControls;

_menu append [
    ["BR"],
    ["LABEL"],
    ["BR"],
    [
        "BUTTON", 
        "Очистить места", 
        {
            params ["_cob","_args"];
            _args params ["_crewOptionsCOB", "_vehicle", "_seats"];
            {
                _crewOptionsCOB call [F(removeCrew), [_vehicle, _x]];
            } forEach _seats;

            _cob call ["Close"];

            [
                { (_this # 0) call [F(openCrewMenu), [_this # 1]] }, 
                [_crewOptionsCOB, _vehicle], 
                0.25
            ] call CBA_fnc_waitAndExecute;
        }, 
        [_self, _vehicle, _seats], 
        [["w", 0.25]]
    ],
    [
        "BUTTON", 
        "Очистить всё", 
        {
            params ["_cob","_args"];
            _args params ["_crewOptionsCOB", "_vehicle"];
            {
                if (isPlayer _x) then { continue; };
                moveOut _x;
                deleteVehicle _x;
            } forEach (crew _vehicle);

            hint "Все AI-юниты в машине были удалены!";
            
            _cob call ["Close"];

            [
                { (_this # 0) call [F(openCrewMenu), [_this # 1]] }, 
                [_crewOptionsCOB, _vehicle], 
                0.25
            ] call CBA_fnc_waitAndExecute;
        }, 
        [_self, _vehicle, _seats], 
        [["w", 0.25]]
    ],
    ["LABEL","",[["w",0.25]]],
    ["BUTTON", "Закрыть", { params ["_cob"]; _cob call ["Close"]; }]
];

_menu call dzn_fnc_ShowAdvDialog2;
