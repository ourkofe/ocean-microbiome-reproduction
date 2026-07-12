#!/usr/bin/env bash
# megahit 조립: 6개 샘플 순차 실행 (서브샘플링된 리드 사용, 시간 단축)

IN="../data/subsampled"
OUT="../results/assembly"
mkdir -p "$OUT"

declare -a SAMPLES=(
  "SRR6144754 dsPETase01"
  "SRR6057749 dsPETase03"
  "SRR1217566 dsPETase04"
  "SRR6144757 dsPETase06"
  "ERR1679394 dsPETase02"
  "ERR1679395 dsPETase05"
)

for entry in "${SAMPLES[@]}"; do
  read -r id name <<< "$entry"
  echo "=== assembling $id ($name) ==="
  megahit \
    -1 "${IN}/${id}_1.sub.fq.gz" \
    -2 "${IN}/${id}_2.sub.fq.gz" \
    -o "${OUT}/${id}" \
    --min-contig-len 1000 \
    -t 8 \
    || echo "!!! $id megahit 실패"
done

echo "=== 조립 전체 완료 ==="
for entry in "${SAMPLES[@]}"; do
  read -r id name <<< "$entry"
  if [ -f "${OUT}/${id}/final.contigs.fa" ]; then
    n=$(grep -c "^>" "${OUT}/${id}/final.contigs.fa")
    echo "${id} (${name}): ${n} contigs"
  else
    echo "${id} (${name}): 실패 또는 결과 없음"
  fi
done
