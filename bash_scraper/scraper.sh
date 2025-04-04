#!/bin/bash
URL="https://www.boursier.com/indices/cours/cac-40-FR0003500008,FR.html"
curl -s "$URL" > page.html
