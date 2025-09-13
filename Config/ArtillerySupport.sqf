/*
 *	Dependency:
 *		- Modules/Authorization
 *		- Modules/ACEActions
 */
tSF_ArtillerySupport_initTimeout   = 0;
tSF_ArtillerySupport_initCondition = { true }; // Overall condition of module init

tSF_ArtillerySupport_FiremissionPreparationTimeout = 15; // Timeout before any shot will be mae\de
tSF_ArtillerySupport_BatteryReloadTime             = 30*60; // Timeout for reloading all firemissions
tSF_ArtillerySupport_AdjustFireExpirationTimeout   = 5*30;	// Expirtation Timeout of firemission request during Adjust Fire phase

// 	VIRTUAL ARTILLERY
/*
 *	Virtual artillery rounds by type, in format:
 *	[
 *		@Artillery Battery confign name
 *		, [ @DisplayName, @NumberAvailable, @RoundClassname ] // Magazines map
 *		, [ @MinRange, @MaxRange ] // Range limits
 *		, [ @MinRangeETA, @MaxRangeETA ] // ETA min and max
 *		, @NumberOfGuns // Number of guns in battery
 *		, @ShotReloadTime // Time between shots, seconds
 *	]
 *
 *	Magazines map:
 *		@DisplayName -- name displayed in Request Firemission screen <STRING>
 *		@NumberAvailable -- number of firemissions available, -1 means not avaialble and no reloading needed <NUMBER>
 *		@RoundClassnames -- classname of round magazine <STRING>
 */
#define HE "HE"
#define SMK "SMK"
#define ILLUM "ILLUM"

tSF_ArtillerySupport_VirtualFiremissionsProperties = [
	[
		"82mm Mortar"  /* Имя конфигурации */
		, [             /* Достуные миссии: [Имя, Доступное кол-во, Класс магазина] */
			[HE, 2, "8Rnd_82mm_Mo_shells"]
			,[SMK, 9, "8Rnd_82mm_Mo_Smoke_white"]
			,[ILLUM, 9, "8Rnd_82mm_Mo_Flare_white"]
		]
        /*
		/*, [300, 4000]  /* Дальность, в метрах: [min, max]*/
		/*, [25, 50]     /* Время подлета, в секундах: [на минимальную дальность, на максимальную дальность] */
		/*, 3            /* Размер залпа */
		/*, 6            /* Время перезарядки между залпами, секунд*/
        /* (опционально) Дополнительные опции:
            rounds: Опции кол-ва снарядов в миссии
            shapes:
            distances:
            searchFire:
        */
        , "range: (min: 300, max: 4000),
           ETA: (min: 25, max: 50),
           guns: 3,
           ROF: `1/6`,
           requestOptions: (
               rounds: [10,1,2,3,4,5,6,7,8,9],
               shapes: [LINE, CIRCLE],
               distances: [50, 100, 150, 200, 250, 25],
               searchFire: true
           )"
	]
    ,[
		"MRLS"
		,[[HE, 6,"12Rnd_230mm_rockets"], ["CLUSTER",2,"12Rnd_230mm_rockets"]]
        , "range: (min: 700, max: 34000),
           ETA: (min: 10, max: 10),
           guns: 5,
           ROF: 5,
           requestOptions: (
               rounds: [10,20,30,40],
               shapes: [CIRCLE],
               distances: [125],
               searchFire: false
           )"
	]
    /*
	,[
		"155mm Howitzer"
		, [[HE, 6,"32Rnd_155mm_Mo_shells", [SMK,9,"6Rnd_155mm_Mo_smoke"], [ILLUM,-1,""]]
		, [400, 24000]
		, [25, 120]
		, 3
		, 6
	]
	,[
		"MRLS"
		,[HE_RNDS(6,"12Rnd_230mm_rockets"), ["CLUSTER",2,"12Rnd_230mm_rockets"], ILLUM_RNDS(-1,"")]
		, [700, 24000]
		, [25, 80]
		, 3
		, 1
        , [50, 150]
        , "rounds: [10,20,30,40],
           shapes: [LINE],
           distances: [50, 100, 150, 200, 250, 25],
           searchFire: true"
	]
	,[
		"105mm Howitzer"
		, [[HE, 2,"8Rnd_82mm_Mo_shells"], [SMK,9,"8Rnd_82mm_Mo_Smoke_white"], [ILLUM,9,"8Rnd_82mm_Mo_Flare_white"]]
		, [300, 12000]
		, [25, 60]
		, 3
		, 6
	]
    */
];



/*
	Ammo classes for different guns:
	Sholef:
		"32Rnd_155mm_Mo_shells","4Rnd_155mm_Mo_guided","6Rnd_155mm_Mo_mine","2Rnd_155mm_Mo_Cluster","6Rnd_155mm_Mo_smoke","2Rnd_155mm_Mo_LG","6Rnd_155mm_Mo_AT_mine"
	2S9 Sochor:
		"32Rnd_155mm_Mo_shells_O","2Rnd_155mm_Mo_guided_O","6Rnd_155mm_Mo_mine_O","2Rnd_155mm_Mo_Cluster_O","6Rnd_155mm_Mo_smoke_O","4Rnd_155mm_Mo_LG_O","6Rnd_155mm_Mo_AT_mine_O"
	MRLS Seara, KAMAZ MRLS:
		"12Rnd_230mm_rockets"
*/
