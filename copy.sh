#!/bin/bash

echo Enter NEW configuration name
read CONFIG_NAME
DIR="/home/$USER/${CONFIG_NAME,,}"
echo $DIR
SUBDIR="/home/$USER/${CONFIG_NAME,,}/${CONFIG_NAME,,}"
echo $SUBDIR

function quit {
	exit
}

function create {
	echo Creating the Directory $DIR
	mkdir -p $DIR
	echo Copying the Files
	echo $PWD
	cp -r $PWD/myvcp $DIR/${CONFIG_NAME,,}
	sed -i.bak "s/myvcp/${CONFIG_NAME,,}/g; s/MyVCP/$CONFIG_NAME/g" $SUBDIR/config.yml
	sed -i.bak "s/myvcp/${CONFIG_NAME,,}/g; s/MyVCP/$CONFIG_NAME/g" $SUBDIR/__init__.py
	cp $PWD/setup.py $DIR
	sed -i.bak "s/myvcp/${CONFIG_NAME,,}/g; s/MyVCP/$CONFIG_NAME/g" $DIR/setup.py
	cp $PWD/README.md $DIR
	cp $PWD/MANIFEST.in $DIR
	cp $PWD/LICENSE $DIR
	cd $DIR
	set -x
	pip install --user -e .
}

if [ -d "$DIR" ]; then
  # Control will enter here if $DIR exists.
	echo The $DIR exists! Delete it and start again? Yes No
	read REPLY
	if [ ${REPLY,,} == "yes" ]; then
		create
	else
		quit
	fi
else
	create
fi
