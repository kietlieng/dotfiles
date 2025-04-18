#!/usr/local/bin/python3
import os, requests, json, sys
from pprint import pprint

GITLAB_TOKEN = os.getenv('GITLAB_TOKEN')
GITLAB_URL = os.getenv('GITLAB_URL')
if len(sys.argv) < 2:
    exit(1)

projectID = sys.argv[1]
jobID = sys.argv[2]
headers = {
    'PRIVATE-TOKEN': GITLAB_TOKEN,
    "Referer": GITLAB_URL,
}

print(GITLAB_URL + '/api/v4/projects/' + projectID + '/jobs/' + jobID + '/artifacts')
deleteResponse = requests.delete(GITLAB_URL + '/api/v4/projects/' + projectID + '/jobs/' + jobID + '/artifacts', headers=headers)
print("response", deleteResponse)
print(" >> ", deleteResponse.text)
print(" >>", deleteResponse.status_code)
print(" >>", deleteResponse.json)
print(" >>", deleteResponse.headers)
