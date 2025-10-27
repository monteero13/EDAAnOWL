# EDAAnOWL — (v0.2.0)

[![EDAAnOWL CI/CD](https://github.com/KhaosResearch/EDAAnOWL/actions/workflows/ci.yml/badge.svg)](https://github.com/KhaosResearch/EDAAnOWL/actions/workflows/ci.yml)

A pilot ontology for the semantic exploitation of data assets in the Agri-food (EDAA) context, aligned with the IDSA Information Model and the BIGOWL ontology.

The purpose of `EDAAnOWL` is to serve as an annotation ontology that enriches the description of Data Space assets. It allows for modeling the functional profile (inputs, outputs, parameters) of _Data Apps_ and _Data Resources_, facilitating their semantic discovery, composition into complex services, and compatibility validation.

## 🚀 Features

- **Main Ontology**: A semantic "bridge" linking `ids:DataApp` to `bigwf:Component` (from BIGOWL).
- **Profile Model**: A `:DataProfile` class to describe the data "signatures" (inputs/outputs) of assets.
- **Modular Vocabularies**: Separate, resolvable SKOS vocabularies for domains (`sector-scheme.ttl`), observed properties (`observed-properties.ttl`), etc.
- **SHACL Validation**: A set of rules in `/shapes/` to ensure the quality of asset annotations.
- **Usage Examples**: Example instances in `/docs/examples/` showing how to annotate real-world assets (like those from `catalog.json`).
- **Robust CI/CD**: A GitHub Actions workflow that validates syntax (rdflib), logical consistency (ROBOT), and data conformance (pyshacl).
- **Automatic Documentation**: Automatic generation and deployment of the ontology documentation using Widoco.

## 📁 Repository Structure

The repository structure separates _resolvable public content_ (in `/docs/`) from _validation tooling_.

- `/docs/` - Content publicly served by GitHub Pages.
  - `ontology/` - The main ontology (`edaan-owl.ttl`) and Widoco documentation.
  - `vocabularies/` - The modular SKOS vocabularies (e.g., `agro-vocab.ttl`).
  - `examples/` - Usage examples (ABox) that instantiate the ontology.
- `/scripts/` - Validation and CI scripts (Python, Bash, Batch).
- `/shapes/` - SHACL rules (`edaan-shapes.ttl`).
- `/tests/` - Turtle files for logical consistency tests.
- `Dockerfile` - Defines the local validation environment.
- `local-validate.sh` - Script for Linux/macOS to run local validation.
- `local-validate.bat` - Script for Windows (CMD) to run local validation.

## 🐳 Local Validation

This repository includes a Docker environment to precisely replicate the CI and validate your changes _before_ pushing.

**Requirements:**

- Docker Desktop (or Docker Engine) installed and running.

**Usage (Linux/macOS):**
Simply run the script from the repository root:

```bash
# Grant execution permissions once
chmod +x local-validate.sh

# Run the full validation suite
./local-validate.sh
```

**Usage (Windows):**
Simply run the script from the repository root:

```
./local-validate.bat
```
