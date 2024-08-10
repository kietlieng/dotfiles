#!/usr/local/bin/python3
import os, requests, json, sys
from pprint import pprint

GITLAB_TOKEN = os.getenv('GITLAB_TOKEN')
GITLAB_URL = os.getenv('GITLAB_URL')
if len(sys.argv) < 2:
    exit(1)

projectId = sys.argv[1]
currentPage = "0"
if len(sys.argv) > 2:
    currentPage = sys.argv[2]
print(sys.argv)
curl_headers = {
    'PRIVATE-TOKEN': GITLAB_TOKEN,
}

#response = requests.get(GITLAB_URL + '/api/v4/projects/' + projectId + '/jobs?per_page=100&page=' + currentPage, headers=curl_headers)
response = requests.get(GITLAB_URL + '/api/v4/projects/' + projectId + '/jobs?page=' + currentPage, headers=curl_headers)
responseHeaders = response.headers

glLimit = 50000

totalPages  = int(responseHeaders['X-Total-Pages'])
currentPage = int(responseHeaders['X-Page'])
results = json.loads(response.text)
preserveNewest = 5
preservePages = 5
jobCount = 0
deleted = 0
pageMessage = "Page " + str(currentPage) + " / " + str(totalPages)

while currentPage < totalPages:
    if currentPage >= preservePages:
        for item in results:
            #pprint(item)
            currentId = str(item['id'])
            if deleted > preserveNewest:
                print(jobCount, ":" + pageMessage, "web_url", item['web_url'], '(' + projectId + '/jobs/' + currentId + '/erase)')
                deleteResponse = requests.post(GITLAB_URL + '/api/v4/projects/' + projectId + '/jobs/' + currentId + '/erase', headers=curl_headers)
                print(deleteResponse.text, "\n")
            else:
                print(pageMessage, "skipping job",  currentId)
            deleted += 1
            jobCount += 1

    # get response second
    #response = requests.get(GITLAB_URL + '/api/v4/projects/' + projectId + '/jobs?per_page=100&page=' + str(currentPage + 1), headers=curl_headers)
    response = requests.get(GITLAB_URL + '/api/v4/projects/' + projectId + '/jobs?page=' + str(currentPage + 1), headers=curl_headers)
    results = json.loads(response.text)
    responseHeaders = response.headers
    totalPages  = int(responseHeaders['X-Total-Pages'])
    currentPage = int(responseHeaders['X-Page'])
    pageMessage = "Page " + str(currentPage) + " / " + str(totalPages)
    jobCount = 0
