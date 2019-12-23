#!/bin/bash

origin_path="/Users/dydwnsekd/Documents/git/git_test/master/"
compare_path="/Users/dydwnsekd/Documents/git/git_test/copy/"

file_list=$(ls -R)

origin_dir_path=$origin_path
compare_dir_path=$compare_path

for file in $file_list
do
    if [ "${file:(-1)}" == ":" ];
    then
        dir_path=${file:2:${#file}-3}/
        origin_dir_path=$origin_path$dir_path
        compare_dir_path=$compare_path$dir_path
    else
        origin_full_path=$origin_dir_path$file
        compare_full_path=$compare_dir_path$file

        if [ -e $compare_full_path ];
        then
            result_diff=`diff --brief ${origin_full_path} ${compare_full_path} | awk '{print $1}'`

            if [ "${result_diff}" == "Files" ];
            then
                echo $origin_full_path
                rm -rf $compare_full_path
                cp $origin_full_path $compare_full_path
            fi
        else
            echo $origin_full_path "is new file"
            cp $origin_full_path $compare_full_path
        fi
    fi
done

