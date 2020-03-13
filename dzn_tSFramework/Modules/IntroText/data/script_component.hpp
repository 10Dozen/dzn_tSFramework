#include "..\..\script_macro.hpp"

#define COMPONENT IntroText

#define	STR_DATE(X) if (count str(X) == 1) then { "0" + str(X) } else { str(X) }
#define LINE1_DEFAULT "%1/%2/%3"
#define LINES_DEFAULT ["Район Н, Страна Н, Регион Н","Операция 'Без имени'"]
