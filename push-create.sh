#!/bin/bash

# 현재 브랜치 확인
CURRENT_BRANCH=$(git branch --show-current)

if [ -z "$CURRENT_BRANCH" ]; then
  echo "현재 브랜치가 없습니다. Git 저장소 안에서 실행해주세요."
  exit 1
fi

# 원격 저장소 URL 확인
REMOTE_URL=$(git remote get-url origin 2>/dev/null)

# 원격 저장소가 없으면 추가
if [ -z "$REMOTE_URL" ]; then
  echo "원격 저장소 'origin'이 없습니다. 새로운 원격을 추가합니다."
  read -p "추가할 원격 저장소 URL을 입력하세요: " NEW_REMOTE_URL

  if [ -z "$NEW_REMOTE_URL" ]; then
    echo "원격 저장소 URL이 입력되지 않았습니다. 스크립트를 종료합니다."
    exit 1
  fi

  git remote add origin "$NEW_REMOTE_URL"
  if [ $? -ne 0 ]; then
    echo "원격 저장소 추가에 실패했습니다."
    exit 1
  fi
  echo "원격 저장소가 추가되었습니다: $NEW_REMOTE_URL"
else
  echo "원격 저장소가 이미 설정되어 있습니다: $REMOTE_URL"
fi

# 브랜치 푸시
echo "현재 브랜치 '$CURRENT_BRANCH'를 원격 저장소로 푸시합니다."
git push -u origin "$CURRENT_BRANCH"

if [ $? -eq 0 ]; then
  echo "브랜치 '$CURRENT_BRANCH'가 성공적으로 푸시되었습니다."
else
  echo "푸시에 실패했습니다."
  exit 1
fi