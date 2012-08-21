DATA IP_PV_LOG;
INFILE 'd:/homework/SAS/2/ip_pv_log';
INPUT A $ B $ C D $ E $ F G H ;
      TIME = input(COMPRESS(C||B||F||':'||D),datetime20.);
	  FORMAT TIME DATETIME20.;
RUN;
PROC PRINT;
RUN; 
