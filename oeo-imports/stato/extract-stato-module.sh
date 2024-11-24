tmpdir=tmp
mkdir -p ${tmpdir}

this_wd=oeo-tools/oeo-imports/stato
ontology_source=src/ontology
imports="${ontology_source}/imports"

# Note: For consistent results run with ROBOT v1.91 or higher
# Download the latest STATO release from 2024-07-07
curl -L https://raw.githubusercontent.com/ISA-tools/stato/refs/heads/dev/releases/1.5/stato.owl > ${tmpdir}/stato-full-download.owl
# Classification:  tbd in oeo-import-edits
robot merge --input ${tmpdir}/stato-full-download.owl extract --method MIREOT --lower-terms ${this_wd}/stato-w-hierarchy.txt --upper-term http://purl.obolibrary.org/obo/STATO_0000633 --upper-term http://purl.obolibrary.org/obo/STATO_0000039 --intermediates all --output ${tmpdir}/stato-extracted-w-hierarchy.owl
# Create Extracted module and annotate with new ontology information
robot annotate --input ${tmpdir}/stato-extracted-w-hierarchy.owl --ontology-iri http://openenergy-platform.org/ontology/oeo/imports/stato-extracted.owl --version-iri http://openenergy-platform.org/ontology/oeo/dev/imports/stato-extracted.owl --output ${tmpdir}/stato-extracted.owl
# Annotates the output module with a commentary to the origin of the content
robot annotate --input ${tmpdir}/stato-extracted.owl --annotation rdfs:comment "This file contains externally imported content from the Statistics Ontology (STATO) for import into the Open Energy Ontology (OEO). It is automatically extracted using ROBOT from the list of selected terms (stato-w-hierarchy.txt) located in the OEO-tools repository." --output ${tmpdir}/stato-extracted.owl
# Annotates each axiom with the ontology IRI, using prov:wasDerivedFrom
robot annotate --input ${tmpdir}/stato-extracted.owl --annotate-derived-from true --annotate-defined-by true --output ${imports}/stato-extracted.owl

rm ${tmpdir}/stato-full-download.owl
rm ${tmpdir}/stato-extracted-w-hierarchy.owl
rm ${tmpdir}/stato-extracted.owl
rmdir ${tmpdir}
