# Docker Setup cho FTES Flutter App

## Tổng quan
Dự án đã được containerized với Docker và tích hợp Redis để hỗ trợ caching và session management.

## Cấu trúc Docker

### Services
1. **ftes-app**: Flutter web application (port 3001)
2. **redis**: Redis database (port 6379)
3. **redis-commander**: Web UI để quản lý Redis (port 8081)

## Cách sử dụng

### 1. Khởi động tất cả services
```bash
docker-compose up -d
```

### 2. Xem logs
```bash
# Xem logs của tất cả services
docker-compose logs -f

# Xem logs của service cụ thể
docker-compose logs -f ftes-app
docker-compose logs -f redis
```

### 3. Dừng services
```bash
# Dừng tất cả services
docker-compose down

# Dừng và xóa volumes
docker-compose down -v
```

### 4. Rebuild app sau khi thay đổi code
```bash
docker-compose up --build -d ftes-app
```

## Truy cập ứng dụng

- **Flutter App**: http://localhost:3001
- **Redis Commander**: http://localhost:8081
- **Redis**: localhost:6379

## Redis Configuration

### Thông tin kết nối
- **Host**: redis (trong container) hoặc localhost (từ host)
- **Port**: 6379
- **Password**: FunnyCode2024!Redis@Cache

### Sử dụng Redis trong Flutter
```dart
import 'package:redis/redis.dart';

// Kết nối Redis
final conn = await RedisConnection().connect('redis', 6379);
final command = RedisCommand(conn);

// Set value
await command.send_object(['SET', 'key', 'value']);

// Get value
final result = await command.send_object(['GET', 'key']);
```

## Environment Variables

Các biến môi trường có thể được cấu hình trong `docker-compose.yml`:

```yaml
environment:
  - REDIS_HOST=redis
  - REDIS_PORT=6379
  - REDIS_PASS=FunnyCode2024!Redis@Cache
```

## Troubleshooting

### 1. Port conflicts
Nếu port 3001, 6379, hoặc 8081 đã được sử dụng, thay đổi trong `docker-compose.yml`:
```yaml
ports:
  - "3002:80"  # Thay 3001 thành 3002
```

### 2. Redis connection issues
Kiểm tra Redis có chạy không:
```bash
docker-compose ps
docker-compose logs redis
```

### 3. Flutter build issues
Xóa build cache và rebuild:
```bash
docker-compose down
docker system prune -f
docker-compose up --build -d
```

## Development

### Hot reload trong development
Để phát triển với hot reload, chạy Flutter trực tiếp:
```bash
cd ftes
flutter run -d web-server --web-port 3001
```

### Chỉ chạy Redis
```bash
docker-compose up -d redis redis-commander
```

## Production Deployment

### 1. Build production image
```bash
docker build -t ftes-app:latest .
```

### 2. Run production container
```bash
docker run -d \
  --name ftes-app \
  -p 3001:80 \
  --network ftes-network \
  ftes-app:latest
```

## Monitoring

### Health checks
Tất cả services đều có health checks:
- **ftes-app**: HTTP check trên port 80
- **redis**: Redis ping command

### Xem health status
```bash
docker-compose ps
```

## Backup Redis Data

### Backup
```bash
docker exec ftes-redis redis-cli --rdb /data/dump.rdb
docker cp ftes-redis:/data/dump.rdb ./redis-backup.rdb
```

### Restore
```bash
docker cp ./redis-backup.rdb ftes-redis:/data/dump.rdb
docker exec ftes-redis redis-cli --rdb /data/dump.rdb
```


