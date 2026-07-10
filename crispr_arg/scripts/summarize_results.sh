"""
Stage 1 결과 종합: 게놈별 위도그룹 / Cas 오페론 확정여부 / ARG 개수 / 예측 OGT 를
하나의 tsv로 합친다.

실행 위치: crispr_arg/scripts/
필요한 입력:
  - results/crisprcastyper/GOMC.bin.*/cas_operons.tab (있으면 확정)
  - results/rgi/GOMC.bin.*.txt (헤더 제외 줄 수 = ARG 개수)
  - OGT_prediction/prediction/newly_predicted_OGTs.txt
"""
import os
import glob

BASE = os.path.join(os.path.dirname(__file__), "..")

# 위도 그룹 (다운로드 스크립트와 동일하게 하드코딩)
EQUATOR_IDS = [4441, 4442, 4443, 4444, 4711, 4781, 4782, 7457,
               5205, 5210, 5211, 5213, 5214, 5215, 5221]
ARCTIC_IDS = [12905, 12906, 12907, 12908, 12909, 12910, 12911, 12912,
              12913, 12922, 12923, 12924, 12925, 12927, 12928]


def latitude_group(bin_id):
    if bin_id in EQUATOR_IDS:
        return "equator"
    if bin_id in ARCTIC_IDS:
        return "arctic"
    return "unknown"


def get_cas_confirmed(bin_id):
    path = os.path.join(BASE, "results", "crisprcastyper",
                         f"GOMC.bin.{bin_id}", "cas_operons.tab")
    return "Yes" if os.path.isfile(path) else "No"


def get_arg_count(bin_id):
    path = os.path.join(BASE, "results", "rgi", f"GOMC.bin.{bin_id}.txt")
    if not os.path.isfile(path):
        return None
    with open(path) as f:
        lines = f.readlines()
    return max(len(lines) - 1, 0)


def load_ogt():
    path = os.path.join(BASE, "OGT_prediction", "prediction",
                         "newly_predicted_OGTs.txt")
    ogt = {}
    if not os.path.isfile(path):
        return ogt
    with open(path) as f:
        for line in f:
            parts = line.strip().split("\t")
            if len(parts) >= 2:
                species = parts[0]  # e.g. GOMC_bin_4441
                bin_id = int(species.split("_")[-1])
                ogt[bin_id] = float(parts[1])
    return ogt


def main():
    ogt_map = load_ogt()
    bin_ids = sorted(EQUATOR_IDS + ARCTIC_IDS)

    out_path = os.path.join(BASE, "results", "summary",
                             "stage1_final_summary.tsv")
    os.makedirs(os.path.dirname(out_path), exist_ok=True)

    with open(out_path, "w") as g:
        g.write("genome\tlatitude_group\tcas_confirmed\targ_count\tpredicted_OGT\n")
        for bin_id in bin_ids:
            group = latitude_group(bin_id)
            cas = get_cas_confirmed(bin_id)
            arg = get_arg_count(bin_id)
            ogt = ogt_map.get(bin_id, "NA")
            g.write(f"GOMC.bin.{bin_id}\t{group}\t{cas}\t{arg}\t{ogt}\n")

    print(f"written: {out_path}")


if __name__ == "__main__":
    main()
