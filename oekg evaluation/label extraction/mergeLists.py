import sys

path1 = sys.argv[1]
path2 = sys.argv[2]

list1 = []
list2 = []


with open(path1, "r") as file:
    for line in file:
        list1.append(line.strip())

with open(path2, "r") as file:
    for line in file:
        list2.append(line.strip())

for line in list1:
    if line not in list2:
        list2.append(line)

with (open("mergedList.txt","w") as file):
    for x in list2:
        file.write(str(x) + "\n")