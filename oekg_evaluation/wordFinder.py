import sys
import rdflib

data = sys.argv[1] #path to the rdf data file
keys = sys.argv[2] #path to the file with all the labels

#example:
#data = /home/madeleine/Schreibtisch/oekg1.nq
#keys = /home/madeleine/PycharmProjects/pythonProject/allLabels.txt

def main():
    g = rdflib.Graph()
    g.parse(data)

    knows_query = """
    SELECT ?s ?b
        WHERE {   
            ?s <http://purl.org/dc/terms/abstract> ?b.
        }"""

    subjects = []
    abstracts = []

    qres = g.query(knows_query)
    for row in qres:
        subjects.append(str(row.s)) #stores the study URI
        abstracts.append(str(row.b)) #stores the abstracts

    keywords = []

    with open(keys,"r") as file:
        for line in file:
            keywords.append(line.strip()) #collect all the labels

    i = 0

    with open("abstract_evaluation.txt", "w") as file:

        for x in abstracts: #go trough abstracts
            file.write("\n")
            file.write(subjects[i]+"\n") #move trough URIs at the same pace
            i = i+1
            for y in keywords: #check every label
                if y in x:
                    file.write(y+": " + str(x.count(y)) + "\n")



main()
