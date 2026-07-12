#!/usr/bin/env bash
set -e

OUTDIR="../data/raw/reads"
mkdir -p "$OUTDIR"
cd "$OUTDIR"

# ---------- NCBI SRA (SRR) : dsPETase01, 03, 04, 06 ----------
# prefetch + fasterq-dump 사용 (sra-toolkit 필요)

declare -a SRR_IDS=(
  "SRR6144754 dsPETase01"
  "SRR6057749 dsPETase03"
  "SRR1217566 dsPETase04"
  "SRR6144757 dsPETase06"
)

for entry in "${SRR_IDS[@]}"; do
  read -r srr name <<< "$entry"
  echo "=== downloading $srr ($name) ==="
  prefetch "$srr"
  fasterq-dump --split-files "$srr" -O ./
done

# ---------- EBI ENA (ERR) : dsPETase02, 05 ----------
# ENA FTP 경로 규칙: 7자리 run 번호는 vol1/fastq/{앞6글자}/00{마지막1자리}/{전체accession}/
# ERR1679394 -> ERR167/004/ERR1679394/
# ERR1679395 -> ERR167/005/ERR1679395/

wget -c "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR167/004/ERR1679394/ERR1679394_1.fastq.gz"
wget -c "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR167/004/ERR1679394/ERR1679394_2.fastq.gz"
wget -c "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR167/005/ERR1679395/ERR1679395_1.fastq.gz"
wget -c "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR167/005/ERR1679395/ERR1679395_2.fastq.gz"

echo "완료. 파일 목록:"
ls -la
