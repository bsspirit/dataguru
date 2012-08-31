libname homework "D:\dataguru\SAS\5";
DATA homework.ch2;
	retain _seed_ 0;
	mu=5;
	sigma=2;
	a=0;
	b=10;
	do _i_ =1 to 1000;
	x1 = mu+sigma*rannor(_seed_);
	x2 = a+(b-a)*ranuni(_seed_);
	x3 = mean(of x1,x2);
	x4 = max(of x1,x2);
	output;
	end;
	drop _seed_ _i_ mu sigma a b;
RUN;
PROC print data = homework.ch2;
RUN;
PROC MEANS DATA=homework.ch2 MAXDEC=3 N MEAN STD CV SKEWNESS;
	VAR x1 x2;
RUN;



	
