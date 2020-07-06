#!/bin/bash

# sample value for your variables
HOST="remotedev.in"
WORKSPACE="nodemon"
PSWRD="pass"

# read the yml template from a file and substitute the string 
# {{MYVARNAME}} with the value of the MYVARVALUE variable
template=`cat "code-server.yaml" | sed -e "s/{{HOST}}/$HOST/g" -e "s/{{WORKSPACE}}/$WORKSPACE/g" -e "s/{{PSWRD}}/$PSWRD/g"`

# apply the yml with the substituted value
echo "$template" | kubectl apply -f -