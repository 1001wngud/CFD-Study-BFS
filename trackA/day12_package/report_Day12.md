# Track A — pitzDailySteady BFS V&V (Day12)

## 1) Goal (Day12)
- Lock Day11 (kOmegaSST) results into a reproducible evidence package: commands + logs + scripts + tables + figures.
- Compare baseline (kEpsilon) vs kOmegaSST with the SAME QoI definition and the SAME extraction script.

## 2) Evidence (what I actually ran)
- Snapshot: evidence/STEP1_snapshot.txt
- Diff (baseline vs SST): evidence/STEP2_diff_baseline_vs_SST.txt

## 3) QoI Definition (critical)
- QoI: reattachment length xr/H based on Ux(x) sign change.
- Rule for multiple crossings:
  - find all contiguous regions where Ux<0
  - select the region with the maximum streamwise length (primary recirculation bubble)
  - define xr at downstream end using linear interpolation across Ux=0
- Script: scripts/xr_longestNeg.awk

## 4) Results (tables)
- Baseline @t=285: tables/STEP4C_xr_baseline_285.txt
- kOmegaSST @t=685: tables/STEP4A_xr_SST_685.txt
- Time stability (600 vs 685): tables/STEP4B_xr_SST_600_vs_685.txt

## 5) Figures
- Fig1: fig/Fig1_Ux_lines_t685.png

## 6) Robustness checks
- (A) x<=0.206 (taper-start excluded) → xr/H unchanged (see table outputs)
- (B) time stability: 600 vs 685 → Δ% small (plateau)

## 7) Limitations / red-team notes
- tau-based (wallShearStress) reattachment can be sensitive due to patch-normal involvement and geometry/patch definition.
- For this report, Ux-based QoI is the primary metric; tau-based is auxiliary.

## **** External references (for framing, not as “my data”)
- OpenFOAM v13 backward-facing step tutorial notes taper in the upper wall.
- OpenFOAM V&V backwardFacingStep2D uses Re_h=36000 and reattachment 6.26±0.1.
- NASA TMR backward-facing step validation describes Re_H≈36000 context and experimental reattachment.
