#!/bin/bash

# Function to display usage instructions
usage() {
    echo "Usage: $0 /path/to/directory [--fix]"
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

# Check if the provided directory exists and is accessible
if [ ! -d "$DIR" ]; then
    echo "Error: Directory '$DIR' does not exist or is not accessible."
    exit 1
fi

# Generate hashes for all files in the directory
HASH_FILE_MAP=$(mktemp)
find "$DIR" -type f -exec md5sum {} + > "$HASH_FILE_MAP"

# Identify duplicates
DUPLICATE_MAP=$(mktemp)
awk '{ print $1 }' "$HASH_FILE_MAP" | sort | uniq -d > "$DUPLICATE_MAP"

# Display results
echo "File | Duplicate"
echo "-------------------------"


while IFS= read -r line; do
    DUP_FILES=$(grep "$line" "$HASH_FILE_MAP" | awk '{ print $2 }')
    FIRST_FILE=true  # Initialize the flag for first file

    for FILE in $DUP_FILES; do
        if [ "$FIRST_FILE" == true ]; then
            echo "$FILE | No"  # First file is not a duplicate
            FIRST_FILE=false  # Set to false after processing the first file
        else
            FIRST_FILE_NAME=$(basename "$FILE")  # Get the filename of the first match
            echo "$FILE | Yes (matches $FIRST_FILE_NAME)"  # Show duplicate with first file's name
            if $FIX_MODE; then
                echo "Deleting duplicate: $FILE"
                rm "$FILE"
            fi
        fi
    done
done < "$DUPLICATE_MAP"

# Clean up
test -f "$HASH_FILE_MAP" && rm "$HASH_FILE_MAP"
test -f "$DUPLICATE_MAP" && rm "$DUPLICATE_MAP"

exit 0
