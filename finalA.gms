* FinalA.gms
*
$eolcom //
option iterlim=999999999;     // avoid limit on iterations
option reslim=300;            // timelimit for solver in sec.
option optcr=0.0;             // gap tolerance
option solprint=ON;           // include solution print in .lst file
option limrow=100;            // limit number of rows in .lst file
option limcol=100;            // limit number of columns in .lst file
//--------------------------------------------------------------------

SET timber 'raw material bought by Metsa Oy'
/   Mat, Kut, Kot, Mak, Kuk, Kok   /;
SET products 'Products made by Metsa Oy'
/   Mas, Kus, Kos, Kuv, Kov, Hsel, Lsel, Pap    /;
SET destinations 'places where Metsa sells products'
/   EU, IE, PA, KI  /;
SET p1(products) 'normal products'
/ Mas, Kus, Kos, Kuv, Kov  /;
SET p2(products) 'products possible to make from leftovers'
/   Hsel, Lsel, Pap     /;
SET p3(products) 'Pulp products which can make paper'
/   HSEL, LSEL /;
SET n 'number of barges'
/   1*107  /;
SET l 'number of barges'
/ 1*23 /;

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
        KOK     0.2 /;




TABLE table2(j,i)'Cubic-meters of material i used in cubic-meter of product j'
                MAT     KUT     KOT     MAK     KUK     KOK
        MAS     2.0     0.0     0.0     -0.8    0.0     0.0
        KUS     0.0     2.0     0.0     0.0     -0.8    0.0
        KOS     0.0     0.0     2.0     0.0     0.0     -0.8
        KUV     0.0     2.8     0.0     0.0     -1.6    0.0
        KOV     0.0     0.0     2.8     0.0     0.0     -1.6
        HSEL    0.0     0.0     0.0     4.8     0.0     0.0
        LSEL    0.0     0.0     0.0     0.0     0.0     4.2
        PAP     0.0     0.0     0.0     0.0     1.0     0.0   ;



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



SCALAR saw_mill 'the capacity of the saw mill, m^3/year'
         /200000/;
SCALAR plywood_mill 'the capacity of the playwood mill, m^3/year'
         /90000/;
SCALAR Hsel_line 'the capacity of the first line, production hsel ton/year'
         /220000/;
SCALAR Lsel_line 'the capacity of the second line, producinng lsel ton/year'
         /180000/;
SCALAR Pap_mill 'the capcity of the paper mill, ton/year'
         /80000/;
SCALAR fuel_price 'fuel wood suitable for producing energy at value of 40'
         /40/;
SCALAR PAP_Pro  'Proportion of HSEL and LSEL needed for PAP'
         /0.2/;
SCALAR fuel_amount 'the amount of fuel we gain by production timbers in p1'
         /-0.2/


VARIABLES
z 'the objective'
y(j) 'Cubic meters produced of product j'
s(i) 'amount of timber i used to make products'
r(n, i) '1 if we buy n boats of timber i, 0 otherwise'
u(l,j,k) '1 if we use n boats for product j shiping to region k, 0 otherwise'
b(i) 'amount of timber i bought'
;

// y/table --> product made
INTEGER VARIABLES y;
BINARY VARIABLES u, r;
POSITIVE VARIABLES s, b;

y.up(j) = 1060000;

EQUATIONS

obj  'Maximum gross profit'



//=============================================ENOUGH TIMBER
timber_used(i) ' amount of  timber i used to make  product j'
prod_starved(i)  'ensure that production can not be starved'
Sold_Prod(j)   'we cant sell more than we produce'
timber_bought(i) 'amount of timber i bought'

//============================== ONLY BUY ONE NUMBER OF BARGERS FOR EACH TIMBER i
Barges_buy(i)  'ensure we only pick one value n for barges for each timber i'
Barges_sell(j, k)'ensure we only pick one value  n for barges for each product to each city'

//=====================================CAPACITYS FOR PRODUCTION
SawmillCap 'Maximum capacity of the saw mill'
PlywoodCap 'Maximum capacity of plywood mill'
HSELCap    'Maximum capacity of HSEL production'
LSELCap    'Maximum capacity of LSEL production'
PAPCap     'Maximum capacity of PAP production'

// =====================  PROPORTION OF HSEL AND LSEL NEEDED FOR PAP
PAP_HSEL     'Proportion needed of HSEL for PAP'
PAP_LSEL     'Proportion needed of LSEL for PAP'
PULP_Bal(p3)     'Cant produce paper without pulp'
;



obj ..

        Z =e= (sum((k,j), (GAMMA(j,k)/1000) * sum(l, q(l,j)*u(l,j,k)))- sum((k,j), (DELTA(j,k)/(1000*1000)) * sum(l, q(l,j)*q(l,j) * u(l,j,k))))   //Amount sold times sellingprice

        - sum(i, ALPHA(i)/1000 * sum(n, h(n,i)*r(n,i))) - sum(i, BETA(i)/(1000*1000) * sum(n, h(n,i)*h(n,i) * r(n,i)))                    //Amount bought times buying price
        + sum(p1, y(p1)*fuel_amount*(-fuel_price/1000))                                                               //Amount of fuel produced times selling price of fuel
        + sum(i, (b(i)-s(i))*ALPHA(i)/1000)                                                                                        //Amount of extra material times its selling price

        - sum(j, y(j)*c(j)/1000)                                                                                         //Amount of produced products times the production cost
        ;



//==========================ENSURE WE HAVE ENOUGH TIMBER========================
timber_used(i) ..  sum(j, y(j)*table2(j, i)) =e= s(i);
prod_starved(i) .. sum(n, r(n, i)*h(n, i)) =g= s(i);
Sold_Prod(j) .. sum((l,k), q(l,j)*u(l,j,k)) =l= y(j);
timber_bought(i) .. b(i) =e= sum(n, r(n, i)*h(n, i));

//=================== ONLY BUY ONE NUMBER OF BARGERS FOR EACH TIMBER i =========
Barges_buy(i) ..  sum( n,r(n,i)) =E= 1;
Barges_sell(j, k) .. sum(l, u(l, j, k)) =E= 1;


//===============================CAPACITYS FOR PRODUCTION ======================
SawmillCap ..  y("Mas") + y("Kus") + y("Kos")  =l= saw_mill;
PlywoodCap ..    y("Kuv") + y("Kov")  =l= plywood_mill;
HSELCap ..   y("Hsel") =l= Hsel_line;
LSELCap ..  y("Lsel") =l= Lsel_line;
PAPCap ..   y("Pap") =l= Pap_mill;

// =====================  PROPORTION OF HSEL AND LSEL NEEDED FOR PAP ===========
PAP_HSEL..  PAP_Pro*y("PAP") =l= y("HSEL");
PAP_LSEL..  PAP_Pro*y("PAP") =l= y("LSEL");
PULP_Bal(p3) .. sum((l,k), u(l,p3,k)*q(l,p3)) + PAP_Pro*y("PAP") =l= y(P3);

MODEL final /all/;
Solve final using mip maxmizing Z;
DISPLAY z.l, u.l, r.l, y.l, s.l, b.l;


