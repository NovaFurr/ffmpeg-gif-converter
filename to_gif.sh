#!/bin/zsh

if [ $# -ne 1 ]; then
  echo "Usage: $0 <input_file>"
  exit 1
fi

input="$1"
basename="${input%.*}"
output="${basename}.gif"
palette="${basename}_palette.png"

# Create color palette
ffmpeg -y -i "$input" -vf "fps=15,scale=512:-1:flags=lanczos,palettegen" "$palette"

# Generate GIF using the palette
ffmpeg -i "$input" -i "$palette" -filter_complex "fps=15,scale=512:-1:flags=lanczos[x];[x][1:v]paletteuse" "$output"

# Clean up palette
rm "$palette"

echo "✅ GIF saved as: $output"
