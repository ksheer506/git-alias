#!/bin/bash

current=$(git branch --show-current)

# dev 브랜치로 전환 및 병합
git checkout dev
git pull
git merge "$current" || { echo "Resolve conflicts in dev and press Enter to continue (or type 'exit' to quit)..."; read input; [[ "$input" == "exit" ]] && exit 1; }

# main 브랜치로 전환 및 병합
git checkout main
git pull
git merge dev || { echo "Resolve conflicts in main and press Enter to continue (or type 'exit' to quit)..."; read input; [[ "$input" == "exit" ]] && exit 1; }

# 사용자 확인 후 push
echo "Press Enter to push dev and main branches (or type 'exit' to quit)..."
read input
[[ "$input" == "exit" ]] && exit 1

# push 동작
git checkout dev
git push
git checkout main
git push

# 원래 브랜치로 복귀
git checkout "$current"
