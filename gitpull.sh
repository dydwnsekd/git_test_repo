#!/bin/bash

git fetch
git_url="git@github.com:dydwnsekd/git_test_repo.git"
branchs=$(git branch -r 2>/dev/null | awk '{print $1}' | tr '/' ' ' | awk '{print $2}')

except_branch=("HEAD" "master")

#branchs=$(echo 'git branch -r 2>/dev/null | awk `{print $1}`' | tr "\n" "/")
#echo "$branchs"

in_array() {
    local needle array value
    needle="${1}"; shift; array=("${@}")
    for value in ${array[@]}; do [ "${value}" == "${needle}" ] && echo "true" && return; done
    echo "false"
}

cd ..
find . ! -name "master/" -delete

for branch in $branchs
do
        branch_check=`in_array $branch ${except_branch[@]}`
        if [ "${branch_check}" == "false" ]; then
                echo "$branch"

                rm -rf $branch
                pwd
                git clone -b $branch $git_url $branch
        fi
done
