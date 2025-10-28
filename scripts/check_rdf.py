#!/usr/bin/env python3
"""
RDF Syntax Validator for EDAAnOWL
Validates all Turtle files in the repository
"""

import os
import sys
from pathlib import Path
from rdflib import Graph
from rdflib.plugins.parsers.notation3 import BadSyntax

def validate_rdf_file(file_path):
    """Validate a single RDF file"""
    try:
        g = Graph()
        g.parse(file_path, format='turtle')
        print(f"✅ [OK] {file_path}")
        return True
    except BadSyntax as e:
        print(f"❌ [FAIL] {file_path} - Syntax error: {e}")
        return False
    except Exception as e:
        print(f"❌ [FAIL] {file_path} - Error: {e}")
        return False

def main():
    """Main validation function"""
    print("🔍 EDAAnOWL RDF Syntax Validation")

    # --- PATHS UPDATED ---
    directories = [
        "docs/latest", # Check the main ontology in latest
        "docs/vocabularies",
        "docs/examples",
        # Check shapes and tests in their root folders
        "shapes",
        "tests"
        # We don't necessarily need to check versioned folders (e.g., docs/0.2.0)
        # unless specifically required, as they should be immutable snapshots.
    ]

    valid_files = 0
    total_files = 0
    has_errors = False

    print(f"Checking directories: {directories}\n")

    for directory in directories:
        if not os.path.exists(directory):
            print(f"⚠️ [WARN] Directory not found, skipping: {directory}")
            continue

        # Use rglob to search recursively (useful for examples)
        for file_path in Path(directory).rglob("*.ttl"):
            total_files += 1
            if validate_rdf_file(file_path):
                valid_files += 1
            else:
                has_errors = True

    print(f"\n--- Validation Summary ---")
    print(f"   Total files: {total_files}")
    print(f"   Valid files: {valid_files}")
    print(f"   Invalid files: {total_files - valid_files}")

    if has_errors:
        print("\n❌ Validation FAILED - Syntax errors found")
        sys.exit(1)
    else:
        print("\n✅ All RDF files are syntactically valid")
        sys.exit(0)

if __name__ == "__main__":
    main()