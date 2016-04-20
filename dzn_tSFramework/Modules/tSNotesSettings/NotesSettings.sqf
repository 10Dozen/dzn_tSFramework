// ********** Topics ****************
#define NOTES		private["_topics"]; _topics = []; player createDiarySubject ["tSF_NotesSettingsPage",tSF_noteSettings_displayName];
#define TOPIC(Y, NAME) 	if (Y) then { _topics pushBack ["tSF_NotesSettingsPage", [ NAME,
#define END			]]; };
#define ADD_TOPICS	for "_i" from (count _topics) to 0 step -1 do {player createDiaryRecord (_topics select _i);};

NOTES	


TOPIC(tSF_noteSettings_enableViewDistance, "Настройки")
"<font color='#12C4FF' size='14'>Настройки видимости</font>
<br /><font color='#A0DB65'><execute expression='[] call dzn_fnc_addViewDistance;'>+ View Distance</execute></font>
<br /><font color='#A0DB65'><execute expression='[] call dzn_fnc_reduceViewDistance;'>- View Distance</execute></font>
"
END

TOPIC(tSF_noteSettings_enableThinLineMarkers, "CQB Линии")
"<font color='#12C4FF' size='14'>Настройки толщины маркеров</font>
<br /><font color='#A0DB65'><execute expression='[] call dzn_fnc_tsf_toggleThinLineMarkers;'>Включить/выключить тонкие маркеры</execute></font>

<br /><font color='#A0DB65'><execute expression='0.1 call dzn_fnc_tsf_changeThinLineMarkersSize;'>+0.1 Толщина</execute></font>
<br /><font color='#A0DB65'><execute expression='(-0.1) call dzn_fnc_tsf_changeThinLineMarkersSize;'>-0.1 Толщина</execute></font>
"
END


ADD_TOPICS
