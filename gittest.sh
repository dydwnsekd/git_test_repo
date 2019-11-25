#!/bin/bash

in_array() {
    local needle array value
    needle="${1}"; shift; array=("${@}")
    for value in ${array[@]}; do [ "${value}" == "${needle}" ] && echo "true" && return; done
    echo "false"
}

old_branchs=$(cat branch_list 2>/dev/null)

# local과 원격 코드, branch 동기화
git fetch && git fetch -p && git reset --hard head && git pull

# git branch 목록
branchs=$(git branch -r 2>/dev/null | awk '{print $1}' | tr '/' ' ' | awk '{print $2}')

echo $branchs > branch_list 
cd ..

for old_branch in $old_branchs
do
    branch_check=`in_array $old_branch ${branchs[@]}`
    
    if [ "${branch_check}" == "false" ];
    then
        echo "$old_branch"
        rm -rf $old_branch
    fi
done