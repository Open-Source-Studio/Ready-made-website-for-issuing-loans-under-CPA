#!/bin/bash
# Security Assessment Script
# Скрипт для демонстрации проблем безопасности

echo "=== SECURITY ASSESSMENT SCRIPT ==="
echo "Анализ безопасности проекта WordPress для займов"
echo ""

# Проверка наличия чувствительных данных
echo "🔍 Поиск чувствительных данных в файлах..."
echo ""

# 1. Поиск паролей в текстовых файлах
echo "1. Проверка наличия паролей в репозитории:"
if grep -r "password\|пароль" *.md *.txt 2>/dev/null | grep -v "password_here"; then
    echo "❌ НАЙДЕНЫ открытые пароли в файлах!"
else
    echo "✅ Пароли не найдены в текстовых файлах"
fi
echo ""

# 2. Поиск небезопасных PHP функций
echo "2. Проверка использования небезопасных PHP функций:"
if grep -r "shell_exec\|exec\|system\|eval" *.php 2>/dev/null; then
    echo "❌ НАЙДЕНЫ потенциально небезопасные функции!"
else
    echo "✅ Небезопасные функции не найдены"
fi
echo ""

# 3. Проверка разрешений файлов
echo "3. Проверка разрешений файлов:"
echo "Текущие разрешения на PHP файлы:"
ls -la *.php | while read line; do
    permissions=$(echo $line | cut -d' ' -f1)
    filename=$(echo $line | awk '{print $NF}')
    if [[ $permissions == *"w"* ]] && [[ $permissions != "-rw-r--r--" ]]; then
        echo "⚠️  $filename: $permissions (проверьте разрешения)"
    else
        echo "✅ $filename: $permissions"
    fi
done
echo ""

# 4. Проверка размеров файлов
echo "4. Анализ размеров исполняемых файлов:"
echo "Большие PHP файлы (>50KB):"
find . -name "*.php" -size +50k -exec ls -lh {} \; | while read line; do
    size=$(echo $line | awk '{print $5}')
    filename=$(echo $line | awk '{print $NF}')
    echo "⚠️  $filename: $size"
done
echo ""

# 5. Проверка дублирующихся файлов
echo "5. Поиск дублирующихся файлов:"
if find . -name "*.php" -exec md5sum {} \; | sort | uniq -d -w32; then
    echo "❌ НАЙДЕНЫ дублирующиеся файлы!"
else
    echo "✅ Дублирующиеся файлы не найдены"
fi
echo ""

echo "=== РЕКОМЕНДАЦИИ ПО БЕЗОПАСНОСТИ ==="
echo ""
echo "🛠️  Немедленные действия:"
echo "1. Удалить пароли из README.md"
echo "2. Использовать переменные окружения (.env файл)"
echo "3. Ограничить доступ к installer.php по IP"
echo "4. Заменить shell_exec на безопасные альтернативы"
echo ""
echo "🔒 Долгосрочные улучшения:"
echo "1. Внедрить двухфакторную аутентификацию"
echo "2. Добавить логирование безопасности"
echo "3. Настроить автоматические обновления"
echo "4. Создать систему мониторинга"
echo ""
echo "📋 Для детального анализа см.:"
echo "- SECURITY_DIAGNOSTIC_REPORT.md"
echo "- TECHNICAL_ANALYSIS_REPORT.md"
echo "- EXECUTIVE_SUMMARY.md"