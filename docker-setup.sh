#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting Inventory Management Phone - Docker Setup${NC}"

# Build and start containers
echo -e "${YELLOW}Building Docker containers...${NC}"
docker-compose build

echo -e "${YELLOW}Starting containers...${NC}"
docker-compose up -d

# Wait for PostgreSQL to be ready
echo -e "${YELLOW}Waiting for PostgreSQL to be ready...${NC}"
sleep 10

# Install Composer dependencies
echo -e "${YELLOW}Installing Composer dependencies...${NC}"
docker-compose exec app composer install

# Generate application key
echo -e "${YELLOW}Generating application key...${NC}"
docker-compose exec app php artisan key:generate

# Run migrations and seeders
echo -e "${YELLOW}Running migrations and seeders...${NC}"
docker-compose exec app php artisan migrate:fresh --seed

# Create storage link
echo -e "${YELLOW}Creating storage link...${NC}"
docker-compose exec app php artisan storage:link

# Build frontend assets
echo -e "${YELLOW}Building frontend assets...${NC}"
docker-compose run --rm node npm install
docker-compose run --rm node npm run build

echo -e "${GREEN}Setup complete!${NC}"
echo -e "${GREEN}Application is running at: http://localhost:8085${NC}"
echo -e "${GREEN}PostgreSQL is available at: localhost:5435${NC}"
echo -e "${GREEN}Database: inventory_phone${NC}"
echo -e "${GREEN}Username: postgres${NC}"
echo -e "${GREEN}Password: password${NC}"
