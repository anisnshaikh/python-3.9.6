#!/bin/bash
clear
exec > >(tee "python3_installation.log") 2>&1
echo -e "\e[47m                                                                                                   \e[0m"
echo -e "\e[47m \e[0m                                      \e[33mInstalling Python3.9\e[0m                                      \e[47m  \e[0m"|tee -a python3_installation.log
echo -e "\e[47m                                                                                                   \e[0m"

py_install=true

if [[ $py_install == "true" ]];then
	if [[ -z `which python3.9` ]];then
		echo -e "\n\n\e[36m Starting Python 3.9.6 installation from source. \e[39m" |tee -a python3_installation.log
		echo -e "\n\n Extract Python-3.9.6.tgz package." |tee -a python3_installation.log
		tar -xzvf Python-3.9.6.tgz > /dev/null 2>&1 

		echo -e "\n\n Configuring package as per system." |tee -a python3_installation.log
		./Python-3.9.6/configure --enable-optimizations	> /dev/null 2>&1

		if [[ $? -ne 0 ]];then
			echo -e "\e[93m[ERROR] Unable to run configure script.\e[39m" |tee -a python3_installation.log
			exit -1
		fi

		echo -e "\n\n Running make to install Python3 at /usr/local/bin." |tee -a python3_installation.log
		make altinstall > /dev/null 2>&1

		if [[ $? -ne 0 ]];then
			echo -e "\e[93m[ERROR] Unable to run make altinstall command.\e[39m" |tee -a python3_installation.log
			exit -1	
		fi
	else
		echo "python3.9 already installed no need to install."
	fi
else 
	unzip ./python_binaries.zip -d /usr/local/bin/
	unzip  ./python_libraries.zip -d /usr/local/lib/


fi
echo -e "\n\n Creating Soft Link for python3 and pip3"
[[ -f /usr/bin/python3.9 ]] ||sudo ln -sf /usr/local/bin/python3.9 /usr/bin/python3.9
[[ -f /usr/bin/pip3.9 ]] || sudo ln -sf /usr/local/bin/pip3.9 /usr/bin/pip3.9

echo -e "\e[47m                                                                                                   \e[0m"
echo -e "\e[47m \e[0m                                \e[32mInstalled Python3.9 successfully\e[0m                                \e[47m  \e[0m"|tee -a python3_installation.log
echo -e "\e[47m                                                                                                   \e[0m"

