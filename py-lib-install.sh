#!/bin/bash
clear
echo "" > py-lib-install.log
python_path=`which python3.9`
$python_path config set global.disable-pip-version-check true > /dev/null 2>&1

echo -e "\e[47m                                                                                                   \e[0m"
echo -e "\e[47m \e[0m                              \e[33mInstalling required python libraries\e[0m                              \e[47m  \e[0m"|tee -a py-lib-install.log
echo -e "\e[47m                                                                                                   \e[0m"

###Checking and installing/upgrading pip version###
if [ `$python_path -m pip list|grep pip| awk '{print $2}'` != "20.2.4" ];then
	echo "Installing pip version 20.2.4" > py-lib-install.log
	$python_path -m pip install pip --force-reinstall --no-index --find-links python-offline-packages/pip-20.2.4-py2.py3-none-any.whl 2> /dev/null
else
	echo "Required Pip package version already exists, no need to install or upgrade"
	echo ""
fi

###Checking and installing/upgrading required python libraries###
for i in `cat  python-offline-packages/requirements.txt`;
do
py_lib=$(echo $i|cut -d "=" -f1)
py_lib_ver=$(echo $i|cut -d "=" -f2) 

$python_path -m pip show $py_lib > /dev/null 2>&1
if [[ $? -eq 0 ]];then
	if [[ `$python_path -m pip show $py_lib|grep "Version:"|awk '{print $2}'` != "$py_lib_ver" ]];then
		echo -e "$py_lib package already exist, Upgrading to $py_lib_ver version" |tee -a py-lib-install.log
		$python_path -m pip install $py_lib --upgrade --no-index --find-links `echo "$(ls python-offline-packages/$py_lib-$py_lib_ver*)"` 2> /dev/null
	else
		echo "Required $py_lib package version already exists, no need to install or upgrade"|tee -a py-lib-install.log
	fi
else
	echo -e "Installing $py_lib version $py_lib_ver Package" |tee -a py-lib-install.log
	$python_path -m pip install $py_lib --no-index --find-links `echo "$(ls python-offline-packages/$py_lib-$py_lib_ver*)"` 2> /dev/null

###Checking for error in installing python library##
if [[ $? -ne 0 ]];then
	echo "Error while installing $py_lib version $py_lib_ver Package. Aborting!!!!" |tee -a py-lib-install.log
	exit -1
fi
fi
echo ""
done

echo -e "\e[47m                                                                                                   \e[0m"
echo -e "\e[47m \e[0m                        \e[32mInstalled required python libraries successfully\e[0m                        \e[47m  \e[0m"|tee -a py-lib-install.log
echo -e "\e[47m                                                                                                   \e[0m"
