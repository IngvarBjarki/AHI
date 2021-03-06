* FinalA.gms
*
$eolcom //
option iterlim=999999999;     // avoid limit on iterations
option reslim=1300;            // timelimit for solver in sec.
option optcr=0.03;             // gap tolerance
option solprint=ON;           // include solution print in .lst file
option limrow=100;            // limit number of rows in .lst file
option limcol=100;            // limit number of columns in .lst file
//--------------------------------------------------------------------

SET timber 'raw material timber bought by Metsa Oy'
/   Mat, Kut, Kot, Mak, Kuk, Kok   /;
SET products 'Products made by Metsa Oy'
/   Mas, Kus, Kos, Kuv, Kov, Hsel, Lsel, Pap    /;
SET destinations 'destinations where Metsa sells products'
/   EU, IE, PA, KI  /;
SET p1(products) 'normal products p1 produced'
/ Mas, Kus, Kos, Kuv, Kov  /;
SET p2(products) 'products p2 possible to make from leftovers'
/   Hsel, Lsel, Pap     /;
SET p3(products) 'Pulp products p3 which can make paper'
/   HSEL, LSEL /;
SET n 'number of barges n bought'
/   1*107  /;
SET l 'number of barges l sold'
/ 1*23 /;
SET v 'Set for profit calculations'
/   ATO, DPC, SP, FC, PROFIT /;
SET t 'years'
/ 1, 2, 3 /;
SET s 'Scenario'
/s1*s4/;

SET m 'production lines'
/   SAW, PLY, SPULP, HPULP, PAPM /;

ALIAS(timber, i);
ALIAS(products, j);
ALIAS(destinations, k);

PARAMETERS


c(products) 'the cost of producing each product, mesured in erous/1000m^3'
    /   Mas   550
        Kus   500
        Kos   450
        Kuv   2500
        Kov   2600
        Hsel  820
        Lsel  800
        Pap   1700  /


alpha(timber) 'alpha cost parameters by timber assortments'
    /   MAT     190
        KUT     150
        KOT     120
        MAK     180
        KUK     150
        KOK     150 /

beta(timber) 'Beta cost parameter by timber assortments'
    /   MAT     1.0
        KUT     0.5
        KOT     3.0
        MAK     0.2
        KUK     0.3
        KOK     0.2 /

CAP0(m) 'Starting capacity'
    /   SAW     100000
        PLY     90000
        SPULP   100000
        HPULP   150000
        PAPM    80000  /

demand_growth(j) 'demand growth for product j'
/   MAS    1.010
     KUS    1.008
     KOS    1.015
     KUV    1.015
     KOV    1.020
     HSEL  1.025
     LSEL   1.030
     PAP     1.035  /


FCOST(m) 'Fixed cost'
    /   SAW     100
        PLY     300
        SPULP   500
        HPULP   500
        PAPM    700 /

MaxCap(m)
   /SAW     150000
    PLY     135000
    SPULP   200000
    HPULP   300000
    PAPM    160000 /;






TABLE table2(j,i)'Cubic-meters of material i used in cubic-meter of product j'
                MAT     KUT     KOT     MAK     KUK     KOK
        MAS     2.0     0.0     0.0     -0.8    0.0     0.0
        KUS     0.0     2.0     0.0     0.0     -0.8    0.0
        KOS     0.0     0.0     2.0     0.0     0.0     -0.8
        KUV     0.0     2.8     0.0     0.0     -1.6    0.0
        KOV     0.0     0.0     2.8     0.0     0.0     -1.6
        HSEL    0.0     0.0     0.0     4.8     0.0     0.0
        LSEL    0.0     0.0     0.0     0.0     0.0     4.2
        PAP     0.0     0.0     0.0     0.0     1.0     0.0      ;



TABLE Prodinm(m,j) 'What products j are in what machines m'
        MAS     KUS     KOS     KUV     KOV     HSEL    LSEL    PAP
