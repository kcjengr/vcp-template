#!/bin/bash

RBG=$'\e[41m'
NORM=$'\e[0m'

function quit {
    exit
}

function copy_vcp {
    DIR="/home/$USER/${1,,}"
    SUBDIR="/home/$USER/${1,,}/src/${1,,}"
    if [ -d "$DIR" ]; then
        while true
        do
            read -p "${RBG}The $DIR directory exists!${NORM} Delete it and start again? Yes No " input
            case $input in
                [yY][eE][sS]|[yY])
                    echo Deleting the Directory $DIR
                    rm -r $DIR
                    break ;;
                [nN][oO]|[nN])
                    quit;;
                *)
                    echo "Invalid input...";;
            esac
        done
    fi
    echo VCP Template files sourced from $TEMPLATE_DIR
    echo Copying the VCP Template to $DIR

    #echo Copying the Files
    #echo $PWD
    #cp -r $PWD/tutorial $DIR/${VCP_NAME,,}

    cp -r $TEMPLATE_DIR/tutorial/ $DIR
    # now correct the sub dir for the correct name
    mv $DIR/src/myvcp $SUBDIR

    sed -i.bak "s/myvcp/${VCP_NAME,,}/g; s/MyVCP/$VCP_NAME/g" $SUBDIR/config.yml
    sed -i.bak "s/myvcp/${VCP_NAME,,}/g; s/MyVCP/$VCP_NAME/g" $SUBDIR/__init__.py
    sed -i.bak "s/myvcp/${VCP_NAME,,}/g; s/MyVCP/$VCP_NAME/g" $DIR/pyproject.toml
    sed -i.bak "s/myvcp/${VCP_NAME,,}/g; s/MyVCP/$VCP_NAME/g" $DIR/debian/rules
    sed -i.bak "s/myvcp/${VCP_NAME,,}/g; s/MyVCP/$VCP_NAME/g" $DIR/debian/control
    cp $PWD/LICENSE $DIR
    cd $DIR
    set -x
    pip install -e .
    set +x
    cd $TEMPLATE_DIR
    echo -e "\e[1;41mNote:\e[21m to edit the VCP in a terminal\e[0m editvcp ${VCP_NAME,,}"
}


function copy_config {
    CONFIG_DIR="/home/$USER/linuxcnc/configs/${VCP_NAME,,}"
    if [ -d "$CONFIG_DIR" ]; then
        while true
        do
            read -p "${RBG}The $CONFIG_DIR directory exists!${NORM} Delete it and start again? Yes No " input
            case $input in
                [yY][eE][sS]|[yY])
                    echo Deleting the Directory $CONFIG_DIR
                    rm -r $CONFIG_DIR
                    echo Creating the Directory $CONFIG_DIR
                    mkdir -p $CONFIG_DIR
                    break ;;
                [nN][oO]|[nN])
                    quit;;
                *)
                    echo "Invalid input...";;
            esac
        done
    else
        echo Creating the Directory $CONFIG_DIR
        mkdir -p $CONFIG_DIR
    fi
    echo Copying Sample Config Files from $PWD/basic_vcp/ to $CONFIG_DIR
    cp -r $TEMPLATE_DIR/basic_vcp/* $CONFIG_DIR
    mv $CONFIG_DIR/basic_vcp.hal $CONFIG_DIR/${VCP_NAME,,}.hal
    mv $CONFIG_DIR/basic_vcp.ini $CONFIG_DIR/${VCP_NAME,,}.ini
    sed -i.bak "s/basic_vcp/${VCP_NAME,,}/g; s/Basic VCP/$VCP_NAME/g" $CONFIG_DIR/${VCP_NAME,,}.ini

}

TEMPLATE_DIR=$(pwd)

# define linuxcnc venv location
VENV="/home/$USER/.linuxcnc_venv"

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


while true; do
    read -p "Enter a name for the VCP or Q to quit " VCP_NAME
    if [ -z $VCP_NAME ] ; then
        echo Name can not be empty
    elif [ ${VCP_NAME,,} = q ] ; then
        break
    elif ! [[ $VCP_NAME =~ ^[0-9a-zA-Z_]+$ ]] ; then
        echo Name can only contain letters, numbers, and underscores
    elif ! [[ ${VCP_NAME:0:1} =~ ^[a-zA-Z]+$ ]] ; then
        echo Name should start with a letter
    else
        copy_vcp $VCP_NAME
        break
    fi
done

while [ -z "$REPLY" ]; do
  read -p "Copy the Tutorial LinuxCNC Configuration Files? Yes No " REPLY
  case "$REPLY" in
    [yY]|[yY]es) copy_config ;;
    [nN]|[nN]o) quit ;;
    *) echo "${RBG}Please choose yes or no${NORM}" ;;
  esac
done
