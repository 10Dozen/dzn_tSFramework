
#define COMPONENT_VARNAME tSF_##thisMODULE##_Component

#define COB COMPONENT_VARNAME
#define ECOB(MODULENAME) TRIPLES(tSF,MODULENAME,Component)
#define QCOB Q(COB)
#define QECOB(MODULENAME) Q(ECOB(MODULENAME))

#define COMPONENT_IFACE tSF_IComponent
#define COMPONENT_STATUS_VARNAME Q(Status)
#define COMPONENT_SET_STATUS(STATUS) COB call ["#setStatus", STATUS]

#define COMPONENT_STATUS_DISABLED Q(Disabled)
#define COMPONENT_STATUS_STARTING Q(Starting)
#define COMPONENT_STATUS_FAILED Q(Failed)
#define COMPONENT_STATUS_OK Q(OK)

// -- Settings
#define COMPONENT_SETTINGS (COB get Q(Settings))
#define ECOMPONENT_SETTINGS(SRC) (ECOB(SRC) get Q(Settings))

#define SETTING(SRC,NODE1) (SRC get Q(Settings) get Q(NODE1))
#define SETTING_2(SRC,NODE1,NODE2) (SRC get Q(Settings) get Q(NODE1) get Q(NODE2))
#define SETTING_3(SRC,NODE1,NODE2,NODE3) (SRC get Q(Settings) get Q(NODE1) get Q(NODE2) get Q(NODE3))

#define SETTING_OR_DEFAULT(SRC,NODE1,DEFAULT) (SRC get Q(Settings) getOrDefault [Q(NODE1), DEFAULT])
#define SETTING_OR_DEFAULT_2(SRC,NODE1,NODE2,DEFAULT) (SRC get Q(Settings) get Q(NODE1) getOrDefault [Q(NODE2), DEFAULT])
#define SETTING_OR_DEFAULT_3(SRC,NODE1,NODE2,NODE3,DEFAULT) (SRC get Q(Settings) get Q(NODE1) get Q(NODE2) getOrDefault [Q(NODE3), DEFAULT])

// -- Component functions
#define F(NAME) 'fnc_##NAME'
#define PREP_COMPONENT_FUNCTION(NAME) \
    [F(NAME), compileScript [PATH(thisMODULE,DOUBLES(fnc,NAME),sqf)]]

// -- Availability
#define TSF_COMPONENT(MODULE) (ECOB(Core) call [F(getComponent), Q(MODULE)])
#define TSF_COMPONENT_ACTIVE(MODULE) ((ECOB(Core) call [F(getComponentState), Q(MODULE)]) != COMPONENT_STATUS_DISABLED)
