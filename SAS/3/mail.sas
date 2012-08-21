libname homework "D:\homework\SAS\3";
%let f1='d:/homework/SAS/3/maillog.txt';
filename fil "(&f1)";


DATA homework.start;
	length email $ 40.;
	key = 'starting';
	addr = 'remote';
    
	infile fil LRECL=32767 MISSOVER;
	input +26 a $ b $ c $ d $ e $ f $ i $ email &;
	id = COMPRESS(c,':');

	DROP a b c d e f i key addr;

	IF a EQ key and i EQ addr THEN DO;	
		OUTPUT;
	END;
	
RUN;
PROC PRINT DATA=homework.start;
RUN;

DATA homework.end;
	key = 'delivery';
	length reason $256;

	infile fil LRECL=32767 MISSOVER;
	input +26 a $ b $ c $ reason &;
	id = COMPRESS(b,':');
	status = COMPRESS(c,':');

	DROP a b c key;

	IF a EQ key THEN DO;
		OUTPUT;
	END;
RUN;
PROC PRINT DATA=homework.end;
RUN;

PROC SORT DATA=homework.start;
	BY id;
PROC SORT DATA=homework.end;
	BY id;
DATA homework.result;
	MERGE homework.start homework.end;
	BY id;

	IF status EQ 'success' THEN DO;
		reason = '';
	END;
	IF email NE '' THEN DO;
		OUTPUT;
	END;

	DROP id;

PROC PRINT DATA=homework.result;
RUN;
