#!/usr/bin/env bash
# QC: fastp로 6개 샘플 트리밍
# SRR*: .fastq (압축 안 됨), ERR*: .fastq.gz (압축됨) - 확장자 다름에 주의

IN="../data/raw/reads"
OUT="../data/clean"
mkdir -p "$OUT"

declare -a SAMPLES=(
  "SRR6144754 fastq dsPETase01"
  "SRR6057749 fastq dsPETase03"
  "SRR1217566 fastq dsPETase04"
  "SRR6144757 fastq dsPETase06"
  "ERR1679394 fastq.gz dsPETase02"
  "ERR1679395 fastq.gz dsPETase05"
)

for entry in "${SAMPLES[@]}"; do
  read -r id ext name <<< "$entry"
  echo "=== QC: $id ($name) ==="
  fastp \
    -i "${IN}/${id}_1.${ext}" \
    -I "${IN}/${id}_2.${ext}" \
    -o "${OUT}/${id}_1.clean.fq.gz" \
    -O "${OUT}/${id}_2.clean.fq.gz" \
    -j "${OUT}/${id}_fastp.json" \
    -h "${OUT}/${id}_fastp.html" \
    --thread 8 \
    || echo "!!! $id fastp 실패"
done

echo "=== QC 전체 완료 ==="
ls -la "$OUT"
