### Basic Backup Config
Persistent container volumes are created locally on the docker host for performance. Nightly backups are sent to a NAS. The steps below were used on Ubuntu 24.04.

1. Create a remote file share for the backup destination (the following steps assume NFS for the share).
2. Install nfs tools and setup the NFS mount. Don't forget to update `<NAS IP>` with your actual NAS IP.
```shell
sudo apt update
sudo apt install nfs-common
sudo mkdir -p /mnt/backups
echo "<NAS_IP>:/<export_path> /mnt/backups nfs defaults 0 0" | sudo tee -a /etc/fstab
sudo mount -a
```
3. Initial the script file
```shell
sudo nano /usr/local/bin/backup_docker_vols.sh
```
4. Copy the script contents into the file:
```shell
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
```
5. Make the script executable:
```shell
sudo chmod +x /usr/local/bin/backup_docker_vols.sh
```
6. Configure 2am nightly backups by opening crontab editor with `crontab -e` and adding the following:
```shell
0 2 * * * /usr/local/bin/backup_docker_vols.sh
```
7. Test the script:
```shell
sudo /usr/local/bin/backup_docker_vols.sh
```
8. Verify the backup files were created on the remote storage.