#!/bin/bash

set -e

RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
RESET="\033[0m"

# 파라미터 처리
if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <protected_branch1> <protected_branch2> ... <commit_count>"
  exit 1
fi

current=$(git branch --show-current)
# 마지막 파라미터를 commit_count로 추출
commit_count="${@: -1}"
# 나머지 파라미터를 protected_branches로 추출
protected_branches=("${@:1:$#-1}")

# 현재 브랜치가 protected branch인지 확인
if [[ " ${protected_branches[@]} " =~ " ${current} " ]]; then
  echo -en "${RED}현재 브랜치 '$current'는 보호되었습니다. 작업을 중단합니다.${RESET}"
  exit 1
fi

# 현재 브랜치 내용 push
if ! git push origin "$current"; then
  git push origin --delete "$current"
  git push origin "$current"
  echo -e "${GREEN}로컬 변경 사항이 원격에 push되었습니다.${RESET}"
fi

# interactive rebase 시작
git rebase -i HEAD~"$commit_count"

# 원격 브랜치 제거 여부 확인
echo -en "${YELLOW}갈라진 원격 브랜치를 제거하려면 Enter를 누르세요.('q'를 입력해 취소할 수 있습니다.)...${RESET}"
read -n 1 -r input

if [[ "$input" == "q" ]]; then
  echo
  echo -en "${GREEN}원격 브랜치 제거 작업이 취소되었습니다..${RESET}"
  exit 0
elif [[ -z "$input" ]]; then
  git push origin --delete "$current"
fi

