# Changelog
All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](https://semver.org) and follows the principles of [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]
### Added
- Additional domain mappings (AGROVOC/CGIAR/AIM) via `skos:exactMatch`. _(planned)_
- Extended SHACL shapes for SOSA/GeoSPARQL/QUDT constraints. _(planned)_
- GitHub Pages publishing workflow. _(planned)_
- Caching of tool JARs (ROBOT/Widoco) to speed up CI. _(planned)_

### Changed
- Restrict docs job to default branch (`main`). _(planned)_

### Fixed
- —

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

[Unreleased]: https://github.com/KhaosResearch/EDAAnOWL/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/KhaosResearch/EDAAnOWL/compare/v0.0.1...v0.1.0
[0.0.1]: https://github.com/KhaosResearch/EDAAnOWL/releases/tag/v0.0.1
