# Note: For consistent results run with ROBOT v1.91 or higher
# Download the STATO release 1.3 (2016-03-18)
curl -L https://raw.githubusercontent.com/ISA-tools/stato/dev/releases/1.3/stato.owl > stato-full-download.owl
# Extract the terms we want without hierarchy
# Classification:  tbd in oeo-import-edits
robot merge --input stato-full-download.owl extract --method MIREOT --lower-terms stato-extract-n-hierarchy.txt --upper-term owl:topObjectProperty --intermediates none --output stato-extracted.owl
# Annotates the output module with a commentary to the origin of the content
robot annotate --input stato-extracted.owl --annotation rdfs:comment "This file contains externally imported content from the Statistics Ontology (STATO) for import into the Open Energy Ontology (OEO). It is automatically extracted using ROBOT." --output iao-extracted.owl
# Annotates each axiom with the ontology IRI, using prov:wasDerivedFrom
robot annotate --input stato-extracted.owl --annotate-derived-from true --annotate-defined-by true --output stato-extracted.owl
# Annotate with new ontology information
robot annotate --input stato-extracted.owl  --ontology-iri http://openenergy-platform.org/ontology/oeo/imports/stato-extracted.owl --version-iri http://openenergy-platform.org/ontology/oeo/dev/imports/iao-extracted.owl --output iao-extracted.owl
rm stato-full-download.owl