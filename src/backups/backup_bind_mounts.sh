#!/bin/bash

BACKUP_SRC="home/rob/docker"
BACKUP_DEST_DIR="/mnt/backups"
BACKUP_FILE="$BACKUP_DEST_DIR/docker_rob_home_binds_$(date +%Y%m%d).tar.gz"
RETENTION_DAYS=30

# Create the backup
tar -czf "$BACKUP_FILE" "$BACKUP_SRC"

# Remove backups older than the retention period
find "$BACKUP_DEST_DIR" -type f -name "docker_rob_home_binds_*.tar.gz" -mtime +$RETENTION_DAYS -exec rm {} \;

# Optional: Log the backup and cleanup process
echo "$(date): Backup created at $BACKUP_FILE and old backups cleaned up" >> /home/rob/backuplogs/docker_backup.log