#!/bin/bash

# echo "########################################################"
# echo " "
# echo "For more information see:"
# echo "https://www.notion.so/cialfo/Setting-Up-cialfo-api-Locally-85fef4dbddf24d57afef03ced3f50d69"
# echo "If you do not have access to Notion, just ask"
# echo " "
# echo "########################################################"

# Copy example files
echo "Copying example files..."
cp config/database.yml.example config/database.yml
cp config/database_pg.yml.example config/database_pg.yml
cp config/secrets.yml.example config/secrets.yml

# Copy setup for puma dev
cp files/puma-dev/api-2.cialfo ~/.puma-dev/.

echo "Done"
