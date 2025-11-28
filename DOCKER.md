# Docker Development Environment

## Quick Start

### Prerequisites
- Docker Desktop installed and running
- Docker Compose installed

### Setup and Run

**For Linux/Mac:**
```bash
chmod +x docker-setup.sh
./docker-setup.sh
```

**For Windows:**
```bash
docker-setup.bat
```

**Or manually:**
```bash
# Build and start containers
docker-compose up -d --build

# Install dependencies
docker-compose exec app composer install

# Generate app key
docker-compose exec app php artisan key:generate

# Run migrations and seeders
docker-compose exec app php artisan migrate:fresh --seed

# Create storage link
docker-compose exec app php artisan storage:link

# Build frontend
docker-compose run --rm node npm install
docker-compose run --rm node npm run build
```

## Access Points

- **Application**: http://localhost:8085
- **PostgreSQL**: localhost:5435
  - Database: `inventory_phone`
  - Username: `postgres`
  - Password: `password`

## Docker Services

### 1. PostgreSQL (postgres)
- **Image**: postgres:16-alpine
- **Port**: 5435 (host) → 5432 (container)
- **Volume**: postgres_data (persistent storage)

### 2. PHP-FPM (app)
- **Image**: Custom (php:8.3-fpm-alpine)
- **Extensions**: PDO, pdo_pgsql, mbstring, gd, zip, etc.
- **Working Directory**: /var/www

### 3. Nginx (nginx)
- **Image**: nginx:alpine
- **Port**: 8085 (host) → 80 (container)
- **Config**: docker/nginx/default.conf

### 4. Node.js (node)
- **Image**: node:20-alpine
- **Purpose**: Build frontend assets
- **Usage**: One-time build, then can be stopped

## Common Commands

### Start containers
```bash
docker-compose up -d
```

### Stop containers
```bash
docker-compose down
```

### View logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f app
docker-compose logs -f nginx
docker-compose logs -f postgres
```

### Execute commands in containers
```bash
# Laravel artisan commands
docker-compose exec app php artisan migrate
docker-compose exec app php artisan db:seed
docker-compose exec app php artisan cache:clear

# Composer commands
docker-compose exec app composer install
docker-compose exec app composer update

# NPM commands (build frontend)
docker-compose run --rm node npm install
docker-compose run --rm node npm run build
docker-compose run --rm node npm run dev
```

### Access container shell
```bash
# PHP container
docker-compose exec app sh

# PostgreSQL container
docker-compose exec postgres psql -U postgres -d inventory_phone
```

### Rebuild containers
```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

## File Structure

```
inventory-stock-management/
├── docker/
│   ├── nginx/
│   │   └── default.conf       # Nginx configuration
│   └── php/
│       └── local.ini           # PHP configuration
├── docker-compose.yml          # Docker Compose configuration
├── Dockerfile                  # PHP-FPM Dockerfile
├── docker-setup.sh            # Linux/Mac setup script
└── docker-setup.bat           # Windows setup script
```

## Environment Variables

The `.env` file is automatically configured for Docker:

```env
DB_CONNECTION=pgsql
DB_HOST=postgres
DB_PORT=5432
DB_DATABASE=inventory_phone
DB_USERNAME=postgres
DB_PASSWORD=postgres
```

## Troubleshooting

### Port already in use
If ports 8085 or 5435 are already in use, modify `docker-compose.yml`:
```yaml
ports:
  - "YOUR_PORT:80"  # For nginx
  - "YOUR_PORT:5432"  # For postgres
```

### Permission issues
```bash
# Fix storage permissions
docker-compose exec app chmod -R 775 storage bootstrap/cache
docker-compose exec app chown -R www-data:www-data storage bootstrap/cache
```

### Database connection issues
```bash
# Check if PostgreSQL is running
docker-compose ps

# Check PostgreSQL logs
docker-compose logs postgres

# Restart PostgreSQL
docker-compose restart postgres
```

### Clear all data and restart
```bash
docker-compose down -v  # Remove volumes
docker-compose up -d --build
./docker-setup.sh  # Re-run setup
```

## Development Workflow

1. **Start development**:
   ```bash
   docker-compose up -d
   ```

2. **Make code changes** (hot reload for frontend):
   ```bash
   docker-compose run --rm node npm run dev
   ```

3. **Run migrations** (after model changes):
   ```bash
   docker-compose exec app php artisan migrate
   ```

4. **View logs**:
   ```bash
   docker-compose logs -f app
   ```

5. **Stop development**:
   ```bash
   docker-compose down
   ```

## Production Build

For production deployment:

```bash
# Build optimized frontend
docker-compose run --rm node npm run build

# Optimize Laravel
docker-compose exec app php artisan config:cache
docker-compose exec app php artisan route:cache
docker-compose exec app php artisan view:cache
```

## Database Backup

```bash
# Backup
docker-compose exec postgres pg_dump -U postgres inventory_phone > backup.sql

# Restore
docker-compose exec -T postgres psql -U postgres inventory_phone < backup.sql
```
