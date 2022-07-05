#include "..\..\script_macro.hpp"

#define COMPONENT EditorRadioSettings

#define ERS_GAMELOGIC_FLAG QUOTE(tSF_ERS_Config)

#define LR_RADIO_CONFIG_TABLE GVAR(LRRadioConfig) = createHashMapFromArray [
#define LR_RADIO_CONFIG_TABLE_END ];

#define BLUFOR_LR_CLASS "tf_rt1523g"
#define OPFOR_LR_CLASS "TFAR_mr3000"
#define INDEP_LR_CLASS "TFAR_anprc155"
