
#define Q(X) #X

#define DOUBLES(X1,X2) X1##_##X2
#define TRIPLES(X1,X2,X3) X1##_##X2##_##X3

#define GVAR(NAME) TRIPLES(tSF,thisMODULE,NAME)
#define QGVAR(NAME) Q(GVAR(NAME))
