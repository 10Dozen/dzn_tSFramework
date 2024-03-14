#include "..\..\script_macro.hpp"

#define COMPONENT IntroText

#define	STR_DATE(X) if (count str(X) == 1) then { "0" + str(X) } else { str(X) }

#define CURSOR_CLICK_PER_SECOND 10

#define DATE_TITLE_DEFAULT      "%1/%2/%3"
#define OPERATION_TITLE_DEFAULT "Операция 'Без имени'"
#define LOCATION_TITLE_DEFAULT  "Район Н, Страна Н, Регион Н"
