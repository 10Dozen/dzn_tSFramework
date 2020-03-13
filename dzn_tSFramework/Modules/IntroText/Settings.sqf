#include "data\script_component.hpp"

/* Dependency: No
 */
GVAR(initTimeout) = 15;
GVAR(initCondition) = { true };  // Overall condition of module init


// 1st line -- Date in format DD/MM/YYYY. Use "%1/%2/%3" to use MissionDate.
GVAR(LineText1)	= "%1/%2/%3";
GVAR(LineStyle1) = "<t align = 'right' shadow = '1' size = '0.7' font='PuristaBold'><br />%1</t>";

// 2nd line
GVAR(LineText2)	= "Район Н, Страна Н, Регион Н";
GVAR(LineStyle2) = "<t align = 'right' shadow = '1' size = '0.7' font='PuristaBold'><br />%1</t>";

// 3rd line
GVAR(LineText3) = "Операция 'Без имени'";
GVAR(LineStyle3) = "<t align = 'right' shadow = '1' size = '0.9' font='PuristaBold'><br />%1</t>";

// Other settings
GVAR(ShowCurrentTime) = true; // show current time in intro text
GVAR(DisplayTime) = 15; // sec
GVAR(TextPosition) = [0.2, 0.7]; // right low corner
