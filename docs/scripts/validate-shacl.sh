#!/bin/bash
set -e

echo "🎯 Running SHACL validation..."

SHACL_FILE="shapes/edaan-shapes.ttl"
DATA_FILE="${1:-examples/minimal-example.ttl}"

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

# Validación con pyshacl
pyshacl \
    -s "$SHACL_FILE" \
    -d "$DATA_FILE" \
    -m \
    -f human

echo "✅ SHACL validation completed!"