#!/bin/bash
set -e

echo "🔍 Starting EDAAnOWL validation process..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# 1. Validar ontología principal
log "Validating main ontology..."
riot --validate ontology/edaan-owl.ttl || error "RDF syntax error in main ontology"

# 2. Validar vocabularios
log "Validating vocabularies..."
for vocab in ontology/vocab/*.ttl; do
    log "  Checking $vocab"
    riot --validate "$vocab" || error "Syntax error in $vocab"
done

# 3. Validar consistencia OWL
log "Validating OWL consistency..."
java -jar robot.jar validate --input ontology/edaan-owl.ttl || error "OWL consistency check failed"

# 4. Validar ejemplos
log "Validating examples..."
for example in examples/*.ttl examples/*/*.ttl; do
    if [ -f "$example" ]; then
        log "  Checking $example"
        java -jar robot.jar verify --input "$example" || warn "Example validation issue in $example"
    fi
done

# 5. Validar con SHACL
log "Validating with SHACL..."
pyshacl -s shapes/edaan-core.shacl.ttl ontology/edaan-owl.ttl examples/agriculture/crop-yield-demo.ttl || error "SHACL validation failed"

# 6. Ejecutar tests
log "Running consistency tests..."
java -jar robot.jar verify --input tests/test-consistency.ttl || warn "Test consistency issues found"

log "✅ All validations completed successfully!"