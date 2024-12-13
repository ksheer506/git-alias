#!/bin/bash

set -e

RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
RESET="\033[0m"

dev=$1
ci=$2
current=$(git branch --show-current)

if [ -z "$1" ] || [ -z "$2" ]; then
  echo -e "${RED}dev, ci 브랜치를 결정하기 위해 두 개의 파라미터가 필요합니다.${RESET}"
  exit 1
fi

# 현재 변경 사항 스태시
stashed=false
if ! git diff --quiet || ! git diff --cached --quiet; then
  git stash push -m "auto-stash before merge"
  stashed=true
  echo "커밋되지 않은 변경 사항이 스태시되었습니다."
fi

# 스태시 복원 트랩 설정
restore_stash() {
  if $stashed; then
    echo -e "${GREEN}스태시를 복원하는 중입니다...${RESET}"
    git stash pop || echo -e "${RED}스태시 복원이 실패했습니다. 수동으로 복원하세요.${RESET}"
  fi
}
trap restore_stash EXIT

# dev 브랜치로 전환 및 병합
git checkout "$dev"
git pull
if ! git merge "$current" --no-edit; then
  echo -en "${YELLOW}dev 브랜치에서 merge 충돌이 발생했습니다. 충돌을 해결하고 Enter를 누르세요.('q'를 입력해 종료할 수 있습니다.)...${RESET}"
  read input
  [[ "$input" == "q" ]] && exit 1
fi

# ci 브랜치로 전환 및 병합
git checkout "$ci"
git pull
if ! git merge "$dev" --no-edit; then
  echo -en "${YELLOW}ci 브랜치에서 merge 충돌이 발생했습니다. 충돌을 해결하고 Enter를 누르세요.('q'를 입력해 종료할 수 있습니다.)...${RESET}"
  read input
  [[ "$input" == "q" ]] && exit 1
fi

# 사용자 확인 후 push
echo -en "${YELLOW}dev와 ci 브랜치를 원격에 push하려면 Enter를 누르세요.('q'를 입력해 종료할 수 있습니다.)...${RESET}"
read input
[[ "$input" == "q" ]] && exit 1

# push 동작
git checkout "$dev"
git push
git checkout "$ci"
git push

# 원래 브랜치로 복귀
git checkout "$current"
