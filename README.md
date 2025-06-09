# Posudaotido - Интернет-магазин посуды

## Структура проекта

```
frontend/
├── public/                 # Статические файлы
├── src/
│   ├── components/        # React компоненты
│   │   ├── admin/        # Компоненты админ-панели
│   │   ├── auth/         # Компоненты аутентификации
│   │   ├── cart/         # Компоненты корзины
│   │   ├── catalog/      # Компоненты каталога
│   │   ├── checkout/     # Компоненты оформления заказа
│   │   ├── layout/       # Компоненты макета
│   │   ├── orders/       # Компоненты заказов
│   │   ├── products/     # Компоненты товаров
│   │   └── profile/      # Компоненты профиля
│   ├── store/            # Redux store и слайсы
│   ├── styles/           # SCSS модули и глобальные стили
│   │   ├── variables.scss    # Переменные стилей
│   │   ├── main.scss        # Глобальные стили
│   │   └── [component].module.scss  # Стили компонентов
│   ├── types/            # TypeScript типы
│   ├── utils/            # Утилиты
│   ├── App.tsx           # Корневой компонент
│   └── index.tsx         # Точка входа
└── package.json          # Зависимости и скрипты

backend/
├── src/
│   ├── controllers/      # Контроллеры
│   ├── models/          # Mongoose модели
│   ├── routes/          # Маршруты API
│   ├── middleware/      # Middleware
│   ├── utils/           # Утилиты
│   └── app.ts           # Точка входа
└── package.json         # Зависимости и скрипты
```

## Технологии

### Фронтенд
- React 18
- TypeScript
- Redux Toolkit для управления состоянием
- React Router для маршрутизации
- Material-UI для компонентов
- Tailwind CSS для стилей
- SCSS модули для компонентных стилей

### Бэкенд
- Node.js
- Express
- MongoDB с Mongoose
- TypeScript
- JWT аутентификация
- Google OAuth для входа через Google
- Nodemailer для отправки email

## Установка и запуск

1. Клонировать репозиторий:
```bash
git clone https://github.com/your-username/posudaotido.git
cd posudaotido
```

2. Установить зависимости:
```bash
# Установка зависимостей для backend
cd backend
npm install

# Установка зависимостей для frontend
cd ../frontend
npm install
```

3. Настройка переменных окружения:

Backend (.env в папке backend):
```
# MongoDB Configuration
MONGODB_URI=mongodb://mongo:27017/posuda-ot-i-do
MONGO_INITDB_ROOT_USERNAME=root
MONGO_INITDB_ROOT_PASSWORD=example

# JWT Configuration
JWT_SECRET=your-jwt-secret
JWT_REFRESH_SECRET=your-jwt-refresh-secret

# Session Configuration
SESSION_SECRET=your-session-secret

# URLs Configuration
FRONTEND_URL=https://posudaotido.ru
API_URL=https://api.posudaotido.ru
PRODUCTION_API_URL=https://api.posudaotido.ru

# Google OAuth Configuration
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret
GOOGLE_CALLBACK_URL=https://api.posudaotido.ru/api/auth/google/callback

# Email Configuration
EMAIL_USER=your-email@example.com
EMAIL_PASSWORD=your-email-password

# Node Environment
NODE_ENV=production
```

Frontend (.env в папке frontend):
```
REACT_APP_API_URL=https://api.posudaotido.ru/api
NODE_ENV=production
```

4. Настройка Google OAuth:
   - Создайте проект в Google Cloud Console
   - Включите Google OAuth API
   - Создайте OAuth 2.0 credentials
   - Добавьте разрешенные URI перенаправления: `https://api.posudaotido.ru/api/auth/google/callback`
   - Скопируйте Client ID и Client Secret в backend/.env

5. Запуск через Docker:
```bash
# Запуск всех сервисов
docker-compose up -d

# Проверка статуса
docker-compose ps
```

## Разработка

### Локальный запуск

Backend:
```bash
cd backend
npm run dev
```

Frontend:
```bash
cd frontend
npm start
```

### Доступ к сервисам
- Frontend: http://localhost:3000
- Backend API: http://localhost:5000
- MongoDB: mongodb://localhost:27017/posuda-ot-i-do

## Тестирование

```bash
# Backend тесты
cd backend
npm test

# Frontend тесты
cd frontend
npm test
```

## Сборка

```bash
# Backend сборка
cd backend
npm run build

# Frontend сборка
cd frontend
npm run build
```

## Деплой

1. Подготовка сервера:
   - Установите Docker и Docker Compose
   - Настройте SSL сертификаты в папку ssl/
   - Создайте .env файлы с production настройками

2. Деплой:
```bash
# Клонирование репозитория
git clone https://github.com/your-username/posudaotido.git
cd posudaotido

# Запуск сервисов
docker-compose up -d

# Проверка логов
docker-compose logs -f
```

## Мониторинг

- Метрики доступны по адресу: https://api.posudaotido.ru/metrics
- Логи контейнеров: `docker-compose logs -f [service]`
- Мониторинг MongoDB: `mongosh mongodb://localhost:27017/posuda-ot-i-do`

## Безопасность

- Все пароли хешируются с использованием bcrypt
- JWT токены с ограниченным сроком действия
- HTTPS для всех соединений
- CORS настроен только для разрешенных доменов
- Защита от XSS и CSRF атак
- Rate limiting для API endpoints