SAW       1       1       1       0       0        0       0      0
PLY       0       0       0       1       1        0       0      0
SPULP     0       0       0       0       0        1       0      0
HPULP     0       0       0       0       0        0       1      0
PAPM      0       0       0       0       0        0       0      1;




TABLE GAMMA(j,k) 'Gamma coefficent for selling product j in region k'
                  EU      IE      PA      KI
         MAS     1600    1300    1400    1500
         KUS     1400    1200    1300    1400
         KOS     1300    1400    1500    1600
         KUV     4400    3800    3600    3500
         KOV     4300    4100    3900    3800
         HSEL    2300    2500    2300    2600
         LSEL    2500    2800    2300    2500
         PAP     4500    4700    4300    4800 ;


TABLE DELTA(j,k) 'Delta coefficient for selling product j in region k'
                 EU      IE      PA      KI
         MAS     4       10      12      15
         KUS     4       10      12      15
         KOS     14      20      22      25
         KUV     4       10      12      15
         KOV     4       10      12      15
         HSEL    2       4       5       6
         LSEL    3       2       5       7
         PAP     4       10      12      15 ;

TABLE RHO(s,t) 'Price coefficients of scenario s in year t'
              1    2    3
         s1  1.00 1.05 1.07
         s2  1.00 1.05 0.95
         s3  1.00 0.95 1.05
         s4  1.00 0.95 0.93 ;
TABLE q(l,j) 'Options of amount l to be sold of product j'
      MAS     KUS     KOS     KUV     KOV     HSEL    LSEL    PAP
 1     0       0       0       0       0       0       0       0
 2   10000   10000   10000   10000   10000   10000   10000   10000
 3   20000   20000   20000   20000   20000   20000   20000   20000
 4   30000   30000   30000   30000   30000   30000   30000   30000
 5   40000   40000   40000   40000   40000   40000   40000   40000
 6   50000   50000   50000   50000   50000   50000   50000   50000
 7   60000   60000   60000   60000   60000   60000   60000   60000
 8   70000   70000   70000   70000   70000   70000   70000   70000
 9   80000   80000   80000   80000   80000   80000   80000   80000
 10  90000   90000   90000   90000   90000   90000   90000   90000
 11  100000  100000  100000  100000  100000  100000  100000  100000
 12  110000  110000  110000  110000  110000  110000  110000  110000
 13  120000  120000  120000  120000  120000  120000  120000  120000
 14  130000  130000  130000  130000  130000  130000  130000  130000
 15  140000  140000  140000  140000  140000  140000  140000  140000
 16  150000  150000  150000  150000  150000  150000  150000  150000
 17  160000  160000  160000  160000  160000  160000  160000  160000
 18  170000  170000  170000  170000  170000  170000  170000  170000
 19  180000  180000  180000  180000  180000  180000  180000  180000
 20  190000  190000  190000  190000  190000  190000  190000  190000
 21  200000  200000  200000  200000  200000  200000  200000  200000
 22  210000  210000  210000  210000  210000  210000  210000  210000
 23  220000  220000  220000  220000  220000  220000  220000  220000 ;





TABLE h(n,i) 'Options of amount n to be bought of material i'
    Mat     KUT     KOT     MAK     KUK     KOK
