# Note: For consistent results run with ROBOT v1.91 or higher
# Download the IAO release from 2022-11-07
curl -L https://raw.githubusercontent.com/information-artifact-ontology/IAO/v2022-11-07/iao.owl > iao-full-download.owl
# Extract the terms we want with hierarchy until the upper term "information content entity" (IAO_0000030). 
# Warning: This removes the domain of IAO_0000136 -- tbd in oeo-import-edits
# Classification:  tbd in oeo-import-edits
robot merge --input iao-full-download.owl extract --method MIREOT --lower-terms iao-w-hierarchy.txt --intermediates all --upper-term http://purl.obolibrary.org/obo/IAO_0000030 --output iao-extracted-w-hierarchy.owl
# Extract the terms we want without hierarchy
robot merge --input iao-full-download.owl extract --method MIREOT --lower-terms iao-n-hierarchy.txt --upper-term owl:topObjectProperty --intermediates none --output iao-extracted-n-hierarchy.owl
# Create Extracted module and annotate with new ontology information
robot merge --input iao-extracted-w-hierarchy.owl --input iao-extracted-n-hierarchy.owl annotate --ontology-iri http://openenergy-platform.org/ontology/oeo/imports/iao-extracted.owl --version-iri http://openenergy-platform.org/ontology/oeo/dev/imports/iao-extracted.owl --output iao-extracted.owl
# Annotates the output module with a commentary to the origin of the content
robot annotate --input iao-extracted.owl --annotation rdfs:comment "This file contains externally imported content from the Information Artifact Ontology (IAO) for import into the Open Energy Ontology (OEO). It is automatically extracted using ROBOT from the list of selected terms (iao-extract-w-hierarchy.txt, iao-extract-n-hierarchy.txt) located in the OEO-tools repository." --output iao-extracted.owl
# Annotates each axiom with the ontology IRI, using prov:wasDerivedFrom
robot annotate --input iao-extracted.owl --annotate-derived-from true --annotate-defined-by true --output iao-extracted.owl
## Annotate with new ontology information
#robot annotate --input iao-extracted.owl  --ontology-iri http://openenergy-platform.org/ontology/oeo/imports/iao-extracted.owl --version-iri http://openenergy-platform.org/ontology/oeo/dev/imports/iao-extracted.owl --output iao-extracted.owl
rm iao-full-download.owl
rm iao-extracted-w-hierarchy.owl
rm iao-extracted-n-hierarchy.owl
