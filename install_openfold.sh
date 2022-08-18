#!/bin/bash

# conda create -n AF2 python=3.8
# conda activate AF2

echo "Installing openfold on ..."

which python

git clone https://github.com/aqlaboratory/openfold.git

# ln -sf "$(pwd)/alphafold-2.2.0" "$(pwd)/alphafold"

export OPENFOLD_PATH="$(pwd)/openfold"

conda install -f $OPENFOLD_PATH/environment.yml

echo "Attempting to install FlashAttention"
pip install git+https://github.com/HazyResearch/flash-attention.git@5b838a8bef78186196244a4156ec35bbb58c337d && echo "Installation successful"

# export CURRENT_ENV="$CONDA_PREFIX"
# conda deactivate
# conda activate "$CURRENT_ENV"

pip install -r "$ALPHAFOLD_PATH/requirements.txt"

pip install --upgrade jax==0.2.14 jaxlib==0.1.69+cuda111 -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html

wget -P "$ALPHAFOLD_PATH/alphafold/common/" "https://git.scicore.unibas.ch/schwede/openstructure/-/raw/7102c63615b64735c4941278d92b554ec94415f8/modules/mol/alg/src/stereo_chemical_props.txt"

cd "$CONDA_PREFIX/lib/python3.8/site-packages" && patch -p0 < "$OPENFOLD_PATH/lib/openmm.patch"


# bash run_alphafold.sh -d ./data -o ./test -f example.fasta -t 2020-05-14

# pip install "jax[cuda]>=0.3.8,<0.4" -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html

conda env config vars set ALPHAFOLD_PATH="$(pwd)/alphafold"
