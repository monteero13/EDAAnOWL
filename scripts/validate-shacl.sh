#!/bin/bash
set -e

echo "🎯 Running SHACL validation..."

### CAMBIO: Rutas actualizadas para ejecutarse desde la raíz del repo
SHACL_FILE="docs/shapes/edaan-shapes.ttl"
DATA_FILE="${1:-docs/examples/minimal-example.ttl}" # El default es ahora el minimal-example

if [ ! -f "$SHACL_FILE" ]; then
    echo "❌ SHACL shapes file not found: $SHACL_FILE"
    exit 1
fi

if [ ! -f "$DATA_FILE" ]; then
    echo "❌ Data file not found: $DATA_FILE"
    exit 1
fi

echo "📋 Validating: $DATA_FILE"
echo "📐 Using SHACL: $SHACL_FILE"

# CAMBIO: Añadido -i para importar la ontología principal.
# Esto es VITAL para que pyshacl conozca las clases (ids:DataApp) y propiedades.
pyshacl \
    -s "$SHACL_FILE" \
    -d "$DATA_FILE" \
    -i "docs/ontology/edaan-owl.ttl" \
    -m \
    -f human

echo "✅ SHACL validation completed!"