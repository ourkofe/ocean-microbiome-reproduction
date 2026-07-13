# Stage 1: CRISPR-Cas ↔ ARG 트레이드오프 재현 - 최종 결과

작성일: 2026-07-13 (전체 결과 원본 대조 검증 완료)

## 데이터
- 출처: CNGBdb GOMC 게놈 카탈로그 (Dataset ID: MDB0000002)
- 게놈 30개 (적도 근처 15개, 북극해 15개) — 위도 절댓값 기준 선정
- 위도는 실제 온도의 대리 지표로만 사용, 핵심 변수는 OGT_prediction 예측값

## 사용 도구
- CRISPRCasTyper v1.8.0 — Cas 오페론 탐지
- RGI v6.0.8 + CARD DB — ARG 탐지
- OGT_prediction (Sauer & Wang, Bioinformatics 2019) — 예측 최적생장온도

## 원본 결과 파일 위치
```
crispr_arg/results/summary/stage1_final_summary.tsv   (30개 게놈 통합표)
crispr_arg/results/crisprcastyper/<게놈명>/cas_operons.tab
crispr_arg/results/rgi/<게놈명>.txt
crispr_arg/OGT_prediction/prediction/newly_predicted_OGTs.txt
```

## 30개 게놈 전체 데이터

| genome | latitude_group | cas_confirmed | arg_count | predicted_OGT |
|---|---|---|---|---|
| GOMC.bin.4441 | equator | No | 0 | 30.68 |
| GOMC.bin.4442 | equator | No | 1 | 36.29 |
| GOMC.bin.4443 | equator | No | 1 | 31.95 |
| GOMC.bin.4444 | equator | No | 0 | 45.93 (Archaea) |
| GOMC.bin.4711 | equator | No | 0 | 18.89 |
| GOMC.bin.4781 | equator | No | 0 | 29.96 |
| GOMC.bin.4782 | equator | No | 1 | 36.28 |
| GOMC.bin.7457 | equator | No | 0 | 29.41 |
| GOMC.bin.5205 | equator | No | 2 | 28.62 |
| GOMC.bin.5210 | equator | No | 0 | 24.88 |
| GOMC.bin.5211 | equator | No | 1 | 24.28 |
| GOMC.bin.5213 | equator | No | 1 | 27.26 |
| GOMC.bin.5214 | equator | **Yes (I-E)** | 0 | 25.83 |
| GOMC.bin.5215 | equator | No | 3 | 31.91 |
| GOMC.bin.5221 | equator | No | 0 | 24.46 |
| GOMC.bin.12905 | arctic | **Yes (I-E)** | 0 | 27.56 |
| GOMC.bin.12906 | arctic | No | 1 | 33.78 |
| GOMC.bin.12907 | arctic | No | 0 | 30.78 |
| GOMC.bin.12908 | arctic | **Yes (I-G/I-C/I-G/I-E/I-E, 5개 오페론)** | 1 | 35.66 |
| GOMC.bin.12909 | arctic | No | 0 | 27.66 |
| GOMC.bin.12910 | arctic | **Yes (I-G)** | 1 | 30.04 |
| GOMC.bin.12911 | arctic | No | 0 | 37.51 |
| GOMC.bin.12912 | arctic | No | 0 | 25.43 |
| GOMC.bin.12913 | arctic | **Yes (I-E, I-E 2개 오페론)** | 1 | 30.61 |
| GOMC.bin.12922 | arctic | No | 0 | 35.95 |
| GOMC.bin.12923 | arctic | No | 2 | 36.86 |
| GOMC.bin.12924 | arctic | No | 0 | 34.79 |
| GOMC.bin.12925 | arctic | No | 0 | 34.05 |
| GOMC.bin.12927 | arctic | **Yes (I-E)** | 0 | 36.95 |
| GOMC.bin.12928 | arctic | **Yes (I-B)** | 0 | 31.62 |

## 종합 통계 (원본 재검증 완료)

### ① 위도 그룹 기준 비교
| | 적도 (n=15) | 북극 (n=15) |
|---|---|---|
| 평균 ARG | 0.667 | 0.400 |
| 평균 예측 OGT | 29.78°C | 32.62°C |
| Cas 확정 비율 | 6.7% (1/15) | 40.0% (6/15) |

### ② Cas 보유 여부 기준 비교 (전체 30개)
| | Cas 있음 (n=7) | Cas 없음 (n=23) |
|---|---|---|
| 평균 ARG | 0.429 | 0.565 |
| 평균 예측 OGT | 31.18°C | 31.20°C |

## 해석

- **위도 기준으로 나누면** 논문의 트레이드오프 방향(북극↑Cas, ↓ARG, ↑OGT)과 일치하는 경향이 뚜렷하게 나타남
- **그러나 Cas 보유 여부로 직접 나누면** OGT 차이가 거의 사라짐 (31.18 vs 31.20°C) → 위도가 실제 온도의 완벽한 대리 지표는 아님을 시사
- 게놈 10개 → 30개로 표본을 늘리자 경향성이 더 뚜렷해졌음 (10개 규모에서는 트레이드오프가 명확하지 않았음)
- 30개 표본으로는 논문 수준(10,274개, nested ANOVA P<0.001)의 통계적 검증은 불가능하며, 정성적 경향 관찰 수준

## 한계
- 표본 크기가 매우 작음 (논문의 0.3% 수준)
- 통계적 유의성 검정 불가
- 해양 내부 온도 대비만 가능, 논문의 "해양 vs 타 생태계" 비교는 미실시
