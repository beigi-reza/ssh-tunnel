#!/bin/bash
#
##
## Reza Beigi (r.beigy@gmail.com)
## https://github.com/beigi-reza/
## https://linkedin.com/in/reza-beigi
##

LogFile=/var/log/ssl-tunnel-activate.log

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


DestinationIP=10.1.8.46
DestinationPort=22
DestinationUser=root

#############  Function
###################################################################
###################################################################
###################################################################

fnGet(){
  Fnbanner
  echo "$white_bold Type ' $yellow_bold tunnel++.sh --help $white_bold ' for help "
  read -p "$white_bold Type Command Mode$green_bold ( Status [$white_bold u $green_bold] / Start Tunnel[$white_bold s $green_bold] / Drop Tunnel [$white_bold d $green_bold] )$rc$white_bold :$red" getValue
  echo "$rc"
  checkGetValue
}

checkGetValue () {

    case "$getValue" in
        "u")
            FnCheckStatus
        ;;
        "s")
            Fnstart
        ;;
        "d")
            FnFindProsses $DestinationIP   
        ;;
        *)
           echo "Sorry, I don't understand"
           fnGet
        ;;     
   esac

}

FnSshPortForward (){    
    echo "$white_bold port $blue_bold$2 $white_bold Server $blue_bold$DestinationIP $white_bold Bind to local port $yellow_bold$1$RC"
    ssh -NTC -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes -f -N -p $DestinationPort $DestinationUser@$DestinationIP -L 0.0.0.0:$1:0.0.0.0:$2

}


#FnExposePort (){
#    echo "$white_bold Port $yellow_bold$1 $white_bold Expose from port $red_bold$2$RC"
#    echo ""
#    socat TCP-LISTEN:$2,fork,bind=0.0.0.0 TCP:localhost:$1 &
#}

FnFindProsses(){    
    proccessCount=$( pgrep -f $1 | awk 'END { print NR }')
    ProcessID=$(pgrep -f $1)   
    #
    FnKillProcess $1    
    
    if [ -z "$2" ]
    then   
       fnGet      
    fi    
}

FnKillProcess(){
    if [ $proccessCount -eq 0 ]
    then
       echo "$red_bold No$white_bold process$red_bold Found with the statement '$blue_bold $1 $red_bold'. $RC "             
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
       echo "$red_bold All the processes that were closed with the statement '$white_bold $1 $red_bold'. $RC "       
    else
       FnFindProsses
    fi   
}

FnCheckResult (){  
  if [ $? -eq 0 ]; then      
      echo "$red_bold Process/es $white_bold killed $red_bold successfully $RC"   
  else
      echo "$red_bold Process $yellow_rev $1 $red_bold Not Killed $RC"   
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

FnHelp(){    
    echo ""
    echo "$RC       $white_bold -  This script manages the SSH Tunnl/s connections between this server and the destination server."
    echo "$RC       $white_bold -  SSH connection between two servers must be through a key."
    echo "$RC       $white_bold -  The destination server information is defined in two variables '$teal_bold DestinationIP$white_bold', '$teal_bold DestinationPort$white_bold' and '$teal_bold DestinationUser' "
    echo ""
    echo "$red_bold Help$RC : [$white_bold Run '$blue_bold tunnel++.sh $white_bold' for menu$RC                                       ]"
    echo "$RC        [          $yellow_bold u $RC = $white_bold Check status SSH Tunnel $RC                           ]"
    echo "$RC        [          $yellow_bold s $RC = $white_bold Start Requested Tunnel/s  $RC                         ]"
    echo "$RC        [          $yellow_bold d $RC = $white_bold Drop All SSH Tunnel/s  $RC                            ]"
    echo "$RC        [$white_bold     '$blue_bold tunnel++.sh $yellow_bold%1$white_bold'$RC                                              ]"
    echo "$RC        [          $yellow_bold --status $RC     = $white_bold Check Active SSH Tunnel $RC                  ]"
    echo "$RC        [          $yellow_bold --start $RC    = $white_bold Start Requested Tunnel/s  $RC                ]"
    echo "$RC        [          $yellow_bold --drop $RC     = $white_bold Drop All SSH Tunnel/s  $RC                   ]"
    echo "$RC        [          $yellow_bold --restart $RC  = $white_bold Drop All SSH Tunnel/s & Start again  $RC     ]"
    echo ""
    exit

}

FnCheckStatus(){

    sshProcess=$( pgrep -f $DestinationIP | awk 'END { print NR }')    
    if [ $sshProcess -gt 0 ]
    then
       echo "$red_bold Found $yellow_rev$sshProcess$RC$red_bold ssh tunnel to Server $blue_bold $DestinationIP $RC "             
    else
       echo "$red_bold No tunnel found to Server $blue_bold $DestinationIP $RC "             
    fi  

#    socatProcess=$( pgrep -f "socat" | awk 'END { print NR }')    
#    if [ $socatProcess -gt 0 ]
#    then
#       echo "$white_bold Found $yellow_rev$socatProcess$RC$white_bold port/s Exposed for Data Transfer$RC "             
#    else
#       echo "$white_bold No ports are expose for data transfer $RC "             
#    fi  

if [ -z "$1" ]
then   
   fnGet
else
   exit 
fi

}

FnLogit(){
  TIME=$(date)
  echo "$1 - on :  $TIME " >>$LogFile
}

Fnstart(){
    
    FnSshPortForward 80 80
    FnSshPortForward 443 443
    #FnSshPortForward 8388 8388 
    #FnSshPortForward 12887 12887 
    #FnSshPortForward 8443 443 

    }

###################################################################
###################################################################
###################################################################
#############  Function


if [ $1 = "help" -o $1 = "-h" -o $1 = "--help" -o $1 = "h" -o $1 = "?" ] ; then
   clear
   Fnbanner
   FnHelp
fi

if [ -z "$1" ]
then   
  clear 
  fnGet
fi

case "$1" in
     "--status")
         FnCheckStatus "parameter"
     ;;
     "--start")
         Fnstart
     ;;
     "--drop")
         FnFindProsses $DestinationIP "parameter"
     ;;
     "--restart")
         FnFindProsses $DestinationIP "parameter" 
         Fnstart
         FnLogit
     ;;

     *)
        echo "for help type '--help'"        
     ;;     
esac




