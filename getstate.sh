#!/bin/bash

cat .packages | while read name remote
do
    clone=$(echo $remote \
                   | sed -re 's|git@(.*):(.*)$|https://\1/\2|p' \
                   | uniq)

    case $DOWNLOAD in

        devnull)
            ;;

        download)
            download=$(echo $clone | sed -rne 's|(.*).git|\1|p')
            curl -Ls ${download}/archive/master.zip -o ${name}.zip
            unzip ${name}.zip
            ;;

        clone)
            git clone $clone $name
            ;;

    esac
done

# End
