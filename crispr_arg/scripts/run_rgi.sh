#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/.."
mkdir -p results/rgi

conda activate rgi_env

for f in data/raw/genomes/*.fa; do
    name=$(basename "$f" .fa)
    echo "=== running RGI on $name ==="
    rgi main -i "$f" -o "results/rgi/${name}" --input_type contig --local --clean
done
