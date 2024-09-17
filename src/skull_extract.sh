#!/bin/bash

# Define input and output directories
input_dir="../Data" 
output_dir="../skull_result"

# Create output directory if it doesn't exist
mkdir -p "$output_dir"

# Get the total number of files to process
total_files=$(ls "$input_dir"/*.nii.gz | wc -l)

# Initialize counter
count=0

# Loop through each .nii.gz file in the input directory
for file in "$input_dir"/*.nii.gz; do
    count=$((count + 1))  # Increment the counter
    
    base_name=$(basename "$file" .nii.gz)
    
    output_file="$output_dir/${base_name}_brain.nii.gz"
    
    # Perform Skull stripping
    bet "$file" "$output_file" -R -f 0.3 -g 0 -c 79 132 80
    
    # Calculate progress percentage
    percent=$((count * 100 / total_files))
    
    # Display progress
    echo -ne "Skull Stripping Progress: $percent% ($count of $total_files)\r"
done

echo -e "\nSkull stripping completed for all files."