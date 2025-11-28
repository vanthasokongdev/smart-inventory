# Redis and Queue Worker Configuration

## What's Added

✅ **Redis 7** - In-memory cache and session store
✅ **Queue Worker** - Laravel queue processor for background jobs

## Services

### Redis
- **Container**: `inventory_redis`
- **Port**: 6379 (exposed to host)
- **Image**: redis:7-alpine
- **Volume**: redis_data (persistent storage)
- **Health Check**: Automatic ping check

### Queue Worker
- **Container**: `inventory_worker`
- **Command**: `php artisan queue:work --sleep=3 --tries=3 --max-time=3600`
- **Auto-restart**: Yes
- **Depends on**: PostgreSQL and Redis

## Configuration

Your `.env` file has been updated with:

```env
CACHE_STORE=redis
SESSION_DRIVER=redis
QUEUE_CONNECTION=redis

REDIS_CLIENT=phpredis
REDIS_HOST=redis
REDIS_PASSWORD=null
REDIS_PORT=6379
```

## Usage

### Cache Operations

```php
// Store cache
Cache::put('key', 'value', 3600);

// Retrieve cache
$value = Cache::get('key');

// Remember cache
$users = Cache::remember('users', 3600, function () {
    return DB::table('users')->get();
});
```

### Queue Jobs

Create a job:
```bash
docker-compose exec app php artisan make:job ProcessInventory
```

Dispatch a job:
```php
ProcessInventory::dispatch($data);
```

### Monitor Queue

```bash
# View worker logs
docker-compose logs -f worker

# Check queue status
docker-compose exec app php artisan queue:work --once

# Clear failed jobs
docker-compose exec app php artisan queue:flush
```

## Redis CLI

Access Redis CLI:
```bash
docker-compose exec redis redis-cli

# Inside Redis CLI
> PING
PONG
> KEYS *
> GET cache_key
> FLUSHALL  # Clear all cache (use with caution)
```

## Monitoring

### View Logs
```bash
# Redis logs
docker-compose logs -f redis

# Worker logs
docker-compose logs -f worker
```

### Check Service Status
```bash
docker-compose ps
```

## Performance Benefits

✅ **Faster Sessions** - Redis is much faster than database sessions
✅ **Efficient Caching** - In-memory cache for frequently accessed data
✅ **Background Jobs** - Offload heavy tasks to queue worker
✅ **Scalable** - Can add more workers as needed

## Restart Services

```bash
# Restart all services
docker-compose restart

# Restart specific service
docker-compose restart redis
docker-compose restart worker
```
