#!/bin/bash

BACKUP_SRC="/var/lib/docker/volumes"
BACKUP_DEST_DIR="/mnt/backups"
BACKUP_FILE="$BACKUP_DEST_DIR/docker_volumes_$(date +%Y%m%d).tar.gz"
RETENTION_DAYS=30

# Create the backup
tar -czf "$BACKUP_FILE" "$BACKUP_SRC"

# Remove backups older than the retention period
find "$BACKUP_DEST_DIR" -type f -name "docker_volumes_*.tar.gz" -mtime +$RETENTION_DAYS -exec rm {} \;

# Optional: Log the backup and cleanup process
echo "$(date): Backup created at $BACKUP_FILE and old backups cleaned up" >> /var/log/docker_backup.log