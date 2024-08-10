#!/opt/homebrew/bin/python3.11

import yaml, os, pprint, logging, datetime, sys, getopt
import inspect, json, pprint, fnmatch, boto3
from jinja2 import *

from botocore.exceptions import ClientError


aws_dictionary = {}

aws_dictionary["bundle"]      = ""
aws_dictionary["id"]          = ""
aws_dictionary["ports"]        = ""
aws_dictionary["sources"]     = ""
aws_dictionary["sourcedescs"] = ""

######## get parameters
# short options
arg_short_options = ""

# long options
arg_long_options = ['sourcedescs=', 'bundle=', 'id=', 'ports=', 'sources=']

########

def load_arg_env_variables():
    global arg_short_options, arg_long_options, aws_dictionary

    try:
        # rearrange the arguements so that it makes sense to the getopt program
        # there is an issue. It does not parse correctly whene the first option is
        # a non-switch related option. E.G. ./recorder.py all --run. It does not 'bundle'
        # correctly. We prioritize it to be --run all on the fly to tleverage
        # the getopts function
        # https://docs.python.org/3/library/getopt.html
        argv = sys.argv[1:]
        opts, args = getopt.getopt(
                argv,
                arg_short_options,
                arg_long_options)
        print(opts, args)

        for option_name, option_value in opts:
            #print("option name " + option_name)
            # CICD run.  Do full run
            print("parse " + option_name)
            if option_name in ('--bundle'):
                aws_dictionary['bundle'] = 'bundle_' + option_value.lower();
            elif option_name in ('--id'):
                aws_dictionary['id'] = option_value
            elif option_name in ('--ports'):
                aws_dictionary['ports'] = option_value
            elif option_name in ('--sources'):
                aws_dictionary['sources'] = option_value
            elif option_name in ('--sourcedescs'):
                aws_dictionary['sourcedescs'] = option_value
            else:
                print("no match for " + option_name)

    except getopt.GetoptError as err:
        print('pre argument fetching ' + str(err))

load_arg_env_variables()


if not len(aws_dictionary['id']):
    print("no input");
    exit(1);

aws_dictionary['bundle_prod_22'] = [
        {
            'IpProtocol': 'tcp',
            'FromPort': 22,
            'ToPort': 22,
            'IpRanges': [
                {
                    'CidrIp': '10.131.0.0/16',
                    'Description': 'Prod AWS'
                    }
                ]
            },
        {
            'IpProtocol': 'tcp',
            'FromPort': 22,
            'ToPort': 22,
            'IpRanges': [
                {
                    'CidrIp': '172.31.0.0/16',
                    'Description': 'Prod DC'
                    }
                ]
            }
        ];


aws_dictionary['bundle_prod_80'] = [
        {
            'IpProtocol': 'tcp',
            'FromPort': 80,
            'ToPort': 80,
            'IpRanges': [
                {
                    'CidrIp': '10.131.0.0/16',
                    'Description': 'Prod AWS'
                    }
                ]
            },
        {
            'IpProtocol': 'tcp',
            'FromPort': 80,
            'ToPort': 80,
            'IpRanges': [
                {
                    'CidrIp': '172.31.0.0/16',
                    'Description': 'Prod DC'
                    }
                ]
            }
        ];

securityGroupID = "sg-0b4722e04fe338167";
targetCidrBlock = "";


def getComment(argIndex, argDescArray):
    if argIndex >= len(argDescArray):
        return "";


    print(argIndex, argDescArray);
    return argDescArray[argIndex];


def generatePermutation(argPorts, argSources, argSourceDescs):

    cidrBlock = [];
    portArray = argPorts.split(',');
    sourceArray = argSources.split(',');
    descArray = argSourceDescs.split(',');
    arrayIndex = 0;
    for port in portArray:
        for source in sourceArray:
            cidrBlock.append(
                    {
                        'IpProtocol': 'tcp',
                        'FromPort': int(port),
                        'ToPort': int(port),
                        'IpRanges': [
                            {
                                'CidrIp': source,
                                'Description': getComment(arrayIndex, descArray)
                                }
                            ]
                        }

                    );

            arrayIndex+= 1

    return cidrBlock;

# if this was filled out
if len(aws_dictionary['bundle']):
    targetCidrBlock = aws_dictionary[aws_dictionary['bundle']];
else:
    securityGroupID = aws_dictionary['id'];
    targetCidrBlock = generatePermutation( aws_dictionary['ports'], aws_dictionary['sources'], aws_dictionary['sourcedescs']);

ec2 = boto3.client('ec2')

response = ec2.describe_vpcs()
print(response);
#vpc_id = response.get('Vpcs', [{}])[0].get('VpcId', '')

for cBlock in targetCidrBlock:
    try:
        data = ec2.authorize_security_group_ingress(
                GroupId = securityGroupID,
                IpPermissions = [cBlock]
                )
        print('Ingress Successfully Set %s' % data)
    except ClientError as e:
        print(e)
