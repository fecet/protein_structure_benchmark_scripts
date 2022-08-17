#!/bin/bash

# conda create -n AF2 python=3.8
# conda activate AF2

echo "Installing alphafold on ..."

which python

conda install -y -c conda-forge openmm==7.5.1 cudnn==8.2.1.32 cudatoolkit==11.1.1 pdbfixer==1.7
conda install -y -c bioconda hmmer==3.3.2 hhsuite==3.3.0 kalign2==2.04

# pip install --upgrade jax==0.2.14 jaxlib==0.1.69+cuda111 -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html

wget "https://github.com/deepmind/alphafold/archive/refs/tags/v2.2.0.tar.gz" && tar -xzf v2.2.0.tar.gz

ln -sf "$(pwd)/alphafold-2.2.0" "$(pwd)/alphafold"

conda env config vars set ALPHAFOLD_PATH="$(pwd)/alphafold"
export CURRENT_ENV="$CONDA_PREFIX"
conda deactivate
conda activate "$CURRENT_ENV"

pip install -r "$ALPHAFOLD_PATH/requirements.txt"

wget -P "$ALPHAFOLD_PATH/alphafold/common/" "https://git.scicore.unibas.ch/schwede/openstructure/-/raw/7102c63615b64735c4941278d92b554ec94415f8/modules/mol/alg/src/stereo_chemical_props.txt"

cd "$CONDA_PREFIX/lib/python3.8/site-packages" && patch -p0 < "$ALPHAFOLD_PATH/docker/openmm.patch"


# bash run_alphafold.sh -d ./data -o ./test -f example.fasta -t 2020-05-14

# pip install "jax[cuda]>=0.3.8,<0.4" -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html
