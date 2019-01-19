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
 *  Change diary topic style
 */
tSF_MissionDefaults_RestyleDiary = true;

/* 
 *	Settings to change diary topic style
 *	In format: [ @Diary Subject name, @Color(RGBA array or []), 2@LeftPicture or "" ]
 */
#define C_DEFAULT []
#define C_DARK [0,0,0,0.2]
#define P_MMO "dzn_tSFramework\Icons\mmo.jpg"
#define P_GSO "dzn_tSFramework\Icons\gso.jpg"
#define P_TS "dzn_tSFramework\Icons\ts.jpg"

tSF_MissionDefaults_DiaryTopicsStyle = [
	["log", C_DARK, ""]
	,["CBA_docs", C_DARK, ""]
	,["radio", C_DARK, ""]
	,["Diary", C_DEFAULT, P_TS]
	,["tSF_Notespage", C_DEFAULT, P_TS]
	,["tSF_NotesSettingsPage", C_DEFAULT, P_TS]
	,["tSF_POM", C_DEFAULT, P_TS]
	,["tSF_AdminTools", C_DEFAULT, P_GSO]
	,["tSF_Diagpage", C_DEFAULT, P_GSO]
	,["tSF Instant Messenger", C_DEFAULT, P_TS]
];

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

