# Frank's Wordpress Bash Script
A bash script that will download the latest Wordpress installation archive into the current directory, decompress the archive, and configure the wp-config.php file with information given.

# Assumptions
This script makes the assumption that you are in the directory where you wish to download & install wordpress. If there is a "latest.tar.gz" or "wp-config.php" file in said directory, the script will exit. The script also assumes that you have a "LAMP" or "LEMP" stack environment and that you are logged in as the proper user (not root!). You must already have a MySQL database created for the installation along with a MYSQL user & password. The script only edits the wp-config.php file with this information, it does not create said MySQL database or user.

### Instructions
```sh
$ cd <Installation Directory>
$ chmod +x frankWpScript.sh
$ ./frankWpScript.sh
```
Feel free to modify and or redistribute the script as needed. It was only made to practice my bash scripting and to finally have something up on my github. :)
