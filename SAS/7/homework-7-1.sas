libname homework "D:\dataguru\SAS\7";

DATA q3;
INPUT x1 x2 @@;
	d=x1-x2;

CARDS;
68 66 80 75 79 79 90 87 77 78 99 89
75 76 82 81 89 88 92 90 79 80 82 84
;
RUN;

PROC MEANS MEAN STD STDERR T PRT;
	VAR d;
RUN;

/*假设减肥前后没有明显变化*/
/*说明t=1.65, p=0.1263>0.05，不能拒绝原假设，因此没有显著差异*/


