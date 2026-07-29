
#!/bin/bash
###############################################################################
# monitor.sh
# Surveillance quotidienne : espace disque + erreurs dans les logs
# Bonus - Atelier Linux Partie 7
###############################################################################

PROJECT_DIR="/home/zale-xy/IA_Project"
REPORT="$PROJECT_DIR/logs/monitoring.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "===== Rapport du $DATE =====" >> "$REPORT"

# 1) Vérifier l'espace disque disponible sur la partition du projet
ESPACE_LIBRE=$(df -h "$PROJECT_DIR" | awk 'NR==2 {print $4}')
ESPACE_POURCENT=$(df -h "$PROJECT_DIR" | awk 'NR==2 {print $5}' | tr -d '%')

echo "Espace disque libre : $ESPACE_LIBRE" >> "$REPORT"

if [ "$ESPACE_POURCENT" -ge 90 ]; then
    echo "ALERTE : disque utilisé à ${ESPACE_POURCENT}% !" >> "$REPORT"
else
    echo "Espace disque OK (${ESPACE_POURCENT}% utilisé)" >> "$REPORT"
fi

# 2) Vérifier s'il y a des erreurs dans les logs
NB_ERREURS=$(grep -c "ERROR" "$PROJECT_DIR"/logs/*.log 2>/dev/null | awk -F: '{sum+=$2} END {print sum}')
NB_ERREURS=${NB_ERREURS:-0}

if [ "$NB_ERREURS" -gt 0 ]; then
    echo "ALERTE : $NB_ERREURS erreur(s) trouvée(s) dans les logs !" >> "$REPORT"
else
    echo "Aucune erreur détectée dans les logs" >> "$REPORT"
fi


