$eolcom //

Sets
    Asset
    Date
;
    
Alias(Asset, i);
Alias(Date, t);

Parameter
    IndexReturns(i,t);
    

$GDXIN Data
$LOAD Asset Date IndexReturns
$GDXIN

display Date;

set
         scen /s1*s250/
         w    /w1*w4/
         period(t) /3-1-2005,    31-1-2005 ,    28-2-2005 ,    28-3-2005 ,    25-4-2005 ,
         23-5-2005 ,    20-6-2005 ,    18-7-2005 ,    15-8-2005 ,    12-9-2005 ,
         10-10-2005,    7-11-2005 ,    5-12-2005 ,    2-1-2006  ,    30-1-2006 ,
         27-2-2006 ,    27-3-2006 ,    24-4-2006 ,    22-5-2006 ,    19-6-2006 ,
         17-7-2006 ,    14-8-2006 ,    11-9-2006 ,    9-10-2006 ,    6-11-2006 ,
         4-12-2006 ,    1-1-2007  ,    29-1-2007 ,    26-2-2007 ,    26-3-2007 ,
         23-4-2007 ,    21-5-2007 ,    18-6-2007 ,    16-7-2007 ,    13-8-2007 ,
         10-9-2007 ,    8-10-2007 ,    5-11-2007 ,    3-12-2007 ,    31-12-2007,
         28-1-2008 ,    25-2-2008 ,    24-3-2008 ,    21-4-2008 ,    19-5-2008 ,
         16-6-2008 ,    14-7-2008 ,    11-8-2008 ,    8-9-2008  ,    6-10-2008 ,
         3-11-2008 ,    1-12-2008 ,    29-12-2008,    26-1-2009 ,    23-2-2009 ,
         23-3-2009 ,    20-4-2009 ,    18-5-2009 ,    15-6-2009 ,    13-7-2009 ,
         10-8-2009 ,    7-9-2009  ,    5-10-2009 ,    2-11-2009 ,    30-11-2009,
         28-12-2009,    25-1-2010 ,    22-2-2010 ,    22-3-2010 ,    19-4-2010 ,
         17-5-2010 ,    14-6-2010 ,    12-7-2010 ,    9-8-2010  ,    6-9-2010  ,
         4-10-2010 ,    1-11-2010 ,    29-11-2010,    27-12-2010,    24-1-2011 ,
         21-2-2011 ,    21-3-2011 ,    18-4-2011 ,    16-5-2011 ,    13-6-2011 ,
         11-7-2011 ,    8-8-2011  ,    5-9-2011  ,    3-10-2011 ,    31-10-2011,
         28-11-2011,    26-12-2011,    23-1-2012 ,    20-2-2012 ,    19-3-2012 ,
         16-4-2012 ,    14-5-2012 ,    11-6-2012 ,    9-7-2012  ,    6-8-2012  ,
         3-9-2012  ,    1-10-2012 ,    29-10-2012,    26-11-2012,    24-12-2012,
         21-1-2013 ,    18-2-2013 ,    18-3-2013 ,    15-4-2013 ,    13-5-2013 ,
         10-6-2013 ,    8-7-2013  ,    5-8-2013  ,    2-9-2013  ,    30-9-2013 ,
         28-10-2013,    25-11-2013,    23-12-2013,    20-1-2014 ,    17-2-2014 ,
         17-3-2014 ,    14-4-2014 ,    12-5-2014 ,    9-6-2014  ,    7-7-2014  ,
         4-8-2014  ,    1-9-2014  ,    29-9-2014 ,    27-10-2014,    24-11-2014,
         22-12-2014,    19-1-2015 ,    16-2-2015 ,    16-3-2015 ,    13-4-2015 ,
         11-5-2015 ,    8-6-2015  ,    6-7-2015  ,    3-8-2015  ,    31-8-2015 ,
         28-9-2015 ,    26-10-2015,    23-11-2015,    21-12-2015,    18-1-2016 ,
         15-2-2016 ,    14-3-2016 ,    11-4-2016 ,    9-5-2016  ,    6-6-2016  ,
         4-7-2016  ,    1-8-2016  ,    29-8-2016 ,    26-9-2016 ,    24-10-2016,
         21-11-2016,    19-12-2016,    16-1-2017 ,    13-2-2017 ,    13-3-2017 ,
         10-4-2017 ,    8-5-2017  ,    5-6-2017  ,    3-7-2017  ,    31-7-2017 ,
         28-8-2017 ,    25-9-2017 ,    23-10-2017,    20-11-2017,    18-12-2017,
         15-1-2018 ,    12-2-2018 ,    12-3-2018 ,    9-4-2018  ,    7-5-2018  ,
         4-6-2018  ,    2-7-2018  ,    30-7-2018 ,    27-8-2018 ,    24-9-2018 ,
         22-10-2018,    19-11-2018,    17-12-2018,    14-1-2019 ,    11-2-2019 ,    11-3-2019 ,    8-4-2019/

// outcomment next line, if you want to reseed the random number generator at each new run of the file
*execseed=gmillisec(jnow)

SCALAR randnum, counter;
counter = -4;

Parameter RetScenWeeks(i, scen, w);
Parameter RetScen(period, i, scen);

loop(period,
        counter=counter + 4;
        loop(scen,
             loop(w,
                     randnum = uniformint(1+counter, 335+counter);
                     RetScenWeeks(i, scen,  w) = SUM(t$(ord(t)=randnum), IndexReturns(i, t)) ;
             );
             RetScen(period, i,scen) = prod(w, (1 + RetScenWeeks(i, scen, w ))) - 1;
        )
);

display RetScen;
EXECUTE_UNLOAD 'RollingScenarios.gdx', scen, Asset, RetScen;
