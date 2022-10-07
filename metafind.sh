#!/bin/bash

red='\033[1;31m'
green='\033[0;32m'
light_green='\033[1;32m'

#####################################
#			   Banner				#
#####################################

Banner()
{
	echo -e "${red}           /@@@@@@@@@,                             +-------------------------------------+"
			 echo "       @@@@@@@@@@@@@@@@@@@                         |            Metafind v1.0            |"
			 echo "    .@@@@@#           ,@@@@@                       +-------------------------------------+"
			 echo "   @@@@@                 @@@@@                     |           Author: Louhan            |"
			 echo "  @@@@(                   .@@@@                    |          Github: louhan-dev         |"
			 echo "  @@@@                     @@@@                    +-------------------------------------+"
			 echo "  @@@@                     @@@@                    "
			 echo "  @@@@.                    @@@@                    "
			 echo "   @@@@&                 *@@@@                     "
			 echo "    @@@@@@             @@@@@@@&                    "
			 echo "      ,@@@@@@@@@@@@@@@@@@@@@@@@@@#                 "
			 echo "          /@@@@@@@@@@@,     @@@@@@@@*              "
			 echo "                               @@@@@@@@.           "
			 echo "                                 .@@@@@@@.         "
			 echo "                                    *@@@/          "
			 echo

}

#####################################
#				Help				#
#####################################

Help()
{
	echo -e "${red}This script aims to capture metadata of files from a certain website."
	echo
	echo "Syntax: $0 [website] [extension file]"
	echo
	echo "examples:"
	echo "$0 www.example.com doc		[Search the example.com website for metadata for files with doc extension]"
	echo "$0 www.example.com pdf		[Search the example.com website for metadata for files with pdf extension]"
	echo "$0 www.example.com ppt		[Search the example.com website for metadata for files with ppt extension]"
	echo
}

#####################################
#				MAIN				#
#####################################

Banner >&2

[[ "$UID" -ne '0' ]] && { echo "Root is required."; exit 1 ;}

if [ "$#" -lt  "2" ]
   then
     Help
     exit 1
fi

response_search=$(lynx --dump "www.google.com/search?q=site:$1+ext:$2")
response_search_urls=$(grep "$1" <<< $response_search | grep -v "site:" | grep -v "\[" | grep "\/" | cut -d "=" -f2 | sed 's/...$//')

for url in $response_search_urls
do
	file_name=$(awk -F/ '{print $NF}' <<< $url)
	wget -q -P /tmp $url
	echo -e "${light_green}###################$file_name###################${green}"
	exiftool /tmp/$file_name
	rm /tmp/$file_name
done