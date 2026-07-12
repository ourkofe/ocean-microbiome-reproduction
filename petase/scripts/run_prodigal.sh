#!/usr/bin/env bash
IN="../results/assembly"
OUT="../results/orf"
mkdir -p "$OUT"

declare -a SAMPLES=(
  "SRR6144754 dsPETase01"
  "ERR1679395 dsPETase05"
)

for entry in "${SAMPLES[@]}"; do
  read -r id name <<< "$entry"
  echo "=== ORF prediction: $id ($name) ==="
  mkdir -p "${OUT}/${id}"
  prodigal \
    -i "${IN}/${id}/final.contigs.fa" \
    -a "${OUT}/${id}/proteins.faa" \
    -d "${OUT}/${id}/genes.fna" \
    -p meta \
    || echo "!!! $id prodigal 실패"
done

echo "=== ORF 예측 완료 ==="
for entry in "${SAMPLES[@]}"; do
  read -r id name <<< "$entry"
  if [ -f "${OUT}/${id}/proteins.faa" ]; then
    n=$(grep -c "^>" "${OUT}/${id}/proteins.faa")
    echo "${id} (${name}): ${n} predicted proteins"
  fi
done
