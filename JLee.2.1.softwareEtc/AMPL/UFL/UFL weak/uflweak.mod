# uflweak.mod // Jon Lee
# 

param M integer > 1;  # NUMBER OF FACILITIES
param N integer > 1;  # NUMBER OF CUSTOMERS

set FACILITIES := {1..M};
set CUSTOMERS := {1..N};

set LINKS := FACILITIES cross CUSTOMERS;

param facility_cost {FACILITIES} :=  round(Uniform(1,100));
param shipping_cost {LINKS} :=  round(Uniform(1,100));

var W {(i,j) in LINKS} >= 0;
var Y {i in FACILITIES} binary;

minimize Total_Cost:
   sum {(i,j) in LINKS} shipping_cost[i,j] * W[i,j]
     + sum {i in FACILITIES} facility_cost[i] * Y[i];

subject to Only_Ship_If_Open {i in FACILITIES}:
   sum {(i,j) in LINKS} W[i,j] <= N * Y[i];

subject to Satisfy_Demand {j in CUSTOMERS}:
   sum {(i,j) in LINKS} W[i,j] = 1;
