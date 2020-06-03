#!/usr/bin/env bash

# 개인키 갱신 및 배포스크립트 
# Author. Runup Kim Tae Oh

#############################
#SET VARIANT FROM PARAMETER
#############################
while getopts u:p: option
do
 case "${option}"
 in
 u) CREATE_USER=${OPTARG};;
 p) USER_PASS=${OPTARG};;
 esac
done

## USER CHECK
if [ -z $CREATE_USER ]
then
 echo "UserName is Required Option Name is -u"
 exit
fi

## FOLDER CHECK
if [ ! -d "/home/${CREATE_USER}" ]
then
  if [ ! "${CREATE_USER}" == "all" ]
    then
    echo "유저가 존재하지 않습니다"
    exit
  fi
fi 

## USER CHECK
if [ -z $USER_PASS ]
then
 echo "UserPass is Required Option Name is -p"
 exit
fi


# KEY GENERATE FUNCTION 
function keyGen(){
  USER_NAME=$1

  sudo mkdir -p /tmp/ssh-key/${host}
  sudo ssh-keygen -t rsa -b 4096 -f /tmp/ssh-key/${host}/${USER_NAME} -P ${USER_PASS}
  sudo mkdir -p /home/${USER_NAME}/.ssh
  sudo chmod 700 /home/${USER_NAME}/.ssh
  sudo mv /tmp/ssh-key/${host}/${USER_NAME}.pub /home/${USER_NAME}/.ssh/authorized_keys
  sudo chmod 600 /home/${USER_NAME}/.ssh/authorized_keys
  sudo chown -R ${USER_NAME}:${USER_NAME} /home/${USER_NAME}/.ssh
}

# GET HOST INFO 
ip=$(sudo hostname -I | sed -e 's/^ *//g' -e 's/ *$//g')
host=$(sudo hostname)

# KEY GENERATE
if [ ${CREATE_USER} == "all" ]
then
  SITELIST=($(ls -d /home/* | awk -F '/' '{print $NF}'))
  for SITE in ${SITELIST[@]}; do
    keyGen "${SITE}"
  done

  echo "scp ${USER}@${ip}:/tmp/ssh-key/${host}/* {Your Location}"
else
 keyGen "${CREATE_USER}"
 echo "scp ${USER}@${ip}:/tmp/ssh-key/${host}/${CREATE_USER} {You Location}"
fi


# DOWNLOAD CONFIRM
echo "위 명령어를 참고해서 개인키를 안전한 장소에 다운로드 하세요"
echo "다운로드를 마치셨나요?"

while :
do
read -rp "Y or N) " cf
case $cf in
        [yY])
                rm -rf /tmp/ssh-key
                echo "Good!! please login ${CREATE_USER} And Setup"
                break
        ;;

        [nN])
                echo "exit"
                exit
        ;;

        *)
                echo "Please Input Yes or No !!!"
        ;;
esac
done
