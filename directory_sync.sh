#!/bin/bash

parameter_check()
{
    echo "Usage: $0 [origin dir path] [compare dir path]"
}

if [ $# -ne 2 ]
then
    parameter_check
    exit 0
fi

origin_path=$1
compare_path=$2

origin_dir_path=$origin_path
compare_dir_path=$compare_path

cd $origin_path
file_list=$(ls -R)

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
                #echo $origin_full_path
                rm -rf $compare_full_path
                cp $origin_full_path $compare_full_path
            fi
        else
            #echo $origin_full_path "is new file"
            echo "not ex"
            cp $origin_full_path $compare_full_path
        fi
    fi
done

unset dir_path
unset compare_dir_path
unset compare_full_path

cd $compare_path
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

        if [ -e $origin_full_path ];
        then
            :
        else
            rm -rf $compare_full_path
        fi
    fi
done