1   0       0       0       0       0       0
2   10000   10000   10000   10000   10000   10000
3   20000   20000   20000   20000   20000   20000
4   30000   30000   30000   30000   30000   30000
5   40000   40000   40000   40000   40000   40000
6   50000   50000   50000   50000   50000   50000
7   60000   60000   60000   60000   60000   60000
8   70000   70000   70000   70000   70000   70000
9   80000   80000   80000   80000   80000   80000
10  90000   90000   90000   90000   90000   90000
11  100000  100000  100000  100000  100000  100000
12  110000  110000  110000  110000  110000  110000
13  120000  120000  120000  120000  120000  120000
14  130000  130000  130000  130000  130000  130000
15  140000  140000  140000  140000  140000  140000
16  150000  150000  150000  150000  150000  150000
17  160000  160000  160000  160000  160000  160000
18  170000  170000  170000  170000  170000  170000
19  180000  180000  180000  180000  180000  180000
20  190000  190000  190000  190000  190000  190000
21  200000  200000  200000  200000  200000  200000
22  210000  210000  210000  210000  210000  210000
23  220000  220000  220000  220000  220000  220000
24  230000  230000  230000  230000  230000  230000
25  240000  240000  240000  240000  240000  240000
26  250000  250000  250000  250000  250000  250000
27  260000  260000  260000  260000  260000  260000
28  270000  270000  270000  270000  270000  270000
29  280000  280000  280000  280000  280000  280000
30  290000  290000  290000  290000  290000  290000
31  300000  300000  300000  300000  300000  300000
32  310000  310000  310000  310000  310000  310000
33  320000  320000  320000  320000  320000  320000
34  330000  330000  330000  330000  330000  330000
35  340000  340000  340000  340000  340000  340000
36  350000  350000  350000  350000  350000  350000
37  360000  360000  360000  360000  360000  360000
38  370000  370000  370000  370000  370000  370000
39  380000  380000  380000  380000  380000  380000
40  390000  390000  390000  390000  390000  390000
41  400000  400000  400000  400000  400000  400000
42  410000  410000  410000  410000  410000  410000
43  420000  420000  420000  420000  420000  420000
44  430000  430000  430000  430000  430000  430000
45  440000  440000  440000  440000  440000  440000
46  450000  450000  450000  450000  450000  450000
47  460000  460000  460000  460000  460000  460000
48  470000  470000  470000  470000  470000  470000
49  480000  480000  480000  480000  480000  480000
50  490000  490000  490000  490000  490000  490000
51  500000  500000  500000  500000  500000  500000
52  510000  510000  510000  510000  510000  510000
53  520000  520000  520000  520000  520000  520000
54  530000  530000  530000  530000  530000  530000
55  540000  540000  540000  540000  540000  540000
56  550000  550000  550000  550000  550000  550000
57  560000  560000  560000  560000  560000  560000
58  570000  570000  570000  570000  570000  570000
59  580000  580000  580000  580000  580000  580000
60  590000  590000  590000  590000  590000  590000
61  600000  600000  600000  600000  600000  600000
62  610000  610000  610000  610000  610000  610000
63  620000  620000  620000  620000  620000  620000
64  630000  630000  630000  630000  630000  630000
65  640000  640000  640000  640000  640000  640000
66  650000  650000  650000  650000  650000  650000
67  660000  660000  660000  660000  660000  660000
68  670000  670000  670000  670000  670000  670000
69  680000  680000  680000  680000  680000  680000
70  690000  690000  690000  690000  690000  690000
71  700000  700000  700000  700000  700000  700000
72  710000  710000  710000  710000  710000  710000
73  720000  720000  720000  720000  720000  720000
74  730000  730000  730000  730000  730000  730000
75  740000  740000  740000  740000  740000  740000
76  750000  750000  750000  750000  750000  750000
77  760000  760000  760000  760000  760000  760000
78  770000  770000  770000  770000  770000  770000
79  780000  780000  780000  780000  780000  780000
80  790000  790000  790000  790000  790000  790000
81  800000  800000  800000  800000  800000  800000
82  810000  810000  810000  810000  810000  810000
83  820000  820000  820000  820000  820000  820000
84  830000  830000  830000  830000  830000  830000
85  840000  840000  840000  840000  840000  840000
86  850000  850000  850000  850000  850000  850000
87  860000  860000  860000  860000  860000  860000
88  870000  870000  870000  870000  870000  870000
89  880000  880000  880000  880000  880000  880000
90  890000  890000  890000  890000  890000  890000
91  900000  900000  900000  900000  900000  900000
92  910000  910000  910000  910000  910000  910000
93  920000  920000  920000  920000  920000  920000
94  930000  930000  930000  930000  930000  930000
95  940000  940000  940000  940000  940000  940000
96  950000  950000  950000  950000  950000  950000
97  960000  960000  960000  960000  960000  960000
98  970000  970000  970000  970000  970000  970000
99  980000  980000  980000  980000  980000  980000
100 990000  990000  990000  990000  990000  990000
101 1000000 1000000 1000000 1000000 1000000 1000000
102 1010000 1010000 1010000 1010000 1010000 1010000
103 1020000 1020000 1020000 1020000 1020000 1020000
104 1030000 1030000 1030000 1030000 1030000 1030000
105 1040000 1040000 1040000 1040000 1040000 1040000
106 1050000 1050000 1050000 1050000 1050000 1050000
107 1060000 1060000 1060000 1060000 1060000 1060000 ;



