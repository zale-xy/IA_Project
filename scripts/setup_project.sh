#!/bin/bash
###############################################################################
# setup_project.sh
# Script d'automatisation pour la préparation d'un environnement Linux
# dédié à un projet d'IA (Atelier Linux - Partie 6)
###############################################################################

set -e  # arrête le script si une commande échoue

echo "=========================================="
echo " Configuration automatique du projet IA"
echo "=========================================="

# ---------------------------------------------------------------------------
# 1) Demander le nom du projet
# ---------------------------------------------------------------------------
read -p "Nom du projet : " PROJECT_NAME

if [ -z "$PROJECT_NAME" ]; then
    echo "Erreur : le nom du projet ne peut pas être vide."
    exit 1
fi

# ---------------------------------------------------------------------------
# 2) Créer l'arborescence
# ---------------------------------------------------------------------------
mkdir -p "$PROJECT_NAME"/{datasets/brut,datasets/clean,config,logs,scripts,models,api,backup,documentation,shared}

ARBO_STATUS="OK"
if [ ! -d "$PROJECT_NAME/datasets/brut" ]; then
    ARBO_STATUS="ECHEC"
fi

# ---------------------------------------------------------------------------
# 3) Créer un fichier de configuration
# ---------------------------------------------------------------------------
CONFIG_FILE="$PROJECT_NAME/config/settings.conf"
cat > "$CONFIG_FILE" << CONF
PROJECT_NAME=$PROJECT_NAME
DATA_PATH=datasets/brut
MODEL_PATH=models
LOG_LEVEL=INFO
API_PORT=8000
AUTHOR=Equipe IA
DATE=$(date '+%d/%m/%Y')
CONF

CONFIG_STATUS="OK"
if [ ! -f "$CONFIG_FILE" ]; then
    CONFIG_STATUS="ECHEC"
fi

# ---------------------------------------------------------------------------
# 4) Installer les outils nécessaires
# ---------------------------------------------------------------------------
echo "Installation des outils (nécessite sudo)..."
if sudo apt update -y && sudo apt install -y git curl wget htop tree python3 python3-pip unzip; then
    SOFT_STATUS="OK"
else
    SOFT_STATUS="ECHEC"
fi

# ---------------------------------------------------------------------------
# 5) Télécharger le dataset
# ---------------------------------------------------------------------------
DATASET_URL="https://raw.githubusercontent.com/mwaskom/seaborn-data/master/iris.csv"
DATASET_PATH="$PROJECT_NAME/datasets/brut/iris.csv"

if wget -q "$DATASET_URL" -O "$DATASET_PATH"; then
    DATASET_STATUS="OK"
else
    DATASET_STATUS="ECHEC"
fi

# ---------------------------------------------------------------------------
# 6) Compresser le projet
# ---------------------------------------------------------------------------
ARCHIVE_PATH="$PROJECT_NAME/backup/${PROJECT_NAME}.tar.gz"
tar -czf "$ARCHIVE_PATH" --exclude="$PROJECT_NAME/backup" "$PROJECT_NAME"

if [ -f "$ARCHIVE_PATH" ]; then
    ARCHIVE_STATUS="OK"
else
    ARCHIVE_STATUS="ECHEC"
fi

# ---------------------------------------------------------------------------
# 7) Afficher un résumé
# ---------------------------------------------------------------------------
echo "=========================================="
echo "Projet créé"
echo "Nom : $PROJECT_NAME"
echo "Arborescence : $ARBO_STATUS"
echo "Fichier de config : $CONFIG_STATUS"
echo "Logiciels : $SOFT_STATUS"
echo "Dataset : $DATASET_STATUS"
echo "Archive : $ARCHIVE_PATH"
echo "=========================================="
echo "Installation terminée."
echo "=========================================="
