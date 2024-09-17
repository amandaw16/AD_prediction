#!/bin/bash

# Define input and output directories
input_dir="../skull_result"
output_dir="../tissue_result"

# Create output directory if it doesn't exist
mkdir -p "$output_dir"

# Get the total number of files to process
total_files=$(ls "$input_dir"/*.nii.gz | wc -l)

# Initialize counter
count=0

# Loop through each .nii.gz file in the input directory
for file in "$input_dir"/*.nii.gz; do
    count=$((count + 1))

    base_name=$(basename "$file" .nii.gz)

    # Define output file prefix (without extension, FAST adds its own suffixes)
    output_prefix="$output_dir/${base_name}_tissue"

    # Perform segmentation and skull stripping using FAST
    fast -S 1 -n 3 -t 1 -g -v -o "$output_prefix" "$file"

    # Rename and move the output segmentation masks
    mv "${output_prefix}_seg_0.nii.gz" "${output_dir}/${base_name}_csf_mask.nii.gz"
    mv "${output_prefix}_seg_1.nii.gz" "${output_dir}/${base_name}_greymatter_mask.nii.gz"
    mv "${output_prefix}_seg_2.nii.gz" "${output_dir}/${base_name}_whitematter_mask.nii.gz"

    # Remove unwanted output files
    rm "${output_prefix}_pve_*.nii.gz"

    # Calculate progress percentage
    percent=$((count * 100 / total_files))

    # Display progress
    echo -ne "Progress: $percent% ($count of $total_files)\r"
done

echo -e "\nTissue Segmentation completed for all files."
