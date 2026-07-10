#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/.."
mkdir -p results/crisprcastyper

conda activate crispr_env

for f in data/raw/genomes/*.fa; do
    name=$(basename "$f" .fa)
    echo "=== running cctyper on $name ==="
    cctyper "$f" "results/crisprcastyper/${name}"
done
