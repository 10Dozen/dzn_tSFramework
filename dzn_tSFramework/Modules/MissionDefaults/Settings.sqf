/* 
 *	Disables input on mission start to prevent accidents with weapons 
 *		and to lower server load
 */
tSF_MissionDefaults_DisableInputOnStart 	= true;
tSF_MissionDefaults_DisableInputTimer	= 20;
tSF_MissionDefaults_SubtitleText		= "Управление отключено, не паникуй! <br /><br />- Не нажимай кнопок<br />- Прослушай ORBAT<br />- Запомни своего командира и напарника";

/* 
 *	Add some gear and weapon safety
 */
tSF_MissionDefaults_PutEarplugsOn		= true;
tSF_MissionDefaults_PutWeaponSafe		= true;

/* 
 *	Add rating for players to prevent issues with vehicles after accidental friendly fiew
 */
tSF_MissionDefaults_AddPlayerRating	= true;

/* 
 *	Turns on in-game calculator (via markers like '@12 + 2*4')
 */
tSF_MissionDefaults_EnableCutieCalc	= true;

/*
 *	Marker Phonetic Autocompletion
 */
tSF_MissionDefaults_EnableMarkerPhoneticAutocompletion	= true;
tSF_MissionDefaults_PhoneticAlphabet = [
	"Alpha"	,"Bravo"	,"Charlie"	,"Delta"	,"Echo"	,"Foxtrot"	
	,"Golf"	,"Hotel"	,"India"	,"Juliett"	,"Kilo"	,"Lima"	
	,"Mike"	,"November"	,"Oscar"	,"Papa"	,"Quebec"	,"Romeo"	
	,"Sierra"	,"Tango"	,"Uniform"	,"Victor"	,"Whiskey"	,"X-ray"	
	,"Yankee"	,"Zulu"
	
	,"Анна"	,"Борис"	,"Василий"	,"Григорий"	,"Дмитрий"	,"Елена"
	,"Женя"	,"Зоя"	,"Иван"	,"Константин"	,"Леонид"	,"Михаил"
	,"Николай"	,"Ольга"	,"Павел"	,"Роман"	,"Семен"	,"Татьяна"
	,"Ульяна"	,"Федор"	,"Харитон"	,"Цапля"	,"Чайка"	,"Шура"
	,"Щука"	,"Эхо"	,"Юрий"	,"Яков"
];
