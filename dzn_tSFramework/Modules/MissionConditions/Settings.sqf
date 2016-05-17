/*
 * Name of trigger to represent players base;
 * if set, it's possible to use   fnc_CheckPlayersReturned   function to check if all player returned to base
 * Set - PlayersBaseTrigger = "" to disable
*/
PlayersBaseTrigger = baseTrg;

/*
 * Default sleep interval between Mission Conditions checks (seconds)
*/
tSF_MissionCondition_DefaultCheckTimer = 15;

/*
 * List of mission Ends and Conditions (up to 20 conditions allowed)
 * In format MissionCondition%1 = [ %EndingClassname(String), %Condition(String), %TimerInterval(Number,seconds, optional) ];
*/ 

MissionCondition1 = [ "WIN", "{ alive player }" ];
MissionCondition2 = [ "LOSE", "{ !alive player }", 30 ];
