PROC IMPORT DATAFILE='/home/subhashini1/my_content/Sales.csv'
	DBMS=CSV
	OUT=WORK.SALES;
RUN;

/* EXPLORE THE DATA */

PROC CONTENTS DATA=WORK.SALES; RUN ; 

/* C & O - GET THE RETURNS DATA TOGETHER WITH THE SALES DATA*/
PROC IMPORT DATAFILE='/home/subhashini1/my_content/Sales_returns.csv'
	DBMS=CSV
	OUT=WORK.RETURNS;
RUN;

PROC CONTENTS DATA=WORK.RETURNS; RUN ; 

/* SORT THE DATASETS ON PRIMARY KEY */

PROC SORT DATA=WORK.SALES;
BY "Order ID"N; RUN ; 
PROC SORT DATA=WORK.RETURNS; 
BY "Order ID"N; RUN ; 

DATA WORK.TOTAL;
MERGE WORK.SALES WORK.RETURNS;
BY "Order ID"N; RUN ;
PROC PRINT DATA=WORK.TOTAL (OBS=10) ; RUN ; 


/* V - RUN FREQ TABLE TO UNDERSTAND DATA SPLIT IN 'STATUS' BETWEEN 
RETURN AND NOTRETURN*/

PROC FREQ DATA=WORK.TOTAL ; 
TABLES STATUS ; RUN ; 

DATA WORK.TOTAL;
SET WORK.TOTAL ; 
LENGTH STATUS2 $15;  
IF STATUS = 'Returned' THEN STATUS2= 'RETURNED';
ELSE STATUS2 = 'NOTRETURNED'; RUN ; 


PROC FREQ DATA=WORK.TOTAL ; 
TABLES STATUS2 ; RUN ; 

/* RUN PIE CHART USING BUTTONS IN TASK OPTION */
/* RUN PIE CHART USING CODE*/

 /* Set the graphics environment */
goptions reset=all cback=white border htitle=12pt htext=10pt;  

title1 "RETURNS IN SALES";

proc gchart data=work.total;
   pie Status2 / other=0
              midpoints="RETURNED" "NOTRETURNED" 
              value=none
              percent=arrow
              slice=arrow
              noheading 
              plabel=(font='Albany AMT/bold' h=1.3 color=depk);
run;
quit; 

/* CHECK BY VALUE OF SALES*/


/* Set the graphics environment */
goptions reset=all cback=white border htitle=12pt htext=10pt;  

title1 "RETURNS IN SALES";

proc gchart data=work.total;
   pie Status2 / SUMVAR=SALES
              midpoints="RETURNED" "NOTRETURNED" 
              value=none
              percent=arrow
              slice=arrow
              noheading 
              plabel=(font='Albany AMT/bold' h=1.3 color=depk);
run;
quit; 


/*A - CORRELATION */

DATA WORK.TOTAL ;
SET WORK.TOTAL ; 
IF STATUS2 = 'RETURNED' THEN STATUS3 = 1;
ELSE STATUS3 = 0 ; RUN ; 


PROC CORR DATA=WORK.TOTAL; 
VAR SALES STATUS3; RUN ; 

PROC FREQ DATA=WORK.TOTAL; 
TABLES STATUS3; RUN ; 