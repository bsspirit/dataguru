

libname homework "D:\dataguru\SAS\4";
DATA homework.c1;
	INFORMAT create_date datetime20.;
	INPUT create_date uid @@;
	CARDS;
	   08JUN2012:21:11:13  1999321817   
	   08JUN2012:21:11:18  11250817   
	   08JUN2012:21:15:14  3299250817   
	   08JUN2012:21:50:48  259250817
	;
RUN;

PROC FORMAT ;
	picture dt low-high='%YƒÍ%0m‘¬%0d»’ %0H:%0M:%0S'(datatype=datetime);
RUN;

PROC PRINT DATA=homework.c1(KEEP=create_date);
	FORMAT create_date dt.;
RUN;

