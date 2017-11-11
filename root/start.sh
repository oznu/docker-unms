#!/bin/sh

cd /app

# Database migrations
node node_modules/sequelize-cli/bin/sequelize db:migrate

echo "Starting unms..."
exec node --optimize_for_size --max_old_space_size=1000 --gc_interval=120 index.js
