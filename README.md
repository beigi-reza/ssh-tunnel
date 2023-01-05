# Tunnel port & Expose

![licence](https://img.shields.io/github/license/beigi-reza/ssh-tunnel)

This script Create tunnle to a server and then the final port is opened publicly and  use ssh ,socat and pgrep commands to execute this script.

## Install socat

```cmd
apt-get update
apt-get install socat
```

### FnSshPortForwardind Help
This function creates a tunnel between the destination server and this server and locally mounts port `<destination-port>` from the destination server on port `<local-port>` from the source server.

### FnExposePort Help

This faction opens `<local-port>` under port `<Bind_port>` publicly

## PreRun

Replace the following variables in the script file  with appropriate values

- ‍‍`DestinationIP=<IP>`  The destination server we want to connect to
- `DestinationPort=<PORT>` SSH port of destination server
in function **`fnStart`** 


For each port you want to open, repeat this line and set the value

- `FnSshPortForwardind <local-port> <destination-port>`
- `FnExposePort <local-port> <Bind_port>` 

`<destination-port>` : The destination port on the destination server
`<local-port>‍ ` : The port that is opened locally on this server for ssh tunnel
`<Bind_port>` : The port that is finally opened on the server and is available from everywhere

## Run 

```cmd
./tunnel++.sh 
```

- **`c`** for check active **ssh tunnel** and **bidirectional data transfers** to Destination Server
- **`s`** Start Tunnel and Bind Port/s to `0.0.0.0` as backgrund Process
- **`k`** kill all **ssh tunnel** and **bidirectional data transfers** 
 


