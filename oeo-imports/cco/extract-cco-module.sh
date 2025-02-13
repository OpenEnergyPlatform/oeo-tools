tmpdir=tmp
mkdir -p ${tmpdir}

this_wd=oeo-tools/oeo-imports/cco
ontology_source=src/ontology
imports="${ontology_source}/imports"

# Download the CCO version of the commit behind release from 2024-11-06
curl -L https://raw.githubusercontent.com/CommonCoreOntology/CommonCoreOntologies/510dad76be0ef710b65a421075af912af25342b7/src/cco-merged/CommonCoreOntologiesMerged.ttl > ${tmpdir}/cco-full-download.ttl
# Extract the terms we want with their hierarchy of subclasses
robot merge --input ${tmpdir}/cco-full-download.ttl extract --method MIREOT --branch-from-terms ${this_wd}/cco-extract-w-hierarchy.txt --intermediates all --output ${tmpdir}/cco-extracted-w-hierarchy.owl
# Extract the terms we want without their hierarchy of subclasses or subproperties
robot merge --input ${tmpdir}/cco-full-download.ttl extract --method MIREOT --lower-terms ${this_wd}/cco-extract-n-hierarchy.txt --intermediates none --output ${tmpdir}/cco-extracted-n-hierarchy.owl
# Create Extracted module and annotate with new ontology information
robot merge --input ${tmpdir}/cco-extracted-w-hierarchy.owl --input ${tmpdir}/cco-extracted-n-hierarchy.owl annotate --ontology-iri http://openenergy-platform.org/ontology/oeo/imports/cco-extracted.owl --version-iri http://openenergy-platform.org/ontology/oeo/dev/imports/cco-extracted.owl --output ${tmpdir}/cco-extracted.owl
# Remove definition of known annotation properties from the import
robot remove --input ${tmpdir}/cco-extracted.owl --select annotation-properties --trim false --output ${tmpdir}/cco-extracted.owl
# Annotates the output module with a commentary to the origin of the content
robot annotate --input ${tmpdir}/cco-extracted.owl --annotation rdfs:comment "This file contains externally imported content from the Common Core Ontologies (CCO) for import into the Open Energy Ontology (OEO). It is automatically extracted using ROBOT from the list of selected terms (cco-extract-w-hierarchy.txt, cco-extract-n-hierarchy.txt) located in the OEO-tools repository." --output ${tmpdir}/cco-extracted.owl
# Annotates each axiom with the ontology IRI, using prov:wasDerivedFrom
robot annotate --input ${tmpdir}/cco-extracted.owl --annotate-derived-from true --annotate-defined-by true --output ${imports}/cco-extracted.owl

rm ${tmpdir}/cco-full-download.ttl
rm ${tmpdir}/cco-extracted-w-hierarchy.owl
rm ${tmpdir}/cco-extracted-n-hierarchy.owl
rm ${tmpdir}/cco-extracted.owl
rmdir ${tmpdir}