/*
 *	Configuration of Conversation Actions:
 *		[ @ConversationName (STRING), @UnitToApply (OBJECT), @ConversationEvent1 (ARRAY), ... , @ConversationEventN (ARRAY)  ]
 *		0: @ConversationName	- (string) name of the conversation
 *		1: @UnitToApply		- (object or array of objects) unit/s to attach conversation action. Unit name is used in dialog screen, to specify the name you can use "tSF_Conversation_Title" unit variable (e.g. Policeman instead of John Doe)
 *		2: @ConversationEvent	- (array) see @ConversationEvent
 *
 *	@ConversationEvent (ARRAY):	
 *		[ @ID, @TextLines, @Answers ]
 *		0: @ID			- (number) ID of conversation event
 *		1: @TextLines		- (array of string or code) text lines of event. Code can be used to compile STRING as output (in that case last element of @TextLines array will be used as argument for code, refered by _this).
 *		2: @Answers		- (array) of @Answer ( [@Answer1, @Answer2, ... , @AnswerN ] )
 *
 *	@Answer (ARRAY):
 *		[ @Label, @CodeToExecute, @Argument, @GoTo ]
 *		0: @Label or [@Code, @Argument]	- (string) text of the answer button or [(code), (any)] code that returns string (argument is available as _this in code)
 *		1: @CodeToExecute	- (code) code to execute on answer selection. Will be spawned after closeDialog 2 command. Variable _this contains [ 0@Object, 1@ConversationName, 2@GoToID, 3@EventID ]
 *		2: @Argument		- (any) argument to use in @CodeToExecute as _this select 4
 *		3: @GoToID		- (number) ID to next @ConversationEvent. -1 to close dialog without transition.
 *
 */
#define	CONVERSATION_TABLE		tSF_Conversations_List = [
#define	CONVERSATION_TABLE_END	];

CONVERSATION_TABLE
	/*
	[
		"John Doe Conversation 1"
		, johnDoe
		, [
			0
			, ["Hello", "What are you looking for?"]
			, [
				[
					"Where are the insurgents?"
					, { hint format ["From 0 to %1", _this select 4]; }
					, "Argument"
					, 1
				]
				, [
					"Sorry, I must go"
					, { hint "Ended"; }
					, "Argument"
					, -1
				]
			]
		]
		, [
			1, ["No, I dont know"], [ ["Sorry for boring you", { hint 'END of evenet 2' }, "Argument", -1] ]
		]
	]
	
	, [
		"John Doe Conversation 2"
		, nil
		, [0, [{format ["Formatted speech %1", _this]}, "Argument2"], [["Goodbye", {}, nil, -1]]]
	]
	
	, [
		"Commoner Conversation"
		, [man1,man2,man3]
		, [0, [{format ["Formatted speech %1", _this]}, "Argument"]
			, [
				[ 
					[ { format ["Goodbye, %1", selectRandom _this] }, ["Sweetie", "Retard"] ]
					, {}
					, nil
					, -1
				]
			]
		]
	]
	*/
CONVERSATION_TABLE_END



