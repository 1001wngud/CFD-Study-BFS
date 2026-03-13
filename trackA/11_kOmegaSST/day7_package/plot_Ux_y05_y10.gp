set term pngcairo size 1400,900
set output "day7_package/fig/Ux_y05mm_y10mm.png"
set title "Ux comparison (y=0.5mm, 1.0mm)  |  xr/H=6.697, 6.640"
set xlabel "x/H"
set ylabel "Ux (m/s)"
set grid
set key left top
set arrow from 6.697, graph 0 to 6.697, graph 1 nohead lw 2
set arrow from 6.640, graph 0 to 6.640, graph 1 nohead lw 2
plot 0 w l title "0",      "day7_package/data/Ux_y05mm.dat" u 1:2 w l title "Ux (y=0.5mm)",      "day7_package/data/Ux_y10mm.dat" u 1:2 w l title "Ux (y=1.0mm)"
