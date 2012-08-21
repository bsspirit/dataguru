libname comp "D:\homework\compete";
%let f1='D:\homework\compete\segment.txt';
filename fil "(&f1)";


DATA comp.c1;
	infile fil ;
	INPUT a  b ;
RUN;

PROC SORT DATA=comp.c1;
	BY a;

DATA comp.c2;
	set comp.c1;
	RETAIN x 0 y 0 z _n_;

RUN;


PROC PRINT DATA=comp.c2;
RUN;
