import sys
import re
import requests

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
        else: #add object on the same position as first isntance of subject
            objectFilter[subjectsFilter.index(x)] = objectFilter[subjectsFilter.index(x)] + ", " + objects[i]
        i = i + 1
    results = []
    results.append(subjectsFilter)
    results.append(objectFilter)
    return results #return list of both lists

def main():
    arg = str(sys.argv[1])

    if arg == "scenarionumber":
        pred = "<http://openenergy-platform.org/ontology/oekg/has_scenario>"
        start2 = 'obj": {"type": "uri", "value": "'

    elif arg == "descriptors":
        pred = "<http://openenergy-platform.org/ontology/oeo/has_study_keyword>"
        start2 = 'obj": {"type": "literal", "value": "'  # scenarionumber, descriptors

    elif arg == "studynumber":
        pred = "<http://openenergy-platform.org/ontology/oekg/has_full_name>"


    r = queryEndpoint(buildquery(pred))
    start = '"subj": {"type": "uri", "value": "'
    end = '"},'
    subjects = re.findall('%s(.*?)%s' % (start, end), r.text) #get the URIs

    if arg == "studynumber":
        print(len(scenarioFilter(subjects))) #how many unique study URIs are in the sample

    if arg == "scenarionumber" or arg == "descriptors":
        end2 = '"}}'
        objects = re.findall('%s(.*?)%s' % (start2, end2), r.text)
        subjectsFiltered = duplicateFilter(subjects, objects)[0]
        objectsFiltered = duplicateFilter(subjects, objects)[1]
        if arg == "scenarionumber":
            i = 0
            with open("scenariosPerStudy.txt", "w") as file:
                for x in objectsFiltered:
                    file.write("\n")
                    file.write(subjectsFiltered[i] + "\n")
                    file.write(str(objectsFiltered[i].count(",") + 1)) #count number ob entrys in one object position
                    i = i + 1
        if arg == "descriptors":
            i = 0
            with open("studyDescriptors.txt", "w") as file:
                for x in objectsFiltered:
                    file.write("\n")
                    file.write(subjectsFiltered[i] + "\n")
                    file.write(objectsFiltered[i] + "\n")
                    i = i + 1


main()











