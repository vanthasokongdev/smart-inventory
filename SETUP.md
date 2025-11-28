# Inventory Management Phone - Setup Instructions

## Prerequisites

Before setting up the application, ensure you have the following installed:

- **PHP** >= 8.2 with the following extensions:
  - PDO
  - pdo_pgsql (for PostgreSQL) OR pdo_sqlite (for SQLite)
  - mbstring
  - openssl
  - tokenizer
  - xml
  - ctype
  - json
  - fileinfo
- **Composer** (PHP dependency manager)
- **Node.js** >= 18.x and **npm**
- **PostgreSQL** >= 13 (recommended) OR SQLite support in PHP

## Installation Steps

### 1. Install Dependencies

```bash
# Install PHP dependencies
composer install

# Install Node.js dependencies
npm install
```

### 2. Configure Environment

Copy the `.env.example` file to `.env`:

```bash
cp .env.example .env
```

### 3. Configure Database

#### Option A: PostgreSQL (Recommended)

1. Create a PostgreSQL database:
```bash
createdb -U postgres inventory_phone
```

2. Update your `.env` file with PostgreSQL credentials:
```env
DB_CONNECTION=pgsql
DB_HOST=127.0.0.1
DB_PORT=5432
DB_DATABASE=inventory_phone
DB_USERNAME=postgres
DB_PASSWORD=postgres
```

#### Option B: SQLite (Alternative)

1. Ensure PHP has SQLite extension enabled (check `php -m | grep sqlite`)

2. Create the database file:
```bash
touch database/database.sqlite
```

3. Update your `.env` file:
```env
DB_CONNECTION=sqlite
DB_DATABASE=/absolute/path/to/database/database.sqlite
```

### 4. Generate Application Key

```bash
php artisan key:generate
```

### 5. Run Migrations and Seeders

```bash
php artisan migrate:fresh --seed
```

This will create all necessary tables and populate them with sample data:
- 4 categories (Smartphones, Feature Phones, Accessories, Tablets)
- 11 sample products with prices and stock quantities

### 6. Create Storage Link

```bash
php artisan storage:link
```

This creates a symbolic link for file uploads (product photos).

### 7. Build Frontend Assets

```bash
# For development
npm run dev

# For production
npm run build
```

### 8. Start the Development Server

```bash
php artisan serve
```

The application will be available at `http://localhost:8000`

## Features

### Backend (Laravel + PostgreSQL/SQLite)

- **Models & Relationships**:
  - Category (hasMany Products)
  - Product (belongsTo Category)

- **API Endpoints**:
  - `GET /api/categories` - List all categories
  - `POST /api/categories` - Create category
  - `GET /api/categories/{id}` - Get category details
  - `PUT /api/categories/{id}` - Update category
  - `DELETE /api/categories/{id}` - Delete category
  - `GET /api/products` - List products (with filters)
  - `POST /api/products` - Create product (with photo upload)
  - `GET /api/products/{id}` - Get product details
  - `PUT /api/products/{id}` - Update product
  - `DELETE /api/products/{id}` - Delete product
  - `POST /api/products/{id}/quantity` - Update stock quantity

- **Validation**:
  - Category: name (required), description (optional)
  - Product: name, category_id, original_price, sale_price, quantity (all required)
  - Photo upload: jpeg, png, jpg, gif (max 2MB)

- **Features**:
  - File upload handling for product photos
  - Stock management (set, increase, decrease)
  - Search and filter products
  - Cascade delete (deleting category removes its products)

### Frontend (Vue.js 3 + Tailwind CSS)

- **Dashboard**:
  - Statistics cards (total products, categories, stock, low stock alerts)
  - Recent products table

- **Category Management**:
  - Grid view of categories
  - Create/Edit modal
  - Delete with confirmation
  - Shows product count per category

- **Product Management**:
  - Comprehensive table view
  - Search by name
  - Filter by category, stock status, price range
  - Create/Edit modal with photo upload
  - Stock adjustment modal (set, increase, decrease)
  - Low stock visual indicators
  - Delete with confirmation

## API Query Parameters

### Products Endpoint

- `search` - Search by product name
- `category_id` - Filter by category
- `in_stock` - Filter by stock availability (true/false)
- `min_price` - Minimum sale price
- `max_price` - Maximum sale price

Example:
```
GET /api/products?search=iPhone&category_id=1&in_stock=true
```

## Troubleshooting

### Database Connection Issues

1. **PostgreSQL password error**: Ensure your PostgreSQL user has a password set and it matches your `.env` file
2. **SQLite driver not found**: Install PHP SQLite extension:
   - Windows: Enable `extension=pdo_sqlite` in `php.ini`
   - Linux: `sudo apt-get install php-sqlite3`
   - Mac: Usually included by default

### File Upload Issues

- Ensure `storage/app/public` directory exists and is writable
- Run `php artisan storage:link` if uploads aren't showing

### Frontend Build Issues

- Clear npm cache: `npm cache clean --force`
- Delete `node_modules` and reinstall: `rm -rf node_modules && npm install`

## Sample Data

The seeder creates:

**Categories:**
- Smartphones
- Feature Phones
- Accessories
- Tablets

**Products:**
- iPhone 15 Pro ($949)
- Samsung Galaxy S24 Ultra ($1099)
- Google Pixel 8 Pro ($849)
- OnePlus 12 ($749)
- Nokia 3310 ($49)
- And more...

## Development

### Running in Development Mode

```bash
# Terminal 1: Laravel backend
php artisan serve

# Terminal 2: Vite dev server (hot reload)
npm run dev
```

### Building for Production

```bash
npm run build
php artisan optimize
```

## Tech Stack

- **Backend**: Laravel 12, PostgreSQL/SQLite
- **Frontend**: Vue.js 3 (Composition API), Vue Router 4
- **Styling**: Tailwind CSS 4
- **HTTP Client**: Axios
- **Build Tool**: Vite

## License

This project is open-source and available for educational purposes.
