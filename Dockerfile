# 1. 빌드 단계
FROM public.ecr.aws/lambda/nodejs:20 AS builder

# 2. 작업 디렉토리 설정
WORKDIR /app

# 3. package.json 및 yarn.lock을 컨테이너에 복사
COPY package.json .
COPY yarn.lock .

RUN npm install -g yarn

# 4. 패키지 설치
RUN yarn

# 5. 나머지 애플리케이션 코드 복사
COPY . .

# 6. 애플리케이션 빌드
RUN yarn build

# 8. 프로덕션 이미지 단계
FROM public.ecr.aws/lambda/nodejs:20 AS production

# 9. 작업 디렉토리 설정
# /var/task
WORKDIR ${LAMBDA_TASK_ROOT}

# 10. 타임존 설정
RUN dnf install -y tzdata && \
    ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime && \
    echo "Asia/Seoul" > /etc/timezone && \
    dnf clean all

# 11. 빌드된 파일과 필요한 종속성만 복사[사이즈 줄이기 목적]
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./package.json
# COPY --from=builder /app/.env .env

# 12. 최종 명령어
CMD ["dist/main.handler"]