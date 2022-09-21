#!/bin/bash
# Description: AlphaFold non-docker version
# Author: Sanjay Kumar Srikakulam

usage() {
	echo ""
	echo "Please make sure all required parameters are given"
	echo "Usage: $0 <OPTIONS>"
	echo "Required Parameters:"
	echo "-d <data_dir>         Path to directory of supporting data"
	echo "-o <output_dir>       Path to a directory that will store the results."
	echo "-f <fasta_path>       Path to a FASTA file containing sequence. If a FASTA file contains multiple sequences, then it will be folded as a multimer"
	echo "-t <max_template_date> Maximum template release date to consider (ISO-8601 format - i.e. YYYY-MM-DD). Important if folding historical test sets"
	echo "Optional Parameters:"
	echo "-g <use_gpu>          Enable NVIDIA runtime to run with GPUs (default: true)"
	echo "-r <run_relax>        Whether to run the final relaxation step on the predicted models. Turning relax off might result in predictions with distracting stereochemical violations but might help in case you are having issues with the relaxation stage (default: true)"
	echo "-e <enable_gpu_relax> Run relax on GPU if GPU is enabled (default: true)"
	echo "-n <openmm_threads>   OpenMM threads (default: all available cores)"
	echo "-a <gpu_devices>      Comma separated list of devices to pass to 'CUDA_VISIBLE_DEVICES' (default: 0)"
	echo "-m <model_preset>     Choose preset model configuration - the monomer model, the monomer model with extra ensembling, monomer model with pTM head, or multimer model (default: 'monomer')"
	echo "-c <db_preset>        Choose preset MSA database configuration - smaller genetic database config (reduced_dbs) or full genetic database config (full_dbs) (default: 'full_dbs')"
	echo "-p <use_precomputed_msas> Whether to read MSAs that have been written to disk. WARNING: This will not check if the sequence, database or configuration have changed (default: 'false')"
	echo "-l <num_multimer_predictions_per_model> How many predictions (each with a different random seed) will be generated per model. E.g. if this is 2 and there are 5 models then there will be 10 predictions per input. Note: this FLAG only applies if model_preset=multimer (default: 5)"
	echo "-b <benchmark>        Run multiple JAX model evaluations to obtain a timing that excludes the compilation time, which should be more indicative of the time required for inferencing many proteins (default: 'false')"
	echo ""
	exit 1
}

while getopts ":d:o:f:t:g:a:c:p" i; do
	case "${i}" in
	d)
		data_dir=$OPTARG
		;;
	o)
		output_dir=$OPTARG
		;;
	f)
		fasta_path=$OPTARG
		;;
	g)
		use_gpu=$OPTARG
		;;
	a)
		gpu_devices=$OPTARG
		;;
	c)
		config_preset=$OPTARG
		;;
	p)
		ckpt_path=$OPTARG
		;;
	esac
done

# Parse input and set defaults
if [[ "$data_dir" == "" || "$output_dir" == "" || "$fasta_path" == "" ]]; then
	usage
fi

if [[ "$use_gpu" == "" ]]; then
	use_gpu=true
fi

if [[ "$gpu_devices" == "" ]]; then
	gpu_devices=0
fi


if [[ "$config_preset" == "" ]]; then
	config_preset="model_1_ptm"
fi


if [[ "$ckpt_path" == "" ]]; then
	ckpt_path="$OPENFOLD_PATH/openfold/resources/openfold_params/finetuning_ptm_2.pt"
fi

# This bash script looks for the run_alphafold.py script in its current working directory, if it does not exist then exits
# alphafold_script="$current_working_dir/alphafold-2.2.0/run_alphafold.py"
# alphafold_script="$OPENFOLD_PATH/run_alphafold.py"
#
# if [ ! -f "$alphafold_script" ]; then
#     echo "Alphafold python script $alphafold_script does not exist."
#     exit 1
# fi

# Export ENVIRONMENT variables and set CUDA devices for use
# CUDA GPU control
# export CUDA_VISIBLE_DEVICES=-1
devices="cpu"
if [[ "$use_gpu" == true ]]; then

	if [[ "$gpu_devices" ]]; then
		devices="cuda:$gpu_devices"
	fi
fi

# Path and user config (change me if required)
uniref90_database_path="$data_dir/uniref90/uniref90.fasta"
uniprot_database_path="$data_dir/uniprot/uniprot.fasta"
mgnify_database_path="$data_dir/mgnify/mgy_clusters_2018_12.fa"
bfd_database_path="$data_dir/bfd/bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt"
small_bfd_database_path="$data_dir/small_bfd/bfd-first_non_consensus_sequences.fasta"
uniclust30_database_path="$data_dir/uniclust30/uniclust30_2018_08/uniclust30_2018_08"
pdb70_database_path="$data_dir/pdb70/pdb70"
pdb_seqres_database_path="$data_dir/pdb_seqres/pdb_seqres.txt"
template_mmcif_dir="$data_dir/pdb_mmcif/mmcif_files"
obsolete_pdbs_path="$data_dir/pdb_mmcif/obsolete.dat"

# Binary path (change me if required)
hhblits_binary_path=$(which hhblits)
hhsearch_binary_path=$(which hhsearch)
jackhmmer_binary_path=$(which jackhmmer)
kalign_binary_path=$(which kalign)

command_args="--output_dir=$output_dir --model_device=$devices --config_preset=$config_preset --openfold_checkpoint_path=$ckpt_path"

database_paths="--uniref90_database_path=$uniref90_database_path --mgnify_database_path=$mgnify_database_path --obsolete_pdbs_path=$obsolete_pdbs_path"

binary_paths="--hhblits_binary_path=$hhblits_binary_path --hhsearch_binary_path=$hhsearch_binary_path --jackhmmer_binary_path=$jackhmmer_binary_path --kalign_binary_path=$kalign_binary_path"

database_paths="$database_paths --pdb70_database_path=$pdb70_database_path"

database_paths="$database_paths --uniclust30_database_path=$uniclust30_database_path --bfd_database_path=$bfd_database_path"

# Run AlphaFold with required parameters
echo "($fasta_path $data_dir $database_paths $binary_paths  $command_args)"

openfold_script="$OPENFOLD_PATH/run_pretrained_openfold.py"

$(python $openfold_script $fasta_path $template_mmcif_dir $database_paths $binary_paths $command_args)
