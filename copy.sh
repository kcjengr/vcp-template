#!/bin/bash

echo Enter NEW configuration name
read CONFIG_NAME
DIR="/home/$USER/${CONFIG_NAME,,}"
echo $DIR
SUBDIR="/home/$USER/${CONFIG_NAME,,}/src/${CONFIG_NAME,,}"
echo $SUBDIR

function quit {
	exit
}

function create {
	echo Copying the Files to $DIR
	echo from $PWD
	cp -r $PWD/myvcp/ $DIR
	# now correct the sub dir for the correct name
	mv $DIR/src/myvcp $SUBDIR
	sed -i.bak "s/myvcp/${CONFIG_NAME,,}/g; s/MyVCP/$CONFIG_NAME/g" $SUBDIR/config.yml
	sed -i.bak "s/myvcp/${CONFIG_NAME,,}/g; s/MyVCP/$CONFIG_NAME/g" $SUBDIR/__init__.py
	sed -i.bak "s/myvcp/${CONFIG_NAME,,}/g; s/MyVCP/$CONFIG_NAME/g" $DIR/pyproject.toml
    sed -i.bak "s/myvcp/${CONFIG_NAME,,}/g; s/MyVCP/$CONFIG_NAME/g" $DIR/debian/rules
    sed -i.bak "s/myvcp/${CONFIG_NAME,,}/g; s/MyVCP/$CONFIG_NAME/g" $DIR/debian/control
	cp $PWD/LICENSE $DIR
	cd $DIR
	set -x
	pip install -e .
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
