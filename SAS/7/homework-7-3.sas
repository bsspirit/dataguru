libname homework "D:\dataguru\SAS\7";

DATA q3;
INPUT x @@;
	IF _N_>10 THEN a=2;
	ELSE a=1;
CARDS;
56 55 54 53 56 52 57 54 52 56
50 48 49 49 50 50 60 55 43 52 56 57
;
RUN;

PROC TTEST;
	CLASS a;
	VAR x;
RUN;
