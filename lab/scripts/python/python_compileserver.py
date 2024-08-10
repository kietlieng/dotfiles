#!/usr/bin/python
from __future__ import unicode_literals
import sys, json, unicodedata, ipaddress

# Using readline()
dnsStream = open(str('/tmp/list_dns.txt'), 'r')
ansibleStream = open(str('/tmp/list_ansible.txt'), 'r')
#racktableStream = open(str('/tmp/list_racktables.txt'), 'r')
ansibleList = []
dnsList = {}
rackList = {}
finalList = {}

while True:
    line = ansibleStream.readline()
    if not line:
        break
    line = line.replace('\n', '')
    ansibleList.append(line)
    #print(line.strip())

while True:
    line = dnsStream.readline()
    if not line:
        break
    line = line.replace('\n', '')
    dnsEntry = line.split("=")
    dnsList[dnsEntry[0]] = dnsEntry[1]
    #print(line.strip())

def getIP(argIP, argIsString = True):
    if "null" != argIP:
        if argIsString:
            return argIP
        return str(ipaddress.IPv4Address(int(argIP)))
    return ""

#while True:
#    line = racktableStream.readline()
#    if not line:
#        break
#    line = line.replace('\n', '')
#    #line = unicodedata.normalize('NFKD', line).encode('ascii', 'ignore')
#    line = line.encode('ascii', 'ignore')
#    rackEntry = [x.encode('utf-8') for x in line.split("_")]
#    # quit this
#    if "null" == rackEntry[0]:
#        continue
##    print(rackEntry)
#    # get idrac
#    rackIP1 = getIP(rackEntry[1].split('=')[0].encode('ascii', 'ignore'))
#    # get IP
#    rackIP2 = getIP(rackEntry[1].split('=')[1].encode('ascii', 'ignore'), False)
#
#    if len(rackIP2):
#        # if entry already exists then double book it
#        if rackIP2 in rackList:
##            print("****double entry")
#            rackList[rackIP2] = rackList[rackIP2] + "_" + rackIP1
#        else:
#            rackList[rackIP2] = rackEntry[0] + "_" + rackIP1

#for rEntry in rackList:
#    print(rackList[rEntry] + "=" + rEntry)
#print(rackList)
#print(dnsList)
dnsStream.close()
ansibleStream.close()
#racktableStream.close()

# maching DNS entries with ansible entries
# example qfns=10.231.44.21
# dnsName = qfns
# dnsList[dnsName] = 10.231.44.21
entryFound = False
for dnsName in dnsList:
    #    print(dnsName + "=>" + dnsList[dnsName])
    # example qfns-usw-r2-def-h2_cas_dev2_els_kaf_zkp
    entryFound = False
    for accummulatedGroup in ansibleList:
        # try to match qfns to qfns-usw-r2-def-h2_cas_dev2_els_kaf_zkp
        #print("matching " + accummulatedGroup + " contains " + dnsName)
        if accummulatedGroup.count(dnsName):
            # if this entry actually exists
            #print("matched " + accummulatedGroup + " contains " + dnsName)
            if dnsList[dnsName] in finalList:
                # set but add the entry to the listing
                #print("old list " + dnsList[dnsName] + "=" + finalList[dnsList[dnsName]] + "_" + accummulatedGroup)
                entryFound = True
                finalList[dnsList[dnsName]] = finalList[dnsList[dnsName]] + "_" + accummulatedGroup
            else:
                # if there is no listing just create it
                #print("new list " + dnsList[dnsName] + "=" + accummulatedGroup)
                entryFound = True
                finalList[dnsList[dnsName]] = accummulatedGroup
    # if there is no entries at all.  Create it before quiting
    if dnsList[dnsName] not in finalList:
        #        print("dns entry " + dnsName + " does not exists is finalList")
        finalList[dnsList[dnsName]] = dnsName
    else:
        # if it exists but it hasn't been found
        if not entryFound:
            finalList[dnsList[dnsName]] = finalList[dnsList[dnsName]] + "_" + dnsName

#print(rackList)
#for rEntry in rackList:
#    print(rackList[rEntry] + "=" + rEntry)
#print(rackList)
#for fEntry in finalList:
#    print(finalList[fEntry] + "=" + fEntry)
def getSecondPortion(argEntry):
    # if there is a second portion
    if argEntry.count("_"):
        return argEntry.split("_")[1] + "_"
    # else return nothing because we don't want to repeat
    return ""

def getFirstPortion(argEntry):
    if argEntry.count("_"):
        return argEntry.split("_")[0]
    return argEntry

for rackEntry in rackList:
    ip1 = rackEntry

    # that means there are 2 IP's
    if ip1 in finalList:
        # what's the entry
        addEntry = rackList[rackEntry].strip("_")
        # if we can't found in entry in the string
        if finalList[ip1].count(getFirstPortion(addEntry)):
            addEntry = getSecondPortion(addEntry) + "BM"
        else:
            addEntry = addEntry + "_BM"

        finalList[ip1] = finalList[ip1].strip("_") + "_" + addEntry
#        print("finalList[ip1] = finalList[ip1] + _BM1 = " + finalList[ip1].strip("_") + " = " + addEntry.strip("_") + "_BM1")
    else:
#        print("nothing")
        finalList[ip1] = rackList[rackEntry].strip("_") + "_BM"
# )       print("finalList[ip1] = finalList[ip1] + _BM = " + finalList[ip1] + " = " + finalList[ip1] + "_BM")

##finalList.sort()
#
for fEntry in finalList:
    print(finalList[fEntry] + "^" + fEntry)
