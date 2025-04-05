#!/bin/bash

# page qu'on va scraper
URL="https://www.selexium.com/bourse/cac-40/"
curl -s -A "Mozilla/5.0" "$URL" > /home/juliencheze/Projet-Python-Git-Linux/bash_scraper/page.html

# extrait valeur num cac 40
valeur=$(grep -oP '(?<=<span class="mx-lg-2">)[0-9]+\.[0-9]+' /home/juliencheze/Projet-Python-Git-Linux/bash_scraper/page.html | head -1)

# crea timestamp
timestamp=$(date "+%Y-%m-%d %H:%M:%S")

# affichage val terminal
echo "Val actuelle du CAC 40 : $valeur"

# enregistrement fichier CSV
echo "$timestamp,$valeur" >> /home/juliencheze/Projet-Python-Git-Linux/bash_scraper/cac40.csv

