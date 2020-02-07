* Importing Data ; 
FILENAME REFFILE2 '/folders/myfolders/TimeSeries/table2.csv';  
  
PROC IMPORT DATAFILE=REFFILE2  
	DBMS=CSV  
	OUT=sp500csv3;  
	GETNAMES=YES;  
RUN; 


* Removing Null Values from Data ; 
  
data sp500csv3 ; set sp500csv3; 
if compress(cats(of _all_),'.')=' ' then delete; 
run;  


title "Plot of Adj_Close: SP500 Data"; 
   proc sgplot data=sp500csv3; 
      series x=Date y=Adj_Close	/ markers; 
   run;

proc arima data=sp500csvtransformed3; 
identify var=Adj_Close nlag=31 stationarity=(adf) ; 
run;
 
proc arima data=sp500csvtransformed3; 
identify var=Adj_Close(1) nlag=31 minic esacf scan ; 
run;

proc arima data=sp500csvtransformed3; 
identify var=Adj_Close(1) nlag=31 ; 
estimate q=4; 
run; 

proc arima data=sp500csvtransformed3; 
identify var=Adj_Close(1) nlag=31 ; 
estimate q=(4) noconstant; 
run; 


proc arima data=sp500csvtransformed3;  
identify var=Adj_Close(1) nlag=31 ; 
estimate q=(4) noconstant; 
run; 
forecast lead=31 out=output;   
quit;  
