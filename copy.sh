#!/bin/bash

RBG=$'\e[41m'
NORM=$'\e[0m'

echo Enter NEW configuration name
read CONFIG_NAME
DIR="/home/$USER/${CONFIG_NAME,,}"
echo $DIR
SUBDIR="/home/$USER/${CONFIG_NAME,,}/src/${CONFIG_NAME,,}"
echo $SUBDIR
# define linuxcnc venv location
VENV="/home/$USER/.linuxcnc_venv"

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

# Determine if venv exists, if not create, then activate
if [ -d "$VENV" ]; then
	# env exists
	echo Venv Exists
else
	echo Creating Venv
	python3 -m venv $VENV --system-site-packages
	# create an alias to enable in a shell when needed
	echo Create \'cncshell\' alias for later use in shells
	echo alias cncshell=\'source $VENV/bin/activate\' >> /home/$USER/.bash_aliases
fi

echo Activate Venv
source $VENV/bin/activate

if [ -d "$DIR" ]; then
  # Control will enter here if $DIR exists.
	echo The $DIR exists! Delete it and start again? Yes No
	read REPLY
	if [ ${REPLY,,} == "yes" ]; then
		rm -rf $DIR
		create
	else
		quit
	fi
else
	create
fi
