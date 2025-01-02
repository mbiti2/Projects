#!/bin/bash
duplicate() 
    # Check if the directory is provided
    if [ $# -ne 1 ]; then
        echo "Usage: $0 <directory_path>"
        exit 1
    fi

    DIR=$1

    # Check if the provided path is a valid directory
    if [ ! -d "$DIR" ]; then
        echo "Error: Directory path is invalid."
        exit 1
    fi

    declare -A file_hashes

    # Find all files in the directory and calculate their hashes
    find "$DIR" -type f -print0 | while IFS= read -r -d '' file; do
        if [ -n "$file" ]; then
            # Calculate hash of the file
            hash=$(sha256sum "$file" | cut -d ' ' -f1)
            file_hashes["$file"]=$hash
        fi
    done

    echo "Original File            | Duplicates"
    echo "-------------------------------------"

    declare -A hash_to_files

    # Group files by their hashes
    for file in "${!file_hashes[@]}"; do
        hash="${file_hashes[$file]}"
        hash_to_files[$hash]+="$file "
    done

    # Display duplicates
    for hash in "${!hash_to_files[@]}"; do
        files=(${hash_to_files[$hash]})
        if [ ${#files[@]} -gt 1 ]; then
            original_file=${files[0]}
            duplicates="${files[@]:1}"
            echo "$original_file | $duplicates"
        else
            echo "${files[0]} | No duplicates"
        fi
    done