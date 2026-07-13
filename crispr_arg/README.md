# Stage 1: CRISPR-Cas ↔ ARG 트레이드오프 재현

논문 Abstract에서 핵심 발견으로 내세운 "CRISPR-Cas 시스템과 항생제 내성
유전자(ARG) 사이의 트레이드오프"를 실제 GOMC 게놈으로 확인.

## 데이터

CNGBdb GOMC 카탈로그(https://db.cngb.org/maya/datasets/MDB0000002)에서
게놈 30개 선정 (적도 근처 15개, 북극해 15개, 위도 절댓값 기준).
논문이 실제로 쓴 핵심 변수는 위도가 아니라 OGT_prediction으로 계산한
예측 온도이므로, 위도는 표본 다양성 확보용 대리 지표로만 사용.

## 사용 도구
- CRISPRCasTyper v1.8.0 — Cas 오페론 탐지
- RGI v6.0.8 + CARD DB — ARG 탐지
- OGT_prediction (Sauer & Wang, *Bioinformatics* 2019) — 예측 최적생장온도

## 실행 순서
```
scripts/download_genomes.sh
scripts/run_crisprcastyper.sh
scripts/run_rgi.sh
(OGT_prediction repo 별도 clone 후) feature_calculation_pipeline.py → prediction_pipeline.py
scripts/summarize_results.py
```

## 최종 결과 (30개 게놈, 원본 로그 대조 검증 완료)

### 위도 그룹 기준
| | 적도 (n=15) | 북극 (n=15) |
|---|---|---|
| 평균 ARG | 0.667 | 0.400 |
| 평균 예측 OGT | 29.78°C | 32.62°C |
| Cas 확정 비율 | 6.7% (1/15) | 40.0% (6/15) |

### Cas 보유 여부 기준 (전체 30개)
| | Cas 있음 (n=7) | Cas 없음 (n=23) |
|---|---|---|
| 평균 ARG | 0.429 | 0.565 |
| 평균 예측 OGT | 31.18°C | 31.20°C |

**해석**: 위도 기준으로는 논문과 같은 방향(북극↑Cas, ↓ARG, ↑OGT)의 경향이
뚜렷했지만, Cas 보유 여부로 직접 나누면 OGT 차이가 거의 사라짐 → 위도가
실제 온도의 완벽한 대리 지표는 아님을 시사. 게놈 10개→30개로 늘렸을 때
경향성이 더 뚜렷해진 것으로 보아, 표본 규모가 신호 검출에 중요함을 확인.

상세 결과: `results/summary/stage1_결과정리.md`

## 한계
- 논문은 10,274개 게놈, nested ANOVA(P<0.001)로 통계적 검증
- 이 재현은 게놈 30개, 통계적 유의성 검정 불가 → 정성적 경향성만 관찰
- 해양 내부 온도 대비만 실시, 논문의 "해양 vs 타 생태계"(GEM 카탈로그) 비교는 미실시
