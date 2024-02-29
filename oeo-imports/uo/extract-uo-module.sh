# Download UO release from 202
#curl -L https://data.bioontology.org/ontologies/UO/submissions/219/download?apikey=8b5b7825-538d-40e0-9e9e-5ab9274a9aeb > uo-full-download.owl
curl -L http://purl.obolibrary.org/obo/uo.owl > uo-full-download.owl
# Extract the terms we want with downward hierarchy
robot merge --input uo-full-download.owl extract --method MIREOT --lower-terms uo-w-hierarchy.txt --intermediates all --output uo-temp-extracted.owl
## add prefix for OBO xmlns:obo="http://purl.obolibrary.org/obo/"
# Linux sed -i 's/xmlns:owl/xmlns:obo="http:\/\/purl.obolibrary.org\/obo\/"\xmlns:owl/' uo-module-temp.owl
# windows
(Get-Content -ReadCount 0 uo-temp-extracted.owl) -replace 'xmlns:owl', 'xmlns:obo="http://purl.obolibrary.org/obo/#"
     xmlns:owl' | Set-Content uo-extracted.owl
# Replace "<rdfs:comment>" with "obo:IAO_0000115" and Replace "<rdfs:comment>" with "</obo:IAO_0000115>"
## Linux:
#sed -i 's/<rdfs:comment>/<obo:IAO_0000115>/g' uo-extracted.owl
#sed -i 's/<\/rdfs:comment>/<\/obo:IAO_0000115>/g' uo-module-temp.owl
## windows:
(Get-Content -ReadCount 0 uo-extracted.owl) -replace '<rdfs:comment>', '<obo:IAO_0000115>' | Set-Content uo-extracted.owl
(Get-Content -ReadCount 0 uo-extracted.owl) -replace '</rdfs:comment>', '</obo:IAO_0000115>' | Set-Content uo-extracted.owl
## 
# Annotates the output with a commentary to the origin of the content
robot annotate --input uo-extracted.owl --annotation rdfs:comment "This file contains externally imported content from the Unit Ontology (UO) for import into the Open Energy Ontology (OEO). It is automatically extracted using ROBOT." --output uo-extracted.owl
# Annotates each axiom with the ontology IRI, using prov:wasDerivedFrom
robot annotate --input uo-extracted.owl --annotate-derived-from true --annotate-defined-by true --output uo-extracted.owl
## add 'definition' label to IAO_0000115
#sed -i "33s/.*/        <rdfs:label>definition<\/rdfs:label>/" uo-extracted.owl
# Annotate with new ontology information
robot annotate --input uo-extracted.owl  --ontology-iri http://openenergy-platform.org/ontology/imports/uo-extracted.owl --version-iri http://openenergy-platform.org/ontology/imports/uo-extracted.owl --output uo-extracted.owl

rm uo-full-download.owl
rm uo-module-temp.owl
