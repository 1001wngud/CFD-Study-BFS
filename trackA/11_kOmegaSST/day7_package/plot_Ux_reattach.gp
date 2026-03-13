set term pngcairo size 1400,900
set output "day7_package/fig/Ux_reattach.png"
set title "Ux along reattach line  |  vertical: xr/H=6.776"
set xlabel "x/H"
set ylabel "Ux (m/s)"
set grid
set key left top
set arrow from 6.776, graph 0 to 6.776, graph 1 nohead lw 2
plot 0 w l title "0", "day7_package/data/Ux_reattach.dat" u 1:2 w l title "Ux"
