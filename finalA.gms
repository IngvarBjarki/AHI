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
SET p3(products)'subset made for table3'
/   Mak, Kuk, Kok, Hsel, Lsel   /;
SET n 'number of barges'
/   1*105  /;

ALIAS(timber, i);
ALIAS(products, j);
ALIAS(destinations, k);

PARAMETERS
afla_wood(timber) 'the alfa value for the timber'
/   Mat  190
    Kut   150
    Kot   120
    Mak  180
    Kuk  150
    Kok  150    /

    beta_wood(timber) 'the beta value for the timber'
    /   Mat   1.0
        Kut    0.5
        Kot    3.0
        Mak  0.2
        Kuk  0.3
        Kok  0.2    /

    c(timber) 'the cost of each timber, mesured in erous/1000m^3'
    /   Mas   550
        Kus   500
        Kos   450
        Kuv   2500
        Kov  2600
        Hsel  820
        Lsel  800
        Pap  1700   /
        ;




TABLE table2(p1,i)'Cubic-meters of material p1 used in cubic-meter of product i'
                MAT     KUT     KOT     MAK     KUK     KOK     FUEL
        MAS     2.0     0.0     0.0     -0.8    0.0     0.0     -0.2
        KUS     0.0     2.0     0.0     0.0     -0.8    0.0     -0.2
        KOS     0.0     0.0     2.0     0.0     0.0     -0.8    -0.2
        KUV     0.0     2.8     0.0     0.0     -1.6    0.0     -0.2
        KOV     0.0     0.0     2.8     0.0     0.0     -1.6    -0.2 ;

TABLE table3(p2, p3) 'timber p3 needed for production of product p2'
                     Mak    Kuk     Kok   Hsel    Lsel
        Hsel      4.8      0.0      0.0      0.0      0.0
        Lsel       0.0      0.0      4.2      0.0      0.0
        Pap       0.0      1.0       0.0     0.2      0.2;


TABLE table4GAMMA(j,k) 'Gamma coefficent for selling product j in region k'
                EU      IE      PA      KI
        MAS     1600    1300    1400    1500
        KUS     1400    1200    1300    1400
        KOS     1300    1400    1500    1600
        KUV     4400    3800    3600    3500
        KOV     4300    4100    3900    3800
        HSEL    2300    2500    2300    2600
        LSEL    2500    2800    2300    2500
        PAP     4500    4700    4300    4800 ;

TABLE table4DELTA(j,k) 'Delta coefficient for selling product j in region k'
                EU      IE      PA      KI
        MAS     4       10      12      15
        KUS     4       10      12      15
        KOS     14      20      22      25
        KUV     4       10      12      15
        KOV     4       10      12      15
        HSEL    2       4       5       6
        LSEL    3       2       5       7
        PAP     4       10      12      15;

TABLE AMOUNT(n,i) 'Options of amount n to be bought of material i'
    Mat     KUT     KOT     MAK     KUK     KOK
