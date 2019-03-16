#!/bin/bash
# powered by bboysoul
# email: bboysoulcn@gamil.com
# todo
# 控制风扇
# 检测是不是安装了ipmitool
# 检测系统版本安装对应的ipmitool
# 关机 开机 重启
# 查看服务器的基本信息

menu()
{
    ipmi_funcs="set_fan_manual set_fans power_status shutdown boot_up restart install_ipmitools_debian install_ipmitools_centos"
    select ipmi_func in $ipmi_funcs:
    do 
        case $REPLY in
        1) set_fan_manual $1 $2 $3
        ;;
        2) set_fans $1 $2 $3
        ;;
        3) power_status $1 $2 $3
        ;;
        4) shutdown $1 $2 $3
        ;;
        5) boot_up $1 $2 $3
        ;;
        6) restart $1 $2 $3
        ;;
        7) install_ipmitools_debian
        ;;
        8) install_ipmitools_centos
        ;;
        *) echo "please select a true num"
        ;;
        esac
    done
}


set_fan_manual()
{
    ipmitool  -I lanplus -U $1 -P $2 -H $3 raw 0x30 0x30 0x01 0x00
}

set_fans()
{
    read -p "Please select your fan speed(1-6 6 is the fastest):" speed
    set_fan_manual $1 $2 $3
    case $speed in
        1) ipmitool  -I lanplus -U $1 -P $2 -H $3 raw 0x30 0x30 0x02 0xff 0x10
        echo "The speed of the fan is now 1"
        ;;
        2) ipmitool  -I lanplus -U $1 -P $2 -H $3 raw 0x30 0x30 0x02 0xff 0x20
        echo "The speed of the fan is now 2"
        ;;
        3) ipmitool  -I lanplus -U $1 -P $2 -H $3 raw 0x30 0x30 0x02 0xff 0x30
        echo "The speed of the fan is now 3"
        ;;
        4) ipmitool  -I lanplus -U $1 -P $2 -H $3 raw 0x30 0x30 0x02 0xff 0x40
        echo "The speed of the fan is now 4"
        ;;
        5) ipmitool  -I lanplus -U $1 -P $2 -H $3 raw 0x30 0x30 0x02 0xff 0x50
        echo "The speed of the fan is now 5"
        ;;
        6) ipmitool  -I lanplus -U $1 -P $2 -H $3 raw 0x30 0x30 0x02 0xff 0x60
        echo "The speed of the fan is now 6"
        ;;
        *) echo "please input 1-6"
        ;;
    esac
}

power_status()
{
    status=`ipmitool -I lanplus -U $1 -P $2 -H $3 power status`
    echo "The server is  Power" `echo $status |awk '{print $4}'`
}

shutdown()
{
    ipmitool -I lanplus -U $1 -P $2 -H $3 power off
    echo "The server is Power off"
}

boot_up()
{
    ipmitool -I lanplus -U $1 -P $2 -H $3 power on
    echo "The server is Power on"
}

restart()
{
    ipmitool -I lanplus -U $1 -P $2 -H $3 power reset
    echo "The server is  restarting"
}

install_ipmitools_debian()
{
    apt-get install -y ipmitool
}
install_ipmitools_centos()
{
    yum install -y ipmitool
}

main()
{
    read -p "please input your ipmi ip: " ip
    read -p "please input your ipmi user:" user
    read -p "plaese input your ipmi password: " password
    menu $user $password $ip
	
}

main
