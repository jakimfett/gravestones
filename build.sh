#!/bin/bash

if [ -z $BUILD_NUMBER ]; then
    BUILD_NUMBER="0"
fi

sed -i "s/BUILD/$BUILD_NUMBER/g" info.json

# Change this to your current factorio install directory
FACTORIOBASEDIR=~/bin/factorio

CURRENTDIRECTORY=${PWD##*/}
FACTORIOMODSDIRECTORY="${PWD##*/}/build"
MODBASENAME=$(cat info.json | grep -Po '(?<="name": ")[^"]*')
CURRENTVERSION=$(cat info.json | grep -Po '(?<="version": ")[^"]*')

cd ../


rm -f $FACTORIOMODSDIRECTORY/$MODBASENAME*
rm -f $FACTORIOBASEDIR/mods/$MODBASENAME*
mkdir -p $FACTORIOMODSDIRECTORY

ln -s $CURRENTDIRECTORY "${MODBASENAME}_${CURRENTVERSION}"

zip -r "${FACTORIOMODSDIRECTORY}/${MODBASENAME}_${CURRENTVERSION}.zip" \
    "${MODBASENAME}_${CURRENTVERSION}" -x *.git* -x *build* -x graphics/screenshot.png

rm "${MODBASENAME}_${CURRENTVERSION}"

cd $CURRENTDIRECTORY
git checkout -- info.json


cp "build/${MODBASENAME}_${CURRENTVERSION}.zip" ~/bin/factorio/mods/
