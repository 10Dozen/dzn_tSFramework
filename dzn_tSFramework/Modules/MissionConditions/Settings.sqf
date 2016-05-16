/*
 * Name of trigger to represent players base;
 * if set, it's possible to use   fnc_CheckPlayersReturned   function to check if all player returned to base
*/
PlayersBaseTrigger = baseTrg;

/*
 * List of mission Ends and Conditions
 * In format MissionCondition%1 = [ %EndingClassname(String), %Condition(String) ];
*/ 

MissionCondition1 = [ "WIN", "{ alive player }" ];
MissionCondition2 = [ "LOSE", "{ !alive player }" ];
