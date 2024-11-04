@echo off

set ECR_REPOSITORY_APP_NAME=test/jwchoi
set FUNCTION_NAME=test-jwchoi
set IMAGE_TAG=latest
set DOCKER_FILE=Dockerfile
set REGION=ap-northeast-1
set ACCOUNT_ID=471112676002
set IMAGE_URI=%ACCOUNT_ID%.dkr.ecr.%REGION%.amazonaws.com/%ECR_REPOSITORY_APP_NAME%:%IMAGE_TAG%

echo ECR_REPOSITORY_APP_NAME=%ECR_REPOSITORY_APP_NAME%
echo FUNCTION_NAME=%FUNCTION_NAME%
echo IMAGE_TAG=%IMAGE_TAG%
echo DOCKER_FILE=%DOCKER_FILE%
echo REGION=%REGION%
echo ACCOUNT_ID=%ACCOUNT_ID%
echo IMAGE_URI=%IMAGE_URI%

aws --profile jenkins ecr get-login-password | docker login --username AWS --password-stdin %ACCOUNT_ID%.dkr.ecr.%REGION%.amazonaws.com

aws --profile jenkins ecr create-repository --repository-name %ECR_REPOSITORY_APP_NAME%

docker build -t %ECR_REPOSITORY_APP_NAME% -f %DOCKER_FILE% .
docker tag %ECR_REPOSITORY_APP_NAME%:%IMAGE_TAG% %IMAGE_URI%
docker push %IMAGE_URI%

aws --profile jenkins lambda create-function --function-name %FUNCTION_NAME% --package-type Image  --code ImageUri=%IMAGE_URI% --role arn:aws:iam::471112676002:role/lambda-role --region %REGION%

aws --profile jenkins lambda update-function-code --function-name %FUNCTION_NAME% --image-uri %IMAGE_URI% --region %REGION%