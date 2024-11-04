@echo off

rem 변수 설정
set ECR_REPOSITORY_APP_NAME=test/jwchoi
set FUNCTION_NAME=test-jwchoi

set IMAGE_TAG=latest
set DOCKER_FILE=Dockerfile
set REGION=ap-northeast-1
set ACCOUNT_ID=471112676002
set IMAGE_URI=%ACCOUNT_ID%.dkr.ecr.%REGION%.amazonaws.com/%ECR_REPOSITORY_APP_NAME%:%IMAGE_TAG%

rem AWS CLI와 Docker 로그인
aws --profile jenkins ecr get-login-password --region %REGION% | docker login --username AWS --password-stdin %ACCOUNT_ID%.dkr.ecr.%REGION%.amazonaws.com

rem ECR 리포지토리 생성
aws ecr create-repository --repository-name %ECR_REPOSITORY_APP_NAME% --region %REGION%

rem Docker 이미지 빌드 및 푸시
docker build -t %ECR_REPOSITORY_APP_NAME% -f %DOCKER_FILE% .
docker tag %ECR_REPOSITORY_APP_NAME%:%IMAGE_TAG% %IMAGE_URI%
docker push %IMAGE_URI%

rem Lambda 함수 업데이트
aws lambda update-function-code --function-name %FUNCTION_NAME% --image-uri %IMAGE_URI%
