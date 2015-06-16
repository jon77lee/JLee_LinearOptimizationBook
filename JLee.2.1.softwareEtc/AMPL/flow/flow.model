
# flow.mod // Jon Lee
# 

set NODES;

set ARCS within NODES cross NODES;
    # TELLS AMPL TO CHECK THAT EACH ARC IS AN ORDERED PAIR OF NODES

param b {NODES};

param upper {ARCS};

param c {ARCS};

var x {(i,j) in ARCS} >= 0, <= upper[i,j];

minimize z:
   sum {(i,j) in ARCS} c[i,j] * x[i,j]

subject to Flow_Conservation {i in NODES}:
   sum {(i,j) in ARCS} x[i,j] - sum {(j,i) in ARCS} x[j,i] = b[i];
