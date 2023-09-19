The script adds an annotation `belongs to module` (OEO_00040001) to every class in every OEO module to indicale, in which module it lives. 
NOTE: Protégé now shows this, too. The annotation is not needed anymore.

To execute the annotator easily:

1. Make sure that Python is installed on your system.

2. Make sure that following Python-modules
   are installed on your system:
    - pathlib
    - csv
    - subprocess
    - os
    - shutil

3. Download the robot.jar from http://robot.obolibrary.org/
   
4. Save the robot.jar in the ontology-project in the path: ontology/src/scripts/btma
   
5. Make sure that jars are executable on your system
   
6. Open the Terminal/Console

7. Navigate to the path: ontology/src/scripts/btma

8. Use the following command lines 
   in the console:

   python3 annotator.py
