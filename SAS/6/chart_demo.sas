DATA auto ;
  INPUT make $  mpg rep78 weight foreign ;
CARDS;
AMC     22 3 2930 0
AMC     17 3 3350 0
AMC     22 . 2640 0
Audi    17 5 2830 1
Audi    23 3 2070 1
BMW     25 4 2650 1
Buick   20 3 3250 0
Buick   15 4 4080 0
Buick   18 3 3670 0
Buick   26 . 2230 0
Buick   20 3 3280 0
Buick   16 3 3880 0
Buick   19 3 3400 0
Cad.    14 3 4330 0
Cad.    14 2 3900 0
Cad.    21 3 4290 0
Chev.   29 3 2110 0
Chev.   16 4 3690 0
Chev.   22 3 3180 0
Chev.   22 2 3220 0
Chev.   24 2 2750 0
Chev.   19 3 3430 0
Datsun  23 4 2370 1
Datsun  35 5 2020 1
Datsun  24 4 2280 1
Datsun  21 4 2750 1
;
RUN; 

PROC PRINT;
RUN;

TITLE 'Simple Vertical Bar Chart ';
PROC GCHART DATA=auto;
      BLOCK weight;
RUN; 
