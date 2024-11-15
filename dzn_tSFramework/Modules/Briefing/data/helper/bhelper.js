var locale = 0; // 0 - EN, 1 - RU
var code = "";

var defaultTags = {
    "SPECOPS": {        hint: "Спецоперация спецоператоров"},
    "INFANTRY": {       hint: "Легкая пехота (контр инсургенси, патрули, оборона)" },
    "MOUT": {           hint: "Преимущественно городские бои" },
    "COMB.ARMS": {      hint: "Общевойсковая операция - масштабные маневры с применением всех средств боя" },
    "ARMOR": {          hint: "Есть тяжелая техника (БМП, танки)" },
    "AIRBORNE": {       hint: "Есть транспортная авиация (вертолеты)" },
    "ARTILLERY": {      hint: "Есть поддержка артиллерии (минометы и круче)" },
    "JTAC/CAS": {       hint: "Есть CAS/нужен JTAC" },
    "RolePlay":  {      hint: "Есть ролевой элемент" },
    "WEST GEAR": {      hint: "Снаряжение западного блока (NATO и т.п.)" },
    "EAST GEAR": {      hint: "Снаряжение восточного блока (ОВД, РФ)" },
    "EXOTIC GEAR": {    hint: "Специфическое снаряжение (60-е, 70-е)" },
    "1950" : {          hint: "Время действия: 1950-ые" },
    "1960" : {          hint: "Время действия: 1960-ые" },
    "1970" : {          hint: "Время действия: 1970-ые" },
    "1980" : {          hint: "Время действия: 1980-ые" },
    "1990" : {          hint: "Время действия: 1990-ые" },
    "2000" : {          hint: "Время действия: 2000-ые" },
    "2010" : {          hint: "Время действия: 2010-ые" },
    "2020" : {          hint: "Время действия: 2020-ые" },
    "2030" : {          hint: "Время действия: 2030-ые" }
};

var defaultTopics = [
    ["I. Situation:", "I. Обстановка:", "### Краткое общее описание происходящего - когда, где, кто и почему участвует в миссии. Общие мотивы сторон. Т.к. мы играем каждый раз в разных временных периодах, за разные стороны, то обстановка должна давать понять кто мы, что происходит и как мы до такого дошли."]
    ,["A. Enemy Forces:", "А. Враждебные силы:", "### Краткое описание известных сил противника (состав и количество), например:\n\n1 взвод легкой пехоты.\n\nТакже указывать известную или предпологаемую поддержку противника (бронетехника, минометы, гранатометы), описывать известные и ожидаемые места дислокации."]
    ,["B. Friendly Forces:", "Б. Дружественные силы:", "### Краткое описание сил игроков - 2 отделения Армии США: 1'1, 1'2. Детальное описание приветствуется. Например:\n\n1ый взвод 3ей роты 435ой парашютно-десантной дивизии тяжелых плуеметов:\n\n1`1 - отделение десантников (9 чел.),\n1`4 - отделение поддержки (7 чел., 2 пулемета, 1 ПТРК)"]
    ,["II. Mission:", "II. Задание:", "1. \n2. \n3. \n### Основные и дополнительные задачи которые должны быть выполнены в ходе миссии. Опциональные задачи должны быть указаны как “(опционально) Не уйти в запой”.\n\nНе забывайте - задачи это 1 возрождение для мертвых игроков - чем больше миссий, тем больше в ней должно быть задач!"]
    ,["III. Execution:", "III. Выполнение:", "### Описание основного предполагаемого плана выполнения (как задумано штабом и мишн мейкером)! Любые замечания по выполнению (план на уровне роты, предварительный план, правила обращения с гражданскими и т.п.), рекомендации по порядку выполнения задач, указание на фичи миссии (например, как отличить информатора от простого бандита). И только если совсем нечего сказать - “По плану командира”"]
    ,["IV. Service Support:", "IV. Поддержка:", "1x Название_техники\n3x Название_техники\n\nCCP\nFARP\n\nРезерв (редеплой) - 1 на отряд\n\n### Описать доступные средства поддержки - транспорт (в формате - 1х автомобиль УАЗ (невооруженный), 2х бронеавтомобиль “Тигр” (вооруженный, АГС и ПКМ)”), артиллерия/авиация (с указанием позывных, если используется модуль из tSF), дополнительные боеприпасы/статики (указать где находятся), наличие CCP и FARP. Доступность и размер резервов для доукомплектации/развертывания."]
    ,["V. Command & Signal:", "V. Сигналы:", "PL NET 50 Mhz\nSUP NET 51 Mhz\n\n1'1 - SR CH 1\n1'2 - SR CH 2\n1'3 - SR CH 3"]
    ,["VI. Mission notes:", "VI. Замечания:", "### Дополнительные замечания, которые могут пригодится для понимания того как миссию выполнить правильно (например, краткая информация об использовании парашютов), какие-то дополнительные сведения об экипировке (например, кто несет заряды взрывчатки)"]
    ,["VII. GSO notes:", "VII. Замечания для GSO:", "### Информация которую увидит только ГСО. Указать какой тактики будет придерживаться враг, какие резервы он имеет и прочие советы по курированию миссии."]
];

