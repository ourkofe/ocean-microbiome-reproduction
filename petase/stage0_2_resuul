# Stage 0/2: GOMC/GOPC 구축 재현 + PETase 발굴 - 최종 결과

작성일: 2026-07-13 (전체 결과 원본 대조 검증 완료, ERR1679395 단백질 수 정정)

## 데이터 출처
Supplementary Table 5 (Chen et al., Nature 2024)의 dsPETase 6개 후보 중
논문에서 실제 활성이 확인된 2개(dsPETase01, dsPETase05)를 재현.

| 후보 | Accession | 서식지 | BioProject |
|---|---|---|---|
| dsPETase01 | SAMN07748057 → SRR6144754 | 마리아나 해구 4,000m | PRJNA412741 |
| dsPETase05 | SAMEA4473313 → ERR1679395 | North Su 열수구 | PRJEB15554 |

참조서열: IsPETase (WP_054022242 / GenBank GAP38373.1)

## 다운로드 완료 (6개 후보 전부, QC까지)

| 샘플 | before_reads | after_reads | Q30 rate |
|---|---|---|---|
| SRR6144754 (dsPETase01) | 108,952,222 | 108,931,382 | 93.80% |
| SRR6057749 (dsPETase03) | 214,838,652 | 208,678,540 | 90.13% |
| SRR1217566 (dsPETase04) | 188,964,668 | 173,206,022 | 92.08% |
| SRR6144757 (dsPETase06) | 97,405,394 | 97,402,852 | 94.15% |
| ERR1679394 (dsPETase02) | 343,204,578 | 332,244,732 | 89.81% |
| ERR1679395 (dsPETase05) | 347,936,922 | 339,110,640 | 91.46% |

※ 파이프라인 끝까지 완주한 건 dsPETase01, 05 두 개. 나머지 4개는 다운로드+QC만 완료.

## 파이프라인
```
원본 리드 (prefetch/wget)
  → QC (fastp)
  → 서브샘플링 (seqkit sample, 원본의 3~9%만 사용 — 시간/메모리 제약)
  → 조립 (megahit, --min-contig-len 1000)
  → ORF 예측 (prodigal -p meta)
  → DIAMOND 검색 (IsPETase 대비, E-value < 1e-5)
  → 최고 히트 서열 추출 → MUSCLE 정렬
  → 촉매삼조체(Ser-Asp-His) 보존 여부 확인
```

## 결과 (원본 로그 재대조 완료)

| 단계 | dsPETase01 (SRR6144754) | dsPETase05 (ERR1679395, v2) |
|---|---|---|
| 서브샘플링 리드 수 | ~500만 (원본의 9.18%) | ~2,985만 (원본의 8.8%) |
| megahit 콘티그 수 | 33,174 | 28,701 |
| 조립 총 길이 | (미기록) | 76.7 Mb, N50 3,252bp |
| prodigal 예측 단백질 수 | 89,340 | **95,825** |
| DIAMOND 히트 수 | 3 | 2 |
| 최고 히트 서열 ID | k141_13538_3 | k119_95553_20 |
| 최고 히트 Identity | 54.9% | 51.1% |
| 최고 히트 정렬 길이 | 213 aa | 264 aa |
| 최고 히트 E-value | 1.25e-77 | 1.83e-90 |
| 최고 히트 Bitscore | 223 | 259 |
| 촉매삼조체(Ser-Asp-His) 보존 | **Yes** | **Yes** |

※ dsPETase05는 최초 시도(서브샘플 500만 리드, 2.95%)에서 히트 0개 →
  리드를 2,985만 개(8.8%)로 늘려 재조립(v2) 후 히트 확보.

## DIAMOND 전체 히트 목록

**dsPETase01 (SRR6144754), 3개 히트**
```
k141_99112_2   26.9%  245aa  1.92e-25  bitscore 89.7
k141_33523_1   32.6%  291aa  3.91e-38  bitscore 124
k141_13538_3   54.9%  213aa  1.25e-77  bitscore 223  ← 최고 히트, 촉매삼조체 검증됨
```

**dsPETase05 (ERR1679395_v2), 2개 히트**
```
k119_77817_1   47.1%   34aa  2.89e-06  bitscore 32.7  (짧은 부분 매치)
k119_95553_20  51.1%  264aa  1.83e-90  bitscore 259   ← 최고 히트, 촉매삼조체 검증됨
```

## 촉매삼조체 검증 상세

두 후보 모두 IsPETase와의 MUSCLE 정렬에서 다음 세 위치가 정확히 일치:

| 촉매잔기 | 위치(모티프) | dsPETase01 | dsPETase05 | IsPETase |
|---|---|---|---|---|
| Serine | G-x-S-x-G 모티프 | GAMGWSMGGGGTLKL | GVIGWSMGGGGTLRV | GVMGWSMGGGGSLIS |
| Aspartate | IFACE 근처 | TPTLIIACELDVVAP | APTLIFACESDVIAP | PTLIFACENDSIAP |
| Histidine | EINGGSH 모티프 | AFLEINGGDHFCAN | AFVEINGGSHYCGN | QFLEINGGSHSCAN |

정렬 원본 파일: `results/diamond/SRR01_aligned.fasta`, `results/diamond/aligned.fasta`

## 논문과의 비교

| | 논문 | 재현 |
|---|---|---|
| 검색 대상 규모 | GOPC 24억 유전자 (24,395 샘플 통합) | 개별 샘플 2개, 원본 리드의 3~9%만 사용 |
| DIAMOND 히트 | 3,954 | 3 (01) / 2 (05) |
| 촉매삼조체 통과 → 최종후보 | 1,598 → 6개 | 각 샘플 1개씩 확인 (총 2개) |

## 결론
원본 리드의 3~9%만 사용한 극소 규모 재현에서도, 논문에서 실제 활성이
확인된 두 후보(dsPETase01, 05)의 서식지 메타지놈으로부터 촉매 삼조체가
완전히 보존된 PETase 유사 서열을 성공적으로 검출함. 이는 논문의 방법론
(DIAMOND 상동성 검색 → 촉매삼조체 필터링)이 훨씬 작은 스케일에서도
동일하게 작동함을 보여줌.

## 미완료 사항
- dsPETase02, 03, 04, 06: 조립부터 미착수 (다운로드+QC만 완료)
- 계통수(FastTree) 구축 미실시
- 신호펩타이드(SignalP) 필터링 미실시
