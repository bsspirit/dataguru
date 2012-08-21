libname homework "D:\homework\SAS\2";
%let f1='d:/homework/SAS/2/ip_pv_log';
filename fil "(&f1)";
DATA homework.c2;
	infile fil;
	input month $ 4-7 day $ 8-10 time $ 10. +4 year  #2 ip #3 pv;
/*	date =cats(day, month , year, ":", time);*/
	date = input(cats(day, month , year, ":", time),datetime20.);
	format date datetime20.
run;
DATA homework.c22;	
	set homework.c2(drop=month year day time);
	put date ip pv;
run;
proc print data=homework.c22;
run;

