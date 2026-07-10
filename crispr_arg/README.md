# Stage 1: CRISPR-Cas ↔ ARG 트레이드오프 재현

논문 Abstract에서 핵심 발견으로 내세운 "CRISPR-Cas 시스템과 항생제 내성 유전자(ARG) 사이의
트레이드오프"를 실제 GOMC 게놈으로 확인해봄.

## 데이터

CNGBdb GOMC 카탈로그(https://db.cngb.org/maya/datasets/MDB0000002)에서 게놈 30개 선정.
논문이 실제로 쓴 변수는 위도가 아니라 OGT_prediction으로 계산한 예측 온도라서,
위도는 다양성 확보용으로만 썼음 (게놈 선정 시 위도 극단값 기준 — 적도 근처 15개, 북극 15개).

## 사용 도구

- CRISPRCasTyper (v1.8.0) — Cas 오페론 탐지
- RGI (v6.0.8) + CARD DB — ARG 탐지
- OGT_prediction (Sauer & Wang, Bioinformatics 2019) — 예측 최적생장온도

## 실행 순서
scripts/download_genomes.sh
scripts/run_crisprcastyper.sh
scripts/run_rgi.sh
scripts/run_ogt_prediction.sh   (OGT_prediction repo 별도 clone 필요)
scripts/summarize_results.py

결과: `results/summary/stage1_final_summary.tsv`

## 결과 요약

30개 전체 기준:

| | Cas 확정 (7개) | Cas 미확정 (23개) |
|---|---|---|
| 평균 예측 OGT | 31.18°C | 31.20°C |
| 평균 ARG | 0.43 | 0.48 |

위도 기준으로는 북극 그룹 Cas 확정 비율(40%)이 적도 그룹(6.7%)보다 뚜렷하게 높았지만,
실제 예측 OGT는 두 그룹이 거의 동일했음. 즉 위도가 실제 온도의 좋은 대리 지표는 아니었음.

## 해석

- 30개 표본으로는 논문 수준(10,274개, nested ANOVA P<0.001)의 통계적 검정은 불가능.
- 논문도 이 트레이드오프가 모든 계통에서 일관되게 나타나지 않는다고 서술하고 있어서,
  우리 결과가 논문과 모순되는 건 아님 — 다만 이 표본 규모로는 신호가 뚜렷하게 드러나지 않았음.
- 왜 대규모 데이터가 필요한지를 직접 체감한 결과로 해석.

## 한계

- 게놈 10개 → 30개로 늘렸을 때 위도 기준 경향은 더 뚜렷해졌지만, 실제 OGT 기준으로는
  여전히 차이가 거의 없었음.
- CARD/CRISPRCasTyper 참조 DB 버전에 따라 결과가 달라질 수 있음.
