
// -- Error reporting
#define TSF_ERR__NO_CONFIG "Конфиг не найден"
#define TSF_ERR__NO_MARKER "Маркер не найден"
#define TSF_ERR__MISCONFIGURED "Некорректная конфигурация"
#define TSF_ERR__MISSING_ENTITY "Отстутсвует целевой объект"
#define TSF_ERR__SETTINGS_PARSE_ERROR "Не удалось распарсить файл настроек (Settings.yaml)"
#define TSF_ERR__INVALID_ARG "Аргумент не корректен"
#define TSF_ERR__MISSING_KIT "Набор снаряжения не найде



#define TSF_ERROR_CALL ECOB(Core) call [F(reportError), [Q(thisMODULE)
#define _EC ]]

#define TSF_ERROR(REASON,MSG) TSF_ERROR_CALL, REASON, MSG _EC
#define TSF_ERROR_1(REASON,MSG,ARG1) TSF_ERROR_CALL, REASON, FORMAT_1(MSG,ARG1) _EC
#define TSF_ERROR_2(REASON,MSG,ARG1,ARG2) TSF_ERROR_CALL, REASON, FORMAT_2(MSG,ARG1,ARG2) _EC
#define TSF_ERROR_3(REASON,MSG,ARG1,ARG2,ARG3) TSF_ERROR_CALL, REASON, FORMAT_3(MSG,ARG1,ARG2,ARG3) _EC
#define TSF_ERROR_4(REASON,MSG,ARG1,ARG2,ARG3,ARG4) TSF_ERROR_CALL, REASON, FORMAT_4(MSG,ARG1,ARG2,ARG3,ARG4) _EC
#define TSF_ERROR_5(REASON,MSG,ARG1,ARG2,ARG3,ARG4,ARG5) TSF_ERROR_CALL, REASON, FORMAT_5(MSG,ARG1,ARG2,ARG3,ARG4,ARG5) _EC

