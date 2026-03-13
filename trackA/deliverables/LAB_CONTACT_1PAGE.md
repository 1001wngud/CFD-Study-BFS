# OpenFOAM BFS (pitzDailySteady) — V&V-minded portfolio (1 page)

## Problem
Backward-Facing Step(BFS) 분리/재부착 유동에서 **재부착 길이 xr/H**를 관심량(QoI)으로 정의하고,
튜토리얼 케이스의 재현성과 난류모델 민감도를 “증거 기반”으로 정리했습니다.

## What I did (method, evidence-first)
- Baseline: kEpsilon (`00_pitzDailySteady`, t=285)
- Model sensitivity: kOmegaSST (`11_kOmegaSST`, t=685)
- QoI 정의: Ux(x) 라인에서 **Ux<0 구간 중 최장 구간의 downstream 끝을 xr**로 정의(다중 교차 ambiguity 방지)
- 강건성(robustness):
  - 시간 안정성: SST에서 t=600→685 변화율이 매우 작음(plateau)
  - taper 구간 배제: blockMeshDict의 taper-start x=0.206 m 근거로 x<=0.206 필터 적용

## Key results (xr/H)
- Baseline(kEpsilon): xr/H ≈ 6.64 ~ 6.78 (3 lines)
- SST(kOmegaSST): xr/H ≈ 7.75 ~ 7.94 (3 lines)
→ 동일한 추출 스크립트/동일한 QoI 규칙에서 **난류모델에 따른 xr/H 민감도(약 +16~17%)**를 확인

## Why this is credible
- 모델 변경이 `momentumTransport: model` 라인에만 국한됨(diff로 증명)
- QoI 정의를 알고리즘으로 고정하고, 표/그림/스크립트로 재현 가능하게 패키징
- “잔차 수렴”이 아니라 QoI 안정성(시간) + 기하 근거(taper-start)까지 포함

## Where in the repo (quick)
- Day12 report: `day12_package/report_Day12.md`
- Curated figures: `deliverables/fig/` (Fig01~Fig06)
- Reproduce tables: `day12_package/reproduce_day12_tables.sh`

## **** External framing (짧게)
**** OpenFOAM BFS 튜토리얼은 상부 벽이 outlet 쪽으로 완만히 taper된다고 명시. :contentReference[oaicite:1]{index=1}  
**** Canonical BFS V&V(backwardFacingStep2D)는 Re_h=36000, 실험 재부착 x/H=6.26±0.10을 핵심 지표로 둠. :contentReference[oaicite:2]{index=2}  
**** NASA TMR도 동일 BFS 맥락(대략 Re_H≈36000)을 정리하고 비교 데이터를 제공. :contentReference[oaicite:3]{index=3}  
