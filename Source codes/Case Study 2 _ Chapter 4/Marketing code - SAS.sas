libname lib1 " /home/subhashini1/my_content "; run;
PROC CONTENTS data = lib1._ALL_ NODS;run;

/*Import the data */

FILENAME REFFILE "/home/subhashini1/my_content/MarketingData.csv" TERMSTR=CR;
RUN;
/* Comment – I have renamed the file to REFILE so that in the Proc Import step I do not have to put the full path.*/

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.MARKET1;
	GETNAMES=YES;
RUN;
/* Understand the dimensions of the dataset- Obs and Vars 
– and type of data in the temporary SAS file in the work directory */
PROC CONTENTS DATA=WORK.MARKET1; RUN;


/*Save the SAS dataset back to the Permanent Directory 
(next time we can load in this dataset instead of the csv dataset)*/



DATA LIB1.MARKET1;
SET WORK.MARKET1; RUN;

/*Check to confirm that the file has been saved*/

PROC CONTENTS data = lib1._ALL_ NODS;run;

/*Summary of Recurring Revenue */
PROC UNIVARIATE DATA=WORK.MARKET1 ;
VAR 'Monthly Reccuring Revenue in INR'n; RUN;

/* Remove Missing value in Monthly Reccuring Reveue */
DATA WORK.MARKET2;
SET WORK.MARKET1;
IF  'Monthly Reccuring Revenue in INR'n = . THEN DELETE; RUN;

/*Remove 0 in Monthly Reccuring Revenue*/
DATA WORK.MARKET2;
SET WORK.MARKET2; 
IF 'Monthly Reccuring Revenue in INR'n = 0 THEN DELETE; RUN;

/*frequency tables*/

PROC SORT DATA =  WORK.MARKET2;
BY CustomerType; RUN;

PROC FREQ DATA=WORK.MARKET2;
 TABLES CustomerType; RUN;

 PROC FREQ DATA=WORK.MARKET2;
 TABLES CustomerType*Vertical; RUN;

 PROC FREQ DATA=WORK.MARKET2;
TABLES Vertical*CustomerType/norow nocol nopercent; RUN;

DATA WORK.MARKET3;
SET WORK.MARKET2; 
IF VERTICAL = "Media & Entertainment" THEN NEWVAR=1;
ELSE IF VERTICAL = "Retail" THEN NEWVAR=2;
ELSE IF VERTICAL = "High Technology" THEN NEWVAR=3;
ELSE IF VERTICAL = "Business Services" THEN NEWVAR=4;
ELSE NEWVAR=0;
RUN;

PROC FREQ DATA=WORK.MARKET3; 
TABLES NEWVAR ; RUN;
/* Create some tables and graphs to understand the data with
respect to the continuous variable of Recurring Monthly Revenue */
PROC MEANS DATA=WORK.MARKET3;
VAR 'Monthly Reccuring Revenue in INR'n; RUN;

/*Create a new variable to represent Monthly
Recurring Revenue /1000 (in thousands)*/

DATA WORK.MARKET3;
SET WORK.MARKET3;
MRR_THOU= 'Monthly Reccuring Revenue in INR'n/1000; RUN;

PROC MEANS DATA=WORK.MARKET3;
VAR MRR_THOU; RUN;

/* Plots to explore sum of the new variable 
MRR_THOU  over the other variables */

PROC MEANS DATA=WORK.MARKET3;
CLASS CustomerType;
VAR MRR_THOU;RUN;


PROC FREQ DATA=WORK.MARKET3;
TABLES CustomerType /NOROW NOCOL;RUN;


PROC MEANS DATA=WORK.MARKET3 N MEAN SUM;
CLASS CustomerType Quarter ;
VAR MRR_THOU;RUN;

