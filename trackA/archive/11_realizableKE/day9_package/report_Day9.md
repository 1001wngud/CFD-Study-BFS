# Track A — Backward-Facing Step (pitzDailySteady) Reattachment Length V&V Note

## 1. Case definition (FACT)
- Case path: ~/OpenFOAM/joo-13/run/portfolio_openfoam/trackA/00_pitzDailySteady
- Latest time used: t = 285
- Step height: H = 0.0254 m
- Inlet velocity: U = 10 m/s (0/U)
- Kinematic viscosity: nu = 1e-05 (constant/physicalProperties)
- Reynolds number based on step height: Re_H = U*H/nu = 25400
- Turbulence model: RAS / kEpsilon (constant/momentumTransport)
- Wall treatment: nutkWallFunction, kqRWallFunction, epsilonWallFunction (0/nut, 0/k, 0/epsilon)

## 2. Reattachment length definitions (FACT)
We report reattachment length using two commonly used definitions:
1) Wall-shear-stress criterion: lowerWall τ_w,x = 0 crossing point
2) Streamwise velocity criterion: sampling line U_x = 0 crossing point (sensitive to sampling height y)

## 3. Results (FACT)
### 3.1 τ_w = 0 (primary)
- xr_tau/H = 6.760 (xr = 0.17169281 m)

### 3.2 U_x = 0 (cross-check)
- xr_Ux/H = 6.776 (graphUniform_reattach)
- xr_Ux/H = 6.697 (y = 0.5 mm)
- xr_Ux/H = 6.640 (y = 1.0 mm)
Observation: Ux-based xr/H varies with y, but remains within ±2% of τ_w-based xr/H.

[FIGURE PLACEHOLDER]
- Fig1: tauLowerWall_tau_x.png (τ_w,x vs x/H, zero crossing)
- Fig2: Ux_reattach.png (Ux vs x/H, zero crossing at sampling line)
- Fig3: Ux_y05mm_y10mm.png (Ux vs x/H at y=0.5/1.0mm)

## 4. Reference comparison strategy (FACT+REF)
We compare in two stages:
- Stage 1 (REF): compare against Pitz–Daily / OpenFOAM-tutorial-family reference to confirm tutorial reproducibility.
- Stage 2 (REF): compare against NASA TMR 2D BFS (Driver–Seegmiller) only as contextual discussion (not 1:1 validation), because geometry/inflow BL/Re/definitions differ.

## 5. Stage 1 comparison — Pitz–Daily family (REF)
Reference: Furbo (2010) summarizes reattachment locations for Pitz–Daily case; for standard k-ε on the tutorial-type mesh (Mt1) the reattachment point is x/H = 6.75.
- This work (τ_w=0): 6.760
- Reference (k-ε, Mt1): 6.75
- Difference: +0.148%

[FIGURE PLACEHOLDER]
- Fig5: Fig5_xrH_comparison.png (bar chart: this work vs Furbo vs NASA TMR)

## 6. Stage 2 contextual comparison — NASA TMR 2D BFS (REF)
NASA TMR reports experimental reattachment x/H = 6.26 ± 0.10 at Re_H ≈ 36,000 (Driver & Seegmiller configuration).
- This work (6.760) vs NASA (6.26): +7.987%

Important: this is NOT a direct validation target for this case; it is used to explain why reattachment metrics can differ when Re, geometry/top wall, and inflow boundary layer condition differ.

[FIGURE PLACEHOLDER]
- Fig6: Fig6_case_comparison_schematic.png (schematic: why NASA TMR is not 1:1)

## 7. Conclusion (FACT + REF)
- Primary metric (τ_w=0): xr/H = 6.760 at t=285.
- Cross-check (Ux=0): y-sensitive but within ±2% of τ_w-based value.
- Agreement with Pitz–Daily-family reference (Furbo 2010 k-ε Mt1 x/H=6.75) is within +0.148%.
- Difference from NASA TMR experiment (x/H=6.26±0.10) is about +7.99%, interpreted as expected due to differing conditions; therefore reported as contextual comparison, not direct validation.

## References (REF)
- OpenFOAM v13 User Guide — Backward-facing step / pitzDailySteady tutorial description
- Furbo, E. (2010). Evaluation of RANS turbulence models... Table 4 (Pitz–Daily reattachment points)
- NASA Turbulence Modeling Resource — 2D Backward Facing Step (Driver–Seegmiller) reattachment metric

---

## Mini History (backfill)
- Day1: pitzDailySteady baseline run completed (steady RANS).
- Day6: reattachment metrics extracted (τw=0 and Ux=0 variants).
- Day7: figures/data packaged into day7_package (results.md, README, plots).
- Day8: conditions fixed (U=10 m/s, nu=1e-05, kEpsilon + wall functions) and reference-comparison logic defined.
- Day9: report write-up (traceability), figure placement, captions, REF notes.

## File Index
- Report: day9_package/report_Day9.md
- Figures:
  - day9_package/fig/tauLowerWall_tau_x.png
  - day9_package/fig/Ux_reattach.png
  - day9_package/fig/Ux_y05mm_y10mm.png
  - day9_package/fig/Fig5_xrH_comparison.png
  - day9_package/fig/Fig6_case_comparison_schematic.png
- Appendix (case snapshots):
  - day9_package/appendix/0_U.txt
  - day9_package/appendix/physicalProperties.txt
  - day9_package/appendix/momentumTransport.txt
