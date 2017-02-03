tSF_IACE_Timeout = -1;

/*
 *	Configuration of ACE Actions:
 *		[ @ActionType, @Name, @ID, @ParentID, @Code, @Condition ]
 *		0:  @List of Classname OR List of @Objects  -   if list of classname is used, then all map objects with given class will be applyed
 *		1:  @Name		-	displayed name of the action node
 *		2:  @ID		-	ID of action node
 *		3:  @ParentID	-	ID of parent action node
 *		4:  @Code		-	code to execute (_target is the action-related object)
 *		5:  @Condition	-	condition of action availabness
 *
 */

#define	ACE_INTRACTIVES_TABLE		tSF_IACE_Actions = [
#define	ACE_INTRACTIVES_TABLE_END	];

ACE_INTRACTIVES_TABLE
	/*
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
		["RHS_CH_47F"]
		, "IACE Action for CH47"
		, "iace_action_for_CH47"
		, ""
		, { hint 'IACE Action for CH47 is done' }
		, { true}	
	]
	*/

	
ACE_INTRACTIVES_TABLE_END
