//     tSF Briefing
// Do not modify this part
#define BRIEFING		_briefing = [];
#define TOPIC(NAME) 	_briefing pushBack ["Diary", [ NAME,
#define END			]];
#define ADD_TOPICS	for "_i" from (count _briefing) to 0 step -1 do {player createDiaryRecord (_briefing select _i);};
//
//
// Briefing goes here

BRIEFING

TOPIC("I. Обстановка:")
"Описание ситуации"
END

TOPIC("А. Враждебные силы:")
"Описание вражеских сил"
END

TOPIC("Б. Дружественные силы:")
"Описание дружественных сил"
END

TOPIC("II. Задание:")
"Описание задач"
END

TOPIC("III. Выполнение:")
"Описание указаний по выполнению"
END

TOPIC("IV. Поддержка:")
"Доступная поддержка"
END

TOPIC("V. Сигналы:")
"Сигналы и радива"
END

TOPIC("VI. Замечания:")
"Прочие замечания"
END

ADD_TOPICS
