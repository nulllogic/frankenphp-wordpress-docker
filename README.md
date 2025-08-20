<p align="left">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="./.imgs/header.jpg">
      <img alt="SCSSleon framework" src="./.imgs/header.jpg">
    </picture>
</p>

# FrankenPHP + WordPress 🚀

Welcome to this FrankenPHP-WordPress-Docker!
With just a few commands, you'll get a fully functional WordPress instance based on FrankenPHP, MariaDB – completely in Docker 🛳️.

---

## 📋 Prerequisites

* [Docker](https://docs.docker.com/get-docker/) ≥ 20.10
* [Docker Compose](https://docs.docker.com/compose/) (included by default in Docker v20.10+)
* `make` – pre-installed on macOS & Linux, on Windows available via [Git for Windows](https://gitforwindows.org/) or WSL.

---

## 🏗️ Installation

```bash
# 1) Clone the repository (if not already done)
git clone <repo-url> frankenphp-wordpress
cd frankenphp-wordpress

# 2) Set your own environment variables
cmp .env.example .env  # Adjust values in your editor

# 3) Download WordPress (creates ./wordpress)
make install-wp

# 4) Generate docker-compose for the desired environment
make init-dev   # Development
#   or
make init-prod  # Production

# 5) Start the stack (FrankenPHP, MariaDB, Dragonfly, phpMyAdmin)
make up
```

Within seconds, you can access:

* 🔗 **WordPress**: [`http://localhost:8080`](http://localhost:8080)
* 🔗 **phpMyAdmin**: [`http://localhost:8081`](http://localhost:8081)
    * Login credentials: the values from `.env` (`MYSQL_USER` & `MYSQL_PASSWORD`)

> 💡 The standard WordPress admin user will be created as usual during the setup wizard.

---

## ⚙️ Makefile Commands

| Command               | Description |
|-----------------------|--------------|
| `make init-dev`       | Copies `docker-compose.dev.yml` → `docker-compose.yml` |
| `make init-prod`      | Copies `docker-compose.prod.yml` → `docker-compose.yml` |
| `make up`             | Build containers (if needed) & start them in the background |
| `make start`          | Start stopped containers |
| `make stop`           | Stop containers **without** deleting them |
| `make down`           | Stop and remove containers (Volumes remain) |
| `make restart`        | Restart containers |
| `make logs`           | Follow live logs from all containers |
| `make build`          | Rebuild images |
| `make clean`          | Full reset: Remove containers, images, volumes & orphans |
| `make install-wp`     | Download latest WordPress source & extract to `./wordpress` |
| `make fix-perms`      | Set owner of `./wordpress` to UID 33 (www-data) |
| `make set-fs-direct`  | Add `define('FS_METHOD','direct')` to `wp-config.php` |
| `make help`           | Overview of all targets |

---

## 🧩 Docker Services

| Service      | Purpose | Port |
|--------------|-------|------|
| **frankenphp** | PHP 8.4 Runtime + Webserver (Base: `dunglas/frankenphp:php8.4`) | Prod: 80 → 80, 443 → 443, Dev: 8080 → 80, 8443 → 443 |
| **db**         | MariaDB 11 with persistent volume storage (`db_data`) | 3306 |
| **dragonfly**  | Dragonfly Redis-compatible for WordPress Object Caching | Dev: 6379 → 6379 |
| **phpmyadmin** | GUI management for MariaDB | 8081 → 80 |

---

## 🌐 Custom Domain & Caddyfile

1. **Create site file**  
   `caddy/site.caddyfile` (extension `.caddyfile` is important)
   ```caddyfile
   {$SERVER_NAME} {
       root * /app/public    # WordPress Root in the container
       encode zstd br gzip
       php_server            # FrankenPHP Shortcut
       file_server
   }
   ```
   `{$SERVER_NAME}` is automatically replaced by the value from `.env`.

2. **Enable Compose mount**  
   In `docker-compose.yml` for the `frankenphp` service:
   ```yaml
   volumes:
      - ./wordpress:/app/public
      - ./caddy/Caddyfile:/etc/caddy/Caddyfile:ro
      - ./caddy/wordpress.caddyfile:/etc/caddy/Caddyfile.d/wordpress.caddyfile:ro
      - ./caddy/opcache.ini:/usr/local/etc/php/conf.d/docker-php-ext-opcache.ini:ro
      - caddy_data:/data
      - caddy_config:/config
   ```

3. **Rebuild & start the stack**
   ```bash
   make build
   make up
   ```

Caddy automatically fetches TLS certificates for public domains. For local hosts, it remains HTTP.

---

## 🔑 Environment Variables

All variables are managed in `.env` and used in `docker-compose.yml`:

| Variable            | Default            | Description                                                 |
|---------------------|--------------------|--------------------------------------------------------------|
| `SERVER_NAME`       | `localhost`        | Public domain/host of your WP site (FrankenPHP variable)    |
| `MYSQL_DATABASE`    | `franken`          | Database name                                               |
| `MYSQL_USER`        | `frankenuser`      | DB user                                                     |
| `MYSQL_PASSWORD`    | `frankenpass`      | DB password                                                 |
| `MYSQL_ROOT_PASSWORD` | `rootpass`       | Root password (internal only)                               |
| `REDIS_HOST`        | `dragonfly`        | Redis server hostname                                       |
| `REDIS_PORT`        | `6379`             | Redis server port                                           |
| `DRAGONFLY_MAX_MEMORY` | `512mb`             | Redis/Dragonfly max memory                                  |

> 🔒 **Security:** `.env` is listed in `.gitignore`. Never share real credentials in public repos!

---

## 🚀 Redis Object Caching

The setup includes a **Dragonfly** container, which is Redis-compatible and works perfectly for WordPress Object Caching.

### Recommended WordPress Plugins:
- **[Redis Object Cache](https://wordpress.org/plugins/redis-cache/)** by Till Krüss (recommended)
- **[W3 Total Cache](https://wordpress.org/plugins/w3-total-cache/)** with Redis backend
- **[WP Redis](https://wordpress.org/plugins/wp-redis/)**

### Installation:
1. Install WordPress plugin via Admin backend
2. Activate plugin
3. For Redis Object Cache: click "Enable Object Cache"
4. The connection to `dragonfly:6379` is automatically detected

> 💡 **Tip:** Dragonfly is up to 25x faster than Redis with the same memory usage!

---

## 🧹 Cleanup

```bash
make clean   # removes EVERYTHING (Containers, Images, Volumes)
```

---

## 🤝 License

See [`LICENSE`](LICENSE).

Have fun 🎉