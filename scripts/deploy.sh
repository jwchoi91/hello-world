#!/bin/bash

# 변수 설정
ECR_REPOSITORY_APP_NAME="test/jwchoi"
FUNCTION_NAME="test-jwchoi"

IMAGE_TAG="latest"
DOCKER_FILE="Dockerfile"
REGION="ap-northeast-1"
ACCOUNT_ID="471112676002"
IMAGE_URI="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${ECR_REPOSITORY_APP_NAME}:${IMAGE_TAG}"

# AWS CLI와 Docker 로그인
aws --profile jenkins ecr get-login-password | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com

# ECR 리포지토리 생성
aws --profile jenkins ecr create-repository --repository-name ${ECR_REPOSITORY_APP_NAME} --region ${REGION}

# Docker 이미지 빌드 및 푸시
# DOCKER_DEFAULT_PLATFORM="linux/amd64"
docker build --platform="linux/amd64" -t ${ECR_REPOSITORY_APP_NAME} -f ${DOCKER_FILE} .
docker tag ${ECR_REPOSITORY_APP_NAME}:${IMAGE_TAG} ${IMAGE_URI}
docker push ${IMAGE_URI}

# Lambda 함수 업데이트
aws --profile jenkins lambda create-function --function-name ${FUNCTION_NAME} --package-type Image  --code ImageUri=${IMAGE_URI} --role arn:aws:iam::471112676002:role/lambda-role --region ${REGION}

aws --profile jenkins lambda update-function-code --function-name ${FUNCTION_NAME} --image-uri ${IMAGE_URI} --region ${REGION}
