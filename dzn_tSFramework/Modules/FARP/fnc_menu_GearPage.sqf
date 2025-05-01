#include "script_component.hpp"

/*

    (_self) (ClientSide)

    Params:
        none

    Returns:
        nothing
*/

params ["_farp"];
DEBUG_1("Params: %1", _this);

private _cfg = (_self get Q(Configs)) get (_farp get Q(Config));
private _defaults = _self get Q(Defaults);

private _menu = _self call [F(menu_navBar), [_farp]];

// -- Read and show resources if limited
((_cfg get Q(Logic)) getVariable GAMELOGIC_RESOURCES) params [
    "",
    "",
    "",
    "_gearResources",
];

if (_gearResources > -1) then {
    //[ Боеприпасы:][ 100/1000 ][▮▮▮▯▯▯▯▯▯▯▯▯▯]
    _menu append [
        ["LABEL", "Снаряжение"],
        ["LABEL", "100/1000"],
        ["LABEL", "▮▮▮▯▯▯▯▯▯▯▯▯▯"],
        ["BR"]
    ];
};

// -- Kit renewal
_menu append [
    ["BUTTON", "Повторно выдарть набор снаряжения", {
        // Action to add item
        params ["_farpLogic", "_item", "_count", "_cost"];
        private _isSuccess = COB call [F(changeResources), [_farp, "gear", _cost]]; // TODO
        if (!_isSuccess) exitWith { /* Notify UNAVAILABLE */ };

        [player, player getVariable "dzn_gear"] call dzn_fnc_gear_assignKit;

        // Notify
    }, []],
    ["LABEL", "10"],
    ["BR"]
];

// -- Items to add
private _items = (_farp getOrDefault [Q(Gear), _defaults get Q(Gear)]) getOrDefault [Q(Items), _defaults get Q(Gear) get Q(Items)];

private _onAddItemButtonClick = {
    params ["_farpLogic", "_item", "_count", "_cost"];

    // -- Handle resorces
    private _isSuccess = COB call [F(changeResources), [_farp, "gear", _cost]]; // TODO
    if (!_isSuccess) exitWith { /* Notify UNAVAILABLE */ };

    for "_i" from 1 to _count do {
        if !([player, _item, true] call CBA_fnc_addItem) then {
            // Add to box  + Notify DROPED ITEM
        };
    };
};


{
    private _itemClass = _x;
    private _itemCount = 1;
    if (_x isEqualType []) then {
        _itemClass = _x # 0;
        _itemCount = _x # 1;
    };

    // Replace placeholders with actual item
    switch (_itemClass) do {
    case "#NVG": { "" /* NVG Class depending on side ?*/ };
    case "#PRIMARY_MAG": { primaryWeaponMagazine player };
    };
    if (_itemClass == "") then { continue; };

    private _itemName = _itemClass call dzn_fnc_getItemDisplayName;
    _menu append [
        ["BUTTON", _itemName, _onAddItemButtonClick, [_itemClass, _itemCount]],
        ["LABEL", "10"],
        ["BR"]
    ];
} forEach _items;
