#!/bin/bash

output="all_neighbourhoods.csv"
rm -f "$output"

first=1

for file in *_neighbourhoods.csv; do
  region=$(echo "$file" | sed -E 's/_County_neighbourhoods\.csv$//; s/_neighbourhoods\.csv$//; s/_/ /g')

  echo "📎 Processing: $file (region: $region)"

  if [ $first -eq 1 ]; then
    echo "region,$(head -n 1 "$file")" > "$output"
    first=0
  fi

  tail -n +2 "$file" | sed "s/^/$region,/" >> "$output"
done

echo "✅ Combined all files into: $output"
