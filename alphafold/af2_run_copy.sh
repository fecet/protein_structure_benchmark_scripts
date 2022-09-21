#!/bin/bash
export GOMP_CPU_AFFINITY=16
# export CUDA_VISIBLE_DEVICES=7

# # native data dir
# native_dir=/data/protein_structure_benchmark/general_datasets/benchmarking_data/casp14_data

# for file in ${native_dir}/CASP14_fasta/*
# do  
#     n=${file%.*}          # remove the extension `.fasta`
#     pdb_id=${n#"${n%/*}/"}     # remove up to the last `/`
#     SECONDS=0
#     bash /cto_studio/xtalpi_lab/protein_structure_benchmark_scripts/run_alphafold.sh \
#         -d /data/alphafold_data \
#         -o /cto_studio/xtalpi_lab/Benchmark_project/af2/CASP14 \
#         -f /data/protein_structure_benchmark/general_datasets/benchmarking_data/casp14_data/CASP14_fasta/${pdb_id}.fasta \
#         -t 9999-01-01 \
#         -c reduced_dbs \
#         -e false \
#         -r false \
#         -a 4 \
#         -b true \
#         |& tee -a CASP14/CASP14.txt
# done

# native data dir
native_dir=/data/protein_structure_benchmark/general_datasets/benchmarking_data/cameo_data

for file in ${native_dir}/cameo_fasta/*
do  
    n=${file%.*}          # remove the extension `.fasta`
    pdb_id=${n#"${n%/*}/"}     # remove up to the last `/`
    SECONDS=0
    bash /cto_studio/xtalpi_lab/protein_structure_benchmark_scripts/run_alphafold.sh \
        -d /data/alphafold_data \
        -o ./test \
        -f /data/protein_structure_benchmark/general_datasets/benchmarking_data/casp14_data/CASP14_fasta/T1024.fasta  \
        -t 9999-01-01 \
        -c reduced_dbs \
        -e false \
        -r false \
        -a 4 \
        -b true \
        |& tee -a CAMEO/CAMEO.txt
done

# # native data dir
# native_dir=/data/protein_structure_benchmark/Antibody/RAB/fasta
# for file in ${native_dir}/*
# do  
#     n=${file%.*}          # remove the extension `.fasta`
#     pdb_id=${n#"${n%/*}/"}     # remove up to the last `/`
#     bash /cto_studio/xtalpi_lab/protein_structure_benchmark_scripts/run_alphafold.sh \
#         -d /data/alphafold_data \
#         -o /cto_studio/xtalpi_lab/Benchmark_project/af2/RAB \
#         -f /data/protein_structure_benchmark/Antibody/RAB/fasta/${pdb_id}.fasta \
#         -t 9999-01-01 \
#         -c reduced_dbs \
#         -e false \
#         -r false \
#         -a 3 \
#         -b true
# done
