import sys
import re
import requests

keys = sys.argv[1] #path to the file with all the labels

sparql_endpoint = "https://openenergyplatform.org/sparql_query/sparql"
sparql_query = {
    "query": """
    PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

        SELECT * WHERE {
            ?sub <http://purl.org/dc/terms/abstract> ?obj.

        }"""
}

r = requests.get(url=sparql_endpoint, params=sparql_query)

start = '"sub": {"type": "uri", "value": "'
start2 = '"obj": {"type": "literal", "value": "'
end = '"}}'
end2 = '"},'

subjects = re.findall('%s(.*?)%s' % (start, end2), r.text) #get the URIs
abstracts = re.findall('%s(.*?)%s' % (start2, end), r.text) #get the abstracts

keywords = []

with open(keys,"r") as file:
    for line in file:
        keywords.append(line.strip()) #collect all the labels

i = 0

with open("results2.txt", "w") as file:

    for x in abstracts: #go trough abstracts
        file.write("\n")
        file.write(subjects[i]+"\n") #move trough URIs at the same pace
        i = i+1
        for y in keywords: #check every label
            if y in x:
                file.write(y+": " + str(x.count(y)) + "\n")






