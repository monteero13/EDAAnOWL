#!/bin/bash
set -e

echo "🎯 Running SHACL validation..."

# --- PATHS UPDATED ---
SHACL_FILE="shapes/edaan-shapes.ttl" # Shapes are now in the root shapes/ folder
DATA_FILE="${1:-docs/examples/minimal-example.ttl}" # Examples remain in docs/examples/
ONTOLOGY_FILE="docs/latest/edaan-owl.ttl" # Ontology is now in docs/latest/

if [ ! -f "$SHACL_FILE" ]; then
    echo "❌ SHACL shapes file not found: $SHACL_FILE"
    exit 1
fi

if [ ! -f "$DATA_FILE" ]; then
    echo "❌ Data file not found: $DATA_FILE"
    exit 1
fi

if [ ! -f "$ONTOLOGY_FILE" ]; then
    echo "❌ Ontology file not found: $ONTOLOGY_FILE"
    exit 1
fi


echo "📋 Validating: $DATA_FILE"
echo "📐 Using SHACL: $SHACL_FILE"
echo "🧬 Against Ontology: $ONTOLOGY_FILE"

pyshacl \
    -s "$SHACL_FILE" \
    -d "$DATA_FILE" \
    -i "$ONTOLOGY_FILE" \ # Use the ontology from 'latest'
    -m \
    -f human

echo "✅ SHACL validation completed!"