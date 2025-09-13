#include "utility.h"

// -- Meta
#define PREFIX tSF
#define TSF_VERSION_NUMBER 2.5
#define TSF_CBASETTINGS_SECTION "Tactical Shift Framework"

// -- Logging
#include "log.h"
#include "errors.h"

// -- Paths
#define PATH(MODULE,FILE,EXT) 'dzn_tSFramework\Modules\MODULE\FILE.EXT'
#define CONFIG_PATH(FILE,EXT) 'Config\FILE.EXT'

// -- Module & Components
#define thisMODULE
#include "component.h"





// Client/Server condition
#define IS_SERVER (isServer)
#define IS_CLIENT (!isServer)
#define IS_PLAYER (!isServer && hasInterface)
#define IS_HEADLESS (!isServer && !hasInterface)


