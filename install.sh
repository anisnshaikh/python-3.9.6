#!/bin/bash

###YUM repo creation for dependency installation################################################
sudo tat DKK_Repo/repodata/repomd.xml
sudo chown -R root.root DKK_Repo
echo -e "[python]\nname=python_repo\nbaseurl=file://`pwd`/DKK_Repo\ngpgcheck=0\nenabled=1\npriority=1" > /etc/yum.repos.d/python.repo
sudo yum clean all
sudo yum repolist --disablerepo=* --enablerepo=python
###YUM repo creation for dependency installation################################################

###Python3.9 Installation dev_v21.10############################################################
echo -e "\n\n Checking and Installing dependencies..." |tee -a install.log
	for i in gcc openssl-devel bzip2-devel libffi-devel zlib-devel libev-devel unixODBC-devel
	do
        sudo yum --disablerepo=* --enablerepo=python list installed $i > /dev/null 2>&1
        if [[ $? == 0 ]];then
                echo " Required dependency $i is already exists, no need to install." |tee -a install.log
        else
                echo " Required dependency $i in not installed, installing $i..." |tee -a install.log
                sudo yum --disablerepo=* --enablerepo=python install $i -y
        fi
	done
	
echo "Checking Python3.9 Installation" | tee -a install.log
which python3.9 > /dev/null 2>&1
if [[ $? -eq 0 ]];then
        echo -e "\e[92mPython 3.9 is already installed. Skipping the Python installation\e[39m" | tee -a install.log
        sudo ln -sf /usr/local/bin/python3.9 /usr/bin/python3.9
        sudo ln -sf /usr/local/bin/pip3.9 /usr/bin/pip3.9
else
        cd python3
        echo -e "\e[92m[MESSAGE] Installing Python3.9\e[39m" | tee -a ../install.log
        sudo ./python3_installation.sh
        if [[ $? -ne 0 ]];then
                echo -e "\e[31mError in installing Python3.9, Please check python3_installation.log"| tee -a ../install.log
                exit 1
        fi
        cd ..
fi
### Python3.9 Installation done #################################################################

### Python libraries installation dev_v21.10 ####################################################
which python3.9
if [[ $? -eq 0 ]];then
cd python3
sudo ./py-lib-install.sh
if [[ $? -ne 0 ]];then
        echo -e "\e[31mError installing in python3.9 libraries, Please check py-lib-install.log"| tee -a ../install.log
        exit 1
fi
cd ..
echo ""
fi
### Python libraries installed ###################################################################

###YUM repo deleting############################################################################
sudo rm -f /etc/yum.repos.d/python.repo
sudo yum clean all
###YUM repo deleting done#######################################################################

