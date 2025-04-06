#!/bin/bash

CSV_PATH="/home/juliencheze/Projet-Python-Git-Linux/bash_scraper/btc.csv"
SUMMARY_PATH="/home/juliencheze/Projet-Python-Git-Linux/bash_scraper/daily_summary.csv"

# Écrire l'en-tête du fichier de résumé
echo "date,opening,closing,high,low,vol_simple,vol_log" > "$SUMMARY_PATH"

# Boucle sur chaque date unique
cut -d',' -f1 "$CSV_PATH" | cut -d' ' -f1 | sort | uniq | while read -r date; do
    # Extraire les lignes correspondant à la date
    lines=$(grep "^$date" "$CSV_PATH")
    prices=$(echo "$lines" | cut -d',' -f2 | tr -d '\r' | grep -oE '[0-9]+\.[0-9]+')

    # Vérifie qu'on a des données
    if [ -z "$prices" ]; then
        continue
    fi

    opening=$(echo "$prices" | head -n 1)
    closing=$(echo "$prices" | tail -n 1)
    high=$(echo "$prices" | sort -n | tail -n 1)
    low=$(echo "$prices" | sort -n | head -n 1)
    vol_simple=$(awk -v h="$high" -v l="$low" 'BEGIN { print h - l }')

    # Calcul des log returns
    returns=()
    previous=""
    while read -r price; do
        if [[ -n "$previous" ]]; then
            log_return=$(awk -v p1="$previous" -v p2="$price" 'BEGIN { print log(p2/p1) }')
            returns+=("$log_return")
        fi
        previous="$price"
    done <<< "$prices"

    # Calcul écart-type
    n=${#returns[@]}
    if (( n > 1 )); then
        sum=0
        for r in "${returns[@]}"; do
            sum=$(awk -v s="$sum" -v r="$r" 'BEGIN { print s + r }')
        done
        mean=$(awk -v s="$sum" -v n="$n" 'BEGIN { print s / n }')

        var=0
        for r in "${returns[@]}"; do
            var=$(awk -v v="$var" -v r="$r" -v m="$mean" 'BEGIN { print v + (r - m)^2 }')
        done
        stddev=$(awk -v v="$var" -v n="$n" 'BEGIN { print sqrt(v / (n - 1)) }')
    else
        stddev="0"
    fi

    echo "$date,$opening,$closing,$high,$low,$vol_simple,$stddev" >> "$SUMMARY_PATH"
done

echo "Résumé quotidien généré dans : $SUMMARY_PATH"
