# 논문 재현 프로젝트
# Ocean Microbiome Paper Reproduction

Chen et al., "Global marine microbial diversity and its potential in bioprospecting", Nature (2024) 재현 프로젝트.
https://doi.org/10.1038/s41586-024-07891-2

논문 전체를 재현하는 건 어려움이 있어, 방법론 위주로 핵심 파이프라인 두 가지만 재현.

## 진행 상황

- [x] Stage 1: CRISPR-Cas ↔ ARG 트레이드오프 (게놈 30개)
- [x] Stage 0/2: PETase 재현 (dsPETase01, 05 완료, 촉매삼조체 보존 확인)

## 폴더

- `crispr_arg/` — Stage 1
- (추가 예정) PETase 관련 폴더

## 데이터 출처

- Stage 1: CNGBdb GOMC 게놈 카탈로그 (Dataset ID: MDB0000002)
- Stage 0/2: NCBI SRA, BioProject PRJNA412741 (논문 Supplementary Table 5 accession 기반)

## 재현 스케일 (논문 대비)

| | 논문 | 재현 |
|---|---|---|
| 게놈 수 | 24,195 | 30 |
| 통계 검정 | nested ANOVA, P<0.001 | 정성적 관찰 |
