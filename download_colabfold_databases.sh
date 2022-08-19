#!/bin/bash
# Setup everything for using mmseqs locally
ARIA_NUM_CONN=8
WORKDIR="${1:-$(pwd)}"

cd "${WORKDIR}"

hasCommand () {
    command -v "$1" >/dev/null 2>&1
}

STRATEGY=""
if hasCommand curl;   then STRATEGY="CURL"; fi
if hasCommand wget;   then STRATEGY="WGET"; fi
if hasCommand aria2c; then STRATEGY="ARIA"; fi
if [ "$STRATEGY" = "" ]; then
	    fail "No download tool found in PATH. Please install aria2c, curl or wget."
fi

echo $STRATEGY

downloadFile() {
    URL="$1"
    OUTPUT="$2"
    set -e
    for i in $STRATEGY; do
        case "$i" in
        ARIA)
            echo "trying aria2c"
            FILENAME=$(basename "${OUTPUT}")
            DIR=$(dirname "${OUTPUT}")
            # aria2c --max-connection-per-server="$ARIA_NUM_CONN" --allow-overwrite=true --check-certificate=false -o "$FILENAME" -d "$DIR" "$URL" && set -e && return 0
            aria2c --max-connection-per-server="$ARIA_NUM_CONN"  --check-certificate=false --continue=true -o "$FILENAME" -d "$DIR" "$URL" && set -e && return 0
            ;;
        CURL)
            curl -L -o -k "$OUTPUT" "$URL" && set -e && return 0
            ;;
        WGET)
            wget -O "$OUTPUT" --no-check-certificate "$URL" && set -e && return 0
            ;;
        esac
    done
    set -e
    fail "Could not download $URL to $OUTPUT"
}

if [ ! -f UNIREF30_READY ]; then
  downloadFile "http://wwwuser.gwdg.de/~compbiol/colabfold/uniref30_2103.tar.gz" "uniref30_2103.tar.gz"
  tar xzvf "uniref30_2103.tar.gz"
  # mmseqs tsv2exprofiledb "uniref30_2103" "uniref30_2103_db"
  # mmseqs createindex "uniref30_2103_db" tmp1 --remove-tmp-files 1
  touch UNIREF30_READY
fi

if [ ! -f COLABDB_READY ]; then
  downloadFile "http://wwwuser.gwdg.de/~compbiol/colabfold/colabfold_envdb_202108.tar.gz" "colabfold_envdb_202108.tar.gz"
  tar xzvf "colabfold_envdb_202108.tar.gz"
  # mmseqs tsv2exprofiledb "colabfold_envdb_202108" "colabfold_envdb_202108_db"
  # # TODO: split memory value for createindex?
  # mmseqs createindex "colabfold_envdb_202108_db" tmp2 --remove-tmp-files 1
  touch COLABDB_READY
fi
