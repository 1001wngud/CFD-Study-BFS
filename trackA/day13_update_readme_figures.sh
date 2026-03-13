#!/usr/bin/env bash
set -euo pipefail

README="README.md"
FIGDIR="deliverables/fig"

# sanity check
req=(
  "$FIGDIR/Fig01_SST_Ux_lines_t685.png"
  "$FIGDIR/Fig02_baseline_Ux_reattach.png"
  "$FIGDIR/Fig03_xrH_model_comparison.png"
  "$FIGDIR/Fig04_xrH_vs_y_sensitivity.png"
  "$FIGDIR/Fig05_Ux_profiles_y05_y10.png"
  "$FIGDIR/Fig06_case_schematic.png"
)
for f in "${req[@]}"; do
  [ -f "$f" ] || { echo "[ERROR] missing: $f"; exit 2; }
done

SECTION_FILE="$(mktemp)"
cat > "$SECTION_FILE" <<'MD'

<!-- FIGURES:START -->
## Curated Figures (deliverables/fig)

아래 6장은 “의심 제거(신뢰도 상승)” 관점에서 **필수 근거만 남긴 세트**입니다.  
- 정의(reattachment), 모델 민감도, y-민감도, 케이스 문맥을 한 번에 커버합니다.

### Fig01 — SST 케이스 Ux 라인 플롯 (reattachment 정의/근거)
![Fig01_SST_Ux_lines_t685](deliverables/fig/Fig01_SST_Ux_lines_t685.png)

### Fig02 — baseline Ux 기반 reattachment 정의 그림
![Fig02_baseline_Ux_reattach](deliverables/fig/Fig02_baseline_Ux_reattach.png)

### Fig03 — xr/H 모델 민감도 요약 (baseline vs SST)
![Fig03_xrH_model_comparison](deliverables/fig/Fig03_xrH_model_comparison.png)

### Fig04 — y 오프셋에 따른 xr/H 민감도
![Fig04_xrH_vs_y_sensitivity](deliverables/fig/Fig04_xrH_vs_y_sensitivity.png)

### Fig05 — y05mm / y10mm 라인 프로파일(샘플링 라인 설명 보조)
![Fig05_Ux_profiles_y05_y10](deliverables/fig/Fig05_Ux_profiles_y05_y10.png)

### Fig06 — 케이스 비교 개념도(문맥/프레이밍)
![Fig06_case_schematic](deliverables/fig/Fig06_case_schematic.png)

### Figure-to-Claim Map (각 그림이 죽이는 의심)
- Fig01/02: “reattachment를 어떻게 정의했는가?” / “다중 교차에서 어떤 룰을 썼는가?”
- Fig03: “모델만 바꿨는데 결과가 얼마나 달라졌는가?”(핵심 메시지)
- Fig04: “샘플링 라인(y) 위치에 얼마나 민감한가?”(후처리/정의 신뢰도 강화)
- Fig05: “y05mm, y10mm가 실제로 0.5mm/1.0mm 오프셋인가?”(라인 정의 의심 제거)
- Fig06: “이 케이스가 canonical BFS와 어떤 맥락에서 다른가?”(비교 프레임 안정화)

<!-- FIGURES:END -->

MD

# If markers exist, replace; else append
if [ -f "$README" ] && grep -q "<!-- FIGURES:START -->" "$README"; then
  awk -v sec="$SECTION_FILE" '
    BEGIN{
      while((getline line < sec)>0){s=s line "\n"}
      close(sec)
    }
    /<!-- FIGURES:START -->/{print s; in=1; next}
    /<!-- FIGURES:END -->/{in=0; next}
    in==0{print}
  ' "$README" > "${README}.tmp"
  mv "${README}.tmp" "$README"
  echo "[OK] replaced existing figures section in $README"
else
  printf "\n" >> "$README"
  cat "$SECTION_FILE" >> "$README"
  echo "[OK] appended figures section to $README"
fi

rm -f "$SECTION_FILE"
echo "[DONE] README updated."
