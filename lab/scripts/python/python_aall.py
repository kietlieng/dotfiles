#!/usr/bin/python
import sys, json, unicodedata

#print(sys.stdin)
rootObject = json.load(sys.stdin)
#print(type(rootObject))
# stupid, need to remove the quote from the value so replace in the parameter is required

invList = {}
def insertInList(argKey, argValue):
    global invList;
    matchList="install_default_docker_pac7db_entropy_init"
    argValue = str(argValue)
    argValue = argValue.replace("deploy_", "")
    argValue = argValue.replace("install_", "")
    argValue = argValue.replace("_g1", "")
    argValue = argValue.replace("_g2", "")
    argValue = argValue.replace("_g3", "")
    argValue = argValue.replace("_g4", "")
    #print("matching ", matchList, argValue, matchList.count(argValue))
    if matchList.count(argValue):
        return

    # has key arleady add more to it
    if argKey in invList:
        argKey = str(argKey)
        #print(">>+ " + argKey + " = " + argValue)
        #print(invList[argKey].count(argValue))
        # check to see if we already have it
        if not invList[argKey].count(argValue):
            invList[argKey] = str(invList[argKey] + "_" + argValue)
            orderList = invList[argKey].split("_")
            orderList.sort()
            #print("sort", invList[argKey], type(orderList), orderList)
            invList[argKey] = str("_".join(orderList))
    else:
        invList[argKey] = str(argValue)
        #print(">>" + argKey + " = " + argValue)

for l1 in rootObject:
    tag = l1.encode('ASCII', 'ignore')
    if tag not in ("auto", "dev", "dev2", "qfnq", "qfns"):
        #print("tag " + tag)
    #    print(l1['deploy_bog_g1'])
        if 'hosts' in rootObject[l1]:
            # actually ... skip hosts
            for l2 in rootObject[l1]['hosts']:
                normL2 = str(l2.encode('ASCII', 'ignore'))
                #print("hosts " + normL2)
                insertInList(normL2, tag)

        if 'children' in rootObject[l1]:
            for l2 in rootObject[l1]['children']:
                if l2 in rootObject and 'children' in rootObject[l2]:
                    normL2 = str(l2.encode('ASCII', 'ignore'))
                    for l3 in rootObject[l2]['children']:
                        normL3 = str(l3.encode('ASCII', 'ignore'))
                        #print("children of " + normL2, normL3)
                        if l3 in rootObject and 'hosts' in rootObject[l3]:
                            for l4 in rootObject[l3]['hosts']:
                                normL4 = str(l4.encode('ASCII', 'ignore'))
                                insertInList(normL4, tag)
                                #print("hosts of " + normL3, normL4)

                if l2 in rootObject and 'hosts' in rootObject[l2]:
                    normL2 = l2.encode('ASCII', 'ignore')
                    for l3 in rootObject[l2]['hosts']:
                        normL3 = str(l3.encode('ASCII', 'ignore'))
                        insertInList(l3, tag)
                        #print("hosts of " + normL2, normL3)

#print(json.dumps(invList, indent=4))
sortInvList = {}

for i in sorted(invList):
   sortInvList[i] = str(invList[i])
for item in sortInvList:
    print(item + "_" + str(sortInvList[item]))
