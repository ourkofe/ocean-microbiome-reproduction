#!/usr/bin/env bash
set -e

OUTDIR="../data/raw/genomes"
mkdir -p "$OUTDIR"
cd "$OUTDIR"

# Sample ID / Assembly ID / 파일명(Sample name 기반)
# 적도 근처(대서양, 위도 ~0도) 5개 + 북극해(위도 86.86) 5개
declare -a ENTRIES=(
  "CNS0704744 CNA0056696 GOMC.bin.4441"
  "CNS0704745 CNA0056699 GOMC.bin.4442"
  "CNS0704746 CNA0056702 GOMC.bin.4443"
  "CNS0704747 CNA0056706 GOMC.bin.4444"
  "CNS0705010 CNA0057814 GOMC.bin.4711"
  "CNS0711420 CNA0063543 GOMC.bin.12905"
  "CNS0711421 CNA0063546 GOMC.bin.12906"
  "CNS0711422 CNA0063551 GOMC.bin.12907"
  "CNS0711424 CNA0063561 GOMC.bin.12909"
  "CNS0711425 CNA0063566 GOMC.bin.12910"
)

for entry in "${ENTRIES[@]}"; do
  read -r sample assembly binname <<< "$entry"
  url="ftp://ftp.cngb.org/pub/CNSA/data2/CNP0004049/${sample}/${assembly}/${binname}.fa.gz"
  echo "downloading ${binname}.fa.gz ..."
  wget -c "$url"
done
