#!/usr/bin/env bash
set -euo pipefail

ROOT="$(pwd)"
OUT="$ROOT/deliverables/fig"
mkdir -p "$OUT"

copy_or_warn () {
  local src="$1"
  local dst="$2"
  if [ -f "$src" ]; then
    cp -f "$src" "$dst"
    echo "[OK] copied: $src -> $dst"
  else
    echo "[WARN] missing (skipped): $src"
  fi
}

# --- MUST (main set) ---
copy_or_warn "day12_package/fig/Fig1_Ux_lines_t685.png" \
             "$OUT/Fig01_SST_Ux_lines_t685.png"

copy_or_warn "00_pitzDailySteady/day7_package/fig/Ux_reattach.png" \
             "$OUT/Fig02_baseline_Ux_reattach.png"

copy_or_warn "00_pitzDailySteady/day9_package/fig/Fig5_xrH_comparison.png" \
             "$OUT/Fig03_xrH_model_comparison.png"

# Fig04: may or may not exist depending on your day10 outputs
copy_or_warn "00_pitzDailySteady/day10_package/fig/FigD10_2_xr_over_H_vs_y.png" \
             "$OUT/Fig04_xrH_vs_y_sensitivity.png"

# --- OPTIONAL ---
copy_or_warn "00_pitzDailySteady/day7_package/fig/Ux_y05mm_y10mm.png" \
             "$OUT/Fig05_Ux_profiles_y05_y10.png"

# NOTE: schematic exists under 11_kOmegaSST in your scan summary
copy_or_warn "11_kOmegaSST/day9_package/fig/Fig6_case_comparison_schematic.png" \
             "$OUT/Fig06_case_schematic.png"

# index file for quick review
cat > "$OUT/FIGURE_INDEX.md" <<'MD'
# Figure Index (deliverables/fig)

- Fig01_SST_Ux_lines_t685.png  
  - SST 케이스에서 Ux(x) 라인 플롯(reattach 정의/근거 시각화)

- Fig02_baseline_Ux_reattach.png  
  - baseline 케이스 Ux 기반 reattachment 정의 그림

- Fig03_xrH_model_comparison.png  
  - baseline vs SST 모델 민감도 요약(표/비교)

- Fig04_xrH_vs_y_sensitivity.png (optional if present)  
  - y 오프셋에 따른 xr/H 민감도(있으면 설득력 상승)

- Fig05_Ux_profiles_y05_y10.png (optional)  
  - y05mm/y10mm 샘플링 라인 설명 보조

- Fig06_case_schematic.png (optional)  
  - 케이스 비교 개념도(문맥/프레이밍 보조)
MD

echo
echo "=== Deliverables figures ==="
ls -lh "$OUT" | sed -n '1,200p'
echo
echo "[OK] created: $OUT/FIGURE_INDEX.md"
