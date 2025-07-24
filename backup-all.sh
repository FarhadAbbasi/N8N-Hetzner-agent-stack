#!/bin/bash


# To run/trigger following backup script:
# crontab -e		#Add following line to crontab for auto-backups.
# 0 */12 * * * /root/agent-stack/backup-all.sh >> /var/log/agent-backup.log 2>&1	



# This script backs up n8n and Qdrant data, archives them, and manages old backups.
# It assumes n8n is running in a Docker container and Qdrant data is stored in a host-mounted volume.
# Set timestamps and paths
TIMESTAMP=$(date +%F-%H%M)
TMP_DIR="/tmp/backup-$TIMESTAMP"
FINAL_DIR="/root/agent-stack/complete-backups"
ARCHIVE_NAME="backup-$TIMESTAMP.tar.gz"

# Paths (adjust if different)
QDRANT_HOST_PATH="/root/agent-stack/data/qdrant/storage"
N8N_CONTAINER="agent-stack-n8n-1"

# Create temporary directory
mkdir -p "$TMP_DIR"

# --- Backup n8n (only if container is running)
if docker ps --format '{{.Names}}' | grep -q "$N8N_CONTAINER"; then
    echo "✅ Backing up n8n..."
    docker cp $N8N_CONTAINER:/home/node/.n8n "$TMP_DIR/n8n"
else
    echo "⚠️  Skipping n8n: container not running"
fi

# --- Backup Qdrant from host-mounted volume
if [ -d "$QDRANT_HOST_PATH" ]; then
    echo "✅ Backing up Qdrant from host volume..."
    cp -r "$QDRANT_HOST_PATH" "$TMP_DIR/qdrant"
else
    echo "⚠️  Skipping Qdrant: path not found - $QDRANT_HOST_PATH"
fi

# --- Archive everything
mkdir -p "$FINAL_DIR"
tar -czf "$FINAL_DIR/$ARCHIVE_NAME" -C /tmp "backup-$TIMESTAMP"

# --- Cleanup
rm -rf "$TMP_DIR"

# --- Delete backups older than 14 days
find "$FINAL_DIR" -type f -name "backup-*.tar.gz" -mtime +14 -exec rm {} \;

echo "✅ Backup completed: $ARCHIVE_NAME"
