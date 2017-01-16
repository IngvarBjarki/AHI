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

ALIAS(timber, i);
ALIAS(products, j);
ALIAS(destinations, k);

Parameters
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
        Kok  0.2    /;

Variables
z 'the objective'
h(i) 'Cubic meters of timber i'
y(j) 'Cubic meters produced of product j'
q(j, k) 'Cubic meters of product j sold to destination k'
s(i)'Cubic meters of timber i in stock'
;

Integer Variables h, y;

Positive Variables s;

Equations
obj .. 'Maximum gross profit'
;