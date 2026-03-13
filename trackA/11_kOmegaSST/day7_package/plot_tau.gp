set term pngcairo size 1400,900
set output "day7_package/fig/tauLowerWall_tau_x.png"
set title "BFS Reattachment (tau_w,x)  |  vertical: xr/H=6.760"
set xlabel "x/H"
set ylabel "wallShearStress.x (Pa)"
set grid
set key left top
set arrow from 6.760, graph 0 to 6.760, graph 1 nohead lw 2
plot 0 w l title "0", "day7_package/data/tau_x.dat" u 1:2 w l title "tau_w,x"
