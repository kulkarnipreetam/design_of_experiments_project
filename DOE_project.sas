filename strdat 'xxxx/Input.txt';  /*Use appropriate file path here*/
data stress;
	infile strdat;
	input obs trt infill speed str;
	
	label obs = 'Observation order';
	label trt = 'Treatment Combination';
	label infill = 'Infill percentage';
	label speed = 'Print speed';
	label str = 'Max stress';

proc print;

/*Raw Data plot*/
proc gplot data=stress;
	plot str*speed=infill / vaxis=axis1 haxis=axis2;
	axis1 label=(angle = 90);
	axis2 offset=(5,5) minor=none;
	symbol1 v=square c=black; symbol2 v=plus c=black;

proc gplot data=stress;
	plot str*trt /vref=0 vaxis=axis1;
	
goptions reset=all;
axis1 label=(angle=90);
symbol1 v=dot c=black;

proc gplot data=stress;
	plot str*speed /vref=0 vaxis=axis1;
	
goptions reset=all;
axis1 label=(angle=90);
symbol1 v=dot c=black;

proc gplot data=stress;
	plot str*infill /vref=0 vaxis=axis1;
	
goptions reset=all;
axis1 label=(angle=90);
symbol1 v=dot c=black;

/*Full interaction model*/
proc glm data=stress;
	classes speed infill;
	model str = speed | infill;
	lsmeans speed | infill / pdiff=all cl adjust=tukey alpha=.01;
	output out=strout p=yhat r=e rstudent=tres;

proc print;

/*Interaction plots*/
proc sort data=stress; by speed infill;
proc means data=stress noprint mean var;
	var str; by speed infill;
	output out=stress2 mean=avgY var=varY;
	label avgY='AVGY';
proc print;
	var speed infill avgY varY;
	
proc gplot data=stress2;
	plot avgY*speed=infill / vaxis=axis1 haxis=axis2;
goptions reset=all;
axis1 label=(angle=90);
axis2 offset=(5,5) minor=none;
symbol1 v=square i=join c=black; symbol2 v=plus i=join c=black;

/* create normal scores for residuals */
proc rank normal=blom out=enrm data=strout;
	var e;
	ranks enrm;
run;

data strnew;
	set strout;
	set enrm;
	label e="Residuals";
	label enrm=’Normal Scores’;
	label yhat="Estimated mean Max. stress";

proc corr data=strnew noprob;
	var e enrm;
run;

/* Normal probability plot*/ 

proc gplot data = strnew;
  plot e*enrm /vaxis = axis1;
  
goptions reset=all;
axis1 label=(angle=90);
symbol1 v=dot c=black;
  
/* Residual Time plot*/

proc gplot data = strnew;
  plot e*obs /vaxis = axis1;

goptions reset=all;
axis1 label=(angle=90);
symbol1 v=dot i=join c=black;
  
/* Aligned residual dot plot by yhat*/

proc gplot data=strnew;
	plot e*yhat /vref=0 vaxis=axis1;
	
goptions reset=all;
axis1 label=(angle=90);
symbol1 v=dot c=black;

proc gplot data=strnew;
	plot e*speed /vref=0 vaxis=axis1;
	
goptions reset=all;
axis1 label=(angle=90);
symbol1 v=dot c=black;

proc gplot data=strnew;
	plot e*infill /vref=0 vaxis=axis1;
	
goptions reset=all;
axis1 label=(angle=90);
symbol1 v=dot c=black;

/* Modified-Levene Test */
data strmod; set stress; set strout;
  id = _n_;
  label id = 'Observation Number';
  group = 1;
  if yhat > 15 then group = 2; 

proc sort data = strmod;
  by group;

proc univariate data = strmod noprint;
  by group;
  var e;
  output out=mout median=mede;

proc print data = mout;
 var group mede;

data mtemp;
  merge strmod mout;
  by group;
  d = abs(e - mede);

proc sort data = mtemp;
  by group;

