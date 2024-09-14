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
/^[0-9]+:/ {
    iface=$2; gsub(":", "", iface);
    print "Интерфейс: " iface
}
/link\/ether/ {
    print "MAC-адрес: " $2
}
/inet / {
    print "IP-адрес: " $2
    print ""
}'
# 4.1. Получение скорости соединения для каждого интерфейса
for iface in $(ls /sys/class/net/); do
  echo "Интерфейс: $iface"

  # Используем ethtool для проводных интерфейсов
  if command -v ethtool &> /dev/null; then
    ethtool $iface 2>/dev/null | grep -i speed
  fi

  # Для беспроводных интерфейсов используем iwconfig
  if command -v iwconfig &> /dev/null; then
    iwconfig $iface 2>/dev/null | grep -i 'Bit Rate'
  fi
  echo ""
done
# 5. Информация о системных разделах
print_section "Информация о файловых системах"
df -h

