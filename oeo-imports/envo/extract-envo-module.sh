# Note: For consistent results run with ROBOT v1.91 or higher
# Download the ENVO release from 2023-13-02
curl -L https://raw.githubusercontent.com/EnvironmentOntology/envo/v2023-02-13/envo.owl > envo-full-download.owl
# Extract the terms we want with hierarchy until the upper term "entity" (IAO_0000030). 
#  -- tbd in oeo-import-edits
# Classification:  tbd in oeo-import-edits
robot merge --input envo-full-download.owl extract --method MIREOT --lower-terms envo-w-hierarchy.txt --intermediates all --upper-term http://purl.obolibrary.org/obo/BFO_0000001 --output envo-extracted-w-hierarchy.owl
# Extract the terms we want without hierarchy
robot merge --input envo-full-download.owl extract --method MIREOT --lower-terms envo-n-hierarchy.txt --upper-term owl:topObjectProperty --intermediates none --output envo-extracted-n-hierarchy.owl
# Create Extracted module and annotate with new ontology information
robot merge --input envo-extracted-w-hierarchy.owl --input envo-extracted-n-hierarchy.owl annotate --ontology-iri http://openenergy-platform.org/ontology/oeo/imports/envo-extracted.owl --version-iri http://openenergy-platform.org/ontology/oeo/dev/imports/envo-extracted.owl --output envo-extracted.owl
# Annotates the output module with a commentary to the origin of the content
robot annotate --input envo-extracted.owl --annotation rdfs:comment "This file contains externally imported content from the The Environment Ontology (ENVO) for import into the Open Energy Ontology (OEO). It is automatically extracted using ROBOT from the list of selected terms (envo-extract-w-hierarchy.txt, envo-extract-n-hierarchy.txt) located in the OEO-tools repository." --output envo-extracted.owl
# Annotates each axiom with the ontology IRI, using prov:wasDerivedFrom
robot annotate --input envo-extracted.owl --annotate-derived-from true --annotate-defined-by true --output envo-extracted.owl
## Annotate with new ontology information
#robot annotate --input envo-extracted.owl  --ontology-iri http://openenergy-platform.org/ontology/oeo/imports/envo-extracted.owl --version-iri http://openenergy-platform.org/ontology/oeo/dev/imports/envo-extracted.owl --output envo-extracted.owl
rm envo-full-download.owl
rm envo-extracted-w-hierarchy.owl
rm envo-extracted-n-hierarchy.owl