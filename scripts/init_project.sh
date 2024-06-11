#!/bin/bash

# echo "########################################################"
# echo " "
# echo "For more information see:"
# echo "URL"
# echo "If you do not have access to Notion, just ask"
# echo " "
# echo "########################################################"

# Copy example files
echo "Copying example files..."
cp config/database.yml.example config/database.yml
cp config/master.key.example config/master.key

# Copy setup for puma dev
cp files/puma-dev/api-dev2.asense ~/.puma-dev/.

echo "Done"
