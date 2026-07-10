#!/usr/bin/env bash
set -e
# 사전 준비 (README 참고):
#   git clone https://github.com/DavidBSauer/OGT_prediction ./OGT_prediction
#   conda create -n ogt_env -c bioconda -c conda-forge bedtools trnascan-se barrnap prodigal python=3.10
#   conda activate ogt_env
#   pip install numpy scipy matplotlib biopython bcbio-gff tqdm scikit-learn matplotlib-venn
#   external_tools.txt는 feature_calculation, prediction 디렉토리 각각에 있어야 함

cd "$(dirname "$0")/../OGT_prediction"

# 게놈 목록: (bin id, domain)
declare -a GENOMES=(
  "4441 Bacteria" "4442 Bacteria" "4443 Bacteria" "4444 Archaea" "4711 Bacteria"
  "12905 Bacteria" "12906 Bacteria" "12907 Bacteria" "12909 Bacteria" "12910 Bacteria"
  "4781 Bacteria" "4782 Bacteria" "7457 Bacteria" "5205 Bacteria" "5210 Bacteria"
  "5211 Bacteria" "5213 Bacteria" "5214 Bacteria" "5215 Bacteria" "5221 Bacteria"
  "12911 Bacteria" "12912 Bacteria" "12922 Bacteria" "12923 Bacteria" "12924 Bacteria"
  "12925 Bacteria" "12908 Bacteria" "12927 Bacteria" "12928 Bacteria" "12913 Bacteria"
)

### 1) feature_calculation ###
cd feature_calculation
mkdir -p genomes

: > genome_species_file.txt
: > species_clade_file.txt

for entry in "${GENOMES[@]}"; do
  read -r id domain <<< "$entry"
  species="GOMC_bin_${id}"
  mkdir -p "genomes/${species}"
  gzip -c "../../data/raw/genomes/GOMC.bin.${id}.fa" > "genomes/${species}/${species}.fa.gz"
  echo -e "${species}.fa.gz\t${species}" >> genome_species_file.txt
  echo -e "${species}\t${domain}" >> species_clade_file.txt
done

rm -rf output feature_calculation.log
python3 feature_calculation_pipeline.py genome_species_file.txt species_clade_file.txt

### 2) prediction ###
cd ../prediction
mkdir -p genomes

: > genome_file.txt
echo -e "species\tsuperkingdom" > species_taxonomy.txt

for entry in "${GENOMES[@]}"; do
  read -r id domain <<< "$entry"
  species="GOMC_bin_${id}"
  mkdir -p "genomes/${species}"
  gzip -c "../../data/raw/genomes/GOMC.bin.${id}.fa" > "genomes/${species}/${species}.fa.gz"
  echo -e "${species}.fa.gz\t${species}" >> genome_file.txt
  echo -e "${species}\t${domain}" >> species_taxonomy.txt
done

rm -rf output prediction.log newly_predicted_OGTs.txt
python3 prediction_pipeline.py \
    ../data/calculations/prediction/regression_models/excluding_genome_size_and_rRNA/ \
    genome_file.txt species_taxonomy.txt

echo "결과: OGT_prediction/prediction/newly_predicted_OGTs.txt"
