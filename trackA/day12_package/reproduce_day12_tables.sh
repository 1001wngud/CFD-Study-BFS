#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
H=0.0254
XR="$ROOT/day12_package/scripts/xr_longestNeg.awk"

echo "[INFO] ROOT=$ROOT"
echo "[INFO] Using H=$H"
echo "[INFO] Using script=$XR"
[ -f "$XR" ] || { echo "[ERROR] missing awk script: $XR"; exit 2; }

mkdir -p "$ROOT/day12_package/tables"

# 1) SST @685
(
  cd "$ROOT/11_kOmegaSST"
  for name in graphUniform_reattach graphUniform_reattach_y05mm graphUniform_reattach_y10mm; do
    f="postProcessing/$name/685/line.xy"
    [ -f "$f" ] || { echo "[ERROR] missing file: $ROOT/11_kOmegaSST/$f"; exit 3; }
    echo "==== $name @685 (x<=0.206) ===="
    awk -v H=$H -v xMax=0.206 -f "$XR" "$f"
    echo
  done
) | tee "$ROOT/day12_package/tables/STEP4A_xr_SST_685.txt"

# 2) SST time stability: 600 vs 685
(
  cd "$ROOT/11_kOmegaSST"
  for t in 600 685; do
    echo "---- time=$t (x<=0.206) ----"
    for name in graphUniform_reattach graphUniform_reattach_y05mm graphUniform_reattach_y10mm; do
      f="postProcessing/$name/$t/line.xy"
      [ -f "$f" ] || { echo "[ERROR] missing file: $ROOT/11_kOmegaSST/$f"; exit 4; }
      echo "$name"
      awk -v H=$H -v xMax=0.206 -f "$XR" "$f"
    done
    echo
  done
) | tee "$ROOT/day12_package/tables/STEP4B_xr_SST_600_vs_685.txt"

# 3) baseline @285 (re-extract)
(
  cd "$ROOT/00_pitzDailySteady"
  for name in graphUniform_reattach graphUniform_reattach_y05mm graphUniform_reattach_y10mm; do
    f="postProcessing/$name/285/line.xy"
    [ -f "$f" ] || { echo "[ERROR] missing file: $ROOT/00_pitzDailySteady/$f"; exit 5; }
    echo "==== $name @285 (x<=0.206) ===="
    awk -v H=$H -v xMax=0.206 -f "$XR" "$f"
    echo
  done
) | tee "$ROOT/day12_package/tables/BASELINE_xr_285_reextract.txt"

echo "[OK] regenerated tables in: $ROOT/day12_package/tables/"
