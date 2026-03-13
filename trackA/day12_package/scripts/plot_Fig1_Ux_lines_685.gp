H=0.0254
Uin=10.0
set terminal pngcairo size 1400,800
set output "../day12_package/fig/Fig1_Ux_lines_t685.png"
set grid
set xlabel "x/H"
set ylabel "U_x/U_in"
set key left top
set arrow from graph 0, first 0 to graph 1, first 0 nohead dt 2

f0 ="postProcessing/graphUniform_reattach/685/line.xy"
f05="postProcessing/graphUniform_reattach_y05mm/685/line.xy"
f10="postProcessing/graphUniform_reattach_y10mm/685/line.xy"

plot \
  f0  using ($1/H):($2/Uin) w l lw 2 title "reattach(line1)", \
  f05 using ($1/H):($2/Uin) w l lw 2 title "y05mm", \
  f10 using ($1/H):($2/Uin) w l lw 2 title "y10mm"
