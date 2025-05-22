## How to import from a new ontology

### Requirements

    ROBOT
    curl
    Windows: WSL

### Workflow

1. Follow the [workflow](https://github.com/OpenEnergyPlatform/ontology/wiki/pull-request-workflow) described in the 'ontology' repository
    (Create an issue, create a feature branch, create a PR, ...)

2. Take the following steps while working on your feature branch

    a. Create or update two lists of terms

        -> terms that should be integrated into the OEO on their own, i.e. without importing the hierarchy  (ontology-n-hierarchy.txt)
        -> terms that should be imported with their parent classes    (ontology-w-hierarchy.txt)

    b. Create a shell script (extract-[ontology abbreviation]-module.sh)

    #### helpful resources

    - preexisting shell-scripts
    - ROBOT documentation

    #### additional advice

    - when importing with hierarchy: do not import parent classes already in the OEO to avoid duplicates

    c. Run shell script (use WSL on Windows)

        enter 
        `bash ./oeo-tools/oeo-imports/[ontology abbreviation]/extract-[ontology abbreviation]-module.sh`        
        in the parent directory of the `oeo-tools` folder after setting up ROBOT according to their description

        this should provide you with a new `[ontology abbreviation]-extracted.owl`
    
    d. Create a new subfolder of oeo-imports called [ontology abbreviation]

    e. Add the extract.sh, extracted.owl, w-hierarchy.txt, n-hierarchy.txt files to the new folder
    
    f. Merge after successful review

3. Add the new terms to the oeo properly

    a. Switch to the 'ontology' repository

    b. Repeat step one there (issue, branch, PR, ...)

    c. Add your new extracted.owl file to the 'imports' folder

    d. Open `oeo-shared.omn` in Protégé

    e. While on the 'Active ontology' tab:
        - Find the 'Ontology imports' tab
        - Press the + next to 'Direct Imports'
        - Select 'Import ontology contained in a local file' 
        - Enter the path to your file within the imports folder (manually or using the 'Browse' function)
    
    f. check the catalog-v0001.xml files in the directories ontology and edits

        They should now contain a line: 
        `<uri id="Imports Wizard Entry" name="http://openenergy-platform.org/ontology/oeo/dev/imports/[ontology abbreviation]-extracted.owl" uri="../imports/[ontology abbreviation]-extracted.owl"/>`

        if they do not, add it to both files
        
    g. Add all neccessary axioms/parent classes in the `oeo-import-edits.owl` file
        - if you want to easily do that in Protégé:
            - since `oeo-import-edits.owl` doesn't import the new `extracted.owl`, you can't easily add e.g. subclass axioms when directly opening it in Protégé
            - instead, open `oeo-shared.omn` in Protégé, which already imports `oeo-import-edits.owl` and should (since step e.) also import the new `extracted.owl`
            - add the axioms in `oeo-shared.omn`
                - left-click on the new axiom in the right `Description: label` panel, so it is highlighted and then right-click
                - in the menu that opens, select the option `Move axiom(s) to ontology...` and select `oeo-import-edits` in the new window
            - after doing this for all axioms, save and make sure to only commit the `oeo-import-edits.owl` file to the repository

    h. Merge after successful review