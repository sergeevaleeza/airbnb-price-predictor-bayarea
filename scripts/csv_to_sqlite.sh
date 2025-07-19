#!/bin/bash

# Usage: sh csv_to_sqlite.sh my_database.db

db_name="$1"
data_dir="./simplified"

if [ -z "$db_name" ]; then
  echo "❌ Please provide a SQLite database name (e.g., airbnb.db)"
  exit 1
fi

# Remove existing DB if exists
rm -f "$db_name"

echo "🛠️ Creating SQLite DB: $db_name"

# Loop over all CSV files in ./simplified directory
for csv_file in "$data_dir"/*.csv; do
  table_name=$(basename "$csv_file" .csv)
  table_name=$(echo "$table_name" | tr -cs 'a-zA-Z0-9' '_')  # sanitize table name

  echo "📥 Importing $csv_file → table: $table_name"

  # Create table and import using .import (requires CSV to have headers)
  sqlite3 "$db_name" <<EOF
.mode csv
.headers on
.import '$csv_file' '$table_name'
EOF

done

echo "✅ All CSVs imported into $db_name"
