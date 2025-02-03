import re
import sys

def write(result, p):
    with open("labels.txt", p) as file:
        for x in result:
            file.write(str(x)+"\n")

def find(start, end,s):
    result = re.findall('%s(.*)%s' % (start, end), s)
    return result

def main():
    s = ""
    start2 = 'rdfs:label "'
    start = '<http://purl.obolibrary.org/obo/IAO_0000118> "'
    end = '"@en'
    end2 = '"@de'

    with open(path, "r") as file:
        for line in file:
            s = s + str(line)

    if mode == "alt" or mode == "all":
        res = find(start,end,s)
        write(res,"w")

    if mode == "ger" or mode == "all":
        res = find(start,end2,s)
        write(res,"a+")

    if mode == "label" or mode == "all":
        res = find(start2,end,s)
        write(res,"a+")

try:
    path = sys.argv[1]
    mode = sys.argv[2]
    if not (mode =="alt" or mode == "all" or mode == "ger" or mode == "label"):
        print("Error:Not a valid mode")
    else:
        main()
except:
    print("Error: Missing or invalid argument!")
#all of those were searched for alternative labels:
#path = r"/home/madeleine/Schreibtisch/ontology/src/ontology/edits/oeo-social.omn"
#path = r"/home/madeleine/Schreibtisch/ontology/src/ontology/edits/oeo-physical.omn"
#path = r"/home/madeleine/Schreibtisch/ontology/src/ontology/edits/oeo-sector.omn"
#path = r"/home/madeleine/Schreibtisch/ontology/src/ontology/edits/oeo-shared.omn"











