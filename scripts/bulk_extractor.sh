#!/bin/bash

# =========================
# Usage: sh bulk_extractor.sh <target_directory>
# Example: sh bulk_extractor.sh ../data
# =========================

set -e  # Stop on error

# Validate argument
if [ -z "$1" ]; then
  echo "❌ Error: Please provide a target directory."
  echo "Usage: sh bulk_extractor.sh ../data"
  exit 1
fi

# Normalize input path (remove trailing slashes)
target_dir="${1%/}"

# Set output and archive directories
output_dir="$target_dir/extracted"
archive_dir="$target_dir/archives"

mkdir -p "$output_dir"
mkdir -p "$archive_dir"

echo "📁 Target directory: $target_dir"
echo "📤 Extracting to: $output_dir"
echo "📦 Archiving original .csv.gz files to: $archive_dir"

# Extract .csv.gz files only from the specified directory (not recursively)
find "$target_dir" -maxdepth 1 -name "*.csv.gz" | while read -r file; do

  echo "🗃️  Extracting: $file"
  base=$(basename "${file%.gz}")         # e.g. calendar.csv
  out="$output_dir/$base"

  if [ -e "$out" ]; then
    name="${base%.csv}"
    out="$output_dir/${name}_exported.csv"
    echo "⚠️  File exists. Renaming to: $out"
  fi

  gzip -cd "$file" > "$out"
  echo "✅ Saved: $out"

  # Move original file to archive
  mv "$file" "$archive_dir/"
  echo "📦 Moved $file to $archive_dir"
done

# Rename files in output dir to append _extracted
cd "$output_dir"

# Rename files in output dir to append _extracted if not already
for f in "$output_dir"/*.csv; do
  filename=$(basename "$f")
  if [[ "$filename" != *_extracted.csv ]]; then
    mv "$f" "$output_dir/${filename%.csv}_extracted.csv"
  fi
done 

for f in *.csv; do
  if [[ "$f" != *_extracted.csv ]]; then
    mv "$f" "${f%.csv}_extracted.csv"
  fi
done

echo "📝 Renamed extracted files (skipping already-tagged ones)"

echo "🎉 Done!"
