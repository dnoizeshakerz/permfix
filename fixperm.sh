#Created by Azlan. This script is for fixing domain docroot (NOT HOMEDIR) of a website hosted in cPanel/Directadmin server, or basically any panel that requires 755/644 permission files.


# Check if running as root
if [ "$(id -u)" != "0" ]; then
    echo "Error: This script must be run as root." >&2
    exit 1
fi

# Ask for DOCROOT if not provided
if [ "$#" -lt 1 ]; then
    read -p "Enter the domain document root path: " DOCROOT
else
    DOCROOT="$1"
fi

# Validate DOCROOT exists
if [ ! -d "$DOCROOT" ]; then
    echo "Error: Directory '$DOCROOT' does not exist." >&2
    exit 1
fi

# Ask for username
read -p "Enter the username to set as owner (e.g., 'soccersi'): " USERNAME

# Validate user exists
if ! id -u "$USERNAME" >/dev/null 2>&1; then
    echo "Error: User '$USERNAME' does not exist." >&2
    exit 1
fi

# Fix permissions
echo "Setting ownership to $USERNAME and adjusting permissions..."
chown -R "$USERNAME":"$USERNAME" "$DOCROOT" && \
    find "$DOCROOT" -type f -exec chmod 644 {} + && \
    find "$DOCROOT" -type d -exec chmod 755 {} +

echo "Permissions fixed successfully for $DOCROOT."
