#!/bin/bash

# Check if figlet is installed
if ! command -v figlet &>/dev/null; then
  echo "figlet is not installed. Please install it using your package manager."
  exit 1
fi

# Default values
NAME="Friend"
OCCASION="Holiday"
THEME="classic"

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  if [[ "$1" == "--name" ]]; then
    NAME="$2"
    shift 2
  elif [[ "$1" == "--occasion" ]]; then
    OCCASION="$2"
    shift 2
  elif [[ "$1" == "--theme" ]]; then
    THEME="$2"
    shift 2
  else
    echo "Unknown option: $1"
    echo "Usage: $0 --name <name> --occasion <occasion> --theme <theme>"
    exit 1
  fi
done

# Generate greeting message based on occasion
if [[ "$OCCASION" == "Christmas" ]]; then
  MESSAGE="Merry Christmas, $NAME!\nWishing you joy, peace, and love this holiday!"
elif [[ "$OCCASION" == "New Year" ]]; then
  MESSAGE="Happy New Year, $NAME!\nMay the year ahead bring happiness and success!"
else
  MESSAGE="Happy Holidays, $NAME!\nWishing you all the best!"
fi

# Choose border style based on theme
if [[ "$THEME" == "classic" ]]; then
  BORDER="*"
elif [[ "$THEME" == "fancy" ]]; then
  BORDER="~"
elif [[ "$THEME" == "minimal" ]]; then
  BORDER="-"
else
  BORDER="*"
fi

# Create the greeting output
BORDER_LINE=$(printf "${BORDER}%.0s" {1..30})

echo -e "\n$BORDER_LINE"
figlet -c "$(echo -e "$MESSAGE" | head -n 1)"
echo -e "$(echo -e "$MESSAGE" | tail -n +2)"
echo -e "$BORDER_LINE\n"