SCALAR fuel_price 'fuel wood suitable for producing energy at value of 40'
         /40/;
SCALAR PAP_Pro  'Proportion of HSEL and LSEL needed for PAP'
         /0.2/;
SCALAR fuel_amount 'the amount of fuel we gain by production timbers in p1'
         /-0.2/
SCALAR SPRO 'all scenarios are equally likely'
         /0.25/


VARIABLES
z 'the objective'

y(s,j,t) 'Cubic meters produced of product j'
s0(s,i,t) 'amount of timber i used to make products'
r(s,n, i,t) '1 if we buy n boats of timber i, 0 otherwise'
u(s,l,j,k,t) '1 if we use n boats for product j shiping to region k, 0 otherwise'
b(s,i,t) 'amount of timber i bought'


Pr(s,t) 'Net profit in each year t'
Cap(s,m,t) 'Capacity of machine m in year t'

;



// y/table --> product made
INTEGER VARIABLES y;
BINARY VARIABLES u, r;
POSITIVE VARIABLES s0, b;

y.up(s,j,t) = 1060000;


EQUATIONS

obj  'Maximum gross profit'



//=============================================ENOUGH TIMBER
timber_used(s,i,t) ' amount of  timber i used to make  product j in year t'
prod_starved(s,i,t)  'ensure that production can not be starved in each year'
Sold_Prod(s,j,t)   'we cant sell more than we produce in each year'
timber_bought(s,i,t) 'amount of timber i bought in each year'

//============================== ONLY BUY ONE NUMBER OF BARGERS FOR EACH TIMBER i
Barges_buy(s,i,t)  'ensure we only pick one value n for barges for each timber i'
Barges_sell(s,j, k,t)  'ensure we only pick one value  n for barges for each product to each city'

//=====================================CAPACITYS FOR PRODUCTION

Capacity2(s,m,t) 'Make sure that the capacity does not go down'
MaxCapacity(s,m,t) 'Make sure we dont go over the maximum capacity'


// =====================  PROPORTION OF HSEL AND LSEL NEEDED FOR PAP
PAP_HSEL(s,t)     'Proportion needed of HSEL for PAP'
PAP_LSEL(s,t)     'Proportion needed of LSEL for PAP'
PULP_Bal(s,p3,t)     'Cant produce paper without pulp'


// =====PROFIT(OLD OBJECTIVE FUNCTION)=======//
nPROFIT(s,t) 'Profit is what we gain minus what we spend'

Capacity3(s,m,t) 'safdasd'



// ======Sales Distribution among regions in each year=====//
TotalSales(s,t) 'Total sales for each year t'
RegionSales(s,t,k) 'Sales in each region k for each year t'


BCTOProcap(s, m) 'MUNA BREYTA NAFNI@CTRL H'
BCT1Procap(s, m) 'Muna BREYTA NAFNI'
BTC0y(s, j)
BTC1y(s, j)
;



obj ..

        Z =e= sum(t, SPRO*sum(s,power(0.95, ord(t)-1)*Pr(s,t)));