var textAreaSettings = {
    "cols": 50
    ,"rows": 10
    ,"width": "800px"
}

function generateTagsCheckboxes() {
    let tagsArray = Object.entries(defaultTags);

    for (let i = 0; i < tagsArray.length; ++i) {
        const [ tagName, tagProps ] = tagsArray[i];
        const tagId = normalizeTagname(tagName);

        $("#tags > ul").append(
            "<li>" +
            `<input type='checkbox' id='${tagId}' value='${tagName}'/>` +
            `<label for='${tagId}'>${tagName} (${tagProps.hint})</label>` +
            "</li>"
        );
    }
};

function generateDefaultTopics() {
    for (var i = 0; i < defaultTopics.length; i++ ) {
        $( "#briefing-form > ul" ).append(
            "<li><div class='dl-1'>Topic</div>"
            + "<div class='dl-2'>"
            + "<input class='topicInput' topicId='" + i + "' value='" + defaultTopics[i][locale] + "' placeholder='" + defaultTopics[i][locale] + "'></input>"
            + "</div></li>"
            + "<li><div class='dl-3'>"
            + "<textarea class='topicData' cols='" + textAreaSettings.cols
            + "' rows='" + textAreaSettings.rows + "'>"
            + defaultTopics[i][2] + "</textarea>"
            + "</div></li><hr />"
        );
    };

    $( ".dl-3 > textarea" ).css( "width", textAreaSettings.width );
}

function changeTopicLocale() {
    $( ".topicInput" ).each( function() {
        var id = $( this ).attr("topicId");
        $( this ).attr({
            "value": defaultTopics[id][locale],
            "placeholder": defaultTopics[id][locale]
        });
    } );

};

function changeLocale() {
    var l = $( "#locale" ).attr( "locale" );
    var label = "";
    if (l == 0) { label = "RU"; l = 1; } else { label = "EN"; l = 0; };
    locale = l;
    $( "#locale" ).attr( "locale", l);
    $( "#locale" ).html( label );

    changeTopicLocale();
}

function escapeQuotes(str) {
    return ( str.replace(new RegExp('"','g'),'""') );
};

function normalizeTagname(str) {
    return str.replaceAll('/', '_')
};

function getCode() {
    const defineBlock = "//     tSF Briefing\n// Не изменяйте и не удаляйте эту часть"
        + "\n#define BRIEFING    _briefing = [];"
        + "\n#define TOPIC(NAME) _briefing pushBack [\"Diary\", [ NAME,"
        + "\n#define END         ]];"
        + "\n#define ADD_TOPICS  for \"_i\" from (count _briefing) to 0 step -1 do {player createDiaryRecord (_briefing select _i);};"
        + "\n#define TAGS        tSF_MissionTags = "
        + "\n//\n//\n// Mission tags";

    const tags = [];
    const tagsInputs = $("#tags input");
    for (let i = 0; i < tagsInputs.length; ++i) {
        if (!tagsInputs[i].checked) continue;
        const tagValue = tagsInputs[i].value;
        tags.push(`"${tagValue}"`);
    }
    const tagsBlock = `\nTAGS([${tags}]);`;
    const preBriefingBlock = "\n\n// Briefing goes here" + "\n\nBRIEFING\n";

    const briefing = [];
    const topicTitles = $(".topicInput");
    const topicContents =  $(".topicData");

    const topicCount = topicTitles.length;

    for (let i = 0; i < topicCount; ++i) {
        const title = escapeQuotes(topicTitles[i].value);
        const text = escapeQuotes(topicContents[i].value.replace(/(\r\n|\n|\r)/g,"\n<br />"));
        const content = [
            `TOPIC("${title}")`,
            `"${text}"`,
            'END',
            ''
        ];
        if (i == topicCount - 1) {
            content.unshift("if ((serverCommandAvailable '#logout') || !(isMultiplayer) || isServer) then {")
            content[content.length - 1] = "};\n"
        }
        briefing.push(content.join('\n'))
    }

    const endBlock = "\nADD_TOPICS"
    const code = (defineBlock + tagsBlock + preBriefingBlock + briefing.join('\n') + endBlock);
    return code;
};

