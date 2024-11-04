tmpdir=tmp
mkdir -p ${tmpdir}

this_wd=oeo-tools/oeo-imports/uo
ontology_source=src/ontology
imports="${ontology_source}/imports"

# Download UO release from 202
#curl -L https://data.bioontology.org/ontologies/UO/submissions/219/download?apikey=8b5b7825-538d-40e0-9e9e-5ab9274a9aeb > ${tmpdir}/uo-full-download.owl
curl -L http://purl.obolibrary.org/obo/uo.owl > ${tmpdir}/uo-full-download.owl
# Extract the terms we want with downward hierarchy
robot merge --input ${tmpdir}/uo-full-download.owl extract --method MIREOT --lower-terms ${this_wd}/uo-w-hierarchy.txt --intermediates all --output ${tmpdir}/uo-module-temp.owl
## add prefix for OBO xmlns:obo="http://purl.obolibrary.org/obo/"
sed -i 's/xmlns:owl/xmlns:obo="http:\/\/purl.obolibrary.org\/obo\/"\n\t \xmlns:owl/' tmp/uo-module-temp.owl
# Replace "<rdfs:comment>" with "obo:IAO_0000115" and Replace "<rdfs:comment>" with "</obo:IAO_0000115>"
sed -i 's/<rdfs:comment>/<obo:IAO_0000115>/g' ${tmpdir}/uo-module-temp.owl
sed -i 's/<\/rdfs:comment>/<\/obo:IAO_0000115>/g' ${tmpdir}/uo-module-temp.owl
# Annotates the output with a commentary to the origin of the content
robot annotate --input ${tmpdir}/uo-module-temp.owl --annotation rdfs:comment "This file contains externally imported content from the Unit Ontology (UO) for import into the Open Energy Ontology (OEO). It is automatically extracted using ROBOT." --output  ${tmpdir}/uo-extracted.owl
# Annotates each axiom with the ontology IRI, using prov:wasDerivedFrom
robot annotate --input  ${tmpdir}/uo-extracted.owl --annotate-derived-from true --annotate-defined-by true --output  ${tmpdir}/uo-extracted.owl
## add 'definition' label to IAO_0000115
sed -i "33s/.*/        <rdfs:label>definition<\/rdfs:label>/"  ${tmpdir}/uo-extracted.owl
# Annotate with new ontology information
robot annotate --input  ${tmpdir}/uo-extracted.owl  --ontology-iri http://openenergy-platform.org/ontology/oeo/imports/uo-extracted.owl --version-iri http://openenergy-platform.org/ontology/oeo/dev/imports/uo-extracted.owl --output  ${imports}/uo-extracted.owl

rm ${tmpdir}/uo-full-download.owl
rm ${tmpdir}/uo-module-temp.owl
rm ${tmpdir}/uo-extracted.owl
rmdir ${tmpdir}