//==========================ENSURE WE HAVE ENOUGH TIMBER==================================
timber_used(s,i,t) ..  sum(j, y(s,j,t)*table2(j, i)) =e= s0(s,i,t);
prod_starved(s,i,t) .. sum(n, r(s,n,i,t)*h(n, i)) =g= s0(s,i,t);
Sold_Prod(s,j,t) .. sum((l,k), q(l,j)*u(s,l,j,k,t)) =l= y(s,j,t);
timber_bought(s,i,t) .. b(s,i,t) =e= sum(n, r(s,n, i,t)*h(n, i));

//=================== ONLY BUY ONE NUMBER OF BARGERS FOR EACH TIMBER i ========================
Barges_buy(s,i,t) ..  sum( n,r(s,n,i,t)) =E= 1;
Barges_sell(s,j, k,t) .. sum(l, u(s,l, j, k,t)) =E= 1;


//=============================== CAPACITYS FOR PRODUCTION =============================/
Capacity2(s,m,t).. Cap(s,m,t-1) + Cap0(m)$(ord(t)=1) =g= sum(j, y(s,j,t)*Prodinm(m,j));
Capacity3(s,m,t).. Cap(s,m,t) =g=  Cap(s,m,t-1) + Cap0(m)$(ord(t)=1);

MaxCapacity(s,m,t).. Cap(s,m,t) =l= MaxCap(m);

BCTOProcap(s, m) ..  Cap(s,m, "1" ) =e= Cap(s++1, m,"1");
BCT1Procap(s, m)$(ord(s) = 1 or ord(s)= 3) .. Cap(s, m, '2') =e=  Cap(s+1, m, '2');

BTC0y(s, j) .. y(s,j,"1") =e= y(s++1,j,"1") ;
BTC1y(s, j)$(ord(s) = 1 or ord(s)= 3) .. y(s,j,"2") =e= y(s+1,j,"2");

// =====================  PROPORTION OF HSEL AND LSEL NEEDED FOR PAP ===========
PAP_HSEL(s,t)..  PAP_Pro*y(s,"PAP",t) =l= y(s,"HSEL",t);
PAP_LSEL(s,t)..  PAP_Pro*y(s,"PAP",t) =l= y(s,"LSEL",t);
PULP_Bal(s,p3,t) .. sum((l,k), u(s,l,p3,k,t)*q(l,p3)) + PAP_Pro*y(s,"PAP",t) =l= y(s,P3,t);


// =====PROFIT(OLD OBJECTIVE FUNCTION)=======//

nPROFIT(s,t).. Pr(s,t) =e=  RHO(s,t)*(sum((k,j), (GAMMA(j,k)/1000) * sum(l, q(l,j)*u(s,l,j,k,t)))
- sum((k,j), (DELTA(j,k)/(1000*1000)) * sum(l, q(l,j)*q(l,j) * u(s,l,j,k,t))/power(demand_growth(j), ord(t)-1)))   //Amount sold times sellingprice

                    - sum(i, ALPHA(i)/1000 * sum(n, h(n,i)*r(s,n,i,t))) - sum(i, BETA(i)/(1000*1000) * sum(n, h(n,i)*h(n,i) * r(s,n,i,t)))                    //Amount bought times buying price
                    + sum(p1, y(s,p1,t)*fuel_amount*(-fuel_price/1000))                                                               //Amount of fuel produced times selling price of fuel
                    + sum(i, (b(s,i,t)-s0(s,i,t))*ALPHA(i)/1000)                                                                                        //Amount of extra material times its selling price
                    - sum(j, y(s,j,t)*c(j)/1000)
                    - sum(m, Cap(s,m,t)*FCost(m)/1000)                                                                                      //Amount of produced products times the production cost
                    ;


MODEL final /all/;
Solve final using mip maxmizing Z;

DISPLAY z.l, u.l, r.l, y.l, s0.l, b.l, Cap.l, pr.l;

