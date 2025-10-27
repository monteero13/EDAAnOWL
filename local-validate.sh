#!/bin/bash
set -e

IMAGE_NAME="edaanowl-validator"
ROOT_DIR=$(git rev-parse --show-toplevel)

echo "--- Construyendo imagen de validación local ($IMAGE_NAME) ---"
# Build the Docker image
docker build -t $IMAGE_NAME -f "$ROOT_DIR/Dockerfile" "$ROOT_DIR"

echo -e "\n--- 🚀 Ejecutando validación de sintaxis (check_rdf.py) ---"
# Execute the RDF syntax checking script
# Mount the root directory to /app in the container
docker run --rm \
    -v "$ROOT_DIR:/app" \
    $IMAGE_NAME \
    python3 scripts/check_rdf.py

echo -e "\n--- 🚀 Ejecutando validación SHACL (minimal-example) ---"
# Execute the SHACL validation on the minimal example
docker run --rm \
    -v "$ROOT_DIR:/app" \
    $IMAGE_NAME \
    pyshacl -s shapes/edaan-shapes.ttl -d docs/examples/minimal-example.ttl -i docs/ontology/edaan-owl.ttl -m -f human

echo -e "\n--- 🚀 Ejecutando validación de consistencia (ROBOT) ---"
# Execute the consistency validation (ROBOT)
docker run --rm \
    -v "$ROOT_DIR:/app" \
    $IMAGE_NAME \
    java -jar $ROBOT_JAR validate --input docs/ontology/edaan-owl.ttl

echo -e "\n✅ Validación local completada."