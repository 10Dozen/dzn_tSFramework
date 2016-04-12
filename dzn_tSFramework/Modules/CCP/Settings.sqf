dzn_tsf_CCP_HealTime		= 10*60; // 10 mins to heal player
dzn_tsf_CCP_Radius		= 25; 	// 25 m 
dzn_tsf_CCP_PreventPlayerDeath	= false; // Once on CCP - player will not die until healed
dzn_tsf_CCP_DefaultComposition	= "";	// Name of default composition; See 'DefaultCompositions.sqf' for names
dzn_tsf_CCP_HintText		= format ["You are at Casualties Collection Point. Wait for %1 minutes to heal.", round(dzn_tsf_CCP_HealTime/60)];
