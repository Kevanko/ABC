#!/bin/bash

# Название контейнера
CONTAINER_NAME="isolation_test"

# Запуск контейнера в фоновом режиме с bash и дополнительными привязками для тестирования
docker run -d --name $CONTAINER_NAME --rm --hostname test-container ubuntu sleep 600

# Проверка PID изоляции
echo "=== PID Namespace Isolation ==="
docker exec $CONTAINER_NAME ps aux

# Проверка изоляции сети
echo "=== Network Namespace Isolation ==="
docker exec $CONTAINER_NAME ifconfig

# Проверка изоляции IPC
echo "=== IPC Namespace Isolation ==="
docker exec $CONTAINER_NAME ipcs -q
docker exec $CONTAINER_NAME ipcs -s
docker exec $CONTAINER_NAME ipcs -m

# Проверка файловой системы (Mount namespace)
echo "=== Mount Namespace Isolation ==="
docker exec $CONTAINER_NAME ls /

# Проверка UTS изоляции (hostname)
echo "=== UTS Namespace Isolation (Hostname) ==="
docker exec $CONTAINER_NAME hostname
docker exec $CONTAINER_NAME hostname new-container
docker exec $CONTAINER_NAME hostname

# Проверка изоляции пользователей (User namespace)
echo "=== User Namespace Isolation ==="
docker exec $CONTAINER_NAME id

# Остановка контейнера
docker stop $CONTAINER_NAME

echo "Isolation checks completed!"
