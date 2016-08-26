#!/usr/bin/python

# Resolve cluster issues after the first boot of the NSX SDN-LAB pod.
# Hany Michael - www.networkskyx.com 

import requests
from xml.etree import ElementTree

url1='https://nsxmgr01.core.hypervizor.com//api/2.0/nwfabric/resolveIssues/domain-c7'
url2='https://nsxmgr01.core.hypervizor.com//api/2.0/nwfabric/resolveIssues/domain-c253'
url3='https://nsxmgr02.core.hypervizor.com//api/2.0/nwfabric/resolveIssues/domain-c7'

nsxmanager_user='admin'
nsxmanager_password='VMware1!'

nsx_headers={'content-type':'application/xml'}


try:
        response = requests.post(url1, headers=nsx_headers,auth=(nsxmanager_user,nsxmanager_password), verify=False)
except requests.exceptions.ConnectionError as e:
        print ("Connection error")

print (response.text)


try:
        response = requests.post(url2, headers=nsx_headers,auth=(nsxmanager_user,nsxmanager_password), verify=False)
except requests.exceptions.ConnectionError as e:
        print ("Connection error")

print (response.text)

try:
        response = requests.post(url3, headers=nsx_headers,auth=(nsxmanager_user,nsxmanager_password), verify=False)
except requests.exceptions.ConnectionError as e:
        print ("Connection error")

print (response.text)

