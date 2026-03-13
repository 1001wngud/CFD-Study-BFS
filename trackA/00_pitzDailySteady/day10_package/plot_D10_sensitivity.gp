set terminal pngcairo size 1200,800
set output "day10_package/fig/FigD10_2_xr_over_H_vs_y.png"

set title "Reattachment estimate (Ux=0) vs sampling height"
set xlabel "sampling height y [mm]"
set ylabel "x_r/H [-]"
set grid
set key left top
set datafile separator ","

plot "day10_package/data/reattach_vs_y.csv" u 1:3 w lp title "Ux=0 (interp)"
