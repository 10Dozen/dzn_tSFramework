tSF_CCP_TimeToHeal			= 30;		// Timeout before healed
tSF_CCP_TimeToHold			= 60;		// Timeout before finishing MediCare cycle

tSF_CCP_Composition			= "Civil SUV";	// Name of default composition; See 'DefaultCompositions.sqf' for names

// Texts
tSF_CCP_STR_NotAllowedText		= "This area is not secured to deploy CCP there. Choose different location.";
tSF_CCP_STR_AlreadySet			= "CCP location was already set (remove previous one to change location).";
tSF_CCP_STR_SuccessSet  		= "CCP will be deployed at selected location";



/*
 * *********************************
 * Description of the module
 * *********************************
 */
tSF_CCP_Schema = [
	/* Module name */	"Casualties Collection Point"
	,[
		/* Module Settings */
		[
			/* Setting */		"tSF_CCP_Composition"
			/* Description */	, "Composition on site"
			/* Type */			, "string"
		]
		, [
			/* Setting */		"tSF_CCP_TimeToHeal"
			/* Description */	, "Time to heal"
			/* Type */			, "time"
		]
		, [
			/* Setting */		"tSF_CCP_TimeToHold"
			/* Description */	, "Time to stay at CCP"
			/* Type */			, "time"
		]
	]
];
