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

