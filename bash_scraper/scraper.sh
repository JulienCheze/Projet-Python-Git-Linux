#!/bin/bash

# page qu'n va  scraper
URL="https://www.selexium.com/bourse/cac-40/"
curl -s -A "Mozilla/5.0" "$URL" > page.html
