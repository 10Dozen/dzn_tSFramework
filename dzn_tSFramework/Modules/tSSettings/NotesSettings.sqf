// ********** Topics ****************
#define NOTES		private["_topics"]; _topics = []; player createDiarySubject ["tSF_NotesSettingsPage",tSF_noteSettings_displayName];
#define TOPIC(Y, NAME) 	if (Y) then { _topics pushBack ["tSF_NotesSettingsPage", [ NAME,
#define END			]]; };
#define ADD_TOPICS	for "_i" from (count _topics) to 0 step -1 do {player createDiaryRecord (_topics select _i);};

NOTES

TOPIC(tSF_noteSettings_enableViewDistance , "Дальность видимости")
"<font color='#12C4FF' size='14'>Настройки видимости</font>
<br /><font color='#A0DB65'><execute expression='[1000, 750] spawn dzn_fnc_addViewDistance;'>+ Дальность видимости</execute></font>
<br /><font color='#A0DB65'><execute expression='[1000, 750] spawn dzn_fnc_reduceViewDistance;'>- Дальность видимости</execute></font>
<br />
<br /><font color='#A0DB65'><execute expression='[] call tSF_fnc_noteSettings_saveViewDistance;'>Сохранить настройки</execute></font>
<br />
<br /><font color='#12C4FF' size='14'>Быстрая настройка:</font>
<br /><font color='#A0DB65'><execute expression='[1500,750] spawn tSF_fnc_noteSettings_setViewDistance;'>Близко (1500/750)</execute></font>
<br /><font color='#A0DB65'><execute expression='[3000,2000] spawn tSF_fnc_noteSettings_setViewDistance;'>Обычно (3000/2000)</execute></font>
<br /><font color='#A0DB65'><execute expression='[5000,3000] spawn tSF_fnc_noteSettings_setViewDistance;'>Средне (5000/3000)</execute></font>
<br /><font color='#A0DB65'><execute expression='[10000,7500] spawn tSF_fnc_noteSettings_setViewDistance;'>Далеко (10000/7500)</execute></font>
<br /><font color='#A0DB65'><execute expression='[20000,12500] spawn tSF_fnc_noteSettings_setViewDistance;'>Очень далеко (20000/12500)</execute></font>
"
END

TOPIC(tSF_noteSettings_enableTerrainGrid, "Детализация ландшафта")
"<font color='#12C4FF' size='14'>Настройки детализации ландшафта</font>
<br /><font color='#A0DB65'><execute expression='""Default"" spawn tSF_fnc_noteSettings_setTerrainGrid;'>По-умолчанию</execute></font>
<br />
<br /><font color='#A0DB65'><execute expression='""Very High"" spawn tSF_fnc_noteSettings_setTerrainGrid;'>Очень высоко</execute></font>
<br /><font color='#A0DB65'><execute expression='""High"" spawn tSF_fnc_noteSettings_setTerrainGrid;'>Высоко</execute></font>
<br /><font color='#A0DB65'><execute expression='""Normal"" spawn tSF_fnc_noteSettings_setTerrainGrid;'>Нормально</execute></font>
<br /><font color='#A0DB65'><execute expression='""No grass"" spawn tSF_fnc_noteSettings_setTerrainGrid;'>Очень низко</execute></font>
"
END

ADD_TOPICS