#!/bin/bash
#
#     _       _       _    ______               _____       _                       _      _       _       _    
#  /\| |/\ /\| |/\ /\| |/\|  ____|             |_   _|     | |                     | |  /\| |/\ /\| |/\ /\| |/\ 
#  \ ` ' / \ ` ' / \ ` ' /| |__ _ __ ___  ___    | |  _ __ | |_ ___ _ __ _ __   ___| |_ \ ` ' / \ ` ' / \ ` ' / 
# |_     _|_     _|_     _|  __| '__/ _ \/ _ \   | | | '_ \| __/ _ \ '__| '_ \ / _ \ __|_     _|_     _|_     _|
#  / , . \ / , . \ / , . \| |  | | |  __/  __/  _| |_| | | | ||  __/ |  | | | |  __/ |_ / , . \ / , . \ / , . \ 
#  \/|_|\/ \/|_|\/ \/|_|\/|_|  |_|  \___|\___| |_____|_| |_|\__\___|_|  |_| |_|\___|\__|\/|_|\/ \/|_|\/ \/|_|\/ 
#                                                                                                               
#                                                                                                               

## FnSshPortForwardind Help
# این فاکشن یک تونل بین سرور مقصد و این سرور ایجاد می کند و پورت شماره 2 را از سرور مقصد بر روی پورت شماره 1 از سرور مبدا به صورت لوکال مانت می کند
## FnExposePort Help
# این فاکشن پورت شماره 1 را تحت پورت شماره 2 اکسپوز می کند 

# apt-get update
# apt-get install socat

## Color
white="$(tput setaf 7)" # white
white_bold="$(tput bold)$(tput setaf 15)"
green_bold="$(tput bold)$(tput setaf 2)"
blue_bold="$(tput bold)$(tput setaf 4)"
red_bold="$(tput bold)$(tput setaf 9)" 
yellow_bold="$(tput bold)$(tput setaf 3)"
teal_bold="$(tput bold)$(tput setaf 6)"
yellow_rev="$(tput bold)$(tput setaf 3)$(tput rev)"
RC="$(tput sgr 0)" # Reset Color
C1="$(tput setaf 190)"
C2="$(tput setaf 191)"
C3="$(tput setaf 192)"
C4="$(tput setaf 193)"
C5="$(tput setaf 194)"
C6="$(tput setaf 195)"
C6="$(tput setaf 188)"

##


DestinationIP=195.248.242.73
DestinationPort=3031


#############  Function
###################################################################
###################################################################
###################################################################

fnGet(){
  Fnbanner
  read -p "$white_bold Type Command Mode$green_bold ( Status [$white_bold s $green_bold] / Start Tunnel[$white_bold t $green_bold] / Drop Tunnel [$white_bold d $green_bold] )$rc$white_bold :$red" getValue
  echo "$rc"

  checkGetValue
}

checkGetValue () {

    case "$getValue" in
        "s")
            FnCheckStatus
        ;;
        "t")
            Fnstart
        ;;
        "d")
            FnFindProsses $DestinationIP   
            FnFindProsses "socat"
        ;;
        *)
           echo "Sorry, I don't understand"
           fnGet
        ;;     
   esac

}

FnSshPortForwardind (){
    echo "$white_bold port $blue_bold$2 $white_bold Server $blue_bold$DestinationIP $white_bold Bind to local port $yellow_bold$1$RC"
    ssh -NTC -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes -f -N -p $DestinationPort root@$DestinationIP -L $1:0.0.0.0:$2
}


FnExposePort (){
    echo "$white_bold Port $yellow_bold$1 $white_bold Expose from port $red_bold$2$RC"
    echo ""
    socat TCP-LISTEN:$2,fork,bind=0.0.0.0 TCP:localhost:$1 &
}

FnFindProsses(){    
    proccessCount=$( pgrep -f $1 | awk 'END { print NR }')
    ProcessID=$(pgrep -f $1)   
    #
    FnKillProcess $1
}

FnKillProcess(){
    if [ $proccessCount -eq 0 ]
    then
       echo "$white_bold No$red_bold process$white_bold Found with the statement '$green_bold $1 $white_bold'. $RC "             
    else
       kill -9 $ProcessID       
       FnCheckResult $ProcessID
       FnChecAgeain $1
    fi  
}

FnChecAgeain (){
    proccessCount=$( pgrep -f $1 | awk 'END { print NR }')
    if [ $proccessCount -eq 0 ]
    then
       echo "$white_bold All the processes that were closed with the statement '$green_bold $1 $white_bold'. $RC "       
    else
       FnFindProsses
    fi   
}

FnCheckResult (){  
  if [ $? -eq 0 ]; then      
      echo "$white_bold Process/es $red_bold killed $white_bold successfully $RC"   
  else
      echo "$white_bold Process $yellow_bold_bold $1 $white_bold Not Killed $RC"   
  fi  
}

Fnbanner(){
    echo $C1"   ______                                       ______   "$RC
    echo $C2"  / / / /   _                   _   _     _     \ \ \ \  "$RC
    echo $C3" / / / /   | |_ _ _ ___ ___ ___| |_| |_ _| |_    \ \ \ \ "$RC
    echo $C4"< < < <    |  _| | |   |   | -_| |_   _|_   _|    > > > >"$RC
    echo $C5" \ \ \ \   |_| |___|_|_|_|_|___|_| |_|   |_|     / / / / "$RC
    echo $C6"  \_\_\_\                                       /_/_/_/  "$RC
    echo $C7"                                                         "$RC
}

FnCheckStatus(){

    sshProcess=$( pgrep -f $DestinationIP | awk 'END { print NR }')    
    if [ $sshProcess -gt 0 ]
    then
       echo "$white_bold Found $yellow_rev$sshProcess$RC$white_bold ssh tunnel to Server $yellow_bold $DestinationIP $RC "             
    else
       echo "$white_bold No tunnel found to Server $yellow_bold $DestinationIP $RC "             
    fi  

    socatProcess=$( pgrep -f "socat" | awk 'END { print NR }')    
    if [ $socatProcess -gt 0 ]
    then
       echo "$white_bold Found $yellow_rev$socatProcess$RC$white_bold port/s Exposed for Data Transfer$RC "             
    else
       echo "$white_bold No ports are expose for data transfer $RC "             
    fi  

}

Fnstart(){
     echo "START"
    
    #FnSshPortForwardind 3128 3128 # Squid 
    #FnExposePort 3128 80 # Squid Publish to 80

    #FnSshPortForwardind 8388 8388 # Shadowsocks 
    #FnExposePort 8388 888 # Shadowsocks expose 888

    #FnSshPortForwardind 12887 12887 # outline Manager
    #FnExposePort 12887 8888 # outline Manager Expose 8888

    #FnSshPortForwardind 8443 443 # outline Access
    #FnExposePort 8443 443 # outline Access Expose 443
}

###################################################################
###################################################################
###################################################################
#############  Function

fnGet



