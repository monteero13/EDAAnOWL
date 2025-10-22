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
        print(f"{file_path} - Valid RDF/Turtle")
        return True
    except BadSyntax as e:
        print(f"{file_path} - Syntax error: {e}")
        return False
    except Exception as e:
        print(f"{file_path} - Error: {e}")
        return False

def main():
    """Main validation function"""
    print("🔍 EDAAnOWL RDF Syntax Validation")
    
    # Define directories to check
    directories = [
        "ontology",
        "ontology/vocab", 
        "examples",
        "examples/agriculture",
        "shapes",
        "tests"
    ]
    
    valid_files = 0
    total_files = 0
    has_errors = False
    
    for directory in directories:
        if not os.path.exists(directory):
            print(f"Directory not found: {directory}")
            continue
            
        for file_path in Path(directory).glob("**/*.ttl"):
            total_files += 1
            if validate_rdf_file(file_path):
                valid_files += 1
            else:
                has_errors = True
    
    print(f"\n Validation Summary:")
    print(f"   Total files: {total_files}")
    print(f"   Valid files: {valid_files}")
    print(f"   Invalid files: {total_files - valid_files}")
    
    if has_errors:
        print("Validation failed - Syntax errors found")
        sys.exit(1)
    else:
        print("All RDF files are syntactically valid")
        sys.exit(0)

if __name__ == "__main__":
    main()