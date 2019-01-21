@echo off
sysmon64 -i NEDR.xml -n
sc create "NEDR" binpath= "c:\\NEDR\\NEDR.exe -c C:\\NEDR\\NEDR.yml" start= "auto"

echo NEDR Installed. Please Restart your computer.