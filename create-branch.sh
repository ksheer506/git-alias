#!/bin/bash

set -e

RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
RESET="\033[0m"

dev=$1
branch_prefix=$2
branch_no=$3

target_branch_name="${branch_prefix}${branch_no}"

# 현재 변경 사항 스태시
stashed=false
if ! git diff --quiet || ! git diff --cached --quiet; then
  git stash push -m "auto-stash"
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

git checkout "$dev"
git pull

# 로컬에 해당 브랜치가 이미 존재하는지 확인 후 체크아웃
if git branch --list "$target_branch_name" | grep -q "$target_branch_name"; then
  echo "Branch exists"
  git rebase "$dev" "$target_branch_name"
  git checkout "$target_branch_name"
else
  git checkout -b "$target_branch_name"
fi