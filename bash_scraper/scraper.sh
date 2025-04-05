#!/bin/bash


#page qu'on va scraper
URL="https://www.stelareum.io/currency/btc.html"

PAGE_PATH="/home/juliencheze/Projet-Python-Git-Linux/bash_scraper/page.html"
CSV_PATH="/home/juliencheze/Projet-Python-Git-Linux/bash_scraper/btc.csv"

curl -s -A "Mozilla/5.0" "$URL" > "$PAGE_PATH"
#extraction valeur numerique
valeur=$(grep '"price":' "$PAGE_PATH" | grep -oE '[0-9]+\.[0-9]+')
#crea timestamp
timestamp=$(date "+%Y-%m-%d %H:%M:%S")
#affichage val terminak
echo "Prix actuel du BTC : $valeur USD"
#enregistrement dans le csv

echo "$timestamp,$valeur" >> "$CSV_PATH"

