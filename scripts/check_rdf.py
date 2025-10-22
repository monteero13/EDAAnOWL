import sys, pathlib
from rdflib import Graph
root = pathlib.Path(".")
ttl_files = list(root.rglob("*.ttl"))
if not ttl_files:
    print("No TTL files found.", file=sys.stderr); sys.exit(1)
failed = 0
for f in ttl_files:
    try:
        g = Graph().parse(str(f), format="turtle")
        print(f"OK: {f} -> {len(g)} triples")
    except Exception as e:
        print(f"ERROR parsing {f}: {e}", file=sys.stderr)
        failed = 1
sys.exit(failed)
