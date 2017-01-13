/* IMPORT DATA USING INFILE INFORMAT STATMENT */
/* THIS CODE WILL GET AUTO GENERATED IF YOU USE THE IMPORT DATA BUTTON 
UNDER THE FILE TAB ON TOP LEFT CORNER OF SCREEN*/
DATA WORK.CONTRACTS;
    LENGTH
        Effective_Date   $ 11
        Contract_Reference_Number $ 8
        Title_of_agreement $ 94
        Service_responsible $ 49
        Description_of_goods_and_service $ 94
        Contract_Start_Date   8
        End_Date         $ 10
        Review_Date      $ 10
        Extension_Period   8
        Contract_Value     8
        SupplierName     $ 40
        NominatedContactPoint $ 37
        ;
    LABEL
        Effective_Date   = "Effective Date"
        Contract_Reference_Number = "Contract Reference Number"
        Title_of_agreement = "Title of agreement"
        Service_responsible = "Service responsible"
        Description_of_goods_and_service = "Description of goods and services"
        Contract_Start_Date = "Contract Start Date"
        End_Date         = "End Date"
        Review_Date      = "Review Date"
        Extension_Period = "Extension Period"
        Contract_Value   = "Contract Value" ;
    FORMAT
        Effective_Date   $CHAR11.
        Contract_Reference_Number $CHAR8.
        Title_of_agreement $CHAR94.
        Service_responsible $CHAR49.
        Description_of_goods_and_service $CHAR94.
        Contract_Start_Date MMDDYY10.
        End_Date         $CHAR10.
        Review_Date      $CHAR10.
        Extension_Period BEST2.
        Contract_Value   BEST11.
        SupplierName     $CHAR40.
        NominatedContactPoint $CHAR37.
      ;
    INFORMAT
        Effective_Date   $CHAR11.
        Contract_Reference_Number $CHAR8.
        Title_of_agreement $CHAR94.
        Service_responsible $CHAR49.
        Description_of_goods_and_service $CHAR94.
        Contract_Start_Date MMDDYY10.
        End_Date         $CHAR10.
        Review_Date      $CHAR10.
        Extension_Period BEST2.
        Contract_Value   BEST11.
        SupplierName     $CHAR40.
        NominatedContactPoint $CHAR37.
        ;
    INFILE '/saswork/SAS_work6710000127DB_odaws02-prod-sg/#LN00030'
        LRECL=332
        ENCODING="UTF-8"
        TERMSTR=CRLF
        DLM='7F'x
        MISSOVER
        DSD ;
    INPUT
        Effective_Date   : $CHAR11.
        Contract_Reference_Number : $CHAR8.
        Title_of_agreement : $CHAR94.
        Service_responsible : $CHAR49.
        Description_of_goods_and_service : $CHAR94.
        Contract_Start_Date : ?? MMDDYY10.
        End_Date         : $CHAR10.
        Review_Date      : $CHAR10.
        Extension_Period : ?? BEST2.
        Contract_Value   : ?? COMMA11.
        SupplierName     : $CHAR40.
        NominatedContactPoint : $CHAR37.
        ;
RUN;

PROC PRINT DATA=WORK.CONTRACTS (OBS=10); RUN;
/*FILENAME REFFILE "/home/subhashini1/my_content/Contacts register Aug 2015 and purchase order over 5000 April to June 2015.csv" TERMSTR=CR;

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;*/


PROC CONTENTS DATA=WORK.CONTRACTS; RUN;

/* KEEP ONLY THOSE VARIABLES THAT ARE AVAILABLE IN THE 
DEFINITIONS GIVEN IN THE PROJECT*/

DATA WORK.CONTRACTS1 (KEEP=Contract_Reference_Number
Contract_Start_Date
Contract_Value
End_Date
Extension_Period
Review_Date
Service_responsible); 
SET WORK.CONTRACTS; RUN ; 

PROC PRINT DATA=WORK.CONTRACTS1 (FIRSTOBS=70 OBS=75); RUN ;

/* CREATE Y VARIABLES
TAT = END DATE - START DATE 
PERDAY = CONTACT AMOUNT / TAT

NOTE - END DATE IS CHARACTER (AS SEEN IN PROC CONTENTS)*/

DATA WORK.CONTRACTS1 ;
SET WORK.CONTRACTS1 ;
END_DATE1=INPUT(End_Date, MMDDYY10.);
FORMAT END_DATE1 MMDDYY10.; RUN;