function getCodeToDisplay() {
    var code = getCode();
    $( "#result-tab-data textarea" ).html(code);
    $( "#result-tab" ).css( "top", "15%" );

    /*
    code = code.replace(/<br \/>/g, "\n&lt;br /&gt;");
    code = code.replace(/</g, "&lt;");
    code = code.replace(/>/g, "&gt;");
    code = code.replace(/(\r\n|\n|\r)/g,"<br />");

    $( "#result-tab" ).css( "top", "15%" );
    */
}

function closeCodeDisplay() {
    $( "#result-tab" ).css( "top", "-3000px" );
};

function getCodeToFile() {
    var a = document.createElement('a');
    a.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(getCode()));
    a.setAttribute('download', "tSF_briefing.sqf" );
    a.click();
}

var openFile = function(event) {
    setTimeout( readFile(event), 200 );
}

function readFile(event) {
    var input = event.target;
    var reader = new FileReader();
    reader.onload = function(){
        text = reader.result;
        if (text.length > 0) {
            console.log( "Read!");
            importBriefing(text);
        } else {
            console.log( "Empty!" );
        }
    };
    reader.readAsText(input.files[0]);
};

function importBriefing(sqfText) {
    console.log("Importing Briefing");

    console.log("#     Parsing SQF");
    let parsedTopics = parseBriefing(sqfText);
    console.log("#     SQF parsed");

    console.log("#     Populating topics");
    for (let i = 0; i < parsedTopics.length; i++) {
        populateTopic(i*2, parsedTopics[i][0], parsedTopics[i][1]);
    }
    console.log("#     Topics populated");

    console.log("#     Parsing tags");
    let parsedTags = parseTags(sqfText);
    console.log("#     Tags parsed");
    console.log(parsedTags)

    console.log("#     Populating tags");
    populateTags(parsedTags);
    console.log("#     Tags populated");

    console.log("#     All done!");
}

function parseBriefing(rawBriefing) {
    var rawLines = rawBriefing.split("\n");

    var tempAllTopics = [];
    var tempTopic = [];
    var isSameTopic = false;
    for (var i = 0; i < rawLines.length; i++) {
        var rawLine = rawLines[i];

        if (!(rawLine.match(/END/g) === null)) {
            isSameTopic = false;

            var parsedTopic = [tempTopic[0]];
            var topicText = "";
            for (var j = 1; j < tempTopic.length; j++) {
                topicText = topicText + tempTopic[j];
            };

            topicText = topicText.substr(1);
            topicText = topicText.slice(0, -1);
            topicText = topicText.replace(/(<br \/>|<br\/)/g,"\n");

            parsedTopic.push(topicText);

            tempAllTopics.push(parsedTopic);
        };

        if (isSameTopic) {
            tempTopic.push(rawLine);
        };

        if (
            !( rawLine.match(/TOPIC\("(.*)"\)/g) === null )
             && rawLine.match(/TOPIC\(NAME\)/g) === null
        ) {
            tempTopic = [];
            isSameTopic = true;

            tempTopic.push( (rawLine.match(/TOPIC\("(.*)"\)/))[1] );
        };
    };

    tempAllTopics.shift(0);
    /*
        Make splited lines all together
    */
    return tempAllTopics
}

function parseTags(rawBriefing) {
    let rawLines = rawBriefing.split("\n");
    let tags = [];
    for (let i = 0; i < rawLines.length; i++) {
        let rawLine = rawLines[i];

        if (!(rawLine.match(/TAGS\(\[(.*)\]\)/g) === null)) {
            let tagsString = rawLine.match(/TAGS\(\[(.*)\]\)/)[1];
            tags = tagsString.replace(/"/g,"").split(",");
            break;
        };
    };
    return tags;
};

function populateTopic(id,title,text) {
    let topics = $('#briefing-form > ul > li');

    let topicTitle = $( topics[id] ).find('.topicInput')[0];
    let topicBody = $( topics[id + 1] ).find('.topicData')[0]

    topicTitle.value = title;
    topicBody.value = text;
}

function populateTags(tags) {
    $(`#tags input`).prop('checked', false);
    for (let j = 0; j < tags.length; ++j) {
        const tagId = normalizeTagname(tags[j]);
        $(`#tags input#${tagId}`).prop('checked',true);
    }
};

// --- Init
$( document ).ready(function() {
    changeLocale();
    generateDefaultTopics();
    generateTagsCheckboxes();
    populateTags(["INFANTRY"]);
});
