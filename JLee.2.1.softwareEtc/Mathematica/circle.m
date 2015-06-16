t = 2 Pi/5; c = Cos[t]; s = Sin[t]; n = 69; e = .75;
m = {{c, -s, 0}, {s, c, 0}, {(c - 1)/c, s/c, 1}};
x = {{1}, {0}, {0}};
y = {{0}, {Cot[t]}, {0}};
T = Partition[
   Flatten[{x, y, m.x, m.y, m.m.x, m.m.y, m.m.m.x, m.m.m.y, m.m.m.m.x,
      m.m.m.m.y, x}], {3}, {3}];
ListAnimate[
 Table[Graphics3D[
   Table[{GrayLevel[e], Polygon[{{0, 0, 0}, T[[i]], T[[i + 1]]}]},
      {i,10}], Boxed -> False, PlotRangePadding -> 2.5,
   BoxRatios -> {2, 2, 2}, SphericalRegion -> True,
   ViewPoint -> {Sin[2 Pi*t/n], Cos[2 Pi*t/n], 0},
   Lighting -> False], {t, 0, n}]]
 