PROC PRINT DATA=WORK.CONTRACTS1 (OBS=10); RUN;

PROC CONTENTS DATA=WORK.CONTRACTS1; RUN;

DATA WORK.CONTRACTS1; 
SET WORK.CONTRACTS1; 
TAT= END_DATE1-Contract_Start_Date; 
PERDAY = Contract_Value/TAT; RUN;


PROC PRINT DATA=WORK.CONTRACTS1 (OBS=10);
VAR TAT PERDAY; RUN; 

/* C - NO ACTIVITY REQUIRED
O - MISSING VALUES
CHECK MISSING VALUES FOR NUMERIC VARIABLES USING PROC MEANS 
CHECK MISSING VALUES FOR CHARACTER VARIABLES USING PROC FREQ

DROP VARIABLES - REVIEW DATE , End_Date, Extension_Period 
IS REDUCDANT FOR THIS PROJECT  */

PROC MEANS DATA=WORK.CONTRACTS1; RUN; 

PROC FREQ DATA=WORK.CONTRACTS1;
TABLES Service_responsible; RUN; 

DATA WORK.CONTRACTS1 (DROP= End_Date
Extension_Period
Review_Date);
SET WORK.CONTRACTS1; RUN; 
/* IN THE PROC FREQ OUTPUT WE CAN SEE THAT BECAUSE OF CASE DIFFERENCE 
SOME SEGMENTS ARE COMING TWICE EG :- COMMUNITY / Community;
CONVERT ALL THE DATA TO UPPER CASE TO STANDARDISE OUTPUT 

WE CAN ALSO SEE THAT SOME MINOR SPELLING DIFFERENCE IN CAUSING DIFFERENT 
SEGMENTS EG:- DEMOCRATIC LEGAL AND POLICY /Democratic Legal & Policy.
CREATE SAME SPELLING ACROSS */

DATA WORK.CONTRACTS1;
SET WORK.CONTRACTS1;
IF Service_responsible IN ('Democratic Legal & Policy') 
THEN Service_responsible= 'DEMOCRATIC LEGAL AND POLICY'; 
IF Service_responsible IN ('Human Resources ICT/CSC & Shared Support Services') 
THEN Service_responsible= 'HUMAN RESOURCES ICT & SHARED SUPPORT';
IF Service_responsible IN ('Planning & Sustainability') 
THEN Service_responsible= 'PLANNING';  
RUN;

DATA WORK.CONTRACTS1;
SET WORK.CONTRACTS1;
Service_responsible= UPCASE(Service_responsible); RUN;

PROC FREQ DATA=WORK.CONTRACTS1; 
TABLES Service_responsible; RUN;

/* WE SEE IN THE PROC MEANS OUTPUT - GENERATED ABOVE- THAT THE END
DATE OF THE PROJECT IS AVAILABLE ONLY FOR 83 CASES. SINCE BOTH THE 
Y VARIABLES NEED END DATE FOR CALCULATIONS, WE SHOULD REMOVE ALL THE 
OBSERVATIONS WHERE END DAT IS MISSING */


DATA WORK.CONTRACTS1;
SET WORK.CONTRACTS1; 
WHERE END_DATE1 NE .; RUN; 

PROC MEANS DATA=WORK.CONTRACTS1; RUN;



/* BAR GRAPH TO CHECK AVERAGE TAT ACROSS DIFFERENT SERVICE 
RESPONSIBLE SEGMENTS GENERATED BY SAS USING GRAPH WIZARD*/

%_eg_conditional_dropds(WORK.SORTTempTableSorted);
/* -------------------------------------------------------------------
   Sort data set SASApp:WORK.CONTRACTS1
   ------------------------------------------------------------------- */

PROC SQL;
	CREATE VIEW WORK.SORTTempTableSorted AS
		SELECT T.Service_responsible, T.TAT
	FROM WORK.CONTRACTS1 as T
;
QUIT;
Axis1
	STYLE=1
	WIDTH=1
	MINOR=NONE


;
Axis2
	STYLE=1
	WIDTH=1


;
TITLE;
TITLE1 "Bar Chart";
FOOTNOTE;
FOOTNOTE1 "Generated by the SAS System (&_SASSERVERNAME, &SYSSCPL) on %TRIM(%QSYSFUNC(DATE(), NLDATE20.)) at %TRIM(%SYSFUNC(TIME(), TIMEAMPM12.))";
PROC GCHART DATA=WORK.SORTTempTableSorted
;
	VBAR 
	 Service_responsible
 /
	SUMVAR=TAT
	CLIPREF
