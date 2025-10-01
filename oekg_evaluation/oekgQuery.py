import sys
import re
import requests
import rdflib

def buildquery(pred): #input: predicate for chosen query, output: full query string
    return '\nPREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>\nPREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\nSELECT * WHERE{\n?subj ' + pred + ' ?obj.\n}'

def queryEndpoint(query): # input: query string, output: http answer
    sparql_endpoint = "https://openenergyplatform.org/sparql_query/sparql"
    sparql_query = {
        "query": query
    }
    return requests.get(url=sparql_endpoint, params=sparql_query)

def scenarioFilter(subjects): #input: list of uris of studies and scenarios, output: list of uris of studies
    subjectsFilter = []
    for x in subjects:  # remove scenario URIs
        if "scenario" not in x:
            subjectsFilter.append(x)
    return subjectsFilter

def duplicateFilter(subjects, objects): #input: lists of subjects and objects, output: list of unique subjects and list of grouped objects
    i = 0
    subjectsFilter = []
    objectFilter = []
    for x in subjects:
        if x not in subjectsFilter:
            subjectsFilter.append(x)
            objectFilter.append(objects[i])
        else: #add object on the same position as first instance of subject
            objectFilter[subjectsFilter.index(x)] = objectFilter[subjectsFilter.index(x)] + ", " + objects[i]
        i = i + 1
    return subjectsFilter, objectFilter #return list of both lists

def main():
    mode = sys.argv[1]
    subjects = []
    objects = []
    if not (mode == "endpoint" or mode == "file"):
        print("Error: Invalid mode! Use 'endpoint' or 'file' as first argument!")
    else:
        arg = str(sys.argv[2])

        if arg == "scenarionumber":
            pred = "<https://openenergyplatform.org/ontology/oekg/has_scenario>"
            start2 = 'obj": {"type": "uri", "value": "'

        elif arg == "keywords":
            pred = "<https://openenergyplatform.org/ontology/oeo/has_study_keyword>"
            start2 = 'obj": {"type": "literal", "value": "'

        elif arg == "studynumber":
            pred = "<https://openenergyplatform.org/ontology/oekg/has_full_name>"

        else:
            print("Error: Invalid query! Use 'scenarionumber', 'keywords' or 'studynumber'!")
            return

        if mode == "endpoint":
            r = queryEndpoint(buildquery(pred))
            start = '"subj": {"type": "uri", "value": "'
            end = '"},'
            subjects = re.findall('%s(.*?)%s' % (start, end), r.text)  # get the URIs

        if mode == "file":
            try:
                data = sys.argv[3]
                g = rdflib.Graph()
                g.parse(data)
                knows_query = buildquery(pred)
                qres = g.query(knows_query)
                for row in qres:
                    subjects.append(str(row.subj))
                    objects.append(str(row.obj))
            except:
                print("Error: Invalid data argument!")

        if arg == "studynumber":
            print(len(scenarioFilter(subjects)))  # how many unique study URIs are in the sample

        if arg == "scenarionumber" or arg == "keywords":
            if mode == "endpoint":
                end2 = '"}}'
                objects = re.findall('%s(.*?)%s' % (start2, end2), r.text)

            dictionary = {objects[i]: subjects[i] for i in range(len(objects))}

            print(dictionary)

            subjectsFiltered, objectsFiltered = duplicateFilter(subjects,objects)
            if arg == "scenarionumber":
                i = 0
                with open("scenariosPerStudy.txt", "w") as file:
                    for x in objectsFiltered:
                        file.write("\n")
                        file.write(subjectsFiltered[i] + "\n")
                        file.write(
                            str(objectsFiltered[i].count(",") + 1))  # count number ob entrys in one object position
                        i = i + 1
            if arg == "keywords":
                i = 0
                with open("studyKeywords.txt", "w") as file:
                    for x in objectsFiltered:
                        file.write("\n")
                        file.write(subjectsFiltered[i] + "\n")
                        file.write(objectsFiltered[i] + "\n")
                        i = i + 1



main()











