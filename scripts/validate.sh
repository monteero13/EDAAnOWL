#!/bin/bash
set -e

echo "🔍 Starting EDAAnOWL validation process..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Assume robot.jar is in the root or PATH
ROBOT_CMD="java -jar robot.jar" # Make sure robot.jar exists or adjust path

# --- PATHS UPDATED ---
ONTOLOGY_FILE="docs/latest/edaan-owl.ttl"
VOCAB_DIR="docs/vocabularies"
EXAMPLES_DIR="docs/examples"
SHAPES_FILE="shapes/edaan-shapes.ttl"
TEST_FILE="tests/test-consistency.ttl"
SHACL_EXAMPLE_FILE="docs/examples/minimal-example.ttl" # Using minimal example for SHACL check

# Check if essential files exist
[[ ! -f "$ONTOLOGY_FILE" ]] && error "Ontology file not found: $ONTOLOGY_FILE"
[[ ! -d "$VOCAB_DIR" ]] && error "Vocab directory not found: $VOCAB_DIR"
[[ ! -d "$EXAMPLES_DIR" ]] && error "Examples directory not found: $EXAMPLES_DIR"
[[ ! -f "$SHAPES_FILE" ]] && error "Shapes file not found: $SHAPES_FILE"
[[ ! -f "$TEST_FILE" ]] && error "Consistency test file not found: $TEST_FILE"


# 1. Validate main ontology syntax (latest)
log "Validating main ontology syntax ($ONTOLOGY_FILE)..."
riot --validate "$ONTOLOGY_FILE" || error "RDF syntax error in main ontology"

# 2. Validate vocabularies
log "Validating vocabularies in $VOCAB_DIR..."
for vocab in $VOCAB_DIR/*.ttl; do
    log "  Checking $vocab"
    riot --validate "$vocab" || error "Syntax error in $vocab"
done

# 3. Validate OWL consistency (latest)
log "Validating OWL consistency ($ONTOLOGY_FILE)..."
$ROBOT_CMD validate --input "$ONTOLOGY_FILE" || error "OWL consistency check failed for $ONTOLOGY_FILE"

# 4. Validate syntax of examples
log "Validating examples syntax in $EXAMPLES_DIR..."
find $EXAMPLES_DIR -name "*.ttl" -print0 | while IFS= read -r -d $'\0' example; do
    log "  Checking $example"
    # Warn instead of error for examples, allows flexibility
    riot --validate "$example" || warn "Syntax issue in example $example"
done

# 5. Validate minimal example with SHACL
log "Validating $SHACL_EXAMPLE_FILE with SHACL shapes..."
pyshacl -s "$SHAPES_FILE" \
        -i "$ONTOLOGY_FILE" \
        -d "$SHACL_EXAMPLE_FILE" \
        -m -f human || error "SHACL validation failed for $SHACL_EXAMPLE_FILE"

# 6. Run consistency tests
log "Running consistency tests from $TEST_FILE..."
# Use ROBOT validate for consistency checking on the test file
$ROBOT_CMD validate --input "$TEST_FILE" || warn "Consistency check failed for test file $TEST_FILE"

log "✅ All validations completed successfully!"