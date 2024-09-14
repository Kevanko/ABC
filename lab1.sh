#!/bin/bash

# Функция для вывода заголовка
print_section() {
    echo "=========================================="
    echo "$1"
    echo "=========================================="
}

# 1. Название и версия ОС, версия и архитектура ядра Linux
print_section "Информация о системе"
echo "Операционная система и версия:"
uname -a

echo "Версия ядра и архитектура:"
uname -r
uname -m

# 2. Информация о процессоре
print_section "Информация о процессоре"
echo "Модель процессора:"
cat /proc/cpuinfo | grep 'model name' | uniq
echo "Частота процессора (MHz):"
cat /proc/cpuinfo | grep 'cpu MHz' | uniq
echo "Количество ядер:"
nproc
echo "Кэш-память:"
cat /proc/cpuinfo | grep 'cache size' | uniq
echo ""

# 3. Информация о размере оперативной памяти
print_section "Информация о памяти"
free -h

# 4. Параметры сетевых интерфейсов и скорость соединения
echo "=== Параметры сетевых интерфейсов ==="
ip addr | awk '
#!/bin/bash

# Вывод информации о сетевых интерфейсах
ip -o link show | awk '
{
    iface=$2
    if (iface ~ /:/) iface=substr(iface, 1, length(iface)-1)
    cmd="ip addr show " iface
    cmd | getline addr
    close(cmd)
    split(addr, a, " ")
    ip_addr=a[3]
    
    cmd="ethtool " iface
    cmd | getline speed
    close(cmd)
    split(speed, s, " ")
    speed=s[2]
    
    cmd="cat /sys/class/net/" iface "/address"
    cmd | getline mac_addr
    close(cmd)
    
    printf "Интерфейс: %-10s IP: %-15s MAC: %-17s Скорость: %-10s\n", iface, ip_addr, mac_addr, speed
}'

# 5. Информация о системных разделах
print_section "Информация о файловых системах"
df -h

