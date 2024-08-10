#!/opt/homebrew/opt/python@3.11/libexec/bin/python

import boto3, json

def listByRegion(argRegion):
    ec2 = boto3.client('ec2', region_name=argRegion)
    response = ec2.describe_security_groups()
    for i in response['SecurityGroups']:
        #print(i)
        #print("Security Group: " + i['GroupName'])
        #print("the Egress rules are as follows: ")
        #for j in i['IpPermissionsEgress']:
        #    print("IP Protocol: " + j['IpProtocol'])
        #    for k in j['IpRanges']:
        #        print("IP Ranges: " + k['CidrIp'])
        #print("The Ingress rules are as follows: ")
        #if i['GroupName'] == 'informer-5-sg':
        #print(json.dumps(i, indent=4))
        for j in i['IpPermissions']:
            #print(j)
            #print("IP Protocol: " + j['IpProtocol'])
            try:
                #print("PORT: " + str(j['FromPort']))
                for k in j['IpRanges']:
                    print(argRegion, ":", i['GroupName'], j['FromPort'], k['CidrIp'])
            except Exception as e:
                for k in j['IpRanges']:
                    print(argRegion, ":", i['GroupName'], k['CidrIp'])
                #print("exception", e)
                #print("No value for ports and ip ranges available for this security group")
                continue


listByRegion('us-west-1')
listByRegion('us-west-2')
listByRegion('us-east-1')
