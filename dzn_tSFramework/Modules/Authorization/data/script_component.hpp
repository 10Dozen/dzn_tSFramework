#include "..\..\script_macro.hpp"

#define COMPONENT Authorization

#define AUTHORIZATION_RULES_TABLE GVAR(RuleList) = [
#define AUTHORIZATION_RULES_TABLE_END ];

#define ROLE [
#define HAS ,
#define PERMISSIONS ]

#define AUTHORIZATION_TYPES ["ARTILLERY", "AIRBORNE", "POM"]

#define ARTILLERY_ALLOWED true
#define AIRBORNE_ALLOWED true
#define POM_ALLOWED true
#define ARTILLERY_NO false
#define AIRBORNE_NO false
#define POM_NO false
#define ALL_ALLOWED true,true,true
#define ARTILLERY_ONLY_ALLOWED true,false,false
#define ARTY_AND_AIRBORNE_ALLOWED true,true,false
