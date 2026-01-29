# Pretix Docker Stack

Production-ready [Pretix](https://pretix.eu) ticket shop deployment with automated backups, monitoring, and out-of-the-box plugin support.

## Features

- **Complete Stack**: Pretix, PostgreSQL, Redis, Caddy (reverse proxy with automatic HTTPS)
- **Pre-installed Plugins**: PayPal, Stripe, Sofort, BitPay, ticket PDFs, reports, pages, and more
- **Automated Backups**: Daily backups via Restic with configurable retention (7 daily, 4 weekly, 12 monthly, 3 yearly)
- **Monitoring**: Prometheus + Grafana dashboard for system metrics
- **Scheduled Tasks**: Automatic Pretix cron jobs every 30 minutes

## Quick Start

### 1. Configuration

Copy the environment template and configure your settings:

```bash
cp .env.example .env
```

Edit `.env` with your configuration:

```bash
URL=tickets.example.com                # Your domain
DATABASE_NAME=pretix                   # Database credentials
DATABASE_USER=pretix
DATABASE_PASSWORD=secure_password

MAIL_ADDRESS=noreply@example.com      # SMTP settings
MAIL_HOST=smtp.example.com
MAIL_USER=user
MAIL_PASSWORD=password
MAIL_PORT=587
MAIL_TLS=on

METRICS_USER=admin                     # Metrics endpoint auth
METRICS_PASSWORD=secure_password

ACME_EMAIL=admin@example.com          # Let's Encrypt email

BACKUP_SSH_PRIVATE_KEY=~/.ssh/id_ed25519      # Backup configuration
BACKUP_SSH_KNOWN_HOSTS=~/.ssh/known_hosts
BACKUP_REPOSITORY=sftp:user@backup.host:/path  # Use SFTP for production
BACKUP_PASSWORD=restic_password

GRAFANA_USER=admin                     # Grafana dashboard
GRAFANA_PASSWORD=secure_password
```

**Note on Backups:**
- For local testing: Use `BACKUP_REPOSITORY=/restic-repo` (local mount, no SSH keys needed)
- For production: Use `BACKUP_REPOSITORY=sftp:user@host:/path` (requires SSH keys configured)
- It's strongly encouraged to test SFTP backups locally before deploying to production

### 2. Initialize (Fresh Installation)

Run the initialization script:

```bash
./init.sh
```

This script performs three critical tasks:
1. Sets correct file permissions for Pretix (UID 15371)
2. Initializes the Restic backup repository
3. Runs database migrations to prepare Pretix with all plugins

Start the stack:

```bash
docker compose up -d
```

Access your Pretix instance at `https://<URL>` and login with Pretix default credentials.

### 3. Restore (From Backup)

To restore from a backup (disaster recovery, migration, or testing):

**Important:** Use `.env.restore` for the restore process!

1. Copy your restore configuration:
   ```bash
   cp .env.restore .env
   ```

2. Configure `.env` with:
   - **Database credentials** matching your backup
   - **Backup repository** and SSH settings matching your backup source
   - **Backup password** used for encryption

   ⚠️ **Critical:** The database credentials in `.env` must match those from the backup. During restore, the `.env` file will be overwritten with the one from the backup. If database credentials don't match, you'll be locked out of the database.

3. Run the restore script:
   ```bash
   ./restore.sh
   ```

4. After restore completes, start the stack:
   ```bash
   docker compose up -d
   ```

## Backup Management

### Manual Backup

Trigger a manual backup at any time:

```bash
./backup.sh
```

This backs up:
- PostgreSQL database (custom format dump)
- Pretix application data (tickets, media, logs)
- `.env` configuration file

### Automatic Backups

Backups run automatically at **3:00 AM daily**. Old backups are pruned at **3:00 PM daily** according to the retention policy.

## Monitoring

Access Grafana at `https://grafana.<URL>` using the credentials configured in `.env`.

Monitored metrics include:
- Pretix application performance
- PostgreSQL database
- Redis cache
- Caddy reverse proxy
- Restic backup status

## Architecture

### Services

- **app**: Pretix application with custom plugins
- **postgres**: PostgreSQL 17 database
- **redis**: Redis 8 cache and session store
- **caddy**: Reverse proxy with automatic HTTPS (Let's Encrypt)
- **restic**: Backup service with scheduled jobs
- **ofelia**: Cron scheduler for Docker containers
- **prometheus**: Metrics collection
- **grafana**: Metrics visualization
- **postgres_exporter**: PostgreSQL metrics
- **redis_exporter**: Redis metrics
- **restic_exporter**: Backup metrics

### Networks

- `caddy`: Reverse proxy communication
- `postgres`: Database connections
- `redis`: Cache connections
- `prometheus`: Metrics collection

## Environment Files

### `.env` (Full Configuration)
Used when running the stack. Contains all service configurations including database, mail, backups, and monitoring credentials.

### `.env.restore` (Restore Configuration)
Used only during the restore process. Contains minimal configuration needed to access the backup and restore the database. Must have database credentials matching those in the backup.

### `.env.example`
Template showing all available configuration options.

## Port Exposure

- `80/443`: HTTP/HTTPS (Caddy)
- Grafana: Accessible via `https://grafana.<URL>` (proxied through Caddy)

## Data Persistence

- `./app/data`: Pretix application data
- `./db/data`: PostgreSQL data
- `./restic/data`: Local Restic repository (if using local backups)

## License

See [LICENSE](LICENSE) file for details.
