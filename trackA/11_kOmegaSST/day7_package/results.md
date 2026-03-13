# Day7 Packaging Results (t=285, H=0.0254 m)

## Reattachment length summary

| 기준(정의) | xr [m] | xr/H | Δ% vs τw=0 |
|---|---:|---:|---:|
| τw=0 (wallShearStress.x 0-교차) | 0.17169281 | 6.760 | 0.000 |
| Ux=0 (graphUniform_reattach) | 0.172110 | 6.776 | +0.237 |
| Ux=0 (y=0.5mm) | 0.170104 | 6.697 | -0.932 |
| Ux=0 (y=1.0mm) | 0.168656 | 6.640 | -1.775 |

**Note**
- Ux=0 기반은 샘플링 높이(y)에 민감(near-wall shear layer 영향).
- τw=0 기반은 벽 전단(패치 정의) 기준이라 “정의”로 더 강하게 고정됨.
- 본 케이스에서는 τw=0 대비 Ux=0 값이 대략 **2% 이내**로 수렴 → 교차검증 OK.
