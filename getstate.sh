#!/bin/bash

cat .packages | while read name remote
do
    clone=$(echo $remote \
                   | sed -re 's|git@(.*):(.*)(.git)*$|https://\1/\2|p' \
                   | uniq)
    if [ "$DOWNLOAD" == "download" ]
    then
        curl ${clone}/archive/master.zip -o ${name}.zip
        unzip ${name}.zip
    else
        git clone $clone $name
    fi
done

# End
