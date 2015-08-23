libname tf "C:\...\sas dataset";
libname tf "H:\...\sas dataset";

***************************************;
* 3. creazione intervalli GIORNALIERI *;
***************************************;

options nocenter;
*******************************************************;
* Define fifteen minute intervals in a CNTLIN data set *;
*******************************************************;
data work.int1m;
 retain label "ddmmmyy:00:00:00-ddmmmyy:00:00:00"
 fmtname "int1m"
 type "N"
 start 0
 end 0
 eexcl "Y";
 do start = "01JAN09:00:00:00"dt to "16DEC14:00:00:00"dt by 60;
 end = start + 60;
 label = put(start,datetime.)/*||"-"||put(end,datetime.)*/;
 /*label = put(start,tod8.0)||"-"||put(end,tod8.0);*/
 output;
 end;
 hlo = "O";
 label = "***OTHER***";
 output;
 format start end datetime.;
run;
********************************************************;
* Use the CNTLIN data set to create the interval format *;
********************************************************;
proc format cntlin = work.int1m;
run;


/*MACRO*/


%macro dataset1m (dati);


data work.&dati    ;  /*CAMBIA NOME*/
       %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
       /*infile 'C:\Users\feder_000\Documents\Tesi\dati originali\.mtgoxEUR.csv' delimiter = ','*/
		infile "H:\Tesi\dataset originali\.&dati..csv" delimiter = ','

  MISSOVER DSD lrecl=32767 ;
informat timestamp best32. ;
informat price best32. ;
informat size best32. ;
format timestamp best12. ;
format price best12. ;
format size best12. ;
input
                   timestamp
                   price
                   size
   ;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

*******************************;
* 2. from utc to sas datetime *;
*******************************;

data &dati.2;  /*CAMBIA NOME*/
set &dati;    /*CAMBIA NOME*/
      /* The INTNX function accounts for leap years. */
   datetime = intnx('DTyear',timestamp,10,'s');  
   format datetime datetime.;          
        
run;   



*****************************;
* 5. creazione dataset OHLC *;
*****************************;

proc sort data=&dati.2;
by datetime;
run;

data &dati.3;    /*CAMBIA NOME*/
set &dati.2 (keep = price size datetime);  /*CAMBIA NOME*/
by datetime;
Int1M = put(datetime,int1m.);
CT_RowNum + 1;
run;

proc sort data=&dati.3;  /*CAMBIA NOME*/
by int1M;
run;


data tf.&dati.1m (drop = Price size);  /*CAMBIA NOME*/
set &dati.3 ;  /*CAMBIA NOME*/
by Int1M;
retain Open
 High
 Low
 Close
 Volume
 Trades .;
if first.datetime or first.Int1M then do ;
 Open = .;
 High = .;
 Low = .;
 Close = .;
 Volume = .;
 Trades = .;
end;
if Open = . then Open = Price; 
 High = max(Price ,High);
 Low = min(Price ,Low );
 Volume = sum(Volume,Size);
 Close = Price;
 Trades + 1;
if last.Int1m then output;
run;

proc sort data=tf.&dati.1m;  /*CAMBIA NOME*/
by datetime;
run;


/*cambio formato a int1m*/
data tf.&dati.1m;
set tf.&dati.1m;
datetimevar1 =input(int1m,anydtdtm20.);
format datetimevar1 datetime20.;
drop int1m;
rename datetimevar1=Int1m;
run;

/*mantengo solo il prezzo close e restringo le osservazioni*/
data tf.&dati.1mclose;
set tf.&dati.1m;
keep close Int1m;
rename close=&dati._close;
if int1m < "30APR2013:23:00:00"dt then delete; /*fatto per non avere missing in bitfinex*/
if int1m > "10DEC2014:23:59:00"dt then delete;
run;

/*proc datasets library=tf;
   delete &dati.1m;
run;*/

%mend dataset1m;

/* fine macro*/
