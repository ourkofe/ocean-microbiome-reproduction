#!/usr/bin/env bash
cd "$(dirname "$0")/.."

for f in data/raw/genomes/*.fa.gz; do
    name=$(basename "$f" .fa.gz)
    gunzip -kf "$f"
    cctyper "data/raw/genomes/${name}.fa" "results/crisprcastyper/${name}"
done
