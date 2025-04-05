#!/bin/bash

#
echo "------ $(date '+%Y-%m-%d %H:%M:%S') ------" >> /home/juliencheze/projet-dashboard/bash_scraper/cron.log

# l'url cible
URL="https://www.selexium.com/bourse/cac-40/"
curl -s -A "Mozilla/5.0" "$URL" -o /home/juliencheze/projet-dashboard/bash_scraper/page.html

#extraire valeur
ligne=$(grep -i "Cac 40" /home/juliencheze/projet-dashboard/bash_scraper/page.html)
echo "Ligne trouvée : $ligne" >> /home/juliencheze/projet-dashboard/bash_scraper/cron.log

valeur=$(echo "$ligne" | grep -Eo "[0-9]+\.[0-9]+" | head -1)
timestamp=$(date "+%Y-%m-%d %H:%M:%S")

#on check si valeur vide
if [[ -n "$valeur" ]]; then
    echo "$timestamp,$valeur" >> /home/juliencheze/projet-dashboard/bash_scraper/cac40.csv
    echo "Ajouté au CSV : $timestamp,$valeur" >> /home/juliencheze/projet-dashboard/bash_scraper/cron.log
else
    echo "⚠️ Aucune valeur extraite — format peut-être modifié" >> /home/juliencheze/projet-dashboard/bash_scraper/cron.log
fi

