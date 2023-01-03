# Tunnel port & Expose

![licence](https://img.shields.io/github/license/beigi-reza/ssh-tunnel)

این اسکریپت به یک سرور tunnel زده و سپس پورت نهایی به صورت عمومی باز می کند
این اسکریپت برای اجرا از فرمانهای ssh و socat استفاده می نمایید 

## Install socat

```cmd
apt-get update
apt-get install socat
```
## PreRun
قبل از اجرا حتما فایل را ویرایش کرده و متغیر های زیر را مقدار دهی کنید

```cmd
DestinationIP=<IP>
DestinationPort=<PORT>
```
قبل از اجرا در فانکشن fnStart پورتهایی که باید باز شوند  را مشخص کنید

```cmd
FnSshPortForwardind 3333 3128
FnExposePort 3128 80 
```
برای باز کدن چندین  پورت این دو خط را تکرار کنید

### FnSshPortForwardind Help

این فاکشن یک تونل بین سرور مقصد و این سرور ایجاد می کند و پورت شماره 2 را از سرور مقصد بر روی پورت شماره 1 از سرور مبدا به صورت لوکال مانت می کند

### FnExposePort Help

این فاکشن پورت شماره 1 را تحت پورت شماره 2 اکسپوز می کند 
