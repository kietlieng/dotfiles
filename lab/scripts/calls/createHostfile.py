#!/opt/homebrew/opt/python@3.11/libexec/bin/python

import sys
import yaml
from nslookup import Nslookup

targetFile = sys.argv[1]
hostDomain = sys.argv[2]

print("targetfile is", targetFile)
with open(targetFile) as fp:
    yaml_data = yaml.load(fp, Loader=yaml.FullLoader);
    #print(yaml_data);

#print(data.values());
dnsArray = {};
cnameArray = {};
def primeSlot(argArray, argIndex):
    if argIndex not in argArray:
        argArray[argIndex] = "";


for dnsEntry in yaml_data:
    # only care about dictionary definitions
    #print(dnsEntry, yaml_data[dnsEntry], type(dnsEntry));
    currentDictionary = yaml_data[dnsEntry];
    if isinstance(currentDictionary, dict):
        currentType = currentDictionary['type'];
        #print("current dictionary", currentType);

        if ('A' == currentType):
            if 'values' in currentDictionary:
                #print(dnsEntry, "has more than 1 value", currentDictionary['values']);
                for value in currentDictionary['values']:
                    primeSlot(dnsArray, value);
                    dnsArray[value] = dnsEntry + "." + hostDomain
            else:
                #print(currentDictionary['value'], dnsEntry + hostDomain);
                primeSlot(dnsArray, currentDictionary['value']);
                dnsArray[currentDictionary['value']] = dnsEntry + "." + hostDomain
            #print(yaml_data[dnsEntry], type(yaml_data[dnsEntry]));
        if ('CNAME' == currentType):
                primeSlot(cnameArray, currentDictionary['value']);
                cnameArray[currentDictionary['value']] = dnsEntry + "." + hostDomain

#print(dnsArray);
for entry in dnsArray:
    print(dnsArray[entry], "A");

dns_query = Nslookup(verbose=False, tcp=False);
for entry in cnameArray:
    lookupDomain = entry.strip().strip(".");
    print(lookupDomain, "CNAME")
    ##ips_record = dns_query.dns_lookup(lookupDomain);
    ##print(ips_record.response_full, ips_record.answer);
    ## more than 1 record
    #if len(ips_record.answer):
    #    if 1 < len(ips_record.answer):
    #        possibleIPs = "Possible IPs " + ", ".join(ips_record.answer) + ". ";
    #    print(ips_record.answer[0] + " " + cnameArray[entry] + " # " + possibleIPs + "Relookup http://nslookup.paciolan.info/?entry=" + lookupDomain);
