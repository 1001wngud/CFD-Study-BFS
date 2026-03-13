# Day10 — Sampling height sensitivity (Ux=0 reattachment)

## 0) 목적
Ux=0 기반 재부착 길이(xr)가 sampling height(y)에 얼마나 민감한지 확인하고,
같은 유동장에서 y만 바꿔 비교한다.

## 1) 방법
- Case: 00_pitzDailySteady (t=285, H=0.0254 m)
- Sampling line: x 방향, y = 0.2 / 0.5 / 1.0 / 2.0 mm
- Ux 음수 -> 0 이상으로 첫 교차하는 x 위치를 선형 보간해 xr 추정

## 2) 결과
### 2.1 Ux(x) 프로파일
- FigD10_1_Ux_profiles.png

### 2.2 y 대비 xr/H
- FigD10_2_xr_over_H_vs_y.png
- Table: day10_package/data/reattach_vs_y.csv

요약:
- y=0.2 mm: xr/H = 6.714
- y=0.5 mm: xr/H = 6.697
- y=1.0 mm: xr/H = 6.640
- y=2.0 mm: xr/H = 6.445
- y 증가에 따라 xr/H가 감소하며, 범위는 0.269 (6.714 -> 6.445)

## 3) 산출물 인덱스
- raw: day10_package/raw/*_line.xy
- csv: day10_package/data/reattach_vs_y.csv
- fig: day10_package/fig/FigD10_1_Ux_profiles.png
- fig: day10_package/fig/FigD10_2_xr_over_H_vs_y.png
- gnuplot: day10_package/plot_D10_profiles.gp
- gnuplot: day10_package/plot_D10_sensitivity.gp
