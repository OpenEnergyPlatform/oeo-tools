import sys

path1 = None
path2 = None

try:
    path1 = sys.argv[1]
    path2 = sys.argv[2]
except:
    print("Error: Missing or invalid argument")


list1 = []
list2 = []

if not (path1 == None or path2 == None):

    try:
        with open(path1, "r") as file:
            for line in file:
                list1.append(line.strip())
    except:
        print("Error: First file not found!")

    try:
        with open(path2, "r") as file:
            for line in file:
                list2.append(line.strip())
    except:
        print("Error: Second file not found!")

    for line in list1:
        if line not in list2:
            list2.append(line)

    with (open("mergedList.txt","w") as file):
        for x in list2:
            file.write(str(x) + "\n")