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

ChatGPT

Вы сказали:
Вывести параметры (имя интерфейса, ip/mac) и скорость сетевого соединения, напиши скрипт с использованием awk 
ChatGPT сказал:
ChatGPT
Для вывода параметров сетевого интерфейса, таких как имя интерфейса, IP-адрес и MAC-адрес, а также скорости сетевого соединения с помощью awk, можно использовать комбинацию команд ip или ifconfig и awk. Вот пример скрипта, который использует ip и awk:

bash
Копировать код
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
Объяснение:
ip -o link show выводит информацию о сетевых интерфейсах.
awk обрабатывает вывод:
Извлекает имя интерфейса.
Выполняет команды для получения IP-адреса, MAC-адреса и скорости интерфейса.
Форматирует и выводит информацию.
Не забудьте сделать скрипт исполняемым, используя команду chmod +x <имя_скрипта>, и запустите его.

Также убедитесь, что у вас установлены необходимые утилиты (ip, ethtool) и у вас есть права на выполнение команд.






# Получаем список интерфейсов
ip link show | awk -F: '$0 !~ /lo/ {print $2}' | while read iface; do
    iface=$(echo $iface | xargs)  # Убираем пробелы вокруг имени интерфейса

    # Получаем IP-адрес
    ip_addr=$(ip addr show $iface | awk '/inet / {print $2}' | cut -d/ -f1)
    
    # Получаем MAC-адрес
    mac_addr=$(ip link show $iface | awk '/link\/ether/ {print $2}')
    
    # Получаем скорость
    speed=$(ethtool $iface 2>/dev/null | awk -F': ' '/Speed:/ {print $2}')
    
    # Выводим информацию
    printf "Интерфейс: %-10s IP: %-15s MAC: %-17s Скорость: %-10s\n" "$iface" "$ip_addr" "$mac_addr" "$speed"
done

# 5. Информация о системных разделах
print_section "Информация о файловых системах"
df -h

