* NewsBoy9.gms
*
$eolcom //
option iterlim=999999999;     // avoid limit on iterations
option reslim=30000;            // timelimit for solver in sec.
option optcr=0.0;             // gap tolerance
option solprint=ON;           // include solution print in .lst file
option limrow=100;            // limit number of rows in .lst file
option limcol=100;            // limit number of columns in .lst file
//--------------------------------------------------------------------

Set scenerio 'all scenarioÂ´s' /1*10/;
Set rain(scenerio) 'rainy day' /1*5/;
Set sun(scenerio) 'sunnyday' /6*10/;
Set t 'time' /A, B, C/;
Alias(scenerio, s);

Parameters
pi(s) 'the probability for each scenario'
/ 1   0.10
  2   0.25
  3   0.30
  4   0.25
  5   0.10
  6   0.10
  7   0.25
  8   0.30
  9   0.25
  10  0.10  /

  d(s) 'demand for each scenario'
  / 1    12
    2    14
    3    16
    4    18
    5    20
    6    22
    7    24
    8    26
    9    28
    10   30     /;

    scalar h 'the scarp value of  recycling news papaer' /10/;
    scalar p 'the profit for selling news paper' /70/;
    scalar c 'the puchasing cost for each news paper'  /20/;


Table   cq(s,t)
                        A       B       C
                1       20      35      0
                2       20      35      0
                3       20      35      0
                4       20      35      0
                5       20      35      0
                6       20      50      0
                7       20      50      0
                8       20      50      0
                9       20      50      0
                10      20      50      0;
// cost of buying newspapers


Table   pq(s,t)
                        A       B       C
                1       0       15      70
                2       0       15      70
                3       0       15      70
                4       0       15      70
                5       0       15      70
                6       0       30      70
                7       0       30      70
                8       0       30      70
                9       0       30      70
                10      0       30      70;
// sales price of newspapers

    variables
    z 'the objective'
    x(s, t) 'number of news paper sold'
    y(s,t) 'the surplus'
    w(s,t) 'the min[x,ds], number of news paper sold in scenario s'   //w(s)
    ;


    Integer variables x;
    Positive variable y;
    Integer variable w;

    x.up(s,'C') = 0;
    w.up(s,'B') = 10;
    w.up(s,'A') = 0;
    w.up(s,'C') = d(s);


    equations
    obj 'the obj, maximize net profit'
   // surplus(s) 'the surpluse, check if we have left over news paper'
    //isX(s) 'this one and isDs, are asigning the lower one to ws to calculate the surpluse later'
    //isDs(s) 'see above'


    buy1(s) "ensure that the first season is the same"
    buy2(s) "ensure that the if its raining we get right constant"
    buy3(s) "-ll- not raining"
    sell1(s)  "right price if its raining"
    sell2(s) "right proce if its not raining"
    lager1(s,t) "the balance"
    lager2(s) "ensure that notheng is sold before it is legal"
    ;

    obj ..                    z =e=  sum((s,t), 0.5*pi(s)*(w(s,t)*pq(s,t) - x(s,t)*cq(s,t)))
                                                            + sum((s,t)$(3=ord(t)),  y(s,t)*h*0.5*pi(s));                        //sum(s, pi(s)*(w(s)*p + y(s)*h - x*c));
  //  surplus(s) ..              y(s) =e= x - w(s);
    //isX(s) ..                    w(s) =l= x;
    //isDs(s) ..                  w(s) =l= d(s); // we are given that the demand is the avrg demand which is 21

    buy1(s) ..                                                                    x(s, "A") =e= x(s++1, "A");

    buy2(s) $(ord(s)< 5) ..                                                       x(s, "B") =e= x(s+1, "B");
    buy3(s) $(ord(s)>5 and ord(s) < card(s))..                                    x(s, "B") =e= x(s+1, "B");

    sell1(s)$(ord(s)< 5) ..                                                 w(s, "B") =e= w(s+1, "B");
    sell2(s) $(ord(s)>5 and ord(s) < card(s)) ..                            w(s, "B") =e= w(s+1, "B");

    lager1(s,t) $(ord(t)<card(t)) ..                                                  y(s,t+1) =e= y(s,t) + x(s, t+1) - w(s, t+1);
    lager2(s) ..                                                                    y(s, "A") =e= x(s, "A");

Model newsBoy /all/;
Solve newsBoy using mip maximizing z;
DISPLAY Z.L, X.L;
