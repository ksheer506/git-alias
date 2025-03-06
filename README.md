# git-alias

전역 .gitconfig 또는 프로젝트 별 /.git/config 파일에 alias 설정

### 1. auto-merge

현재 브랜치를 dev, ci 브랜치에 차례차례로 merge. 로컬에서 merge가 완료되면 사용자 입력을 받아 원격에 push.

```shell
# .gitconfig
# dev, ci 브랜치 순으로 파라미터 전달
merge = !bash C:/auto-merge.sh dev pc-ci
```

### 2. safe-interactive-rebase

interactive rebase 시 예기치 못한 오류로 작업 내용이 손실되지 않도록 현재 브랜치를 원격에 push 후, 사용자 입력에 따라 임시로 push한 원격 제거.

```shell
# .gitconfig
# 하나 이상의 보호할 브랜치를 파라미터로 전달
safe-rebase = !bash C:/safe-interactive-rebase.sh dev pc-ci pc-qa mobile-ci mobile-qa
```

```shell
# 현재 브랜치에서 HEAD를 포함한 3개 커밋을 interactive rebase
git safe-rebase 3
```

### 3. create-branch

특정 브랜치를 시작점으로 하는 브랜치를 생성해 체크 아웃. 만약 해당 이름의 브랜치가 존재한다면 시작 브랜치로 rebase 후 체크 아웃.

```shell
# .gitconfig
# param0: 새 브랜치의 시작 브랜치
# param1: 브랜치 생성 시 사용할 prefix. 
 branch = !bash C:/create-branch.sh dev sunghyeon
```

```shell
# dev를 시작점으로 하는 sunghyeon1100 브랜치 생성
git branch 1100
```
