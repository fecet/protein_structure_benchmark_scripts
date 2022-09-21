#!/bin/bash
# Setup everything for using mmseqs locally
WORKDIR="${1:-$(pwd)}"

cd "${WORKDIR}"


if [ ! -f UNIREF30_SETUP_READY ]; then
  mmseqs tsv2exprofiledb "uniref30_2103" "uniref30_2103_db"
  mmseqs createindex "uniref30_2103_db" tmp1 --remove-tmp-files 1
  touch UNIREF30_SETUP_READY
fi

if [ ! -f COLABDB_SETUP_READY ]; then
  mmseqs tsv2exprofiledb "colabfold_envdb_202108" "colabfold_envdb_202108_db"
  # TODO: split memory value for createindex?
  mmseqs createindex "colabfold_envdb_202108_db" tmp2 --remove-tmp-files 1
  touch COLABDB_SETUP_READY
fi
