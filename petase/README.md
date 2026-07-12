# Stage 0/2: GOMC/GOPC 구축 재현 + PETase 발굴

논문의 "Deep-sea PETases depolymerize PET film" 파트를, Supplementary Table 5에
명시된 실제 accession으로 재현. 조립~ORF예측 과정이 GOMC/GOPC 구축 방법론
자체의 재현이며, 그 결과물로 PETase 유사서열을 탐색.

## 데이터 출처
Supplementary Table 5의 dsPETase 6개 후보 중 2개(논문에서 실제 활성이
확인된 dsPETase01, dsPETase05)를 우선 재현.

| 후보 | Accession | 서식지 | BioProject |
|---|---|---|---|
| dsPETase01 | SAMN07748057 → SRR6144754 | 마리아나 해구 4,000m | PRJNA412741 |
| dsPETase05 | SAMEA4473313 → ERR1679395 | North Su 열수구 | PRJEB15554 |

참조서열: IsPETase (WP_054022242, GenBank GAP38373.1)

## 파이프라인
원본 리드 다운로드 (prefetch/wget)
→ QC (fastp)
→ 서브샘플링 (seqkit sample, 시간/메모리 제약으로 원본의 3~9%만 사용)
→ 조립 (megahit)
→ ORF 예측 (prodigal)
→ DIAMOND 검색 (IsPETase 대비, E-value<1e-5)
→ 최고 히트 서열 추출 → MUSCLE 정렬
→ 촉매삼조체(Ser-Asp-His) 보존 여부 육안 확인

## 결과

| 단계 | dsPETase01 | dsPETase05 |
|---|---|---|
| 서브샘플링 리드 수 | ~500만 (9.18%) | ~2,985만 (8.8%) |
| 조립 콘티그 수 | 33,174 | 28,701 |
| 조립 총 길이 | - | 76.7 Mb |
| ORF(유전자) 예측 수 | 89,340 | 32,202 |
| DIAMOND 히트 수 | 3 | 2 |
| 최고 히트 Identity / E-value | 54.9% / 1.25e-77 | 51.1% / 1.83e-90 |
| 촉매삼조체(Ser-Asp-His) 보존 | Yes | Yes |

두 후보 모두 IsPETase와의 정렬에서 Ser-Asp-His 촉매 삼조체가 정확히
같은 위치에 보존된 서열을 확보함 (G-x-S-x-G 모티프, IFACE 근처 Asp,
EINGGSH 근처 His 전부 일치).

## 논문과의 비교

| | 논문 | 재현 |
|---|---|---|
| 검색 대상 | GOPC 24억 유전자 (24,395 샘플) | 개별 샘플 2개, 원본 리드의 3~9%만 사용 |
| DIAMOND 히트 | 3,954 | 3 (01) / 2 (05) |
| 최종 촉매삼조체 통과 | 1,598 → 최종 6개 후보 | 각 샘플 1개씩 확인 |

## 한계
- 원본 리드의 극히 일부만 사용 (시간/메모리 제약)
- 나머지 4개 후보(dsPETase02,03,04,06)는 미착수
- 통계적 검증 없이 단일 히트 기반 정성적 확인 수준

## 파일 위치
- `data/reference/IsPETase_ref.fasta`: 참조서열
- `data/raw/reads/`: 원본 리드 (gitignore, accession으로 재다운로드 가능)
- `data/clean/`: fastp QC 결과 (gitignore)
- `data/subsampled/`: 서브샘플링 리드 (gitignore)
- `results/assembly/`: megahit 조립 결과
- `results/orf/`: prodigal ORF 예측 결과
- `results/diamond/`: DIAMOND 검색 결과 및 정렬 파일
- `results/summary/petase_final_results.md`: 최종 결과 요약
