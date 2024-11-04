#!/bin/bash
FILE_NAME=ssq-lambda-jwchoi.zip
zip -r ./release/s3/$FILE_NAME node_modules dist  #.env
aws --profile jenkins s3 cp ./release/s3/$FILE_NAME s3://ssq-lambda