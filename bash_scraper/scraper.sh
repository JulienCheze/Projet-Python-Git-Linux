#!/bin/bash

# page qu'n va  scraper
URL="https://www.selexium.com/bourse/cac-40/"
curl -s -A "Mozilla/5.0" "$URL" > page.html

#extrait valeur num cac 40
valeur=$(grep -i "Cac 40" page.html | grep -Eo "[0-9]+\.[0-9]+" | head -1)

#affichage valeur terminal
echo "Val actuelle du CAC 40 : $valeur"
