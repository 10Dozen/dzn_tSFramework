#include "script_component.hpp"

/*
    Updates roster data.
    (_self)

    Params:
        none
    Returns:
        nothing
*/


/*
    Gather data here
*/

/*
private _wrapper = "<font size='12' face='TahomaB'>%1</font>";
private _content = [
    "<font size='14'><font color='#4287f5'>BLUFOR</font> (18)</font>",

    "<font size='14'><font color='#f5c242'>Razor 1`6</font> (4)</font>",
    "<font color='#c9bea7'>Platoon Leader</font>",
    "          Some Nickname <font face='TahomaB' size='10' color='#cfcfcf'>/ АКС74У <font color='#93afba'>ДВ</font> <font color='#9db099'>КВ</font></font>",
    "<font color='#c9bea7'>Platoon Sergeant</font>",
    "          Comrade_Paulus <font face='TahomaB' size='10' color='#cfcfcf'>/ АКС74У <font color='#93afba'>ДВ</font> <font color='#9db099'>КВ</font></font>",
    "<font color='#c9bea7'>Снайпер</font>",
    "          Реневал[SBER] <font face='TahomaB' size='10' color='#cfcfcf'>/ СВ-96 <font color='#9db099'>КВ</font></font>",
    "<font color='#c9bea7'>JTAC</font>",
    "          Kilo-Kilo-123 <font face='TahomaB' size='10' color='#cfcfcf'>/ АК-74М (Зенитка/RIS/Пустынный) + Javeline FGM142 <font color='#93afba'>ДВ</font> <font color='#9db099'>КВ</font></font>",
    "",

    "<font size='14'><font color='#f5c242'>Razor 1`2*</font> (7)</font>",
    "<font color='#c9bea7'>Razor 1`2 Squad Leader</font>",
    "          Some Nickname <font face='TahomaB' size='10' color='#cfcfcf'>/ АК-74Н <font color='#93afba'>ДВ</font> <font color='#9db099'>КВ</font></font>",
    "*<font color='#c9bea7'>RED - Fireteam Leader</font>",
    "          10Dozen <font face='TahomaB' size='10' color='#cfcfcf'>/ АК-74Н <font color='#9db099'>КВ</font></font>",
    "<font color='#c9bea7'>RED - Automatic Rifleman</font>",
    "          Comrade_Paulus <font face='TahomaB' size='10' color='#cfcfcf'>/ ПКМ (Б-50/Ручка) <font color='#9db099'>КВ</font></font>",
    "<font color='#c9bea7'>RED - Grenadier</font>",
    "          Реневал[SBER] <font face='TahomaB' size='10' color='#cfcfcf'>/ АК-74 ГП-25 (Лесной) <font color='#9db099'>КВ</font></font>",
    "<font color='#c9bea7'>BLUE - Старший стрелок</font>",
    "          Kilo-Kilo-123 <font face='TahomaB' size='10' color='#cfcfcf'>/ АК-74М (Зенитка/RIS/Лесной) + РШГ-2 <font color='#9db099'>КВ</font></font>",
    "<font color='#c9bea7'>BLUE - Стрелок</font>",
    "          Comrade_Paulus <font face='TahomaB' size='10' color='#cfcfcf'>/ РПК (Зенитка/RIS/Лесной) <font color='#9db099'>КВ</font></font>",
    "<font color='#c9bea7'>BLUE - Стрелок</font>",
    "          Реневал[SBER] <font face='TahomaB' size='10' color='#cfcfcf'>/ АК-74М (Лесной) + РПГ-26 <font color='#9db099'>КВ</font></font>",

    "",
    "<font size='14'><font color='#f5c242'>Razor 1`3</font> (7)</font>",
    "<font color='#c9bea7'>Razor 1`3 Squad Leader</font>",
    "          Some Nickname <font face='TahomaB' size='10' color='#cfcfcf'>/ АК-74Н <font color='#93afba'>ДВ</font> <font color='#9db099'>КВ</font></font>",
    "<font color='#c9bea7'>RED - Fireteam Leader</font>",
    "          10Dozen <font face='TahomaB' size='10' color='#cfcfcf'>/ АК-74Н <font color='#9db099'>КВ</font></font>",
    "<font color='#c9bea7'>RED - Automatic Rifleman</font>",
    "          Comrade_Paulus <font face='TahomaB' size='10' color='#cfcfcf'>/ ПКМ (Б-50/Ручка) <font color='#9db099'>КВ</font></font>",
    "<font color='#c9bea7'>RED - Grenadier</font>",
    "          Реневал[SBER] <font face='TahomaB' size='10' color='#cfcfcf'>/ АК-74 ГП-25 <font color='#9db099'>КВ</font></font>",
    "<font color='#c9bea7'>BLUE - Старший стрелок</font>",
    "          Kilo-Kilo-123 <font face='TahomaB' size='10' color='#cfcfcf'>/ АК-74М (Зенитка/RIS) + РШГ-2 <font color='#9db099'>КВ</font></font>",
    "<font color='#c9bea7'>BLUE - Стрелок</font>",
    "          Comrade_Paulus <font face='TahomaB' size='10' color='#cfcfcf'>/ РПК (Зенитка/RIS) <font color='#9db099'>КВ</font></font>",
    "<font color='#c9bea7'>BLUE - Стрелок</font>",
    "          Реневал[SBER] <font face='TahomaB' size='10' color='#cfcfcf'>/ АК-74М + РПГ-26 <font color='#9db099'>КВ</font></font>",

     ""
];
*/


