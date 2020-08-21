#!/usr/bin/env bash
#!/bin/sh
if [ $# -ne 3 ]
then
 echo "Example Dev east infra"
 exit 1
fi

environment=$1
region=$2
operation=$3


if [ $environment == "Dev" ]
then
	if [ $region == "east" ]
	then
		AMI="ami-0a54aef4ef3b5f881"
		VPC="vpc-cb6ecda0"
		Subnet1="subnet-af7f17e3"
		Subnet2="subnet-5c488337"
		KeyName="Mediawiki_key"
		CertificateARN="arn:aws:acm:us-east-2:271416318392:certificate/47b58fc3-54aa-4ac3-80dd-9b79b0f2f7aa"
		HostZone="mediawiki.poc.com."
	else
		echo "Inavlid params"
		exit 1
	fi
else
	echo "Invalid environment"
	exit 1
fi

# get user working directory

#git clone -b ${branch} https://github.com/Manutd34/Mediawiki.git


if [ $operation == "infra" ]
then
	echo "Stack creation is about to start"
	aws cloudformation create-stack --stack-name pocstack --template-body file://Mediawiki.yaml \
	--parameters ParameterKey=Environment,ParameterValue=Dev ParameterKey=AMI,ParameterValue=${AMI} \
	ParameterKey=VPC,ParameterValue=${VPC} ParameterKey=Subnet1,ParameterValue=${Subnet1} \
	ParameterKey=Subnet2,ParameterValue=${Subnet2} ParameterKey=KeyName,ParameterValue=${KeyName} \
	ParameterKey=CertificateARN,ParameterValue=${CertificateARN} ParameterKey=HostZone,ParameterValue=${HostZone}

	# wait for stack to be created

	aws cloudformation wait stack-create-complete --stack-name pocstack

	echo "stack creation is done for Mediawiki"
else
	echo "Operation is invalid"
fi

