#!/bin/bash
# Author: Franklin E.
# Description: A bash script that will download latest WordPress archive, uncompress archive, & configure if proper information is given.

currentDir=$(pwd);
logFileName=$(echo esWP-`date '+%m-%d-%y_%H:%M:%S'`.txt);
latestWP="https://wordpress.org/latest.tar.gz";
configLineNum=();
errorMsg=('wget failed to download file!' \
          'Encountered issues decompressing the latest.tar file!' \
          'Username input capture failed! Exiting script!' \
          'Password input capture step failed!' \
          'MySQL test query failed! Likely credentials are wrong!' \
          'Moving Wordpress to active directory failed!' \
          'MySQL Database name input capture failed!' \
          'Sed failed to properly update wp-config.php file!')

errorCheck ()
{
    if [ "$?" -gt 0 ];
    then
        echo "$1" >> $currentDir/$logFileName;
        echo "$1";
        exit 1;
    fi
}

preReqCheck ()
{
    if [ -a wp-config.php ]  || [ -a latest.tar.gz ];
    then
        echo "We found a possible previous installation! Script will exit. Make sure directory is free!.";
        exit 1;
    fi
}

downloadAndExtractWP ()
{
    wget -v $latestWP -o $currentDir/$logFileName;
    errorCheck "${errorMsg[0]}";
    tar -xzvf latest.tar.gz >> $currentDir/$logFileName 2>&1;
    errorCheck "${errorMsg[1]}";
    mv wordpress/* $currentDir >> $currentDir/$logFileName 2>&1;
    errorCheck "${errorMsg[5]}";		
    mv wp-config-sample.php wp-config.php;
}

configWp ()
{
    read -p "Enter MySQL database name: " wpDB;
    errorCheck "${errorMsg[6]}";
    read -p "Enter MySQL username: " wpUser;
    errorCheck "${errorMsg[2]}";
    read -s -p "Enter MySQL password:" wpPass;
    errorCheck "${errorMsg[3]}";
    mysql -u"$wpUser" -p"$wpPass" -e "SHOW DATABASES;" >> $currentDir/$logFileName 2>&1;
    errorCheck "${errorMsg[4]}";
    for grepResult in $(egrep -nr 'DB_(NAME|USER|PASSWORD)' wp-config.php | cut -f1 -d:); 
    do 
        configLineNum+=("$grepResult");
    done
    sed -i "${configLineNum[0]}s/.*/define( 'DB_NAME',   "\'$wpDB\'" );/" wp-config.php;
    errorCheck "${errorMsg[7]}";		
    sed -i "${configLineNum[1]}s/.*/define( 'DB_USER',   "\'$wpUser\'" );/" wp-config.php;
    errorCheck "${errorMsg[7]}";		
    sed -i "${configLineNum[2]}s/.*/define( 'DB_PASSWORD',   "\'$wpPass\'" );/" wp-config.php;
    errorCheck "${errorMsg[7]}";		
}

preReqCheck
downloadAndExtractWP
configWp
