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

# Asumimos que robot.jar está en la raíz o en el PATH
ROBOT_CMD="java -jar robot.jar"

# --- CAMBIO: Rutas actualizadas ---
ONTOLOGY_FILE="docs/ontology/edaan-owl.ttl"
VOCAB_DIR="docs/vocabularies"
EXAMPLES_DIR="docs/examples"
SHAPES_FILE="docs/shapes/edaan-shapes.ttl"
TEST_FILE="docs/tests/test-consistency.ttl"
SHACL_EXAMPLE_FILE="docs/examples/agriculture/crop-yield-demo.ttl"


# 1. Validar ontología principal
log "Validating main ontology syntax ($ONTOLOGY_FILE)..."
riot --validate "$ONTOLOGY_FILE" || error "RDF syntax error in main ontology"

# 2. Validar vocabularios
log "Validating vocabularies in $VOCAB_DIR..."
for vocab in $VOCAB_DIR/*.ttl; do
    log "  Checking $vocab"
    riot --validate "$vocab" || error "Syntax error in $vocab"
done

# 3. Validar consistencia OWL
log "Validating OWL consistency (this may take a moment)..."
# robot.jar validate cargará la ontología y sus imports (IDSA, BIGOWL, vocabs)
$ROBOT_CMD validate --input "$ONTOLOGY_FILE" || error "OWL consistency check failed"

# 4. Validar sintaxis de ejemplos
log "Validating examples syntax in $EXAMPLES_DIR..."
# Usamos find para buscar recursivamente en todos los subdirectorios
find $EXAMPLES_DIR -name "*.ttl" -print0 | while IFS= read -r -d $'\0' example; do
    log "  Checking $example"
    riot --validate "$example" || warn "Syntax issue in example $example"
done

# 5. Validar con SHACL
log "Validating $SHACL_EXAMPLE_FILE with SHACL shapes..."
# --- CAMBIO: Corregido el nombre del fichero SHACL y añadido el import -i ---
pyshacl -s "$SHAPES_FILE" \
        -i "$ONTOLOGY_FILE" \
        -d "$SHACL_EXAMPLE_FILE" \
        -m -f human || error "SHACL validation failed"

# 6. Ejecutar tests de consistencia
log "Running consistency tests from $TEST_FILE..."
# 'verify' es correcto si el test-consistency.ttl tuviera tests SPARQL.
# 'validate' es para consistencia. Usemos 'validate' ya que es lo que hace.
$ROBOT_CMD validate --input "$TEST_FILE" || warn "Test consistency check failed"

log "✅ All validations completed successfully!"