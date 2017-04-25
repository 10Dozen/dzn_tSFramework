/*
 *	Teleport conditions:
 *
 *	tSF_JIPTeleport_MaxTime		-	time after JIP
 *	tSF_JIPTeleport_MaxDistance	-	distance from spawn point
 *
*/ 
tSF_JIPTeleport_MaxTime			=	600;	// seconds (min. 10 seconds)
tSF_JIPTeleport_MaxDistance		=	75;	// meters


//	Relative (from SL position) teleporting position 
tSF_JIPTeleport_RelativePos		= [10,0,0];

// 	Show message for JIPs
tSF_JIPTeleport_ShowMessage		= true;
tSF_JIPTeleport_Message			= format [
	"У Вас есть %1 секунд, чтобы воспользоваться телепортом к вашему лидеру отделения. Также вы потеряете возможность телепорта, если отойдете на расстояние больше чем %2 метров от текущего места."
	,tSF_JIPTeleport_MaxTime
	,tSF_JIPTeleport_MaxDistance
];
