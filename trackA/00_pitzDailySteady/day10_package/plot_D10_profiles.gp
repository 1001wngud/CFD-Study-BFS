set terminal pngcairo size 1400,800
set output "day10_package/fig/FigD10_1_Ux_profiles.png"

set title "Ux(x) at different sampling heights (t=285)"
set xlabel "x [m]"
set ylabel "Ux [m/s]"
set grid
set key left top

plot \
  0 w l title "Ux=0", \
  "day10_package/raw/graphUniform_reattach_y02mm_line.xy" u 1:2 w l title "y=0.2 mm", \
  "day10_package/raw/graphUniform_reattach_y05mm_line.xy" u 1:2 w l title "y=0.5 mm", \
  "day10_package/raw/graphUniform_reattach_y10mm_line.xy" u 1:2 w l title "y=1.0 mm", \
  "day10_package/raw/graphUniform_reattach_y20mm_line.xy" u 1:2 w l title "y=2.0 mm"
