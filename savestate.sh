#!/bin/bash

ls \
    | while read dir
do
    [ -d $dir ] && echo $dir
done \
    | while read dir
do
    cd $dir
    remote=$(git remote -v | awk '/(fetch)/ { print $2}')
    echo $dir $remote
    cd ..
done > .packages

# End
