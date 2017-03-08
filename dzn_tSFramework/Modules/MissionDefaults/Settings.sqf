tSF_MissionDefaults_DisableInputOnStart 	= true;
tSF_MissionDefaults_DisableInputTimer	= 20;

tSF_MissionDefaults_SubtitleText		= "Управление отключено, не паникуй! <br /><br />- Не нажимай кнопок<br />- Прослушай ORBAT<br />- Запомни своего командира и напарника";


tSF_MissionDefaults_PutEarplugsOn		= true;
tSF_MissionDefaults_PutWeaponSafe		= true;

tSF_MissionDefaults_AddPlayerRating	= true;

tSF_MissionDefaults_EnableCutieCalc	= true;

/*
 * *********************************
 * Description of the module
 * *********************************
 */
tSF_MissionDefaults_Schema = [
	/* Module name */	"Mission Defaults"
	,[
		/* Module Settings */
		[
			/* Setting */		"tSF_MissionDefaults_DisableInputOnStart"
			/* Description */	, "Disable input on start"
			/* Type */			, "bool"
		]
		, [
			/* Setting */		"tSF_MissionDefaults_DisableInputTimer"
			/* Description */	, "Disable input on start time"
			/* Type */			, "time"
		]
		, [
			/* Setting */		"tSF_MissionDefaults_PutEarplugsOn"
			/* Description */	, "Put earplug in on start"
			/* Type */			, "bool"
		]
		, [
			/* Setting */		"tSF_MissionDefaults_PutWeaponSafe"
			/* Description */	, "Put weapon on SAFE on start"
			/* Type */			, "bool"
		]
		, [
			/* Setting */		"tSF_MissionDefaults_AddPlayerRating"
			/* Description */	, "Add player rating"
			/* Type */			, "bool"
		]		
	]
];
