#!/bin/bash

source /vol/software/anaconda3/etc/profile.d/conda.sh
conda activate msnovelist-env

## Run evaluation for each splits weights of epoch 20+ (if existing)

# Directory where weights and config file are located
weights_dir="/home/vo87poq/MSNovelist-dev/data/weights"
config_file="/home/vo87poq/MSNovelist-dev/config.DOCKER-LIGHT.yaml"
python_script="independent_eval.py"

# Iterate over the subfolders in the "weights" directory
for subfolder in "$weights_dir"/split_*; do
    # Extract the split number from the subfolder name
    split_number=$(basename "$subfolder" | sed 's/split_//')

    # Iterate over the .hdf5 files in the current subfolder
    for weight_file in "$subfolder"/w-*.hdf5; do
        # Extract the filename (e.g., w-25-0.067-0.073.hdf5)
        filename=$(basename "$weight_file")

        # Update the "weights" value in the YAML file
        sed -i "s/weights: .*/weights: $filename/" "$config_file"

        # Update the "weights_folder" value in the YAML file
        sed -i "s|weights_folder: .*|weights_folder: $weights_dir\/split_$split_number\/|" "$config_file"

        # Run Python script with the updated configuration
        SPLIT="$split_number" python "$python_script"
    done
done