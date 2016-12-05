tSF_Diag_AddDiagTopic = {
	tSF_Diag_Subject = "tSF_Diagpage";
	if !(player diarySubjectExists tSF_Diag_Subject) then {
		player createDiarySubject [tSF_Diag_Subject, "tSF DIAGNOSTICS"];
	};	
};

tSF_Diag_TSF_CollectData = {
	/*
		tS Framework Total:
		
			Date:
			XX.YY.ZZZZ
			
			Modules:
			
			%ModuleName% -- [Enabled/Disabled]
			...
			
			Mission Params		
		
		Modules if enabled:
		
		tSF - Briefing 
			[Enabled/Disabled] tSF_Briefing_ShowRoster
			[-1 seconds] -  tSF_Briefing_RosterTimeout
			[Enabled/Disabled] tSF_Briefing_UpdateRosterOnJIP
			
			
		tSF - CCP
		tSF - ...
	*/
	
	tSF_Diag_tSFrameworkTopicName = "tSF - Total";
	tSF_Diag_tSFramework = "";
};



tSF_Diag_Dynai_CollectData = {
	/*
		Dynai:
			Config Zone vs Real zones
	*/
	
};

tSF_Diag_Gear_CollectData = {
	/*
		Gear:
			GAT vs Kits
			
			GAT vs Kits vs Roles
	*/
	
};


