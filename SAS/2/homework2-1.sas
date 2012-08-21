libname homework "D:\homework\SAS\2";
PROC IMPORT OUT = homework.c21
DATAFILE= "D:\homework\SAS\2\demo.xls"
DBMS=EXCEL REPLACE;
SHEET="cdb_threads";
GETNAMES=YES;
options nodate;
proc print;
RUN;
