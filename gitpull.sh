#!/bin/bash

parameter_check()
{
    echo "Usage: $0 [git master path] [git url]"
}

# 배열에 내가 찾는 값이 있는지 확인하는 함수
in_array()
{
    local needle array value
    needle="${1}"; shift; array=("${@}")
    for value in ${array[@]}; do [ "${value}" == "${needle}" ] && echo "true" && return; done
    echo "false"
}

path='./'
git_url=''

if [ $# -ne 2 ]
then
    parameter_check
    exit 0
elif [ $2 -eq '' ]
then
    echo $2
    echo "input git_url"
    parameter_check
    exit 0
fi

path=$1
git_url=$2

cd $path

# local과 원격 코드, branch 동기화
git fetch && git fetch -p && git reset --hard head && git pull

# git_url 수정 필요
# git_url="git@github.com:dydwnsekd/git_test_repo.git"

# git branch 목록
branchs=$(git branch -r 2>/dev/null | awk '{print $1}' | tr '/' ' ' | awk '{print $2}')

# master은 제거
except_branch=("HEAD" "master")

cd ..

# branch별로 directory를 관리하는데 로컬에 있는 directory 목록 확인
branch_dirs=$(ls)

# branch들 모두 확인
for branch in $branchs
do
    # master을 제외한 다른 branch들에 대해서만 확인할 수 있도록 체크
    branch_check=`in_array $branch ${except_branch[@]}`
    
    # branch directory가 이미 있을 경우 true(branch directory 가 존재) / false(branch는 있는데 dirtory가 없음)
    dir_check=`in_array $branch ${branch_dirs[@]}` 

    if [ "${branch_check}" == "false" ]; then
            
        if [ "${dir_check}" == "true" ]; then
                cd $branch && git fetch && git reset --hard head && git pull && cd ..
        else
                git clone -b $branch $git_url $branch
        fi
    fi
done
