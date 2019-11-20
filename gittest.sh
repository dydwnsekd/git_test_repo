#!/bin/bash

in_array() {
    local needle array value
    needle="${1}"; shift; array=("${@}")
    for value in ${array[@]}; do [ "${value}" == "${needle}" ] && echo "true" && return; done
    echo "false"
}

# git branch 목록
branchs=$(git branch -r 2>/dev/null | awk '{print $1}' | tr '/' ' ' | awk '{print $2}')

echo $branchs "\n " >> branch_list 