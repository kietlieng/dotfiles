#!/usr/local/bin/python3
import os, requests, json, sys
from pprint import pprint

GITLAB_TOKEN = os.getenv('GITLAB_TOKEN')
GITLAB_URL = os.getenv('GITLAB_URL')

print(GITLAB_TOKEN, GITLAB_URL)

if len(sys.argv) < 2:
    exit(1)

projectId = sys.argv[1]
currentPage = "0"
if len(sys.argv) > 2:
    currentPage = sys.argv[2]
print(sys.argv)
headers = {
    'PRIVATE-TOKEN': GITLAB_TOKEN,
    'Content-Type': 'application/x-www-form-urlencoded',
    "Referer": GITLAB_URL,
}

print(GITLAB_URL + '/api/v4/projects/' + projectId + '/jobs?per_page=100&page=' + currentPage)
response = requests.get(GITLAB_URL + '/api/v4/projects/' + projectId + '/jobs?per_page=100&page=' + currentPage, headers=headers)
responseHeaders = response.headers



##

#deleteResponse = requests.delete(GITLAB_URL + '/api/v4/projects/' + projectId + '/jobs/' + currentId + '/artifacts', headers=headers)
#print(GITLAB_URL + '/api/v4/projects/' + projectId + '/jobs/' + currentId + '/artifacts', currentPage, jobCount)
#print("response", deleteResponse)
#print(" >>", deleteResponse.headers)
#statusCode = deleteResponse.status_code
#print(" >>", deleteResponse.status_code)
#exit()

##


print(responseHeaders)
#totalPages  = int(responseHeaders['X-Total-Pages'])
currentPage = int(responseHeaders['X-Page'])

results = json.loads(response.text)
preserveNewest = 50
deleted = 0
#pageMessage = "Page " + str(currentPage) + "/" + str(totalPages)
pageMessage = "Page " + str(currentPage)
jobCount=0
while True:
    jobCount=0
    for item in results:
        currentId = str(item['id'])
        if deleted > preserveNewest:
#            pprint(item, depth=2)
            #getResponse = requests.get(GITLAB_URL + '/api/v4/projects/' + projectId + '/jobs/' + currentId + '/artifacts', headers=headers)
            #print("delete", getResponse)
            #print("delete2", getResponse.text)

            deleteResponse = requests.delete(GITLAB_URL + '/api/v4/projects/' + projectId + '/jobs/' + currentId + '/artifacts', headers=headers)
            print(GITLAB_URL + '/api/v4/projects/' + projectId + '/jobs/' + currentId + '/artifacts', currentPage, jobCount)
            #print(pageMessage, "delete id", currentId)
            print("response", deleteResponse)
            print(" >>", deleteResponse.headers)
            statusCode = deleteResponse.status_code
            print(" >>", deleteResponse.status_code)
        else:
            print(pageMessage, "skipping",  currentId)
        deleted += 1
        jobCount += 1

#    exit(1)

    if jobCount < 3:
        print("there are no more items on the page.  Quitting")
        break

    # get response second
    response = requests.get(GITLAB_URL + '/api/v4/projects/' + projectId + '/jobs?per_page=100&page=' + str(currentPage + 1), headers=headers)
    print('>> ' + GITLAB_URL + '/api/v4/projects/' + projectId + '/jobs?per_page=100&page=' + str(currentPage + 1))
    results = json.loads(response.text)
    responseHeaders = response.headers
#    totalPages  = int(responseHeaders['X-Total-Pages'])
    currentPage = int(responseHeaders['X-Page'])

#    pageMessage = "Page " + str(currentPage) + "/" + str(totalPages)
    pageMessage = "Page " + str(currentPage)
