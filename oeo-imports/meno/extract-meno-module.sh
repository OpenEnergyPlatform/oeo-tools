tmpdir=tmp
mkdir -p ${tmpdir}

this_wd=oeo-tools/oeo-imports/meno
ontology_source=src/ontology
imports="${ontology_source}/imports"

# Download the MENO version of the commit behind release from 2024-03-19
curl -L https://raw.githubusercontent.com/stap-m/midlevel-energy-ontology/refs/heads/dev/ontology/src/midlevel-energy.owl > ${tmpdir}/meno-full-download.owl
# Extract the terms we want with their hierarchy of subclasses
robot merge --input ${tmpdir}/meno-full-download.owl extract --method MIREOT --branch-from-terms ${this_wd}/meno-extract-w-hierarchy.txt --intermediates all --output ${tmpdir}/meno-extracted-w-hierarchy.owl
# Extract the terms we want without their hierarchy of subclasses or subproperties
robot merge --input ${tmpdir}/meno-full-download.owl extract --method MIREOT --lower-terms ${this_wd}/meno-extract-n-hierarchy.txt --intermediates none --output ${tmpdir}/meno-extracted-n-hierarchy.owl
# Create Extracted module and annotate with new ontology information
robot merge --input ${tmpdir}/meno-extracted-w-hierarchy.owl --input ${tmpdir}/meno-extracted-n-hierarchy.owl annotate --ontology-iri http://openenergy-platform.org/ontology/oeo/imports/meno-extracted.owl --version-iri http://openenergy-platform.org/ontology/oeo/dev/imports/meno-extracted.owl --output ${tmpdir}/meno-extracted.owl
# Annotates the output module with a commentary to the origin of the content
robot annotate --input ${tmpdir}/meno-extracted.owl --annotation rdfs:comment "This file contains externally imported content from the Midlevel Energy Ontology (MENO) for import into the Open Energy Ontology (OEO). It is automatically extracted using ROBOT from the list of selected terms (meno-extract-w-hierarchy.txt, meno-extract-n-hierarchy.txt) located in the OEO-tools repository." --output ${tmpdir}/meno-extracted.owl
# Annotates each axiom with the ontology IRI, using prov:wasDerivedFrom
robot annotate --input ${tmpdir}/meno-extracted.owl --annotate-derived-from true --annotate-defined-by true --output ${imports}/meno-extracted.owl

rm ${tmpdir}/meno-full-download.owl
rm ${tmpdir}/meno-extracted-w-hierarchy.owl
rm ${tmpdir}/meno-extracted-n-hierarchy.owl
rm ${tmpdir}/meno-extracted.owl
rmdir ${tmpdir}