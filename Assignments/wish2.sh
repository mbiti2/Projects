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
  case $1 in
    --name)
      NAME="$2"
      shift 2
      ;;
    --occasion)
      OCCASION="$2"
      shift 2
      ;;
    --theme)
      THEME="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 --name <name> --occasion <occasion> --theme <theme>"
      exit 1
      ;;
  esac
done

# Generate greeting message based on occasion and theme
case "$OCCASION" in
  "Christmas")
    MESSAGE="Merry Christmas, $NAME!\nWishing you joy, peace, and love this holiday!"
    ;;
  "New Year")
    MESSAGE="Happy New Year, $NAME!\nMay the year ahead bring happiness and success!"
    ;;
  *)
    MESSAGE="Happy Holidays, $NAME!\nWishing you all the best!"
    ;;
esac

# Choose border style based on theme
case "$THEME" in
  "classic")
    BORDER="*"
    ;;
  "fancy")
    BORDER="~"
    ;;
  "minimal")
    BORDER="-"
    ;;
  *)
    BORDER="*"
    ;;
esac

# Create the greeting output
echo -e "\n${BORDER}${BORDER}${BORDER}${BORDER}${BORDER}${BORDER}${BORDER}${BORDER}${BORDER}${BORDER}${BORDER}${BORDER}${BORDER}${BORDER}${BORDER}${BORDER}${BORDER}"
figlet -c "$(echo "$MESSAGE" | head -n 1)"
echo -e "${BORDER} $(echo "$MESSAGE" | tail -n +2) ${BORDER}"
echo -e "${BORDER}${BORDER}${BORDER}${BORDER}${BORDER}${BORDER}${BORDER}${BORDER}${BORDER}${BORDER}${BORDER}${BORDER}${BORDER}${BORDER}${BORDER}${BORDER}${BORDER}\n"
