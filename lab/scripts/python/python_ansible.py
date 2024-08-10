#!/usr/bin/python
import sys, json; 

rootObject = json.load(sys.stdin)
# stupid, need to remove the quote from the value so replace in the parameter is required
for item in rootObject[sys.argv[1].replace('"', '')]["hosts"]:
  print(item)
