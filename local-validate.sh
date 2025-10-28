#!/bin/bash
set -e

IMAGE_NAME="edaanowl-validator"
ROOT_DIR=$(git rev-parse --show-toplevel)

echo "--- Building local validation image ($IMAGE_NAME) ---"
docker build -t $IMAGE_NAME -f "$ROOT_DIR/Dockerfile" "$ROOT_DIR"

echo -e "\n--- 🚀 Running syntax validation (check_rdf.py) ---"
docker run --rm \
    -v "$ROOT_DIR:/app" \
    $IMAGE_NAME \
    python3 scripts/check_rdf.py

echo -e "\n--- 🚀 Running SHACL validation (minimal-example vs latest) ---"
docker run --rm \
    -v "$ROOT_DIR:/app" \
    $IMAGE_NAME \
    pyshacl -s shapes/edaan-shapes.ttl \
            -d docs/examples/minimal-example.ttl \
            -i docs/latest/edaan-owl.ttl \
            -m -f human

echo -e "\n--- 🚀 Running OWL consistency validation (ROBOT on latest) ---"
docker run --rm \
    -v "$ROOT_DIR:/app" \
    $IMAGE_NAME \
    java -jar $ROBOT_JAR validate --input docs/latest/edaan-owl.ttl

echo -e "\n✅ Local validation completed."

# --- ADDED ---
echo -e "\n--- 🧹 Cleaning up old Docker images (dangling) ---"
docker image prune -f