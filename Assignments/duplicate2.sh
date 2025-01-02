#!/bin/bash

#Function to doplicate usage instructions
usage(){
      echo "usage: $0 /path/to/directory [--fix]"
      exit 1
}
# Ensure at least one argument is provided
if [ $# -lt 1 ]; then
    usage
fi
 # Parse arguments
 DIR=$1
 FIX_MODE=false
if [ "$2" == "--fix" ]; then
    FIX_MODE=true
fi
# Check if the provided directory exist and is accessible
if [ ! -d "$DIR" ]; then 
    echo "Error: Direcrtory '$DIR' does not exist or is not accessible."
    exit 1
fi
# Declare associative arrays
declare -A file_hash
declare -A duplicate_files

echo "Scanning directory for dupplicates: $DIR"
# iterate through all the files and calculate their hashes
while IFS= read -r -d '' file; do 
      hash=$(sha256sum "$file" | awk '{print $1}')
      if [[ -v file_hash[$hash] ]]; then 
          # Mark as duplicate
          duplicate_files[$file]=${file_hash[$hash]}
          if $FIX_MODE; then
             echo "Deleting duplicate: $file (matches ${file_hash[$hash]})"
             rm "$file"
          fi
        else
            #store the hash and file
            file_hash[$hash]=$file
        fi
done< <(find "$DIR" -type f -print0)    
        # Display results
if [ ${#duplicate_files[@]} -eq 0 ]; then
    echo "No duplicates found in the directory."
else
    echo "Duplicates found:"
    for file in "${!duplicate_files[@]}"; do
        echo "Duplicate: $file (matches ${duplicate_files[$file]})"
    done
fi
exit 0 