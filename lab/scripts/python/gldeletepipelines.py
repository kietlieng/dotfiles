#!/usr/local/bin/python3
import os, requests, json, sys, re, time
from pprint import pprint


GITLAB_TOKEN = os.getenv('GITLAB_TOKEN')
GITLAB_URL = os.getenv('GITLAB_URL')
if len(sys.argv) < 2:
    print("Need projectID")
    exit(1)

projectId = sys.argv[1]
currentPage = "0"
jobTargetNames = ".*"

# page offset
if len(sys.argv) > 2:
    currentPage = sys.argv[2]

# target jobnames to lookfor 
if len(sys.argv) > 3:
    jobTargetNames = sys.argv[3]

print(sys.argv)
headers = {
    'PRIVATE-TOKEN': GITLAB_TOKEN,
}

print(GITLAB_URL + '/api/v4/projects/' + projectId + '/pipelines?per_page=100&page=' + currentPage)
response = requests.get(GITLAB_URL + '/api/v4/projects/' + projectId + '/pipelines?per_page=100&page=' + currentPage, headers=headers)
responseHeaders = response.headers

print(responseHeaders)

results = json.loads(response.text)
print(results)

preserveNewest = 100
deleted = 0
pageMessage = "Page " + str(currentPage)
pipelineCount=0
jobCount=0
while True:

    pipelineCount=0
    jobCount=0

    for item in results:

        piplineID = str(item['id'])
        if deleted > preserveNewest:
#            print(item, depth=2)
#            print(item)
            print(GITLAB_URL + '/api/v4/projects/' + projectId + '/pipelines/' +  piplineID + '/jobs?scope[]=success&scope[]=canceled&scope[]=failed', currentPage, pipelineCount)
#            print("pipeline id", piplineID)
#            pprint(item, depth=2)
            # get jobs for a pipeline
            pipelineResponse = requests.get(GITLAB_URL + '/api/v4/projects/' + projectId + '/pipelines/' +  piplineID + '/jobs?scope[]=success&scope[]=canceled&scope[]=failed', headers=headers)
#            GET /projects/:id/pipelines/:pipeline_id/jobs

            jobResults = json.loads(pipelineResponse.text)
#            print(pipelineResponse.text)
            for jobItem in jobResults:
                jobID = str(jobItem['id'])
                jobName = jobItem['name']
#                print("id", jobID, "name", jobName)
#                print(jobItem)

                # find match and delete artifacts
                if re.search(jobTargetNames, jobName):
                    deleteResponse = requests.delete(GITLAB_URL + '/api/v4/projects/' + projectId + '/jobs/' + jobID + '/artifacts', headers=headers)
                    jobCount += 1
                    print("Name Matched deleted status:", deleteResponse.status_code, jobCount, jobID, jobName)

                    # sleep every pages calls
                    if (jobCount % 30) == 0:
                        print("\n\nsleep ...", jobCount)
                        time.sleep(1)

        else:
            print(pageMessage, "skipping pipeline",  piplineID)
        deleted += 1
        pipelineCount += 1

#    exit(1)

    if pipelineCount < 3:
        print("there are no more items on the page.  Quitting")
        break

    # get response second
    response = requests.get(GITLAB_URL + '/api/v4/projects/' + projectId + '/pipelines?per_page=100&page=' + str(int(currentPage) + 1), headers=headers)
    print('>> ' + GITLAB_URL + '/api/v4/projects/' + projectId + '/pipelines?per_page=100&page=' + str(int(currentPage) + 1))
    results = json.loads(response.text)
    responseHeaders = response.headers

    nextCurrentPage = int(currentPage) + 1


    currentPage = str(nextCurrentPage)

    pageMessage = "Page " + str(currentPage)
