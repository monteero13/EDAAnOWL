# Changelog

All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](https://semver.org) and follows the principles of [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Added

### Changed

### Fixed

### Removed

## [0.2.0] – 2025-10-27

### Added

- **Local Validation**: Added `Dockerfile`, `local-validate.sh` (Linux/macOS), and `local-validate.bat` (Windows) to replicate the CI environment and run all validations locally.
- **Modular Vocabularies**: Created separate SKOS vocabulary files in `/docs/vocabularies/` (e.g., `sector-scheme.ttl`, `agro-vocab.ttl`, `observed-properties.ttl`).
- **SHACL for `:DataProfile`**: Added a new shape to `edaan-shapes.ttl` to validate the structure of the core `:DataProfile` class.

### Changed

- **Repository Structure**: Refactored the file structure. Tooling (scripts, shapes, tests) has been moved from `/docs/` to dedicated root directories (`/scripts/`, `/shapes/`, `/tests/`). The `/docs/` directory now _only_ contains public content intended for GitHub Pages.
- **Modular Ontology (`edaan-owl.ttl`)**: The main ontology now uses `owl:imports` to load IDSA, BIGOWL, and the new modular vocabularies, cleaning up the main file.
- **CI/CD (`ci.yml`)**: Updated all file paths in the CI jobs to match the new repository structure.
- **Validation Scripts**: All scripts (`check_rdf.py`, `validate.sh`, `validate-shacl.sh`) have been updated to use the new file paths.
- **SHACL (`edaan-shapes.ttl`)**: Reinforced existing shapes to validate `sh:nodeKind` (e.g., `sh:IRI`) in addition to cardinality.
- **Consistency Test (`test-consistency.ttl`)**: The test file now imports the main ontology (`edaan-owl.ttl`) so the reasoner can load all necessary definitions.

### Fixed

- **Examples (`crop-yield-demo.ttl`)**: Removed the static `:compatibleWith` assertion, as compatibility is intended to be _inferred_ by a rules engine (SWRL).
- **Examples**: Updated all examples in `/docs/examples/` to use the new modular vocabulary prefixes.
- **Dockerfile**: Corrected the `WORKDIR` and `ENV` order to ensure `robot.jar` can be downloaded correctly.

### Removed

- Removed the static `:compatibleWith` property from `edaan-owl.ttl`, as compatibility will be dynamically inferred by rules.

---

## [0.1.0] – 2025-10-22

### Added

- **CI/CD**: New workflow **“EDAAnOWL CI/CD”** with two jobs:
  - `validate`: Python 3.11 + Java 17, **ROBOT** (`validate`, `reason` with ELK), **SHACL** (the _minimal example_ **must** pass), example verification, and **reports** uploaded as artifacts.
  - `docs`: Automatic documentation generation with **Widoco** and direct **commit** of the output to `/documentation` (includes WebVOWL and `.htaccess`).
- **Documentation**: Create `documentation/index.html` (alias of `index-en.html`) for a stable landing URL.

### Changed

- **RDF validation**: CI now delegates the RDF syntax check to `scripts/check_rdf.py` (DRY — single source of truth).
- **Workflow permissions**: `contents: write` enabled to allow committing `/documentation`.
- **Report structure**: Consolidated outputs under `reports/` and uploaded as artifacts.

### Fixed

- Ensure `reports/` exists before writing outputs.
- Widoco step cleans the `documentation/` directory while preserving `.gitkeep` when present.

---

## [0.0.1] – 2025-10-21

### Added

- **License**: **MIT**.
- Initial repository layout with ontology, shapes, examples, and scripts.

### Notes

- Namespace prepared for future **w3id** mappings (`https://w3id.org/EDAAnOWL/`).
- Initial examples provided as seeds to expand per use case.

[Unreleased]: https://github.com/KhaosResearch/EDAAnOWL/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/KhaosResearch/EDAAnOWL/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/KhaosResearch/EDAAnOWL/compare/v0.0.1...v0.1.0
[0.0.1]: https://github.com/KhaosResearch/EDAAnOWL/releases/tag/v0.0.1
