#!/bin/bash

# 배열에 내가 찾는 값이 있는지 확인하는 함수
in_array() {
    local needle array value
    needle="${1}"; shift; array=("${@}")
    for value in ${array[@]}; do [ "${value}" == "${needle}" ] && echo "true" && return; done
    echo "false"
}

# local과 원격 코드, branch 동기화
git fetch && git fetch -p

# git branch 목록
branchs=$(git branch -r 2>/dev/null | awk '{print $1}' | tr '/' ' ' | awk '{print $2}')

# master은 제거
except_branch=("HEAD" "master")

cd ..

# branch별로 directory를 관리하는데 로컬에 있는 directory 목록 확인
branch_dirs=$(ls)

# branch들 모두 확인
for dir in $branch_dirs
do
        # master을 제외한 다른 branch들에 대해서만 확인할 수 있도록 체크
        branch_check=`in_array $dir ${except_branch[@]}`
        
        # directory명이 branch중에 있으면 true 없으면 false
        dir_check=`in_array $dir ${branchs[@]}` 

        if [ "${branch_check}" == "false" ]; then
                
                if [ "${dir_check}" == "false" ]; then
                        rm -rf $dir
                fi
        fi
done
