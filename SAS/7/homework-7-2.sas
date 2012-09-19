libname homework "D:\dataguru\SAS\7";

DATA q4;
INPUT x @@;
	x=x-72;

CARDS;
54 67 68 78 70 66 68 71 66 69
;
RUN;

PROC MEANS T PRT;
RUN;

/*假设中毒者与正常人没有显著差异*/
/*t=-2.29, p=0.048<0.05，则拒绝原假设，*/
