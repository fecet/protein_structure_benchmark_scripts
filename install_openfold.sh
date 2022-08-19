#!/bin/bash

# conda create -n AF2 python=3.8
# conda activate AF2

echo "Installing openfold on ..."

which python

git clone https://github.com/aqlaboratory/openfold.git

export OPENFOLD_PATH="$(pwd)/openfold"

# conda env update --file "openfold_env.yml"

conda install -y -c conda-forge openmm==7.5.1 cudatoolkit==11.3 pdbfixer==1.7 setuptools=59.5.0
conda install -y -c bioconda hmmer==3.3.2 hhsuite==3.3.0 kalign2==2.04
conda install -y -c pytorch pytorch=1.12

pip install -r openfold_env.txt

pip install git+https://github.com/NVIDIA/dllogger.git

echo "Attempting to install FlashAttention"
pip install git+https://github.com/HazyResearch/flash-attention.git@5b838a8bef78186196244a4156ec35bbb58c337d || echo "Installation faild"

pushd "$CONDA_PREFIX/lib/python3.8/site-packages/" \
    && patch -p0 < "$OPENFOLD_PATH/lib/openmm.patch" \
    && popd

wget --no-check-certificate -P "$OPENFOLD_PATH/openfold/resources/" "https://git.scicore.unibas.ch/schwede/openstructure/-/raw/7102c63615b64735c4941278d92b554ec94415f8/modules/mol/alg/src/stereo_chemical_props.txt"

mkdir -p "$OPENFOLD_PATH/tests/test_data/alphafold/common"

ln -rs "$OPENFOLD_PATH/openfold/resources/stereo_chemical_props.txt" "$OPENFOLD_PATH/tests/test_data/alphafold/common"

echo "Downloading OpenFold parameters..."
bash "$OPENFOLD_PATH/scripts/download_openfold_params_huggingface.sh" "$OPENFOLD_PATH/openfold/resources"

# echo "Downloading AlphaFold parameters..."
# bash "$OPENFOLD_PATH/scripts/download_alphafold_params.sh" "$OPENFOLD_PATH/openfold/resources"
# Decompress test data
gunzip $OPENFOLD_PATH/tests/test_data/sample_feats.pickle.gz


# python $OPENFOLD_PATH/setup.py install
pip install $OPENFOLD_PATH
conda env config vars set OPENFOLD_PATH="$(pwd)/openfold" -p $CONDA_PREFIX
