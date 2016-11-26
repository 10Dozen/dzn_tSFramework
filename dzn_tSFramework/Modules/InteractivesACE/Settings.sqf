
/*
 *
 *
 */

#define	ACE_INTRACTIVES_TABLE		tSF_IACE_Actions = [
#define	ACE_INTRACTIVES_TABLE_END	];

ACE_INTRACTIVES_TABLE
	[
		"SELF"
		, "IACE Action 1"
		, "iace_action_1"
		, ""
		, { hint "IACE Action 1 is done"; }
		, { true }
	]
	,[
		"SELF"
		, "IACE Sub Action of 1"
		, "iace_subaction_1"
		, "iace_action_1"
		, { hint "IACE Sub Action 1 is done"; }
		, { true }
	]
	,[
		[Shahid, Shahid_1, "RHS_CH_47F"]
		, "IACE Action for Shahid"
		, "iace_action_for_shahid"
		, ""
		, { hint 'IACE Action for Shahid is done' }
		, { true}	
	]

	
ACE_INTRACTIVES_TABLE_END
