#!/bin/bash
#Записываем начальный таймстемп
start_timestamp=$(date +%s)
# Ищем вхождение слова "php7.4" во всех файлах в директории логов и считаем количество строк совпадения
grep -r "php7.4" /var/log/ | wc -l
# Записываем конечный таймстемп
end_timestamp=$(date +%s)
# Вычисляем время работы скрипта
execution_time=$((end_timestamp - start_timestamp))
# Выводим время работы скрипта
echo "Время работы скрипта: $execution_time секунд."
