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

# Получаем список интерфейсов
ip link show | awk -F: '$0 !~ /lo/ {print $2}' | while read iface; do
    iface=$(echo $iface | xargs)  # Убираем пробелы вокруг имени интерфейса

    # Получаем IP-адрес
    ip_addr=$(ip addr show $iface | awk '/inet / {print $2}' | cut -d/ -f1)
    
    # Получаем MAC-адрес
    mac_addr=$(cat /sys/class/net/$iface/address)
    
    # Получаем скорость
    speed=$(ethtool $iface 2>/dev/null | awk -F': ' '/Speed:/ {print $2}')
    
    # Выводим информацию
    printf "Интерфейс: %-10s IP: %-15s MAC: %-17s Скорость: %-10s\n" "$iface" "$ip_addr" "$mac_addr" "$speed"
done

# 5. Информация о системных разделах
print_section "Информация о файловых системах"
df -h

