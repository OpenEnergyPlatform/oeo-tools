import sys
import rdflib
import re
import requests

def queryFile():
    g = rdflib.Graph()
    g.parse(data)

    knows_query = """                                     
    SELECT ?s ?b                                          
        WHERE {                                           
            ?s DC:abstract ?b.                            
        }"""

    subjects = []
    objects = []

    qres = g.query(knows_query)
    for row in qres:
        subjects.append(str(row.s))  # stores the study URI
        objects.append(str(row.b))  # stores the abstracts

    return subjects, objects

def queryEndpoint():
    sparql_endpoint = "https://openenergyplatform.org/sparql_query/sparql"
    sparql_query = {
        "query": """
        PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
        PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
        PREFIX DC: <http://purl.org/dc/terms/>

            SELECT * WHERE {
                ?sub DC:abstract ?obj.

            }"""
    }

    r = requests.get(url=sparql_endpoint, params=sparql_query)
    start = '"sub": {"type": "uri", "value": "'
    start2 = '"obj": {"type": "literal", "value": "'
    end = '"}}'
    end2 = '"},'

    subjects = re.findall('%s(.*?)%s' % (start, end2), r.text)  # get the URIs
    objects = re.findall('%s(.*?)%s' % (start2, end), r.text)  # get the abstracts

    return subjects, objects

def checkKeywords(keys):
    keywords = []

    with open(keys, "r") as file:
        for line in file:
            keywords.append(line.strip())  # collect all the labels

    i = 0

    with open("abstractEvaluation.txt", "w") as file:

        for x in objects:  # go trough objects
            file.write("\n")
            file.write(subjects[i] + "\n")  # move trough URIs at the same pace
            i = i + 1
            for y in keywords:  # check every label
                if y in x:
                    file.write(y + ": " + str(x.count(y)) + "\n")


try:
    mode = sys.argv[1]  # endpoint | file
    if not (mode == "endpoint" or mode == "file"):
        print("Error: Invalid mode! Use 'endpoint' or 'file' as first argument!")
    else:
        keys = sys.argv[2]  # path to file with all the labes
        if mode == "endpoint":
            subjects, objects = queryEndpoint()
        if mode == "file":
            data = sys.argv[3]  # path to rdf data file
            subjects, objects = queryFile()

        checkKeywords(keys)

except:
    print("Error: Missing or invalid argument!")