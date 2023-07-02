 # VCP Template

Very basic QtPyVCP based Virtual Control Panel for LinuxCNC.
This is intended as a template that you can use as a base for
creating your own VCPs.

## Getting Started

1) Ensure that developement dependencies are installed
```
sudo apt install qttools5-dev qttools5-dev-tools python3-wheel python3-venv
```

2) Fork this repository to your github account or to other git environment.

3) Clone it to your local machine:
  `git clone [url-to-your-forked-repo]`

4) Use the scripts 'copy.sh' or 'tutorial.sh' to create a starting VCP

5) Either follow the tutorial or start your own VCP journey

6) Edit the layout in QtDesigner by running:

`editvcp myvcp`

Where `myvcp` is whatever name you ended up using for your new VCP.

## To Copy

1) Clone the VCP Template:
  `git clone https://github.com/kcjengr/vcp-template.git`
  
2) Run the copy.sh script and give it a new name:
  `./copy.sh`

## To Create the Tutorial

1) Clone the VCP Template:
  `git clone https://github.com/kcjengr/vcp-template.git`
  
2) Run the tutorial.sh script and give it a new name:
  `./tutorial.sh`

## Overall Comments
The use of copy.sh or tutorial.sh will also setup a couple of things:

1) A python virtual env located in `~/.linuxcnc_venv`

This is where the starting vcps are installed to via the scripts.

2) An alias is created in `~/.bash_alias` called `cncshell`. This alias
can be used from a bash shell to activate the virtual python environment
 referenced in #1 above.  You will need to open either a new shell
 window or tab for this alias to be available.
 
To be able to edit the new VCPs that you have started you will need to
run the editvcp command from a shell with the cncshell activate.

i.e.  steps being from within a shell:

```
cncshell

editvcp myvcp
```