DEBUG_MSG("(updateRoster) Invoked");
private _rosterContent = [];

private _allSlots = playableUnits;
private _factionsDetails = SETTING_2(_self,Roster,factions);

private _sidePlayer = side player;
private _showAllSides = SETTING_2(_self,Roster,showPlayersFromAllSides);
if (!_showAllSides) then {
    _allSlots = _allSlots select { side _x == _sidePlayer };
};
DEBUG_1("(updateRoster) Slots: %1", _allSlots);

private ["_prefixOrdering"];
if (!isNil QECOB(MissionDefaults)) then {
    _prefixOrdering = SETTING_2(ECOB(MissionDefaults),DisableOnStart,orbatPrefixSortingOrder);
};

private _processedGroups = [];
private _groupsInfo = createHashMapFromArray [
    [west, []], [east, []], [independent, []], [civilian, []]
];
private ["_grp", "_grpInfo"];
{
    _grp = group _x;
    if (_grp in _processedGroups) then { continue; };
    _processedGroups pushBack _grp;

    _grpInfo = ECOB(Core) call [F(getGroupORBAT), [_x, _prefixOrdering, true]];
    (_groupsInfo get (side _x)) pushBack _grpInfo;
} forEach _allSlots;

// Sort group names
/*
{
    _groupsInfo set [
        _x,
        [_groupsInfo get _x, [], { _x # 0 }] call BIS_fnc_sortBy
    ]
} forEach (keys _groupsInfo);
*/

// Compose content
private _sidesToShow = [_sidePlayer];
if (_showAllSides) then {
    _sidesToShow pushBackUnique west;
    _sidesToShow pushBackUnique east;
    _sidesToShow pushBackUnique independent;
    _sidesToShow pushBackUnique civilian;
};


DEBUG_1("(updateRoster) _sidesToShow: %1", _sidesToShow);
DEBUG_1("(updateRoster) _groupsInfo: %1", _groupsInfo);


private _rosterContent = [];

private ["_side", "_sideGroups", "_unitsPerSide", "_sideSettings", "_sideRoster"];
{
    _side = _x;
    _sideGroups = _groupsInfo get _x;
    if (_sideGroups isEqualTo []) then { continue; };

    _unitsPerSide = 0;
    _sideSettings = _factionsDetails select (_factionsDetails findIf {
        _x get Q(side) == _side
    });

    _sideRoster = [];

    DEBUG_1("(updateRoster) Processing side: %1", _side);
    {
        _x params ["_grpName", "_grpSize", "_leaderInfo", "_members"];
        _unitsPerSide = _unitsPerSide + _grpSize;
        private _isMyGroup = false;

        private _leaderRosterData = _self call [F(formatUnitRosterLine), _leaderInfo];
        _isMyGroup = _isMyGroup || (_leaderRosterData # 1);

        DEBUG_1("(updateRoster) _leaderRosterData: %1", _leaderRosterData);

        // --- Members info
        private _membersLines = [_leaderRosterData # 0];
        {
            private _memberRosterData = _self call [F(formatUnitRosterLine), _x];
            _isMyGroup = _isMyGroup || (_memberRosterData # 1);
            _membersLines pushBack (_memberRosterData # 0);
            DEBUG_1("(updateRoster) _leaderRosterData: %1", _memberRosterData);
        } forEach _members;

        private _groupHeader = format [
            HEADER_WRAPPER,
            COLOR_GROUP_NAME,
            [_grpName, "*" + _grpName] select _isMyGroup,
            _grpSize
        ];
        DEBUG_1("(updateRoster) _groupHeader: %1", _groupHeader);

        _sideRoster pushBack ([
            _groupHeader,
            _membersLines joinString "<br/>"
        ] joinString "<br/>");
        _sideRoster pushBack "";

        DEBUG_1("(updateRoster) _sideRoster: %1", _sideRoster);

    } forEach _sideGroups;

    DEBUG_1("(updateRoster) _unitsPerSide: %1", _unitsPerSide);

    // --- Add Side header + Side groups
    _rosterContent pushBack (format [
        HEADER_WRAPPER,
        _sideSettings get Q(color), _sideSettings get Q(name), _unitsPerSide
    ]);
    _rosterContent pushBack (_sideRoster joinString "<br/>");
    _rosterContent pushBack "";
} forEach _sidesToShow;

DEBUG_1("(updateRoster) Updating with _rosterContent: %1", _rosterContent);

private _record = _self get Q(RosterRecord);
player removeDiaryRecord ["Diary", _self get Q(RosterRecord)];
_self set [Q(RosterRecord),
    player createDiaryRecord [
        "Diary",
        [
            ROSTER_TOPIC_NAME,
            format [MAIN_WRAPPER, _rosterContent joinString "<br/>"]
        ]
    ]
];