1   10000   10000   10000   10000   10000   10000
2   20000   20000   20000   20000   20000   20000
3   30000   30000   30000   30000   30000   30000
4   40000   40000   40000   40000   40000   40000
5   50000   50000   50000   50000   50000   50000
6   60000   60000   60000   60000   60000   60000
7   70000   70000   70000   70000   70000   70000
8   80000   80000   80000   80000   80000   80000
9   90000   90000   90000   90000   90000   90000
10  100000  100000  100000  100000  100000  100000
11  110000  110000  110000  110000  110000  110000
12  120000  120000  120000  120000  120000  120000
13  130000  130000  130000  130000  130000  130000
14  140000  140000  140000  140000  140000  140000
15  150000  150000  150000  150000  150000  150000
16  160000  160000  160000  160000  160000  160000
17  170000  170000  170000  170000  170000  170000
18  180000  180000  180000  180000  180000  180000
19  190000  190000  190000  190000  190000  190000
20  200000  200000  200000  200000  200000  200000
21  210000  210000  210000  210000  210000  210000
22  220000  220000  220000  220000  220000  220000
23  230000  230000  230000  230000  230000  230000
24  240000  240000  240000  240000  240000  240000
25  250000  250000  250000  250000  250000  250000
26  260000  260000  260000  260000  260000  260000
27  270000  270000  270000  270000  270000  270000
28  280000  280000  280000  280000  280000  280000
29  290000  290000  290000  290000  290000  290000
30  300000  300000  300000  300000  300000  300000
31  310000  310000  310000  310000  310000  310000
32  320000  320000  320000  320000  320000  320000
33  330000  330000  330000  330000  330000  330000
34  340000  340000  340000  340000  340000  340000
35  350000  350000  350000  350000  350000  350000
36  360000  360000  360000  360000  360000  360000
37  370000  370000  370000  370000  370000  370000
38  380000  380000  380000  380000  380000  380000
39  390000  390000  390000  390000  390000  390000
40  400000  400000  400000  400000  400000  400000
41  410000  410000  410000  410000  410000  410000
42  420000  420000  420000  420000  420000  420000
43  430000  430000  430000  430000  430000  430000
44  440000  440000  440000  440000  440000  440000
45  450000  450000  450000  450000  450000  450000
46  460000  460000  460000  460000  460000  460000
47  470000  470000  470000  470000  470000  470000
48  480000  480000  480000  480000  480000  480000
49  490000  490000  490000  490000  490000  490000
50  500000  500000  500000  500000  500000  500000
51  510000  510000  510000  510000  510000  510000
52  520000  520000  520000  520000  520000  520000
53  530000  530000  530000  530000  530000  530000
54  540000  540000  540000  540000  540000  540000
55  550000  550000  550000  550000  550000  550000
56  560000  560000  560000  560000  560000  560000
57  570000  570000  570000  570000  570000  570000
58  580000  580000  580000  580000  580000  580000
59  590000  590000  590000  590000  590000  590000
60  600000  600000  600000  600000  600000  600000
61  610000  610000  610000  610000  610000  610000
62  620000  620000  620000  620000  620000  620000
63  630000  630000  630000  630000  630000  630000
64  640000  640000  640000  640000  640000  640000
65  650000  650000  650000  650000  650000  650000
66  660000  660000  660000  660000  660000  660000
67  670000  670000  670000  670000  670000  670000
68  680000  680000  680000  680000  680000  680000
69  690000  690000  690000  690000  690000  690000
70  700000  700000  700000  700000  700000  700000
71  710000  710000  710000  710000  710000  710000
72  720000  720000  720000  720000  720000  720000
73  730000  730000  730000  730000  730000  730000
74  740000  740000  740000  740000  740000  740000
75  750000  750000  750000  750000  750000  750000
76  760000  760000  760000  760000  760000  760000
77  770000  770000  770000  770000  770000  770000
78  780000  780000  780000  780000  780000  780000
79  790000  790000  790000  790000  790000  790000
80  800000  800000  800000  800000  800000  800000
81  810000  810000  810000  810000  810000  810000
82  820000  820000  820000  820000  820000  820000
83  830000  830000  830000  830000  830000  830000
84  840000  840000  840000  840000  840000  840000
85  850000  850000  850000  850000  850000  850000
86  860000  860000  860000  860000  860000  860000
87  870000  870000  870000  870000  870000  870000
88  880000  880000  880000  880000  880000  880000
89  890000  890000  890000  890000  890000  890000
90  900000  900000  900000  900000  900000  900000
91  910000  910000  910000  910000  910000  910000
92  920000  920000  920000  920000  920000  920000
93  930000  930000  930000  930000  930000  930000
94  940000  940000  940000  940000  940000  940000
95  950000  950000  950000  950000  950000  950000
96  960000  960000  960000  960000  960000  960000
97  970000  970000  970000  970000  970000  970000
98  980000  980000  980000  980000  980000  980000
99  990000  990000  990000  990000  990000  990000
100 1000000 1000000 1000000 1000000 1000000 1000000
101 1010000 1010000 1010000 1010000 1010000 1010000
102 1020000 1020000 1020000 1020000 1020000 1020000
103 1030000 1030000 1030000 1030000 1030000 1030000
104 1040000 1040000 1040000 1040000 1040000 1040000
105 1050000 1050000 1050000 1050000 1050000 1050000
106 1060000 1060000 1060000 1060000 1060000 1060000 ;




SCALAR saw_mill 'the capacity of the saw mill, m^3/year'
    /200000/;
SCALAR playwood_mill 'the capacity of the playwood mill, m^3/year'
    /90000/;
SCALAR Hsel_line 'the capacity of the first line, production hsel ton/year'
    /220000/;
SCALAR Lsel_line 'the capacity of the second line, producinng lsel ton/year'
    /180000/;
SCALAR Pap_mill 'the capcity of the paper mill, ton/year'
    /8000/;



VARIABLES
z 'the objective'
h(i) 'Cubic meters of timber i' // getum breytt í parameter og margfaldað með r(i,n) fyrir balance
y(j) 'Cubic meters produced of product j'
q(j, k) 'Cubic meters of product j sold to destination k' // getum breytt í parameter og margfaldað með u
s(i)'Cubic meters of timber i in stock' // should be integer since all member of the constraint are integer
r(i, n) '1 if we buy n boats of timber i, 0 otherwise'
u(n,j,k) '1 if we use n boats for product j shiping to region k, 0 otherwise'
;

INTEGER VARIABLES h, y;
BINARY VARIABLES u, r;
POSITIVE VARIABLES s;

EQUATIONS
obj .. 'Maximum gross profit'

SawmillCap.. 'Maximum capacity of the saw mill'
PlywoodCap.. 'Maximum capacity of plywood mill'
HSELCap..    'Maximum capacity of HSEL production'
LSELCap..    'Maximum capacity of LSEL production'
PAPCap..     'Maximum capacity of PAP production'

;
