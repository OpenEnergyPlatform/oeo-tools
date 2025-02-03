import re
import sys

path = sys.argv[1]
mode = sys.argv[2]
#all of those were searched for alternative labels:
#path = r"/home/madeleine/Schreibtisch/ontology/src/ontology/edits/oeo-social.omn"
#path = r"/home/madeleine/Schreibtisch/ontology/src/ontology/edits/oeo-physical.omn"
#path = r"/home/madeleine/Schreibtisch/ontology/src/ontology/edits/oeo-sector.omn"
#path = r"/home/madeleine/Schreibtisch/ontology/src/ontology/edits/oeo-shared.omn"

def write(result, p):
    with open("labels.txt", p) as file:
        for x in result:
            file.write(str(x)+"\n")

def find(start, end):
    result = re.findall('%s(.*)%s' % (start, end), s)
    return result

s = ""
start2 = 'rdfs:label "'
start = '<http://purl.obolibrary.org/obo/IAO_0000118> "'
end = '"@en'
end2 = '"@de'

with open(path, "r") as file:
    for line in file:
        s = s + str(line)

if mode == "alt" or mode == "all":
    res = find(start,end)
    write(res,"w")

if mode == "ger" or mode == "all":
    res = find(start,end2)
    write(res,"a+")

if mode == "label" or mode == "all":
    res = find(start2,end)
    write(res,"a+")










