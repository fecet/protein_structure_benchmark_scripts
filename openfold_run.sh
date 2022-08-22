#!/bin/bash
export GOMP_CPU_AFFINITY=16
export CUDA_VISIBLE_DEVICES=6

# native data dir
native_dir=/data/protein_structure_benchmark/general_datasets/benchmarking_data/casp14_data

# for file in ${native_dir}/CASP14DM_fasta/*
# do  
#     n=${file%.*}          # remove the extension `.fasta`
#     pdb_id=${n#"${n%/*}/"}     # remove up to the last `/`

bash run_openfold.sh \
    -d /data/alphafold_data \
    -o /cto_studio/xtalpi_lab/Benchmark_project/openfold/CASP14 \
    -f /data/protein_structure_benchmark/general_datasets/benchmarking_data/casp14_data/CASP14DM_fasta \
    -t 9999-01-01 \
    -c reduced_dbs \
    -r true \
    -a 6 \
    -e model_3_ptm \
    -p /cto_studio/xtalpi_lab/protein_structure_benchmark_scripts/openfold/openfold/resources/openfold_params/finetuning_no_templ_ptm_1.pt
# done