proc means data = mtemp noprint;
  by group;
  var d;
  output out=mout1 mean=meand;

proc print data = mout1;
  var group meand;

data mtemp1;
  merge mtemp mout1;
  by group;
  ddif = (d - meand)**2;

proc sort data = mtemp1;
 by group yhat;

proc ttest data = mtemp1;
  class group;
  var d;

proc print data = mtemp1; 
 by group;
 var id yhat e d ddif;
run;

/*Bonferroni outlier test*/
data outlier;
	tinvtres = tinv(0.99861,11);
proc print;

/*Variance stabilizing transformation*/
data stress3; set stress;
	invY = 1 / str;

proc glm data=stress3;
	classes speed infill;
	model invY = speed | infill;
	ESTIMATE 'speed <2500 vs. speed = 2500'
			speed 1 1 -2 /divisor = 2;
	ESTIMATE 'speed >1500 vs. speed = 1500'
			speed 2 -1 -1 /divisor = 2;
	ESTIMATE 'speed <2500 vs. speed = 2500 for infill 30 vs. infill 80'
			speed*infill 1 -1 1 -1 -2 2 /divisor = 2;
	lsmeans speed | infill / pdiff=all cl adjust=tukey alpha=.01;
	output out=strout3 p=yhat3 r=e3 rstudent=tres3;
proc print;
/* create normal scores for residuals after transformation*/
proc rank normal=blom out=enrm3 data=strout3;
	var e3;
	ranks enrm3;
run;

data strnew3;
	set strout3;
	set enrm3;
	label e3="Residuals";
	label enrm3=’Normal Scores’;
	label yhat3="Estimated mean Max. stress";

proc corr data=strnew3 noprob;
	var e3 enrm3;
run;

/* Normal probability plot after transformation*/ 

proc gplot data = strnew3;
  plot e3*enrm3 /vaxis = axis1;
  
goptions reset=all;
axis1 label=(angle=90);
symbol1 v=dot c=black;
  
/* Residual Time plot after transformation*/
proc sort data = strnew3;
  by obs;

proc gplot data = strnew3;
  plot e3*obs /vaxis = axis1;

goptions reset=all;
axis1 label=(angle=90);
symbol1 v=dot i=join c=black;
  
/* Aligned residual dot plot by yhat after transformation*/

proc gplot data=strnew3;
	plot e3*yhat3 /vref=0 vaxis=axis1;
	
goptions reset=all;
axis1 label=(angle=90);
symbol1 v=dot c=black;

proc gplot data=strnew3;
	plot e3*speed /vref=0 vaxis=axis1;
	
goptions reset=all;
axis1 label=(angle=90);
symbol1 v=dot c=black;

proc gplot data=strnew3;
	plot e3*infill /vref=0 vaxis=axis1;
	
goptions reset=all;
axis1 label=(angle=90);
symbol1 v=dot c=black;

/* Modified-Levene Test after transformation*/
data strmod3; set stress3; set strout3;
  id3 = _n_;
  label id3 = 'Observation Number';
  group = 1;
  if yhat3 > 0.06 then group = 2; 

proc sort data = strmod3;
  by group;

proc univariate data = strmod3 noprint;
  by group;
  var e3;
  output out=mout3 median=mede3;

proc print data = mout3;
 var group mede3;

data mtemp3;
  merge strmod3 mout3;
  by group;
  d3 = abs(e3 - mede3);

proc sort data = mtemp3;
  by group;

proc means data = mtemp3 noprint;
  by group;
  var d3;
  output out=mout4 mean=meand4;

proc print data = mout4;
  var group meand4;

data mtemp4;
  merge mtemp3 mout4;
  by group;
  ddif3 = (d3 - meand4)**2;

proc sort data = mtemp4;
 by group yhat3;

proc ttest data = mtemp4;
  class group;
  var d3;

proc print data = mtemp4; 
 by group;
 var id3 yhat3 e3 d3 ddif3;
run;
