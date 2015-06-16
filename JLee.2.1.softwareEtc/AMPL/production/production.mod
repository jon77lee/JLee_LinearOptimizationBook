
# production.mod // Jon Lee
# 

param m integer > 0;     # NUMBER OF ROWS
param n integer > 0;     # NUMBER OF COLUMNS
set ROWS := {1..m};      # DEFINING THE SET OF ROW INDICES
set COLS := {1..n};      # DEFINING THE SET OF COLUMNS INDICES

param b {ROWS};          # RIGHT-HAND SIDE DATA
param c {COLS};          # OBJECTIVE-FUNCTION DATA
param a {ROWS,COLS};     # CONSTRAINT-MATRIX DATA

var x {j in COLS} >= 0;  # DEFINING THE (NONNEGATIVE) VARIABLES

maximize z:              # CHOOSE MAX/MIN AND NAME THE OBJ. FUNCTION
   sum {j in COLS} c[j] * x [j];  # DEFINING THE OBJECTIVE FUNCTION

subject to Constraints {i in ROWS}: # DEFINING THE CONSTRAINT INDICES
   sum {j in COLS} a[i,j] * x[j] <= b[i]; # DEFINING THE CONSTRAINTS
