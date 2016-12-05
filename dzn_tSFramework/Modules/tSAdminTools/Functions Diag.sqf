#define		HEAD	""
#define		TITLE	""

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
	
	private _topicHead = format[
		"<t %1>Scenario name:</t>  %2<br /><t %1>Date:</t> %3<br />"		
		, HEAD
		, missionName /* briefingName */
		, MissionDate 
	]; 
	
	private _topicModules = format["<t %1>Modules:</t><br />", TITLE];
	{		
		_topicModules = format [
			"%1<br />[%2] %3"
			, _topicModules
			, if (_x select 0) then { "ENABLED"} else {"DISABLED"}
			, _x select 1
		]
	} forEach [
		[tSF_module_MissionDefaults			,"Mission Defaults"]
		,[tSF_module_MissionConditions		,"Mission Conditions"]
		,[tSF_module_IntroText				,"Intro Text"]
		,[tSF_module_Briefing				,"Briefing"]
		,[tSF_module_JIPTeleport			,"JIP Teleport"]		
		,[tSF_module_tSNotes				,"tS Notes"]
		,[tSF_module_tSNotesSettings		,"tS Notes Settings"]		
		,[tSF_module_CCP					,"Casualties Collection Point"]
		,[tSF_module_Support				,"Support"]		
		,[tSF_module_Interactives			,"Interactives"]
		,[tSF_module_InteractivesACE		,"Interactives ACE"]		
		,[tSF_module_EditorVehicleCrew		,"Editor Vehicle Crew"]
		,[tSF_module_EditorUnitBehavior		,"Editor Unit Behavior"]
		,[tSF_module_EditorRadioSettings	,"Editor Radio Settings"]		
		,[tSF_module_tSAdminTools			,"tS Admin Tools"]
	];
	
	
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


