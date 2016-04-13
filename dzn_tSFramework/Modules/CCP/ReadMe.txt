***************************************
	tSF - CCP 
	Ver. 0.1	
***************************************
	Dependencies:
		dzn_commonFunctions
		
	How To:
		- Trigger or triggers (that represent allowed area for CCP) synchonized with GameLogic named 'tsf_CCP'
		- Set up Settings.sqf file
		- On mission start and until briefing ends: script scans for CCP marker. If CCP is places outside allowed zone - warning message displayed and marker deletes.
		- On briefing end: spawn composition and CCP location at CCP marker. If no marker was placed - CCP creates at 'tsf_CCP' GameLogic position.