FRAME	TYPE=MEAN
	COUTLINE=BLACK
	RAXIS=AXIS1
	MAXIS=AXIS2
;
/* -------------------------------------------------------------------
   End of task code
   ------------------------------------------------------------------- */
RUN; QUIT;
%_eg_conditional_dropds(WORK.SORTTempTableSorted);
TITLE; FOOTNOTE;

/* CREATE PIE CHART TO UNDERSTAND CONTRIBUTION OF EACH SEGMENT 
OF Service_responsible IN THE DATA*/

/* -------------------------------------------------------------------
   Code generated by SAS Task

   Generated on: Wednesday, November 11, 2015 at 9:50:21 AM
   By task: Pie Chart

   Input Data: SASApp:WORK.CONTRACTS1
   Server:  SASApp
   ------------------------------------------------------------------- */

%_eg_conditional_dropds(WORK.SORTTempTableSorted);
/* -------------------------------------------------------------------
   Sort data set SASApp:WORK.CONTRACTS1
   ------------------------------------------------------------------- */

PROC SQL;
	CREATE VIEW WORK.SORTTempTableSorted AS
		SELECT T.Service_responsible
	FROM WORK.CONTRACTS1 as T
;
QUIT;
TITLE;
TITLE1 "Pie Chart";
FOOTNOTE;
FOOTNOTE1 "Generated by the SAS System (&_SASSERVERNAME, &SYSSCPL) on %TRIM(%QSYSFUNC(DATE(), NLDATE20.)) at %TRIM(%SYSFUNC(TIME(), TIMEAMPM12.))";
PROC GCHART DATA =WORK.SORTTempTableSorted
;
	PIE	 Service_responsible /
 	TYPE=PCT
	NOLEGEND
	SLICE=OUTSIDE
	PERCENT=OUTSIDE
	VALUE=NONE
	OTHER=4
	OTHERLABEL="Other"
	COUTLINE=BLACK
NOHEADING
;
/* -------------------------------------------------------------------
   End of task code
   ------------------------------------------------------------------- */
RUN; QUIT;
%_eg_conditional_dropds(WORK.SORTTempTableSorted);
TITLE; FOOTNOTE;

/* DRAW A SCATTE PLOT TO SEE IF SOME CASES HAVE SIGNIFICANTLY HIGHER TAT
OR HIGHER RATE PER DAY VALUES*/

/* -------------------------------------------------------------------
   Code generated by SAS Task

   Generated on: Wednesday, November 11, 2015 at 9:59:42 AM
   By task: Scatter Plot (2)

   Input Data: SASApp:WORK.CONTRACTS1
   Server:  SASApp
   ------------------------------------------------------------------- */

%_eg_conditional_dropds(WORK.SORTTempTableSorted);
/* -------------------------------------------------------------------
   Sort data set WORK.CONTRACTS1
   ------------------------------------------------------------------- */
PROC SORT
	DATA=WORK.CONTRACTS1(KEEP=TAT Service_responsible)
	OUT=WORK.SORTTempTableSorted
	;
	BY Service_responsible;
RUN;
	SYMBOL1
	INTERPOL=NONE
	HEIGHT=10pt
	VALUE=CIRCLE
	LINE=1
	WIDTH=2

	CV = _STYLE_
;
Axis1
	STYLE=1
	WIDTH=1
	MINOR=NONE


;
Axis2
	STYLE=1
	WIDTH=1
	MINOR=NONE


;
TITLE;
TITLE1 "Scatter Plot";
FOOTNOTE;
FOOTNOTE1 "Generated by the SAS System (&_SASSERVERNAME, &SYSSCPL) on %TRIM(%QSYSFUNC(DATE(), NLDATE20.)) at %TRIM(%SYSFUNC(TIME(), TIMEAMPM12.))";
PROC GPLOT DATA=WORK.SORTTempTableSorted
 NOCACHE ;
PLOT TAT * TAT / 
	VAXIS=AXIS1

	HAXIS=AXIS2

FRAME ;
	BY Service_responsible;
/* -------------------------------------------------------------------
   End of task code
   ------------------------------------------------------------------- */
RUN; QUIT;
%_eg_conditional_dropds(WORK.SORTTempTableSorted);
TITLE; FOOTNOTE;
GOPTIONS RESET = SYMBOL;

