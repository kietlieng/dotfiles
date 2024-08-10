#!/usr/local/bin/python3
import os, requests, json, sys
from pprint import pprint

GITLAB_TOKEN = os.getenv('GITLAB_TOKEN')
GITLAB_URL = os.getenv('GITLAB_URL')
if len(sys.argv) < 1:
    exit(1)

projectId = "0"
currentPage = "0"
if len(sys.argv) > 1:
    currentPage = str(sys.argv[1])
print(sys.argv)
curlHeaders = {
    'PRIVATE-TOKEN': GITLAB_TOKEN,
}

glFile = open("~/lab/scripts/servers/gitlablist.txt", "r")
lines = glFile.readlines()

glLimit = 50000
glList = []
count=0
for line in lines:
    count += 1
    print("Line{}: {}".format(count, line.strip()))
    glList.append(line.strip())

print(glList)
for projectId in glList:
    print(projectId)

    #response = requests.get(GITLAB_URL + '/api/v4/projects/' + projectId + '/jobs?per_page=100&page=' + currentPage, headers=curlHeaders)
    response = requests.get(GITLAB_URL + '/api/v4/projects/' + projectId + '/jobs?page=' + str(currentPage), headers=curlHeaders)
    responseHeaders = response.headers

    try:
        totalPages  = int(responseHeaders['X-Total-Pages'])
        currentPage = int(responseHeaders['X-Page'])
    except:
        print("hitting issue on page", currentPage, "Jumping to next project")
        currentPage = 0
        continue
    results = json.loads(response.text)
    #print(currentPage, totalPages, results)
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
                    deleteResponse = requests.post(GITLAB_URL + '/api/v4/projects/' + projectId + '/jobs/' + currentId + '/erase', headers=curlHeaders)
                    print(deleteResponse.text, "\n")
                else:
                    print(pageMessage, "skipping job",  currentId)
                deleted += 1
                jobCount += 1

        # get response second
        #response = requests.get(GITLAB_URL + '/api/v4/projects/' + projectId + '/jobs?per_page=100&page=' + str(currentPage + 1), headers=curlHeaders)
        response = requests.get(GITLAB_URL + '/api/v4/projects/' + projectId + '/jobs?page=' + str(currentPage + 1), headers=curlHeaders)
        results = json.loads(response.text)
        responseHeaders = response.headers
        try:
            totalPages  = int(responseHeaders['X-Total-Pages'])
            currentPage = int(responseHeaders['X-Page'])
        except:
            print("hitting issue on page", currentPage, "Jumping to next project")
            # increment if can't find it
            currentPage += 1

        if currentPage > glLimit:
            print("breaking because reached", glLimit, "page limit")
            currentPage = 0
            break

        pageMessage = "Page " + str(currentPage) + " / " + str(totalPages)
        jobCount = 0
