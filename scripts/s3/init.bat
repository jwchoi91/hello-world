@echo off
set FILE_NAME=ssq-lambda-jwchoi.zip

REM 압축하기 (PowerShell 사용, Windows에서는 zip이 기본 제공되지 않음)
powershell Compress-Archive -Path node_modules, dist -DestinationPath .\release\s3\%FILE_NAME%

REM AWS CLI로 파일 업로드 (profile 설정과 s3 경로는 동일하게 사용)
aws --profile jenkins s3 cp .\release\s3\%FILE_NAME% s3://ssq-lambda
