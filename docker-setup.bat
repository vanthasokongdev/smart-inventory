@echo off
echo Starting Inventory Management Phone - Docker Setup

echo Building Docker containers...
docker-compose build

echo Starting containers...
docker-compose up -d

echo Waiting for PostgreSQL to be ready...
timeout /t 10 /nobreak

echo Installing Composer dependencies...
docker-compose exec app composer install

echo Generating application key...
docker-compose exec app php artisan key:generate

echo Running migrations and seeders...
docker-compose exec app php artisan migrate:fresh --seed

echo Creating storage link...
docker-compose exec app php artisan storage:link

echo Building frontend assets...
docker-compose run --rm node npm install
docker-compose run --rm node npm run build

echo.
echo Setup complete!
echo Application is running at: http://localhost:8085
echo PostgreSQL is available at: localhost:5435
echo Database: inventory_phone
echo Username: postgres
echo Password: password
