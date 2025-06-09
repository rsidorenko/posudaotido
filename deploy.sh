#!/bin/bash

# Цвета для вывода
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Функция для вывода сообщений
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Проверка наличия необходимых утилит
check_requirements() {
    print_message "Проверка необходимых утилит..."
    
    if ! command -v docker &> /dev/null; then
        print_error "Docker не установлен"
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose не установлен"
        exit 1
    fi
    
    if ! command -v certbot &> /dev/null; then
        print_message "Установка Certbot..."
        sudo apt-get update
        sudo apt-get install -y certbot python3-certbot-nginx
    fi
}

# Настройка SSL-сертификатов
setup_ssl() {
    print_message "Настройка SSL-сертификатов..."
    
    # Запрос домена
    read -p "Введите ваш домен (например, example.com): " DOMAIN
    
    # Получение SSL-сертификата
    sudo certbot certonly --standalone -d $DOMAIN -d www.$DOMAIN
    
    if [ $? -eq 0 ]; then
        print_message "SSL-сертификаты успешно получены"
        
        # Создание директории для сертификатов
        mkdir -p ssl
        
        # Копирование сертификатов
        sudo cp /etc/letsencrypt/live/$DOMAIN/fullchain.pem ssl/
        sudo cp /etc/letsencrypt/live/$DOMAIN/privkey.pem ssl/
        
        # Установка прав
        sudo chown -R $USER:$USER ssl/
    else
        print_error "Ошибка при получении SSL-сертификатов"
        exit 1
    fi
}

# Обновление конфигурационных файлов
update_configs() {
    print_message "Обновление конфигурационных файлов..."
    
    # Обновление backend/.env
    sed -i "s|your-domain.com|$DOMAIN|g" backend/.env
    
    # Обновление frontend/.env
    sed -i "s|your-domain.com|$DOMAIN|g" frontend/.env
    
    # Обновление docker-compose.yml
    sed -i "s|your-domain.com|$DOMAIN|g" docker-compose.yml
}

# Сборка и запуск контейнеров
deploy_containers() {
    print_message "Сборка и запуск контейнеров..."
    
    docker-compose down
    docker-compose up -d --build
    
    if [ $? -eq 0 ]; then
        print_message "Контейнеры успешно запущены"
    else
        print_error "Ошибка при запуске контейнеров"
        exit 1
    fi
}

# Настройка автоматического обновления SSL
setup_ssl_renewal() {
    print_message "Настройка автоматического обновления SSL-сертификатов..."
    
    # Создание скрипта для обновления сертификатов
    cat > renew-ssl.sh << 'EOF'
#!/bin/bash
certbot renew
cp /etc/letsencrypt/live/$DOMAIN/fullchain.pem ssl/
cp /etc/letsencrypt/live/$DOMAIN/privkey.pem ssl/
docker-compose restart nginx
EOF
    
    chmod +x renew-ssl.sh
    
    # Добавление задачи в crontab
    (crontab -l 2>/dev/null; echo "0 0 1 * * /path/to/renew-ssl.sh") | crontab -
}

# Основной процесс деплоя
main() {
    print_message "Начало процесса деплоя..."
    
    check_requirements
    setup_ssl
    update_configs
    deploy_containers
    setup_ssl_renewal
    
    print_message "Деплой успешно завершен!"
    print_message "Ваш сайт доступен по адресу: https://$DOMAIN"
}

# Запуск основного процесса
main 