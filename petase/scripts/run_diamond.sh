#!/usr/bin/env bash
REF="../data/reference/IsPETase_ref.fasta"
ORF="../results/orf"
OUT="../results/diamond"
mkdir -p "$OUT"

# 1) IsPETase 참조 DB 만들기
diamond makedb --in "$REF" -d "${OUT}/ispetase_db"

declare -a SAMPLES=(
  "SRR6144754 dsPETase01"
  "ERR1679395 dsPETase05"
)

for entry in "${SAMPLES[@]}"; do
  read -r id name <<< "$entry"
  echo "=== DIAMOND search: $id ($name) ==="
  diamond blastp \
    --query "${ORF}/${id}/proteins.faa" \
    --db "${OUT}/ispetase_db" \
    --evalue 1e-5 \
    --outfmt 6 qseqid sseqid pident length evalue bitscore \
    --out "${OUT}/${id}_hits.tsv" \
    || echo "!!! $id diamond 실패"
done

echo "=== DIAMOND 검색 완료 ==="
for entry in "${SAMPLES[@]}"; do
  read -r id name <<< "$entry"
  if [ -f "${OUT}/${id}_hits.tsv" ]; then
    n=$(wc -l < "${OUT}/${id}_hits.tsv")
    echo "${id} (${name}): ${n} hits"
  fi
done
