# Track A — OpenFOAM BFS(pitzDailySteady) V&V-style Portfolio: Project Flow

## 0. 목표(Goal)
- Backward-Facing Step(BFS) 분리/재부착 유동에서 **재부착 길이 xr/H**를 관심량(QoI)로 정의하고,
- 동일한 후처리 파이프라인으로 **baseline(kEpsilon) vs kOmegaSST**의 모델 민감도와 결과 강건성을 “증거 기반”으로 정리한다.
- 컨택용 포트폴리오 목적: **재현성(재실행/재추출 가능) + 근거(diffs/logs/스크립트/그림) + 한계(τ 기준의 민감성)**까지 포함.

## 1. 케이스/환경 (FACT)
- 루트: `~/OpenFOAM/joo-13/run/portfolio_openfoam/trackA`
- 케이스:
  - baseline: `00_pitzDailySteady` (RAS: kEpsilon, 기준 time: t=285)
  - 모델 변경: `11_kOmegaSST` (RAS: kOmegaSST, latestTime: t=685)
- Step 높이: H = 0.0254 m

## 2. 사용한 도구/유틸리티 (FACT)
- OpenFOAM 실행: `foamRun` (SIMPLE steady)
- 후처리: `foamPostProcess -func <functionObject>`
- 라인 샘플링: `graphUniform_*`가 생성하는 `postProcessing/.../line.xy`
- 시각화: gnuplot (Ux line plot 등)
- 재부착 길이 계산: awk 스크립트(선형보간 + 최장 음구간 규칙)

## 3. QoI(관심량) 정의 (FACT + 수식)
### 3.1 무차원 재부착 길이
- QoI: `xr/H`  
  - xr: Ux(x)에서 재부착(ux=0) 기준으로 정의한 위치
  - H: step height (0.0254 m)

### 3.2 Ux 기반 재부착 정의 (다중 교차 방지 규칙)
Ux(x)는 위치에 따라 여러 번 0을 교차할 수 있어서 “첫 교차” 정의는 애매할 수 있다.  
따라서 아래 룰로 **primary recirculation bubble**에 해당하는 xr을 고정한다.

- 규칙:
  1) Ux<0 인 연속 구간(negative segment)을 전부 탐지
  2) 그 중 **streamwise 길이가 가장 긴 구간(bestNeg)** 선택
  3) bestNeg의 downstream 끝에서 **Ux=0 교차를 선형보간으로 xr 계산**

- 선형보간 수식(두 점 (x1,u1<0), (x2,u2>=0)):
  - xr = x1 + (0-u1) * (x2-x1) / (u2-u1)

## 4. 기하(taper) 영향 배제 근거 (FACT)
- `system/blockMeshDict`에 `convertToMeters 0.001` → 좌표 단위는 mm.
- vertices에서 upper-wall y가 x=206mm 이후에 변함(예: y=25.4 → 16.6 mm 구간이 x=206 이후 존재).
- 따라서 taper 시작은 x=206mm = 0.206m로 근거화 가능.
- 후처리에서 `x<=0.206` 필터를 적용해 taper 구간을 배제해도 xr/H가 유지되는지 확인.

## 5. 샘플링 라인 정의(y 오프셋) 근거 (FACT)
- `system/graphUniform_reattach`: y = -0.025399
- `system/graphUniform_reattach_y05mm`: y = -0.024899 → Δy = +0.0005 m (0.5mm)
- `system/graphUniform_reattach_y10mm`: y = -0.024399 → Δy = +0.0010 m (1.0mm)
→ y05mm/y10mm 라벨이 실제로 0.5mm/1.0mm 오프셋임을 system 파일로 증명.

## 6. 핵심 결과 (FACT)

### 6.1 Baseline: kEpsilon @t=285 (x<=0.206)
(동일 스크립트로 재추출)

- graphUniform_reattach:  xr/H = 6.776402
- y05mm:                 xr/H = 6.697131
- y10mm:                 xr/H = 6.640051

범위: 6.64 ~ 6.78

### 6.2 kOmegaSST @t=685 (x<=0.206)
- graphUniform_reattach:  xr/H = 7.936759
- y05mm:                 xr/H = 7.849779
- y10mm:                 xr/H = 7.749403

범위: 7.75 ~ 7.94

### 6.3 시간 안정성(plateau) — SST t=600 vs t=685 (x<=0.206)
- reattach:  7.942307 → 7.936759  (Δ=-0.0699%)
- y05mm:     7.855078 → 7.849779  (Δ=-0.0675%)
- y10mm:     7.782667 → 7.749403  (Δ=-0.4274%)

→ QoI가 시간에 대해 거의 plateau: “임시 값” 의심을 줄임.

### 6.4 모델 민감도 요약(FACT)
baseline → SST 변화(동일 QoI 정의/동일 스크립트/동일 x<=0.206)
- reattach: +17.12%
- y05mm:    +17.21%
- y10mm:    +16.71%

## 7. 피규어(스토리에서의 역할) (FACT)
- Fig01 (SST Ux lines): reattachment 정의/근거 시각화(다중 교차 룰 포함)
- Fig02 (baseline Ux reattach): baseline에서 xr 정의가 어떻게 잡히는지 증명
- Fig03 (xr/H comparison): baseline vs SST의 핵심 메시지(모델 민감도)
- Fig04 (xr/H vs y): 샘플링 라인 위치 민감도(후처리 신뢰도 강화)
- Fig05 (Ux profiles y05/y10): y 오프셋 라인 정의 설명 보조
- Fig06 (case schematic): 케이스 문맥/비교 프레임 안정화

## 8. τ(wallShearStress) 기반 접근의 위치(FACT + 한계)
- baseline에서는 τ 기준 xr 추출을 시도했고 값이 존재했으나,
- SST 케이스에서는 functionObject 읽기 이슈/다중 음구간 등으로 “단일 xr” 고정이 논쟁적이라
  본 프로젝트에서는 **Ux 기반 QoI를 메인**, τ는 **보조/한계**로만 둔다.

**** 참고(외부): OpenFOAM의 wallShearStress는 벽 전단응력을 계산하며, 문서에서 τ = R · n 형태로 설명된다(패치 법선 의존). 따라서 τx 기준의 재부착 정의는 기하/패치 구성에 민감해질 수 있다.  
(출처는 README/보고서 외부참고 섹션에만 인용)

## 9. 재현(재추출) 방법(FACT)
- `day12_package/scripts/xr_longestNeg.awk`로 테이블 재생성
- `deliverables/fig/`에 curated figure 세트(Fig01~Fig06) 정리
- 최소 제출본: `release/trackA_release/` (deliverables + day12_package + README)

