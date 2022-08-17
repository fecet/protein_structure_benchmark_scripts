#!/bin/bash

# conda create -n colabfold python=3.8
# conda activate colabfold

echo "Installing colabfold on ..."

which python

conda install -y -c conda-forge openmm==7.5.1 cudnn==8.2.1.32 cudatoolkit==11.1.1 pdbfixer==1.7
conda install -y -c bioconda hmmer==3.3.2 hhsuite==3.3.0 kalign2==2.04


pip install "colabfold[alphafold] @ git+https://github.com/sokrypton/ColabFold"
pip install https://storage.googleapis.com/jax-releases/cuda11/jaxlib-0.3.10+cuda11.cudnn82-cp37-none-manylinux2014_x86_64.whl
pip install jax==0.3.13

# colabfold_batch <directory_with_fasta_files> <result_dir> 
