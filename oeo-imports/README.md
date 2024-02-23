The folder contains the routines for importing external ontologies to OEO.
Workflow for new/updated imports:
1. Create feature branch
2. create/update list of terms (ontology-w-hierarchy.txt, ontology-n-hierarchy.txt)
3. run shell script locally --> result: new version of ontology-extracted.owl
4. Create PR, review, merge
5. Add newly created ontology-extracted.owl file to oeo repository
 
Requirements
- ROBOT
- curl
