#!/bin/bash

ls && cd .. && ls

in_array() {
    local needle array value
    needle="${1}"; shift; array=("${@}")
    for value in ${array[@]}; do [ "${value}" == "${needle}" ] && echo "true" && return; done
    echo "false"
}

cd ..
branch_dirs=$(ls)

for dir in $branch_dirs
do
        echo "$dir"
done
