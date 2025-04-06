#!/bin/bash

CSV_PATH="/home/juliencheze/Projet-Python-Git-Linux/bash_scraper/btc.csv"
SUMMARY_PATH="/home/juliencheze/Projet-Python-Git-Linux/bash_scraper/daily_summary.csv"

# Header du fichier de sortie
echo "date,opening,closing,high,low,volatility" > "$SUMMARY_PATH"

# On boucle sur chaque jour unique
cut -d',' -f1 "$CSV_PATH" | cut -d' ' -f1 | sort | uniq | while read -r date; do
    lines=$(grep "^$date" "$CSV_PATH")
    values=$(echo "$lines" | cut -d',' -f2)

    opening=$(echo "$values" | head -n 1)
    closing=$(echo "$values" | tail -n 1)
    high=$(echo "$values" | sort -n | tail -n 1)
    low=$(echo "$values" | sort -n | head -n 1)
    volatility=$(awk -v h="$high" -v l="$low" 'BEGIN { print h - l }')

    echo "$date,$opening,$closing,$high,$low,$volatility" >> "$SUMMARY_PATH"
done

echo "Résumé quotidien généré dans : $SUMMARY_PATH"
