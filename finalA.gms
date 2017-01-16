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
h(i) 'Cubic meters of timber i'
y(j) 'Cubic meters produced of product j'
q(j, k) 'Cubic meters of product j sold to destination k'
s(i)'Cubic meters of timber i in stock'
;

INTEGER VARIABLES h, y;

POSITIVE VARIABLES s;

EQUATIONS
obj .. 'Maximum gross profit'

SawmillCap.. 'Maximum capacity of the saw mill'
PlywoodCap.. 'Maximum capacity of plywood mill'
HSELCap..    'Maximum capacity of HSEL production'
LSELCap..    'Maximum capacity of LSEL production'
PAPCap..     'Maximum capacity of PAP production'
;
