/* IMPORT DATA*/
PROC IMPORT DATAFILE='/saswork/SAS_work7F170001C26A_odaws01-prod-sg/#LN00010'
DBMS=CSV
OUT=WORK.BOP;
GETNAMES=YES; RUN ; 

/* CHECK THE DIMENSIONS OF DATA*/
PROC CONTENTS DATA=WORK.BOP; RUN ; 

/* Conclusion:- all are numeric*/
/* CHECK DESCRIPTIVE STATS*/

PROC MEANS DATA=WORK.BOP; RUN ; 

/* Conclusion :- No null or na values */
/* explore outliers*/

PROC UNIVARIATE DATA=WORK.BOP; 
VAR Total_Exports Total_Imports total_BOP;
RUN ; 

/* limits for outliers
Lower limit = Q1 -(1.5*(Q3-Q1))
Upper limit = Q3 + (1.5*(Q3-Q1))*/

DATA WORK.BOP3; 
SET WORK.BOP ; 
WHERE Total_Exports  BETWEEN 2373485  AND -1254379 
AND  Total_Imports BETWEEN 3399729.5 AND -1872218.5; RUN ; 

PROC CONTENTS DATA=WORK.BOP3; RUN ; 


/* A - CORRELAATION */

PROC CORR DATA=WORK.BOP3; 
VAR Total_Exports Total_Imports; run ; 
